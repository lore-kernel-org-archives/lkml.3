Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3IESYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:24:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3IESYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:24:39 -0400
Date: Thu, 05 Sep 2013 14:24:36 -0400 (EDT)
Message-Id: <20130905.142436.685399325201245026.davem@davemloft.net>
To: Vineet.Gupta1@synopsys.com
Cc: netdev@vger.kernel.org, Alexey.Brodkin@synopsys.com, romieu@fr.zoreil.com,
        linux-kernel@vger.kernel.org, arc-linux-dev@synopsys.com
Subject: Re: [PATCH] ethernet/arc/arc_emac: optimize the Tx/Tx-reclaim
 paths a bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378299791-24598-1-git-send-email-vgupta@synopsys.com>
References: <1378299791-24598-1-git-send-email-vgupta@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 11:24:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Date: Wed, 4 Sep 2013 18:33:11 +0530

> This came out of staring at code due to recent performance fix.
> 
> * TX BD reclaim can call netif_wake_queue() once, outside the loop if
>   one/more BDs were freed, NO need to do this each iteration.
> 
> * TX need not look at next BD to stop the netif queue. It rather be done
>   in the next tx call, when it actually fails as the queue seldom gets
>   full but the check nevertheless needs to be done for each packet Tx.
>   Profiled this under heavy traffic (big tar file cp, LMBench betworking
>   tests) and saw not a single hit to that code.
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

You should keep the check in the transmit queueing code as a BUG check,
almost every driver has code of the form (using NIU as an example):

	if (niu_tx_avail(rp) <= (skb_shinfo(skb)->nr_frags + 1)) {
		netif_tx_stop_queue(txq);
		dev_err(np->device, "%s: BUG! Tx ring full when queue awake!\n", dev->name);
		rp->tx_errors++;
		return NETDEV_TX_BUSY;
	}

and arc_emac should too.

Otherwise queue management bugs are incredibly hard to diagnose.

I'm not applying this patch.
