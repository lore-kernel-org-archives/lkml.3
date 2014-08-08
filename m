Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaHHF2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:28:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaHHF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:28:03 -0400
Date: Thu, 07 Aug 2014 22:28:01 -0700 (PDT)
Message-Id: <20140807.222801.2128816957894671099.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Paul.Durrant@citrix.com
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <53E3A075.2090400@citrix.com>
References: <53E28017.9040908@citrix.com>
	<20140806.140146.1448631909293617629.davem@davemloft.net>
	<53E3A075.2090400@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 22:28:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Thu, 7 Aug 2014 16:51:17 +0100

> Ok, how about this:
> * ndo_start_xmit tries to set up the grant copy operations, something
> * which is done now in the thread
> * no estimation madness, just go ahead and try to do it
> * if the skb can fit, kick the thread
> * if it fails (not enough slots to complete the TX), then:
>   * call netif_tx_stop_queue on that queue (just like now)
>   * set up timer rx_stalled (just like now)
>   * save the state of the current skb (where the grant copy op setup is
>   * halted)
> * if new slots coming in, continue to create the grant copy ops for the
> * stalled skb, and if it succeeds, kick the thread plus call
> * netif_tx_start_queue. (just like now)
> * if the timer fires, drop the stalled skb, and set the carrier off, so
> * QDisc won't bother to queue packets for a stalled interface
> * the thread will only do the actual grant copy hypercall and releasing
> * the skb
> * in any case, ndo_start_xmit should return NETDEV_TX_OK, just like now

It sounds like this would work, and indeed it would abide by the intended
rules of netif_{stop,wake}_queue() and ->ndo_start_xmit()'s return
values.
