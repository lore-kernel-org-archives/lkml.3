Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaDNTcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:32:55 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:44874 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaDNTcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:32:52 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 15:32:52 EDT
Date: Mon, 14 Apr 2014 15:26:16 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ptyser@xes-inc.com, linus walleij <linus.walleij@linaro.org>,
        gnurou@gmail.com, linux-gpio@vger.kernel.org, vdonnefort@gmail.com
Message-ID: <1711081890.4667634.1397503576740.JavaMail.zimbra@redhat.com>
In-Reply-To: <1397498107.2419.5.camel@flatline.rdu.redhat.com>
References: <1397498107.2419.5.camel@flatline.rdu.redhat.com>
Subject: Re: [git bisect regression 3.15-rc1] NULL ptr deref in
 ichx_gpio_probe
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: NULL ptr deref in ichx_gpio_probe
Thread-Index: h5iFpW9pi+dZUrVsIUH4voviSoFPaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tad more information.  I did a build of-rc1 with the GPIO_ICH module built in so I could use addr2line to help you run it down.  No idea if this is actually useful for you...

$ addr2line --inline --exe=vmlinux ffffffff813fc4e0
/storage/kernel/ichx-rebase/drivers/gpio/gpio-ich.c:388
/storage/kernel/ichx-rebase/drivers/gpio/gpio-ich.c:461

-Eric

----- Original Message -----
> I cannot boot 3.15-rc1 kernels because I get a NULL ptr bug in
> ichx_gpio_probe.  The backtrace is at the end of the e-mail.  I did a
> bisect and found:
> 
> $ git bisect good
> b667cf488aa9476b0ab64acd91f2a96f188cfd21 is the first bad commit
> commit b667cf488aa9476b0ab64acd91f2a96f188cfd21
> Author: Vincent Donnefort <vdonnefort@gmail.com>
> Date:   Fri Feb 7 14:21:05 2014 +0100
> 
>     gpio: ich: Add support for multiple register addresses
> 
>     This patch introduces regs and reglen pointers which allow a chipset to
>     have
>     register addresses differing from ICH ones.
> 
>     Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
>     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> :040000 040000 f69690db4ff26eb01553bbc33679bf43d9054948
> 889bd1726d656d0a274edbc41c220e67e6151500 M      drivers
> 
> I am attaching the full dmesg from that boot as possibly other
> information will be helpful...
> 
> The Backtrace:
> 
> [   18.021255] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   18.021617] IP: [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c
> [gpio_ich]
> [   18.021918] PGD 0
> [   18.022011] Oops: 0000 [#1] SMP
> [   18.022011] Modules linked in: gpio_ich(+) snd_seq_device snd_pcm
> i5400_edac joydev edac_core parport_pc snd_timer lpc_ich shpchp parport
> tpm_tis snd soundcore microcode i2c_i801 serio_raw mfd_core i5k_amb tpm
> nouveau hid_logitech_dj video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm
> drm ata_generic tg3 pata_acpi ptp pps_core i2c_core
> [   18.022011] CPU: 5 PID: 553 Comm: systemd-udevd Not tainted 3.14.0-rc1+ #9
> [   18.022011] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203,
> BIOS A04 08/21/2008
> [   18.022011] task: ffff880033e2cc50 ti: ffff88044ba26000 task.ti:
> ffff88044ba26000
> [   18.022011] RIP: 0010:[<ffffffffa02a46a0>]  [<ffffffffa02a46a0>]
> ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
> [   18.022011] RSP: 0018:ffff88044ba27ba0  EFLAGS: 00010246
> [   18.022011] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000000000
> [   18.022011] RDX: 0000000000000000 RSI: 0000000000000100 RDI:
> ffffffff81c3e180
> [   18.022011] RBP: ffff88044ba27bd0 R08: 0000000000000000 R09:
> ffff880034fb04b0
> [   18.022011] R10: 0000000000000001 R11: ffff880033e2d7f0 R12:
> ffff880034fb0000
> [   18.022011] R13: ffff88044c28dcc0 R14: 0000000000000003 R15:
> 0000000000000000
> [   18.022011] FS:  00007fbc8df5f880(0000) GS:ffff88045e000000(0000)
> knlGS:0000000000000000
> [   18.022011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   18.022011] CR2: 0000000000000000 CR3: 000000044b95e000 CR4:
> 00000000000007e0
> [   18.022011] Stack:
> [   18.022011]  ffff880034fb04b0 ffff880034fb0010 ffffffffa02a6028
> ffff880034fb0000
> [   18.022011]  0000000000000000 0000000000000001 ffff88044ba27c00
> ffffffff814f4a55
> [   18.022011]  ffffffff814f21a2 ffff880034fb0010 0000000000000000
> ffffffffa02a6028
> [   18.022011] Call Trace:
> [   18.022011]  [<ffffffff814f4a55>] platform_drv_probe+0x45/0xb0
> [   18.022011]  [<ffffffff814f21a2>] ? driver_sysfs_add+0x82/0xb0
> [   18.022011]  [<ffffffff814f2945>] driver_probe_device+0x125/0x3a0
> [   18.022011]  [<ffffffff814f2c93>] __driver_attach+0x93/0xa0
> [   18.022011]  [<ffffffff814f2c00>] ? __device_attach+0x40/0x40
> [   18.022011]  [<ffffffff814f0683>] bus_for_each_dev+0x73/0xc0
> [   18.022011]  [<ffffffff814f22ce>] driver_attach+0x1e/0x20
> [   18.022011]  [<ffffffff814f1e78>] bus_add_driver+0x188/0x260
> [   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
> [   18.022011]  [<ffffffff814f3334>] driver_register+0x64/0xf0
> [   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
> [   18.022011]  [<ffffffff814f497a>] __platform_driver_register+0x4a/0x50
> [   18.022011]  [<ffffffffa00d0017>] ichx_gpio_driver_init+0x17/0x1000
> [gpio_ich]
> [   18.022011]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
> [   18.022011]  [<ffffffff81063e93>] ? set_memory_nx+0x43/0x50
> [   18.022011]  [<ffffffff81130e58>] load_module+0x1c28/0x26d0
> [   18.022011]  [<ffffffff8112bff0>] ? store_uevent+0x70/0x70
> [   18.022011]  [<ffffffff81236790>] ? kernel_read+0x50/0x80
> [   18.022011]  [<ffffffff81131ad6>] SyS_finit_module+0xa6/0xd0
> [   18.022011]  [<ffffffff817c9f69>] system_call_fastpath+0x16/0x1b
> [   18.022011] Code: 00 00 40 61 2a a0 e9 f0 fd ff ff 48 8b 05 81 1f 00 00 45
> 31 c0 48 c7 c7 80 e1 c3 81 4c 89 4d d0 48 8b 48 08 48 8b 50 10 48 63 c3 <0f>
> b6 34 01 0f b6 14 1a 4c 89 c9 49 03 75 00 e8 8c a2 df e0 48
> [   18.022011] RIP  [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c
> [gpio_ich]
> [   18.022011]  RSP <ffff88044ba27ba0>
> [   18.022011] CR2: 0000000000000000
> [   18.047269] ---[ end trace 178b39b238232179 ]---
> 
> 
