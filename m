Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaHSXKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:10:54 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16116 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHSXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:10:53 -0400
X-IronPort-AV: E=Sophos;i="5.01,898,1400050800"; 
   d="scan'208";a="43024310"
Subject: Re: [PATCH 2/3] tg3: Fix tx_pending checks for tg3_tso_bug
From: Michael Chan <mchan@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Prashant Sreedharan <prashant@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1408474371-19509-2-git-send-email-bpoirier@suse.de>
References: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
	 <1408474371-19509-2-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 19 Aug 2014 16:10:52 -0700
Message-ID: <1408489852.7404.60.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 11:52 -0700, Benjamin Poirier wrote: 
> @@ -7838,11 +7838,14 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
>                        struct netdev_queue *txq, struct sk_buff *skb)
>  {
>         struct sk_buff *segs, *nskb;
> -       u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
>  
> -       /* Estimate the number of fragments in the worst case */
> -       if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
> +       if (unlikely(tg3_tx_avail(tnapi) <= skb_shinfo(skb)->gso_segs)) {
> +               trace_printk("stopping queue, %d <= %d\n",
> +                            tg3_tx_avail(tnapi), skb_shinfo(skb)->gso_segs);
>                 netif_tx_stop_queue(txq);
> +               trace_printk("stopped queue\n");
> +               tnapi->wakeup_thresh = skb_shinfo(skb)->gso_segs;
> +               BUG_ON(tnapi->wakeup_thresh >= tnapi->tx_pending);
>  
>                 /* netif_tx_stop_queue() must be done before checking
>                  * checking tx index in tg3_tx_avail() below, because in 

I don't quite understand this logic and I must be missing something.
gso_segs is the number of TCP segments the large packet will be broken
up into.  If it exceeds dev->gso_max_segs, it means it exceeds
hardware's capabilty and it will do GSO instead of TSO.  But in this
case in tg3_tso_bug(), we are doing GSO and we may not have enough DMA
descriptors to do GSO.  Each gso_seg typically requires 2 DMA
descriptors.

