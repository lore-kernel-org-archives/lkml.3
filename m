Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaGJHJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:09:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51027 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbaGJHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:09:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nVoZ1EBLitsGa3T/gnIqe
Date: Thu, 10 Jul 2014 00:09:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] tty: serial: Add 8250-core based omap driver
Message-ID: <20140710070948.GH28884@atomide.com>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
 <1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140709 10:52]:
> 
> v1…v2:
> 	- added runtime PM. Could somebody could plese double check
> 	  this? I seems to be enabled and nothing explodes. However
> 	  serial_omap_get_context_loss_count() & enable_wakeup() are
> 	  NULL pointer (in the omap-serial driver). So I am not sure how
> 	  this supposed to work :)
> 	- added omap_8250_set_termios()

You can test this pretty easily on beagleboard xm for example
using v3.16-r4:

1. Compile the kernel using omap2plus_defconfig and enable your
   driver. USB EHCI needs to be disabled and OTG port should
   not have a USB cable connected.

2. Boot with init=/bin/sh to keep user space timers to minimum
   at least until you have verified to hit off-idle

3. Enable UART timeouts with something like this. You may need
   to update it for ttyS, I just changed ttyO to ttyS here:

   #!/bin/bash
   uarts=$(find /sys/class/tty/ttyS*/device/power/ -type d)
   for uart in $uarts; do
   	echo 3000 > $uart/autosuspend_delay_ms
   done

   uarts=$(find /sys/class/tty/ttyS*/power/ -type d)
   for uart in $uarts; do
   	echo enabled > $uart/wakeup
   	echo auto > $uart/control
   done

   echo 1 > /sys/kernel/debug/pm_debug/enable_off_mode

4. Wait for UART to time out and verify you hit off-idle by
   looking at the debugfs entry:

   # cat /sys/kernel/debug/pm_debug/count
   ...
   core_pwrdm (ON),OFF:6,RET:0,INA:0,ON:7,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0
   ...
 
I just tried testing this, but did not get far on my omap3 evm:

[    5.445953] Unhandled fault: external abort on non-linefetch (0x1028) at 0xfb020000
[    5.453674] Internal error: : 1028 [#1] SMP ARM
[    5.458221] Modules linked in:
[    5.461334] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc4-00006-gaab2c6a #98
[    5.469024] task: ce058b00 ti: ce05a000 task.ti: ce05a000
[    5.474456] PC is at mem32_serial_in+0xc/0x1c
[    5.478851] LR is at serial8250_do_startup+0xc8/0x89c
[    5.483917] pc : [<c0346f90>]    lr : [<c034ab2c>]    psr: 60000113
[    5.483917] sp : ce05bd10  ip : c0a0aba8  fp : ce275400
[    5.495452] r10: 00000000  r9 : cda7a680  r8 : ce27568c
[    5.500701] r7 : ce275400  r6 : 00000000  r5 : ce280408  r4 : c10b6234
[    5.507263] r3 : fb020000  r2 : 00000002  r1 : fb020000  r0 : c10b6234
[    5.513854] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    5.521179] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    5.526977] Process swapper/0 (pid: 1, stack limit = 0xce05a248)
[    5.532989] Stack: (0xce05bd10 to 0xce05c000)
...
[    5.734771] [<c0346f90>] (mem32_serial_in) from [<c034ab2c>] (serial8250_do_startup+0xc8/0x89c)
[    5.743530] [<c034ab2c>] (serial8250_do_startup) from [<c03461f8>] (uart_startup.part.3+0x7c/0x1dc)
[    5.752624] [<c03461f8>] (uart_startup.part.3) from [<c0346d68>] (uart_open+0xe4/0x124)
[    5.760681] [<c0346d68>] (uart_open) from [<c032c19c>] (tty_open+0x130/0x58c)
[    5.767852] [<c032c19c>] (tty_open) from [<c01216f4>] (chrdev_open+0x9c/0x174)
[    5.775115] [<c01216f4>] (chrdev_open) from [<c011b8d4>] (do_dentry_open+0x1d0/0x310)
[    5.783020] [<c011b8d4>] (do_dentry_open) from [<c011bd98>] (finish_open+0x34/0x4c)
[    5.790710] [<c011bd98>] (finish_open) from [<c012a8f8>] (do_last.isra.27+0x5a4/0xb98)
[    5.798675] [<c012a8f8>] (do_last.isra.27) from [<c012afa0>] (path_openat+0xb4/0x5e4)
[    5.806549] [<c012afa0>] (path_openat) from [<c012b7dc>] (do_filp_open+0x2c/0x80)
[    5.814086] [<c012b7dc>] (do_filp_open) from [<c011cd14>] (do_sys_open+0x100/0x1d0)
[    5.821777] [<c011cd14>] (do_sys_open) from [<c07b7ce0>] (kernel_init_freeable+0x124/0x1c8)
[    5.830200] [<c07b7ce0>] (kernel_init_freeable) from [<c054eb90>] (kernel_init+0x8/0xe4)
[    5.838348] [<c054eb90>] (kernel_init) from [<c000e868>] (ret_from_fork+0x14/0x2c)

Sounds like the clocks are not enabled properly?

Regards,

Tony
