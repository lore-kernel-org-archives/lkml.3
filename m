Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaGQHK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:10:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42916 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaGQHK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:10:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/iakrmjKKXgX7pVJCq5G2
Date: Thu, 17 Jul 2014 00:09:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140717070859.GD18374@atomide.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140716 07:47]:
> This patch provides a 8250-core based UART driver for the internal OMAP
> UART. The longterm goal is to provide the same functionality as the
> current OMAP uart driver and hopefully DMA support which could borrowed
> from the 8250-core.
> 
> It has been only tested as console UART on am335x-evm and dra7-evm.
> The device name is ttyS based instead of ttyO. If a ttyO based node name
> is required please ask udev for it. If both driver are activated (this
> and omap-serial) then this serial driver will take control over the
> device due to the link order
> 
> v3…v4:
> 	- drop RS485 support
> 	- wire up ->throttle / ->unthrottle
> v2…v3:
> 	- wire up startup & shutdown for wakeup-irq handling.
> 	- RS485 handling (well the core does).
> 
> v1…v2:
> 	- added runtime PM. Could somebody could plese double check
> 	  this?
> 	- added omap_8250_set_termios()

Seems to boot a bit further now with output from serial console
initially, then I'm getting the following error again that's probably
related to clocks not enabled when the registers are accessed:

[    1.050231] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.068664] 4806a000.serial: ttyS0 at MMIO 0x4806a000 (irq = 88, base_baud = 3000000) is a OMAP
[    1.074676] 4806c000.serial: ttyS1 at MMIO 0x4806c000 (irq = 89, base_baud = 3000000) is a OMAP
[    1.078613] console [ttyS2] disabled
[    1.079193] 49020000.serial: ttyS2 at MMIO 0x49020000 (irq = 90, base_baud = 3000000) is a OMAP
[    1.938110] console [ttyS2] enabled
[    1.946533] 49042000.serial: ttyS3 at MMIO 0x49042000 (irq = 96, base_baud = 3000000) is a OMAP
...
[    5.538421] Unhandled fault: external abort on non-linefetch (0x1028) at 0xfb020000
[    5.546142] Internal error: : 1028 [#1] SMP ARM
[    5.550720] Modules linked in:
[    5.553802] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc5-00070-g1f95851 #129
[    5.561584] task: ce058b00 ti: ce05a000 task.ti: ce05a000
[    5.567016] PC is at mem32_serial_in+0xc/0x1c
[    5.571411] LR is at serial8250_do_startup+0xc8/0x89c
[    5.576507] pc : [<c034731c>]    lr : [<c034a988>]    psr: 60000113
[    5.576507] sp : ce05bcf0  ip : c0a008e8  fp : ce46c400
[    5.588043] r10: 00000000  r9 : cda7a680  r8 : ce46c68c
[    5.593292] r7 : ce46c400  r6 : 00000000  r5 : ce548e10  r4 : c10abf34
[    5.599853] r3 : fb020000  r2 : 00000002  r1 : fb020000  r0 : c10abf34
[    5.606414] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    5.613769] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    5.619537] Process swapper/0 (pid: 1, stack limit = 0xce05a248)
...
[    5.835601] [<c034731c>] (mem32_serial_in) from [<c034a988>] (serial8250_do_startup+0xc8/0x89c)
[    5.844360] [<c034a988>] (serial8250_do_startup) from [<c034c58c>] (omap_8250_startup+0x5c/0xdc)
[    5.853179] [<c034c58c>] (omap_8250_startup) from [<c034b170>] (serial8250_startup+0x14/0x20)
[    5.861755] [<c034b170>] (serial8250_startup) from [<c0346584>] (uart_startup.part.3+0x7c/0x1dc)
[    5.870605] [<c0346584>] (uart_startup.part.3) from [<c03470f4>] (uart_open+0xe4/0x124)
[    5.878662] [<c03470f4>] (uart_open) from [<c032c528>] (tty_open+0x130/0x58c)
[    5.885864] [<c032c528>] (tty_open) from [<c01216ec>] (chrdev_open+0x9c/0x174)
[    5.893127] [<c01216ec>] (chrdev_open) from [<c011b8cc>] (do_dentry_open+0x1d0/0x310)
[    5.901000] [<c011b8cc>] (do_dentry_open) from [<c011bd90>] (finish_open+0x34/0x4c)
[    5.908721] [<c011bd90>] (finish_open) from [<c012a8f0>] (do_last.isra.27+0x5a4/0xb98)
[    5.916687] [<c012a8f0>] (do_last.isra.27) from [<c012af98>] (path_openat+0xb4/0x5e4)
[    5.924560] [<c012af98>] (path_openat) from [<c012b7d4>] (do_filp_open+0x2c/0x80)
[    5.932098] [<c012b7d4>] (do_filp_open) from [<c011cd0c>] (do_sys_open+0x100/0x1d0)
[    5.939788] [<c011cd0c>] (do_sys_open) from [<c07b6ce0>] (kernel_init_freeable+0x124/0x1c8)
[    5.948211] [<c07b6ce0>] (kernel_init_freeable) from [<c054ed28>] (kernel_init+0x8/0xe4)
[    5.956359] [<c054ed28>] (kernel_init) from [<c000e868>] (ret_from_fork+0x14/0x2c)
...
[    5.974792] In-band Error seen by MPU  at address 0
[    5.979675] ------------[ cut here ]------------
[    5.984344] WARNING: CPU: 0 PID: 1 at drivers/bus/omap_l3_smx.c:162 omap3_l3_app_irq+0xcc/0x124()
...

Regards,

Tony
