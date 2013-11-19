Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3KSUZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:25:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3KSUZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:25:39 -0500
Date: Tue, 19 Nov 2013 15:25:36 -0500 (EST)
Message-Id: <20131119.152536.146706009595105149.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v4 3/4] r8152: support stopping/waking tx queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384831511-1625-4-git-send-email-hayeswang@realtek.com>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
	<1384831511-1625-1-git-send-email-hayeswang@realtek.com>
	<1384831511-1625-4-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Nov 2013 12:25:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 19 Nov 2013 11:25:10 +0800

> The maximum packet number which a tx aggregation buffer could contain
> is the buffer size / (packet size + descriptor size).
> 
> If the tx buffer is empty and the tx queue length is more than the
> maximum value which is defined above, stop the tx queue. Wake the tx
> queue after any queued packet is filled in a available tx buffer.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

This is racy.

You have nothing which synchronizes r8152_tx_agg_fill() and rtl8152_start_xmit(),
therefore:

> +	if (netif_queue_stopped(tp->netdev))
> +		netif_wake_queue(tp->netdev);
> +

A netif_stop_queue() can occur right after the netif_queue_stopped() check,
meaning you can end up with the queue being stopped forever and the TX queue
stuck.

I am finding this patch series _very_ tiring, every single time I take
the time to review it, I find major problems.
