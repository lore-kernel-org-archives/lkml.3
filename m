Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaGJPsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:48:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:49601 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGJPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:48:04 -0400
Message-ID: <53BEB5AF.7010604@linutronix.de>
Date: Thu, 10 Jul 2014 17:47:59 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] tty: serial: Add 8250-core based omap driver
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de> <1404928177-26554-7-git-send-email-bigeasy@linutronix.de> <20140710070948.GH28884@atomide.com>
In-Reply-To: <20140710070948.GH28884@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 09:09 AM, Tony Lindgren wrote:
> You can test this pretty easily on beagleboard xm for example
> using v3.16-r4:

I tried this with am335x-evm, dra7-evm and beaglebone (omap5-uevm and
am335x-evmsk didn't want to boot a kernel and omap4-blaze didn't even
want to show MLO/U-boot) with the same result.

> 1. Compile the kernel using omap2plus_defconfig and enable your
>    driver. USB EHCI needs to be disabled and OTG port should
>    not have a USB cable connected.

EHCI was already disabled in the config. OTG was not connected.

> 2. Boot with init=/bin/sh to keep user space timers to minimum
>    at least until you have verified to hit off-idle

I had network up and configured. Was that okay? I also tried
"ifconfig eth0 down; sleep 10; ifconfig eth0 up" to see if it works.

> 3. Enable UART timeouts with something like this. You may need
>    to update it for ttyS, I just changed ttyO to ttyS here:
> 
>    #!/bin/bash
>    uarts=$(find /sys/class/tty/ttyS*/device/power/ -type d)
>    for uart in $uarts; do
>    	echo 3000 > $uart/autosuspend_delay_ms
>    done
> 
>    uarts=$(find /sys/class/tty/ttyS*/power/ -type d)
>    for uart in $uarts; do
>    	echo enabled > $uart/wakeup
>    	echo auto > $uart/control
>    done
> 
>    echo 1 > /sys/kernel/debug/pm_debug/enable_off_mode
> 
> 4. Wait for UART to time out and verify you hit off-idle by
>    looking at the debugfs entry:
> 
>    # cat /sys/kernel/debug/pm_debug/count
>    ...
>    core_pwrdm (ON),OFF:6,RET:0,INA:0,ON:7,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0

That core_pwrdm shows only up on dra7. However with both drivers (mine
and the current omap serial) the UART went down after three secs (as
expected) and didn't accept any characters while writing on the
console. If I wrote something on it via network (like echo a >
/dev/ttyO0) it came back and was working as long as I kept it busy. The
thing is that RX does not wake it up. Any idea?
Also, while it was I checked the core_pwrdm and I had ON:1 and OFF:0.
So something is not right.
Since Dra7 has some things missing I tried it on am335x with the same
behavior. Should it work here?

>    ...
>  
> I just tried testing this, but did not get far on my omap3 evm:
> 
> [    5.445953] Unhandled fault: external abort on non-linefetch (0x1028) at 0xfb020000
> [    5.453674] Internal error: : 1028 [#1] SMP ARM
> [    5.458221] Modules linked in:
> [    5.461334] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc4-00006-gaab2c6a #98
> [    5.469024] task: ce058b00 ti: ce05a000 task.ti: ce05a000
> [    5.474456] PC is at mem32_serial_in+0xc/0x1c
> [    5.478851] LR is at serial8250_do_startup+0xc8/0x89c
> [    5.483917] pc : [<c0346f90>]    lr : [<c034ab2c>]    psr: 60000113
> [    5.483917] sp : ce05bd10  ip : c0a0aba8  fp : ce275400
> [    5.495452] r10: 00000000  r9 : cda7a680  r8 : ce27568c
> [    5.500701] r7 : ce275400  r6 : 00000000  r5 : ce280408  r4 : c10b6234
> [    5.507263] r3 : fb020000  r2 : 00000002  r1 : fb020000  r0 : c10b6234
> [    5.513854] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    5.521179] Control: 10c5387d  Table: 80004019  DAC: 00000015
> [    5.526977] Process swapper/0 (pid: 1, stack limit = 0xce05a248)
> [    5.532989] Stack: (0xce05bd10 to 0xce05c000)
> ...
> [    5.734771] [<c0346f90>] (mem32_serial_in) from [<c034ab2c>] (serial8250_do_startup+0xc8/0x89c)
> [    5.743530] [<c034ab2c>] (serial8250_do_startup) from [<c03461f8>] (uart_startup.part.3+0x7c/0x1dc)
> [    5.752624] [<c03461f8>] (uart_startup.part.3) from [<c0346d68>] (uart_open+0xe4/0x124)
> [    5.760681] [<c0346d68>] (uart_open) from [<c032c19c>] (tty_open+0x130/0x58c)
> [    5.767852] [<c032c19c>] (tty_open) from [<c01216f4>] (chrdev_open+0x9c/0x174)
> [    5.775115] [<c01216f4>] (chrdev_open) from [<c011b8d4>] (do_dentry_open+0x1d0/0x310)
> [    5.783020] [<c011b8d4>] (do_dentry_open) from [<c011bd98>] (finish_open+0x34/0x4c)
> [    5.790710] [<c011bd98>] (finish_open) from [<c012a8f8>] (do_last.isra.27+0x5a4/0xb98)
> [    5.798675] [<c012a8f8>] (do_last.isra.27) from [<c012afa0>] (path_openat+0xb4/0x5e4)
> [    5.806549] [<c012afa0>] (path_openat) from [<c012b7dc>] (do_filp_open+0x2c/0x80)
> [    5.814086] [<c012b7dc>] (do_filp_open) from [<c011cd14>] (do_sys_open+0x100/0x1d0)
> [    5.821777] [<c011cd14>] (do_sys_open) from [<c07b7ce0>] (kernel_init_freeable+0x124/0x1c8)
> [    5.830200] [<c07b7ce0>] (kernel_init_freeable) from [<c054eb90>] (kernel_init+0x8/0xe4)
> [    5.838348] [<c054eb90>] (kernel_init) from [<c000e868>] (ret_from_fork+0x14/0x2c)
> 
> Sounds like the clocks are not enabled properly?

puh. So after staring a while at your backtrace I realized that
shutdown & startup callbacks are not overwritten properly. Well, thanks
for that. Anyway, even serial8250_do_startup() has
pm_runtime_get_sync() before first register access so I have no idea
where this is coming from.

> 
> Regards,
> 
> Tony
> 

Sebastian
