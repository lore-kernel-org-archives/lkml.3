Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253AbaLLUWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:22:35 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42233 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965744AbaLLUWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:22:34 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, ulf.hansson@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Seungwon Jeon <tgih.jun@samsung.com>
Subject: regression on rk3288 with - mmc: dw_mmc: Remove old card detect infrastructure
Date: Fri, 12 Dec 2014 21:22:23 +0100
Message-ID: <8867707.LK6gZlxufx@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when trying linux-next for 20141210 on my rk3288 eval board I got errors
when ejecting sd cards. Especially a timeout for a command and following
this an rcu stall which essentially stops everything [0].

My way to reproduce the issue is:
- boot into an initramfs
- insert card
- remove card
- boom

It happens 100% of the time on the first removal of the card.


Bisecting the issue brought me to

first bad commit
6130e7a9c34d01afbd4e7e215846d1f2d70333bb
mmc: dw_mmc: Remove old card detect infrastructure

and indeed if I revert this one, card ejection works again - also multiple
times in a row. Affected machine is a rk3288-evb-rk808 board which
currently uses the internal card-detect mechanism of the dw_mmc and
relevant git history (--oneline) is:

864de9b Revert "mmc: dw_mmc: Remove old card detect infrastructure"
5bd48e0 ARM: dts: Bump SD card pin drive strength up on rk3288-evb
12fd072 Add linux-next specific files for 20141210
...


I'll try to dig deeper, but if anybody has ideas beforehand I would also
be very glad.


Heiko


[0]
[    4.598966] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 50000000Hz, actual 50000000HZ div = 0)
[    4.608754] mmc0: new high speed SDHC card at address e624
[    4.614614] mmcblk1: mmc0:e624 SU08G 7.40 GiB 
[    4.626585]  mmcblk1: p1
[    7.727168] mmc0: card e624 removed
[    8.227064] mmc_host mmc0: Timeout sending command (cmd 0x202000 arg 0x0 status 0x80202000)
[   29.237053] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies g=-251 c=-252 q=5)
[   29.245795] Task dump for CPU 0:
[   29.249020] swapper/0       R running      0     0      0 0x00000002
[   29.255423] [<c00148e4>] (unwind_backtrace) from [<c00111e0>] (show_stack+0x10/0x14)
[   29.263169] [<c00111e0>] (show_stack) from [<c005a318>] (rcu_dump_cpu_stacks+0x94/0xa4)
[   29.271172] [<c005a318>] (rcu_dump_cpu_stacks) from [<c005c710>] (rcu_check_callbacks+0x1b8/0x548)
[   29.280128] [<c005c710>] (rcu_check_callbacks) from [<c005e850>] (update_process_times+0x30/0x5c)
[   29.288998] [<c005e850>] (update_process_times) from [<c00694f4>] (tick_handle_periodic+0x24/0x80)
[   29.297956] [<c00694f4>] (tick_handle_periodic) from [<c02d12ac>] (arch_timer_handler_phys+0x28/0x30)
[   29.307174] [<c02d12ac>] (arch_timer_handler_phys) from [<c005551c>] (handle_percpu_devid_irq+0x68/0x84)
[   29.316650] [<c005551c>] (handle_percpu_devid_irq) from [<c0051e58>] (generic_handle_irq+0x20/0x30)
[   29.325688] [<c0051e58>] (generic_handle_irq) from [<c0051f64>] (__handle_domain_irq+0x88/0xb0)
[   29.334378] [<c0051f64>] (__handle_domain_irq) from [<c0008614>] (gic_handle_irq+0x3c/0x60)
[   29.342725] [<c0008614>] (gic_handle_irq) from [<c0011c40>] (__irq_svc+0x40/0x54)
[   29.350198] Exception stack(0xc07b7eb0 to 0xc07b7ef8)
[   29.355245] 7ea0:                                     c07b7ef8 c07b7ef8 00000000 00000000
[   29.363416] 7ec0: 00000282 c07b8100 0000000a ee005000 00200000 ffff8e02 c07ebd80 00000000
[   29.371585] 7ee0: 00000000 c07b7ef8 c005d11c c0024ac8 60000113 ffffffff
[   29.378200] [<c0011c40>] (__irq_svc) from [<c0024ac8>] (__do_softirq+0x74/0x230)
[   29.385593] [<c0024ac8>] (__do_softirq) from [<c0024ed4>] (irq_exit+0x84/0xa8)
[   29.392811] [<c0024ed4>] (irq_exit) from [<c0051f68>] (__handle_domain_irq+0x8c/0xb0)
[   29.400635] [<c0051f68>] (__handle_domain_irq) from [<c0008614>] (gic_handle_irq+0x3c/0x60)
[   29.408980] [<c0008614>] (gic_handle_irq) from [<c0011c40>] (__irq_svc+0x40/0x54)
[   29.416452] Exception stack(0xc07b7f68 to 0xc07b7fb0)
[   29.421500] 7f60:                   ffffffed 00000000 c07b7fb8 c001e360 00000000 00000000
[   29.429670] 7f80: 00000000 ffffffed c05dbb80 ef7fcb40 c07be400 00000000 00000000 c07b7fb0
[   29.437837] 7fa0: c000f388 c000f38c 60000013 ffffffff
[   29.442891] [<c0011c40>] (__irq_svc) from [<c000f38c>] (arch_cpu_idle+0x2c/0x38)
[   29.450288] [<c000f38c>] (arch_cpu_idle) from [<c004a848>] (cpu_startup_entry+0xd4/0x238)
[   29.458465] [<c004a848>] (cpu_startup_entry) from [<c05b1bd0>] (start_kernel+0x338/0x3a4)

