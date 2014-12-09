Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaLIUiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:38:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38452 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLIUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:37:56 -0500
Date: Tue, 09 Dec 2014 15:37:53 -0500 (EST)
Message-Id: <20141209.153753.198847867496667798.davem@davemloft.net>
To: asolokha@kb.kras.ru
Cc: claudiu.manoil@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gianfar: handle map error in gfar_new_rxbdp()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417775874-17775-2-git-send-email-asolokha@kb.kras.ru>
References: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
	<1417775874-17775-2-git-send-email-asolokha@kb.kras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 12:37:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>
Date: Fri,  5 Dec 2014 17:37:53 +0700

> @@ -2854,7 +2866,15 @@ int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit)
>  		rx_queue->rx_skbuff[rx_queue->skb_currx] = newskb;
>  
>  		/* Setup the new bdp */
> -		gfar_new_rxbdp(rx_queue, bdp, newskb);
> +		rxbdpret = gfar_new_rxbdp(rx_queue, bdp, newskb);
> +		if (unlikely(rxbdpret)) {
> +			/* We drop the frame if we failed to map a new DMA
> +			 * buffer
> +			 */
> +			count_errors(bdp->status, dev);
> +			dev_kfree_skb(newskb);
> +			continue;
> +		}
>  
>  		/* Update to the next pointer */
>  		bdp = next_bd(bdp, base, rx_queue->rx_ring_size);

You need to add much more sophisticated handling of this error.

Otherwise the chip will just stop when it gets to the first
descriptor for which a DMA mapping failed in this way.

What you need to do is allocate and attempt to map the new SKB
_first_, and only if that succeeds will you pass the original
SKB up into the networking stack.

If the DMA mapping fails, you leave the OLD skb in the RX ring
and advance the ring pointer, as if the received packet never
happened.  You are essentially dropping it.
