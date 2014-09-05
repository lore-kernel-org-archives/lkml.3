Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaIEXol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:44:41 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34205 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaIEXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:44:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,476,1406617200"; 
   d="scan'208";a="44808749"
Subject: Re: [PATCH net v6 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: Prashant Sreedharan <prashant@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1409880647-14887-5-git-send-email-bpoirier@suse.de>
References: <1409880647-14887-1-git-send-email-bpoirier@suse.de>
	 <1409880647-14887-5-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 5 Sep 2014 16:35:35 -0700
Message-ID: <1409960135.18724.33.camel@prashant>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
>  		       struct netdev_queue *txq, struct sk_buff *skb)
>  {
> -	struct sk_buff *segs, *nskb;
> -	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
> +	unsigned int segs_remaining = skb_shinfo(skb)->gso_segs;
>  
> -	/* Estimate the number of fragments in the worst case */
> -	tg3_maybe_stop_txq(tnapi, txq, frag_cnt_est, frag_cnt_est);
> -	if (netif_tx_queue_stopped(txq))
> -		return NETDEV_TX_BUSY;
> +	if (unlikely(tg3_tx_avail(tnapi) <= segs_remaining)) {
> +		if (!skb_is_nonlinear(skb) || skb_linearize(skb))
> +			goto tg3_tso_bug_drop;
> +		tg3_start_xmit(skb, tp->dev);

fyi.. Initially the driver was doing a skb_copy()
(tigon3_dma_hwbug_workaround()) for LSO skb that met HW bug conditions
but users started reporting page allocation failures due to copying of
large LSO skbs. To avoid this Commit 4caab52eb102f1 (tg3: Prevent page
allocation failure during TSO workaround) changed the driver logic to do
skb_gso_segment() for LSO skbs that met the HW bug conditions. With
skb_linearize() we might end up again with memory allocation failures
for large LSO skbs though at a much less frequent level (ie when TX
queue is almost full). 

Also some of the tg3 supported chips like 5719, 57766 have dma_limits of
4k, 2k respectively so if the LSO skb that gets linearized has size more
than dma_limit then tg3_tx_frag_set() will consume more descriptors and
if budget becomes 0 in tg3_tx_frag_set() we end up calling tg3_tso_bug()
again and eventually dropping the skb, if descriptors do not get freed
still. Instead the skb can be dropped when we know we do not have enough
descriptors to handle skb for these chip versions.

> +	} else {
> +		struct sk_buff *segs, *nskb;
>  
> -	segs = skb_gso_segment(skb, tp->dev->features &
> -				    ~(NETIF_F_TSO | NETIF_F_TSO6));
> -	if (IS_ERR(segs) || !segs)
> -		goto tg3_tso_bug_end;
> +		segs = skb_gso_segment(skb, tp->dev->features &
> +				       ~(NETIF_F_TSO | NETIF_F_TSO6 |
> +					 NETIF_F_SG));
> +		if (IS_ERR(segs) || !segs)
> +			goto tg3_tso_bug_drop;
>  
> -	do {
> -		nskb = segs;
> -		segs = segs->next;
> -		nskb->next = NULL;
> -		tg3_start_xmit(nskb, tp->dev);
> -	} while (segs);
> +		do {
> +			nskb = segs;
> +			segs = segs->next;
> +			nskb->next = NULL;
> +			if (--segs_remaining)
> +				__tg3_start_xmit(nskb, tp->dev, segs_remaining);
> +			else
> +				tg3_start_xmit(nskb, tp->dev);
> +		} while (segs);
>  
> -tg3_tso_bug_end:
> +		dev_kfree_skb_any(skb);
> +	}
> +
> +	return NETDEV_TX_OK;
> +
> +tg3_tso_bug_drop:
> +	tp->tx_dropped++;
>  	dev_kfree_skb_any(skb);
>  
>  	return NETDEV_TX_OK;
> @@ -7895,6 +7908,12 @@ tg3_tso_bug_end:
>  /* hard_start_xmit for all devices */
>  static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
> +	return __tg3_start_xmit(skb, dev, MAX_SKB_FRAGS + 1);
> +}
> +
> +static netdev_tx_t __tg3_start_xmit(struct sk_buff *skb,
> +				    struct net_device *dev, u32 stop_thresh)
> +{
>  	struct tg3 *tp = netdev_priv(dev);
>  	u32 len, entry, base_flags, mss, vlan = 0;
>  	u32 budget;
> @@ -8102,7 +8121,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	tw32_tx_mbox(tnapi->prodmbox, entry);
>  
>  	tnapi->tx_prod = entry;
> -	tg3_maybe_stop_txq(tnapi, txq, MAX_SKB_FRAGS + 1,
> +	tg3_maybe_stop_txq(tnapi, txq, stop_thresh,
>  			   TG3_TX_WAKEUP_THRESH(tnapi));
>  
>  	mmiowb();
> @@ -12336,9 +12355,7 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
>  	if ((ering->rx_pending > tp->rx_std_ring_mask) ||
>  	    (ering->rx_jumbo_pending > tp->rx_jmb_ring_mask) ||
>  	    (ering->tx_pending > TG3_TX_RING_SIZE - 1) ||
> -	    (ering->tx_pending <= MAX_SKB_FRAGS + 1) ||
> -	    (tg3_flag(tp, TSO_BUG) &&
> -	     (ering->tx_pending <= (MAX_SKB_FRAGS * 3))))
> +	    (ering->tx_pending <= MAX_SKB_FRAGS + 1))
>  		return -EINVAL;
>  
>  	if (netif_running(dev)) {


