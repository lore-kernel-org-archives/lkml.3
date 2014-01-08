Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaAHCMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:12:33 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:65171 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaAHCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:12:24 -0500
Message-ID: <1389147141.26646.74.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next v3 6/9] xen-netback: Handle guests with too
 many frags
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com
Date: Tue, 07 Jan 2014 18:12:21 -0800
In-Reply-To: <1389139818-24458-7-git-send-email-zoltan.kiss@citrix.com>
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>
	 <1389139818-24458-7-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 00:10 +0000, Zoltan Kiss wrote:

>  
> +		if (skb_shinfo(skb)->frag_list) {
> +			nskb = skb_shinfo(skb)->frag_list;
> +			xenvif_fill_frags(vif, nskb, INVALID_PENDING_IDX);
> +			skb->len += nskb->len;
> +			skb->data_len += nskb->len;
> +			skb->truesize += nskb->truesize;
> +			skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> +			skb_shinfo(nskb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> +			vif->tx_zerocopy_sent += 2;
> +			nskb = skb;
> +
> +			skb = skb_copy_expand(skb,
> +					0,
> +					0,
> +					GFP_ATOMIC | __GFP_NOWARN);

skb can be NULL here

> +			skb_shinfo(skb)->destructor_arg = NULL;
> +		}
>  		if (skb_is_nonlinear(skb) && skb_headlen(skb) < PKT_PROT_LEN) {
>  			int target = min_t(int, skb->len, PKT_PROT_LEN);
>  			__pskb_pull_tail(skb, target - skb_headlen(skb));
> @@ -1568,6 +1660,9 @@ static int xenvif_tx_submit(struct xenvif *vif)
>  		}
>  


