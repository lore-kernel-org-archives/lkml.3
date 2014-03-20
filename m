Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbaCTTfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:35:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57363 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbaCTTcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:05 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 08/11] In the uart_handle_cts_change(), uart_write_wakeup() is called after we call @uart_port->ops->start_tx().
Date: Thu, 20 Mar 2014 14:30:04 -0500
Message-ID: <1395343807-21618-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Shijie <b32955@freescale.com>

The Documentation/serial/driver tells us:
-----------------------------------------------
  start_tx(port)
	Start transmitting characters.

	Locking: port->lock taken.
	Interrupts: locally disabled.
-----------------------------------------------

So when the uart_write_wakeup() is called, the port->lock is taken by
the upper. See the following callstack:

	|_ uart_write_wakeup
	   |_ tty_wakeup
	      |_ ld->ops->write_wakeup

With the port->lock held, we call the @write_wakeup. Some implemetation of
the @write_wakeup does not notice that the port->lock is held, and it still
tries to send data with uart_write() which will try to grab the prot->lock.
A dead lock occurs, see the following log caught in the Bluetooth by uart:

--------------------------------------------------------------------
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
 lock: 0xdc3f4410, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.17-16839-ge4a1bef #1320
[<80014cbc>] (unwind_backtrace+0x0/0x138) from [<8001251c>] (show_stack+0x10/0x14)
[<8001251c>] (show_stack+0x10/0x14) from [<802816ac>] (do_raw_spin_lock+0x108/0x184)
[<802816ac>] (do_raw_spin_lock+0x108/0x184) from [<806a22b0>] (_raw_spin_lock_irqsave+0x54/0x60)
[<806a22b0>] (_raw_spin_lock_irqsave+0x54/0x60) from [<802f5754>] (uart_write+0x38/0xe0)
[<802f5754>] (uart_write+0x38/0xe0) from [<80455270>] (hci_uart_tx_wakeup+0xa4/0x168)
[<80455270>] (hci_uart_tx_wakeup+0xa4/0x168) from [<802dab18>] (tty_wakeup+0x50/0x5c)
[<802dab18>] (tty_wakeup+0x50/0x5c) from [<802f81a4>] (imx_rtsint+0x50/0x80)
[<802f81a4>] (imx_rtsint+0x50/0x80) from [<802f88f4>] (imx_int+0x158/0x17c)
[<802f88f4>] (imx_int+0x158/0x17c) from [<8007abe0>] (handle_irq_event_percpu+0x50/0x194)
[<8007abe0>] (handle_irq_event_percpu+0x50/0x194) from [<8007ad60>] (handle_irq_event+0x3c/0x5c)
--------------------------------------------------------------------

This patch adds more limits to the @write_wakeup, the one who wants to
implemet the @write_wakeup should follow the limits which avoid the deadlock.

Signed-off-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/tty_ldisc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index b8347c2..8946e31 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -92,7 +92,10 @@
  *	This function is called by the low-level tty driver to signal
  *	that line discpline should try to send more characters to the
  *	low-level driver for transmission.  If the line discpline does
- *	not have any more data to send, it can just return.
+ *	not have any more data to send, it can just return. If the line
+ *	discipline does have some data to send, please arise a tasklet
+ *	or workqueue to do the real data transfer. Do not send data in
+ *	this hook, it may leads to a deadlock.
  *
  * int (*hangup)(struct tty_struct *)
  *
-- 
1.9.1.286.g5172cb3

