Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaHVXZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:25:35 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:60161 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaHVXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:25:34 -0400
X-IronPort-AV: E=Sophos;i="5.04,384,1406617200"; 
   d="scan'208";a="43631182"
Subject: Re: [PATCH v2 3/3] tg3: Fix tx_pending checks for tg3_tso_bug
From: Prashant Sreedharan <prashant@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1408658240-6811-3-git-send-email-bpoirier@suse.de>
References: <1408658240-6811-1-git-send-email-bpoirier@suse.de>
	 <1408658240-6811-3-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Aug 2014 16:17:27 -0700
Message-ID: <1408749447.8268.53.camel@prashant>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, thanks for the patch. Broadcom QA will be testing the changes.
Couple of comments below.
>  	segs = skb_gso_segment(skb, tp->dev->features &
>  				    ~(NETIF_F_TSO | NETIF_F_TSO6));
> -	if (IS_ERR(segs) || !segs)
> +	if (IS_ERR_OR_NULL(segs))
>  		goto tg3_tso_bug_end;
>  
>  	do {
> +		unsigned int desc_cnt = skb_shinfo(segs)->nr_frags + 1;
> +
>  		nskb = segs;
>  		segs = segs->next;
>  		nskb->next = NULL;
> -		tg3_start_xmit(nskb, tp->dev);
> +
> +		if (tg3_tx_avail(tnapi) <= segs_remaining - 1 + desc_cnt &&
> +		    skb_linearize(nskb)) {
> +			nskb->next = segs;
> +			segs = nskb;
> +			do {
> +				nskb = segs->next;
> +
> +				dev_kfree_skb_any(segs);
> +				segs = nskb;
> +			} while (segs);

If skb_linearize() fails need to increment the tp->tx_dropped count

> +			goto tg3_tso_bug_end;
> +		}
> +		segs_remaining--;
> +		if (segs_remaining)
> +			__tg3_start_xmit(nskb, tp->dev, segs_remaining);

To clarify passing segs_remaining will make sure the queue is never
stopped correct ?

> +		else
> +			tg3_start_xmit(nskb, tp->dev);
>  	} while (segs);
>  


