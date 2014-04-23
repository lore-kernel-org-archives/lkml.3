Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaDWP2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:28:36 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:40805 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaDWP2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:28:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Apr 2014 17:27:02 +0200
From: =?UTF-8?Q?Andreas_Bie=C3=9Fmann?= <andreas@biessmann.de>
To: =?UTF-8?Q?Andreas_Bie=C3=9Fmann?= <andreas@biessmann.de>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] =?UTF-8?Q?bluetooth=3Ahci=5Fldisc=3A=20add=20tasklet?=
 =?UTF-8?Q?=20for=20deferred=20TX=20handling?=
In-Reply-To: <20140423151548.GA10025@t440s.P-661HNU-F1>
References: <1397661950-30408-1-git-send-email-andreas@biessmann.de>
 <20140423151548.GA10025@t440s.P-661HNU-F1>
Message-ID: <b16342861634db446e03982a8d0f41cf@biessmann.de>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

Am 2014-04-23 17:15, schrieb Johan Hedberg:
> On Wed, Apr 16, 2014, Andreas Bießmann wrote:
>> This patch fixes a recursive locking scenario when using BCSP 
>> connection via
>> 8250 driver. The 8250 driver may tty_wakeup() in interrupt context 
>> which
>> results in hci_uart_tx_wakeup(). This in turn will call uart_write() 
>> in the
>> very same context and therefore will spin_lock() the same lock within 
>> the
>> same context.
>> 
>> Here is the call stack:
>> 
>> ---8<---
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 3.4.87-gf1a3cc3 #3 Tainted: G           O
>> ---------------------------------------------
>> swapper/0 is trying to acquire lock:
>>  (&port_lock_key){-.-...}, at: [<c023e21c>] uart_write+0x60/0xfc
>> 
>> but task is already holding lock:
>>  (&port_lock_key){-.-...}, at: [<c0242830>] 
>> serial8250_handle_irq+0x24/0x88
>> 
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>> 
>>        CPU0
>>        ----
>>   lock(&port_lock_key);
>>   lock(&port_lock_key);
>> 
>>  *** DEADLOCK ***
>> 
>>  May be due to missing lock nesting notation
>> 
>> 2 locks held by swapper/0:
>>  #0:  (&(&i->lock)->rlock){-.-...}, at: [<c0240f44>] 
>> serial8250_interrupt+0x2c/0xc0
>>  #1:  (&port_lock_key){-.-...}, at: [<c0242830>] 
>> serial8250_handle_irq+0x24/0x88
>> 
>> stack backtrace:
>> [<c0014234>] (unwind_backtrace+0x0/0xec) from [<c0398448>] 
>> (dump_stack+0x20/0x24)
>> [<c0398448>] (dump_stack+0x20/0x24) from [<c006eebc>] 
>> (print_deadlock_bug+0xb4/0xe4)
>> [<c006eebc>] (print_deadlock_bug+0xb4/0xe4) from [<c006f04c>] 
>> (check_deadlock.isra.20+0x160/0x18c)
>> [<c006f04c>] (check_deadlock.isra.20+0x160/0x18c) from [<c0070890>] 
>> (validate_chain.isra.24+0x4a4/0x4f0)
>> [<c0070890>] (validate_chain.isra.24+0x4a4/0x4f0) from [<c00715a0>] 
>> (__lock_acquire+0x670/0x740)
>> [<c00715a0>] (__lock_acquire+0x670/0x740) from [<c0071cb0>] 
>> (lock_acquire+0x138/0x15c)
>> [<c0071cb0>] (lock_acquire+0x138/0x15c) from [<c03a5904>] 
>> (_raw_spin_lock_irqsave+0x54/0x68)
>> [<c03a5904>] (_raw_spin_lock_irqsave+0x54/0x68) from [<c023e21c>] 
>> (uart_write+0x60/0xfc)
>> [<c023e21c>] (uart_write+0x60/0xfc) from [<bf0716d8>] 
>> (hci_uart_tx_wakeup+0x9c/0x160 [hci_uart])
>> [<bf0716d8>] (hci_uart_tx_wakeup+0x9c/0x160 [hci_uart]) from 
>> [<bf0717f4>] (hci_uart_tty_wakeup+0x58/0x5c [hci_uart])
>> [<bf0717f4>] (hci_uart_tty_wakeup+0x58/0x5c [hci_uart]) from 
>> [<c02246ec>] (tty_wakeup+0x48/0x68)
>> [<c02246ec>] (tty_wakeup+0x48/0x68) from [<c023efb0>] 
>> (uart_write_wakeup+0x2c/0x30)
>> [<c023efb0>] (uart_write_wakeup+0x2c/0x30) from [<c0241d0c>] 
>> (serial8250_tx_chars+0xf0/0x140)
>> [<c0241d0c>] (serial8250_tx_chars+0xf0/0x140) from [<c0242878>] 
>> (serial8250_handle_irq+0x6c/0x88)
>> [<c0242878>] (serial8250_handle_irq+0x6c/0x88) from [<c02428c4>] 
>> (serial8250_default_handle_irq+0x30/0x34)
>> [<c02428c4>] (serial8250_default_handle_irq+0x30/0x34) from 
>> [<c0240f5c>] (serial8250_interrupt+0x44/0xc0)
>> [<c0240f5c>] (serial8250_interrupt+0x44/0xc0) from [<c0087c70>] 
>> (handle_irq_event_percpu+0xc4/0x2cc)
>> [<c0087c70>] (handle_irq_event_percpu+0xc4/0x2cc) from [<c0087ec4>] 
>> (handle_irq_event+0x4c/0x6c)
>> [<c0087ec4>] (handle_irq_event+0x4c/0x6c) from [<c008a368>] 
>> (handle_edge_irq+0x114/0x14c)
>> [<c008a368>] (handle_edge_irq+0x114/0x14c) from [<c0087528>] 
>> (generic_handle_irq+0x40/0x54)
>> [<c0087528>] (generic_handle_irq+0x40/0x54) from [<c01f1900>] 
>> (gpio_irq_handler+0x168/0x1ac)
>> [<c01f1900>] (gpio_irq_handler+0x168/0x1ac) from [<c0087528>] 
>> (generic_handle_irq+0x40/0x54)
>> [<c0087528>] (generic_handle_irq+0x40/0x54) from [<c000ed7c>] 
>> (handle_IRQ+0x70/0x94)
>> [<c000ed7c>] (handle_IRQ+0x70/0x94) from [<c000877c>] 
>> (omap3_intc_handle_irq+0x64/0x78)
>> [<c000877c>] (omap3_intc_handle_irq+0x64/0x78) from [<c000df44>] 
>> (__irq_svc+0x44/0x78)
>> --->8---
>> 
>> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Cc: Gustavo Padovan <gustavo@padovan.org>
>> Cc: Johan Hedberg <johan.hedberg@gmail.com>
>> Cc: linux-bluetooth@vger.kernel.org
>> ---
>> 
>> It seems at least one other guy had the very same problem with another 
>> uart
>> (mpc52xx): http://www.spinics.net/lists/linux-rt-users/msg09246.html
>> 
>> I wonder, if my approach is right. It is runtime tested with 3.4.87 on 
>> our
>> board and work around the mentioned recursive locking. But I do not 
>> know, if
>> it should be fixed in another way.
>> If it is right, I'd work some more on it to get the fix mainline.
>> 
>>  drivers/bluetooth/hci_ldisc.c |   49 
>> ++++++++++++++++++++++++++++++++++++-----
>>  drivers/bluetooth/hci_uart.h  |    2 ++
>>  2 files changed, 45 insertions(+), 6 deletions(-)
> 
> This seems to be tackling the same problem as the following patch from
> Felipe Balbi (of which a new revision was sent earlier today):
> 
> 	Subject: [PATCH 02/13] bluetooth: hci_ldisc: fix deadlock condition

seems so, thanks for the pointer!

Best regards

Andreas Bießmann
