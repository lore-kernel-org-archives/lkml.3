Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbbATCwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:52:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37865 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbATCwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:52:24 -0500
Date: Mon, 19 Jan 2015 21:52:20 -0500 (EST)
Message-Id: <20150119.215220.720365670558757349.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: sfeldma@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] r8152: adjust rx_bottom
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
References: <CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
	<20150119.161333.1471925264489559119.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Jan 2015 18:52:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 20 Jan 2015 02:48:50 +0000

>> >> +                       urb->actual_length = 0;
>> >> +                       list_add_tail(&agg->list, next);
>> > 
>> > Do you need a spin_lock_irqsave(&tp->rx_lock, flags) around this?
>> 
>> Indeed, and rtl_start_rx() seems to also access agg->list without
>> proper locking.
> 
> It is unnecessary because I deal with them in a local list_head. My steps are
>    1. Move the whole list from tp->rx_done to local rx_queue. (with spin lock)
>    2. dequeue/enqueue the lists in rx_queue.
>    3. Move the lists in rx_queue to tp->rx_done if it is necessary. (spin lock)
> For step 2, it wouldn't have race, because the list_head is local and no other
> function would change it. Therefore, I don't think it needs the spin lock.
> 
> The rtl_start_rx() also uses the similar way.

agg->list is not local, you have to use a spinlock to protect
modifications to it, some other sites which modify agg->list do take
the lock properly.

You cannot modify a list like agg->list without proper locking.

