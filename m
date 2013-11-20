Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3KTFWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:22:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3KTFW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:22:27 -0500
Date: Wed, 20 Nov 2013 00:22:23 -0500 (EST)
Message-Id: <20131120.002223.1492430030566522391.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v4 3/4] r8152: support stopping/waking tx queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <9C2E97E7BED9426ABE0FF4F63E12E33D@realtek.com.tw>
References: <1384831511-1625-4-git-send-email-hayeswang@realtek.com>
	<20131119.152536.146706009595105149.davem@davemloft.net>
	<9C2E97E7BED9426ABE0FF4F63E12E33D@realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Nov 2013 21:22:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hayeswang <hayeswang@realtek.com>
Date: Wed, 20 Nov 2013 11:28:46 +0800

>  David Miller [mailto:davem@davemloft.net] 
> [...]
>> This is racy.
>> 
>> You have nothing which synchronizes r8152_tx_agg_fill() and 
>> rtl8152_start_xmit(),
>> therefore:
>> 
>> > +	if (netif_queue_stopped(tp->netdev))
>> > +		netif_wake_queue(tp->netdev);
>> > +
>> 
>> A netif_stop_queue() can occur right after the 
>> netif_queue_stopped() check,
>> meaning you can end up with the queue being stopped forever 
>> and the TX queue
>> stuck.
> 
> If the situation occurs, it means there is no tx buffer at that time. If the
> netif_wake_queue() is called, only one more packet would be queued and the tx
> queue would be stopped again after calling rtl8152_start_xmit(). That is, it
> is not necessary to wake the queue. Besides, after the tx is completed, another
> tasklet would be scheduled if there is any packet which is queued in the list.
> That is, the r8152_tx_agg_fill() would be called and the netif_queue_stopped()
> would be check againg, so the tx queue would not be stopped forever.

Then the queue can be woken when in fact r8152_start_xmit() is not able to
actually queue packets.  It is just as equally problematic.

You have to synchronize this state, somehow.

tg3 driver does this by taking netif tx queue lock during the wake
test sequence in TX reclaim.  This works because ->ndo_start_xmit() is
run with this lock held.
