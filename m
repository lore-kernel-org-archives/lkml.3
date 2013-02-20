Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab3BTR5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:57:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3BTR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:57:18 -0500
Date: Wed, 20 Feb 2013 12:57:15 -0500 (EST)
Message-Id: <20130220.125715.2150428275032134361.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bind@enas.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel 3.7.2 strange warning and short system hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361379176.19353.187.camel@edumazet-glaptop>
References: <5124F57A.6080908@enas.net>
	<1361379176.19353.187.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 09:57:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 20 Feb 2013 08:52:56 -0800

> I guess tg3 needs to call dev_kfree_skb_any()
> 
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index bdb0869..22d9e44 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -5942,7 +5942,7 @@ static void tg3_tx(struct tg3_napi *tnapi)
>  		pkts_compl++;
>  		bytes_compl += skb->len;
>  
> -		dev_kfree_skb(skb);
> +		dev_kfree_skb_any(skb);
>  
>  		if (unlikely(tx_bug)) {
>  			tg3_tx_recover(tp);

I've seen this pattern on several occasions and I have to wonder...

Do we really require, therefore, every NAPI driver to use dev_kfree_skb_any()
in it's TX reclaim if it supports netpoll?

That seems completely bogus.

netpoll is supposed to provide an execution environment when it invokes
->poll() that is identical to the normal NAPI execution.  If that would
be true, then this change above would be completely unnecessary.

We need to figure out what is the case here, and audit all the NAPI
drivers to make sure they do the right thing once we know what the
right thing actually is.
