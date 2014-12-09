Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaLIUjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:39:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38461 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaLIUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:39:05 -0500
Date: Tue, 09 Dec 2014 15:39:03 -0500 (EST)
Message-Id: <20141209.153903.1672471330337681259.davem@davemloft.net>
To: asolokha@kb.kras.ru
Cc: claudiu.manoil@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gianfar: handle map error in gfar_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417775874-17775-3-git-send-email-asolokha@kb.kras.ru>
References: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
	<1417775874-17775-3-git-send-email-asolokha@kb.kras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 12:39:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>
Date: Fri,  5 Dec 2014 17:37:54 +0700

> @@ -2296,6 +2296,12 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  						   0,
>  						   frag_len,
>  						   DMA_TO_DEVICE);
> +			if (unlikely(dma_mapping_error(priv->dev, bufaddr))) {
> +				/* As DMA mapping failed, pretend the TX path
> +				 * is busy to retry later
> +				 */
> +				return NETDEV_TX_BUSY;
> +			}

You are not "busy", you are dropping the packet due to insufficient system
resources.

Therefore the appropriate thing to do is to free the SKB, increment
the drop statistical counter, and return NETDEV_TX_OK.
