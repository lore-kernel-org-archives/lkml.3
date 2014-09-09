Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaIIJiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:38:14 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63361 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaIIJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:38:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 9 Sep 2014 11:36:06 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 3/3] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20140909093606.GB2974@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-4-git-send-email-octavian.purdila@intel.com>
 <20140905153835.GC13242@localhost>
 <CAE1zotK4QkA9PWW=uOmM-j=N=MNuBt1v3CgdA+GXctdFUZ3QKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotK4QkA9PWW=uOmM-j=N=MNuBt1v3CgdA+GXctdFUZ3QKA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 07:04:51PM +0300, Octavian Purdila wrote:
> On Fri, Sep 5, 2014 at 6:38 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Fri, Sep 05, 2014 at 06:17:59PM +0300, Octavian Purdila wrote:

> > In general, how well have these patches been tested with disconnect
> > events? At least gpiolib is known to blow up (sooner or later) when a
> > gpiochip is removed when having requested gpios.
> 
> I do disconnect tests regularly. Since switching to the new irq
> interface the following patch is needed:
> 
> https://lkml.org/lkml/2014/9/5/408
> 
> With it and the current patch sets things seems to work well.

I see no comments from Linus W on that patch?

And I can confirm that things do blow up.

After disconnecting while having a gpio exported, I get the familiar
OOPS below when reconnecting the device.

This has also been reported here:

	https://lkml.org/lkml/2014/8/4/303

[  711.232574] gpiochip_find_base: found new base at 234
[  711.232696] Unable to handle kernel NULL pointer dereference at virtual address 00000030
[  711.232727] pgd = c0004000
[  711.232757] [00000030] *pgd=00000000
[  711.232849] Internal error: Oops: 17 [#1] PREEMPT ARM
[  711.232879] Modules linked in: i2c_dln2 gpio_dln2 dln2 netconsole [last unloaded: i2c_dln2]
[  711.233032] CPU: 0 PID: 16 Comm: khubd Tainted: G        W      3.17.0-rc3 #1
[  711.233093] task: df2b5480 ti: df2b6000 task.ti: df2b6000
[  711.233123] PC is at gpiochip_add+0x7c/0x378
[  711.233184] LR is at vprintk_emit+0x284/0x628
[  711.233215] pc : [<c023aee8>]    lr : [<c0079034>]    psr: 000f0093
[  711.233215] sp : df2b7900  ip : df2b77f8  fp : df2b792c
[  711.233276] r10: df4dd800  r9 : ffffffe0  r8 : 000000ea
[  711.233306] r7 : c06ba8b0  r6 : a00f0013  r5 : c06ba8d0  r4 : df452804
[  711.233337] r3 : 00000000  r2 : 00000000  r1 : 000000ec  r0 : 000000ea
[  711.233367] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  711.233398] Control: 10c5387d  Table: 9f4c0019  DAC: 00000015
[  711.233459] Process khubd (pid: 16, stack limit = 0xdf2b6240)
[  711.233551] Stack: (0xdf2b7900 to 0xdf2b8000)
[  711.233581] 7900: c0055f6c df452e08 00000020 00000000 df4dd810 df452800 bf033640 ffffffe0
[  711.233642] 7920: df2b795c df2b7930 bf0334b0 c023ae78 bf0332e8 df4dd810 bf033978 c06de2c8
[  711.233673] 7940: 00000000 bf033978 c06c081c 0000000e df2b7974 df2b7960 c02893e0 bf0332f4
[  711.233703] 7960: c0eb2cf0 df4dd810 df2b79ac df2b7978 c0287314 c02893b0 df2b799c c02895f4
[  711.233764] 7980: df2b79ac bf033978 df4dd810 c0287574 df4acc20 00000000 c06c081c df41f480
[  711.233795] 79a0: df2b79c4 df2b79b0 c02875c4 c02871d4 00000000 df4dd810 df2b79ec df2b79c8
[  711.233856] 79c0: c02853e8 c0287580 df0414d8 df4cf094 df4acc20 df4dd810 df4dd844 c06bded0
[  711.233886] 79e0: df2b7a0c df2b79f0 c0287154 c028538c df041400 df4dd818 df4dd810 c06bded0
[  711.233917] 7a00: df2b7a2c df2b7a10 c02865c0 c02870d8 df2b5480 df4dd818 df4dd810 00000000
[  711.233978] 7a20: df2b7a64 df2b7a30 c02844fc c0286534 df2b7a58 df2b7a40 c0282b8c c02160a0
[  711.234008] 7a40: 00000000 df4dd800 df4dd810 00000010 00000000 bf02ec18 df2b7a84 df2b7a68
[  711.234069] 7a60: c02890c8 c02840a4 df4acc20 df4dd800 00000000 00000010 df2b7ac4 df2b7a88
[  711.234100] 7a80: c02a571c c0288ffc 00000000 c010c048 df0000c0 df4dd810 000000d0 df41f484
[  711.234130] 7aa0: bf02ec54 00000000 df4acc20 ffffffff 00000002 00000000 df2b7b0c df2b7ac8
[  711.234191] 7ac0: c02a5918 c02a54ec 00000000 00000000 00000000 00000040 bf02e380 df41f480
[  711.234222] 7ae0: df4acc20 df4e4000 00000000 00000040 bf02e380 df4acc00 df4acc20 df4e4040
[  711.234283] 7b00: df2b7b54 df2b7b10 bf02e7bc c02a586c 00000000 00000000 00000000 df4dbac8
[  711.234313] 7b20: df2b7b3c df4acc00 c0430dc8 df41a868 df41a800 bf02efc0 df4acc20 df4dbac8
[  711.234344] 7b40: 00000000 00000000 df2b7b8c df2b7b58 c030bc38 bf02e604 c016f220 df4acc00
[  711.234405] 7b60: df2b7b8c c0eb2cf0 df4acc20 c06de2c8 00000000 bf02efc0 c06c6c88 0000000e
[  711.234436] 7b80: df2b7bc4 df2b7b90 c0287314 c030ba88 df4acc00 c0287574 df41a868 bf02efc0
[  711.234497] 7ba0: df4acc20 c0287574 df41a868 00000000 c06c6c88 00000001 df2b7bdc df2b7bc8
[  711.234527] 7bc0: c02875c4 c02871d4 00000000 df4acc20 df2b7c04 df2b7be0 c02853e8 c0287580
[  711.234588] 7be0: df2936d8 df4cf194 df41a868 df4acc20 df4acc54 c06c6ca0 df2b7c24 df2b7c08
[  711.234619] 7c00: c0287154 c028538c df293600 df4acc28 df4acc20 c06c6ca0 df2b7c44 df2b7c28
[  711.234649] 7c20: c02865c0 c02870d8 df2b5480 df4acc28 df4acc20 00000000 df2b7c7c df2b7c48
[  711.234710] 7c40: c02844fc c0286534 df2b7c64 df2b7c58 c0430dc8 c0309a04 00000000 c06e0d88
[  711.234741] 7c60: df41a868 df4acc00 df41a800 df407650 df2b7d04 df2b7c80 c0309a74 c02840a4
[  711.234802] 7c80: 00000001 00000000 00000000 00000000 00001388 df499090 df2b7cbc c016f194
[  711.234832] 7ca0: c06d7dbd df347000 00000001 df477b40 df41a804 00000001 df407600 c06c6e3c
[  711.234924] 7cc0: c06c6ca0 c03087f8 00000001 df477b40 df41a868 df407650 c016f194 df41a800
[  711.234985] 7ce0: 00000001 c06de2c8 00000000 c06c76ec c06c6994 0000000e df2b7d1c df2b7d08
[  711.235015] 7d00: c0313d88 c03094c4 c06c76ec df41a800 df2b7d34 df2b7d20 c030ba48 c0313d58
[  711.235046] 7d20: c0eb2cf0 df41a868 df2b7d6c df2b7d38 c0287314 c030ba08 df2b7d5c df2b7d48
[  711.235107] 7d40: c0432ae0 c06c76ec df41a868 c0287574 df40ac68 00000000 c06c6994 00000000
[  711.235137] 7d60: df2b7d84 df2b7d70 c02875c4 c02871d4 00000000 df41a868 df2b7dac df2b7d88
[  711.235198] 7d80: c02853e8 c0287580 df2936d8 df294b14 df40ac68 df41a868 df41a89c c06c6ca0
[  711.235229] 7da0: df2b7dcc df2b7db0 c0287154 c028538c df293600 df41a870 df41a868 c06c6ca0
[  711.235290] 7dc0: df2b7dec df2b7dd0 c02865c0 c02870d8 df2b5480 df41a870 df41a868 00000000
[  711.235321] 7de0: df2b7e24 df2b7df0 c02844fc c0286534 39383160 c000343a df407868 0006463a
[  711.235351] 7e00: df41a800 df41a868 df4773c0 df41a800 df40ac00 df407868 df2b7e64 df2b7e28
[  711.235412] 7e20: c02ff3b8 c02840a4 00000000 c006e374 00000007 00000000 00000001 00000000
[  711.235443] 7e40: 00000001 df40a644 df41a800 df40ac00 df407868 00000000 df2b7f24 df2b7e68
[  711.235504] 7e60: c0300c84 c02ff11c 00000000 c042d9d8 df2b7f14 df2b7e80 c042d9d8 00000005
[  711.235534] 7e80: 00000000 c0ea95fc c0eb4008 df347000 00000001 df40a644 df407808 c06c69bc
[  711.235565] 7ea0: df40787c 00000064 df407874 df407870 df407800 df40a820 df40a644 df40a408
[  711.235626] 7ec0: c06e03b0 df40a800 df40ac9c df407800 df40a400 df40ac00 df083dfc 01010113
[  711.235656] 7ee0: df2b0001 00000000 df2b5480 c0069ebc df2b7ef0 df2b7ef0 c0300360 df295ac0
[  711.235717] 7f00: 00000000 00000000 c0300360 00000000 00000000 00000000 df2b7fac df2b7f28
[  711.235748] 7f20: c005bdf4 c030036c df2b7f44 00000000 c006e37c 00000000 00000000 00000001
[  711.235778] 7f40: dead4ead ffffffff ffffffff c06e5a34 00000000 00000000 c053dfec df2b7f5c
[  711.235839] 7f60: df2b7f5c 00000000 00000001 dead4ead ffffffff ffffffff c06e5a34 00000000
[  711.235870] 7f80: 00000000 c053dfec df2b7f88 df2b7f88 df295ac0 c005bd0c 00000000 00000000
[  711.235931] 7fa0: 00000000 df2b7fb0 c000f9c8 c005bd18 00000000 00000000 00000000 00000000
[  711.235961] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  711.236022] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 0843a044 40201100
[  711.236083] [<c023aee8>] (gpiochip_add) from [<bf0334b0>] (dln2_gpio_probe+0x1c8/0x22c [gpio_dln2])
[  711.236145] [<bf0334b0>] (dln2_gpio_probe [gpio_dln2]) from [<c02893e0>] (platform_drv_probe+0x3c/0x6c)
[  711.236206] [<c02893e0>] (platform_drv_probe) from [<c0287314>] (driver_probe_device+0x14c/0x3ac)
[  711.236267] [<c0287314>] (driver_probe_device) from [<c02875c4>] (__device_attach+0x50/0x54)
[  711.236328] [<c02875c4>] (__device_attach) from [<c02853e8>] (bus_for_each_drv+0x68/0x9c)
[  711.236419] [<c02853e8>] (bus_for_each_drv) from [<c0287154>] (device_attach+0x88/0x9c)
[  711.236480] [<c0287154>] (device_attach) from [<c02865c0>] (bus_probe_device+0x98/0xbc)
[  711.236511] [<c02865c0>] (bus_probe_device) from [<c02844fc>] (device_add+0x464/0x584)
[  711.236572] [<c02844fc>] (device_add) from [<c02890c8>] (platform_device_add+0xd8/0x26c)
[  711.236633] [<c02890c8>] (platform_device_add) from [<c02a571c>] (mfd_add_device+0x23c/0x340)
[  711.236663] [<c02a571c>] (mfd_add_device) from [<c02a5918>] (mfd_add_devices+0xb8/0x110)
[  711.236724] [<c02a5918>] (mfd_add_devices) from [<bf02e7bc>] (dln2_probe+0x1c4/0x26c [dln2])
[  711.236816] [<bf02e7bc>] (dln2_probe [dln2]) from [<c030bc38>] (usb_probe_interface+0x1bc/0x2a8)
[  711.236846] [<c030bc38>] (usb_probe_interface) from [<c0287314>] (driver_probe_device+0x14c/0x3ac)
[  711.236907] [<c0287314>] (driver_probe_device) from [<c02875c4>] (__device_attach+0x50/0x54)
[  711.236968] [<c02875c4>] (__device_attach) from [<c02853e8>] (bus_for_each_drv+0x68/0x9c)
[  711.236999] [<c02853e8>] (bus_for_each_drv) from [<c0287154>] (device_attach+0x88/0x9c)
[  711.237060] [<c0287154>] (device_attach) from [<c02865c0>] (bus_probe_device+0x98/0xbc)
[  711.237091] [<c02865c0>] (bus_probe_device) from [<c02844fc>] (device_add+0x464/0x584)
[  711.237152] [<c02844fc>] (device_add) from [<c0309a74>] (usb_set_configuration+0x5bc/0x7f8)
[  711.237213] [<c0309a74>] (usb_set_configuration) from [<c0313d88>] (generic_probe+0x3c/0x88)
[  711.237274] [<c0313d88>] (generic_probe) from [<c030ba48>] (usb_probe_device+0x4c/0x80)
[  711.237304] [<c030ba48>] (usb_probe_device) from [<c0287314>] (driver_probe_device+0x14c/0x3ac)
[  711.237365] [<c0287314>] (driver_probe_device) from [<c02875c4>] (__device_attach+0x50/0x54)
[  711.237396] [<c02875c4>] (__device_attach) from [<c02853e8>] (bus_for_each_drv+0x68/0x9c)
[  711.237457] [<c02853e8>] (bus_for_each_drv) from [<c0287154>] (device_attach+0x88/0x9c)
[  711.237518] [<c0287154>] (device_attach) from [<c02865c0>] (bus_probe_device+0x98/0xbc)
[  711.237548] [<c02865c0>] (bus_probe_device) from [<c02844fc>] (device_add+0x464/0x584)
[  711.237609] [<c02844fc>] (device_add) from [<c02ff3b8>] (usb_new_device+0x2a8/0x474)
[  711.237640] [<c02ff3b8>] (usb_new_device) from [<c0300c84>] (hub_thread+0x924/0x161c)
[  711.237701] [<c0300c84>] (hub_thread) from [<c005bdf4>] (kthread+0xe8/0xfc)
[  711.237762] [<c005bdf4>] (kthread) from [<c000f9c8>] (ret_from_fork+0x14/0x20)
[  711.237823] Code: e0801001 e1510002 ca000003 ea00006e (e5932030) 
[  711.237854] ---[ end trace c3415a06381032c8 ]---
[  711.237915] note: khubd[16] exited with preempt_count 1


And with no exported gpios I also get the following BUG on disconnect just
like Octavian reported in the link above:

[  206.720703] BUG: sleeping function called from invalid context at /home/johan/work/omicron/src/linux/kernel/locking/mutex.c:583
[  206.720825] in_atomic(): 1, irqs_disabled(): 128, pid: 188, name: modprobe
[  206.720855] 3 locks held by modprobe/188:
[  206.720886]  #0:  (&dev->mutex){......}, at: [<c02876c4>] driver_detach+0x54/0xc8
[  206.721069]  #1:  (&dev->mutex){......}, at: [<c02876d0>] driver_detach+0x60/0xc8
[  206.721221]  #2:  (gpio_lock){......}, at: [<c023b720>] gpiochip_remove+0x24/0x160
[  206.721435] irq event stamp: 3994
[  206.721466] hardirqs last  enabled at (3993): [<c0432bcc>] _raw_spin_unlock_irqrestore+0x7c/0x84
[  206.721527] hardirqs last disabled at (3994): [<c0432998>] _raw_spin_lock_irqsave+0x2c/0x6c
[  206.721588] softirqs last  enabled at (3574): [<c0044084>] __do_softirq+0x230/0x3b8
[  206.721679] softirqs last disabled at (3569): [<c0044574>] irq_exit+0xd8/0x114
[  206.721740] Preemption disabled at:[<  (null)>]   (null)
[  206.721801] 
[  206.721832] CPU: 0 PID: 188 Comm: modprobe Tainted: G        W      3.17.0-rc3 #1
[  206.721893] [<c0016bec>] (unwind_backtrace) from [<c0013850>] (show_stack+0x20/0x24)
[  206.721954] [<c0013850>] (show_stack) from [<c042cb14>] (dump_stack+0x24/0x28)
[  206.722015] [<c042cb14>] (dump_stack) from [<c0061fa0>] (__might_sleep+0x144/0x1a0)
[  206.722076] [<c0061fa0>] (__might_sleep) from [<c042ec6c>] (mutex_lock_nested+0x40/0x3d0)
[  206.722137] [<c042ec6c>] (mutex_lock_nested) from [<c007a978>] (free_desc+0x4c/0x74)
[  206.722198] [<c007a978>] (free_desc) from [<c007ab14>] (irq_free_descs+0x58/0x94)
[  206.722229] [<c007ab14>] (irq_free_descs) from [<c0080984>] (irq_dispose_mapping+0x48/0x60)
[  206.722290] [<c0080984>] (irq_dispose_mapping) from [<c023b750>] (gpiochip_remove+0x54/0x160)
[  206.722351] [<c023b750>] (gpiochip_remove) from [<bf0090fc>] (dln2_gpio_remove+0x30/0x44 [gpio_dln2])
[  206.722473] [<bf0090fc>] (dln2_gpio_remove [gpio_dln2]) from [<c0288c2c>] (platform_drv_remove+0x28/0x2c)
[  206.722534] [<c0288c2c>] (platform_drv_remove) from [<c0286d3c>] (__device_release_driver+0x80/0xd4)
[  206.722595] [<c0286d3c>] (__device_release_driver) from [<c0287734>] (driver_detach+0xc4/0xc8)
[  206.722656] [<c0287734>] (driver_detach) from [<c02869dc>] (bus_remove_driver+0x70/0xe4)
[  206.722686] [<c02869dc>] (bus_remove_driver) from [<c028804c>] (driver_unregister+0x38/0x58)
[  206.722747] [<c028804c>] (driver_unregister) from [<c028942c>] (platform_driver_unregister+0x1c/0x20)
[  206.722808] [<c028942c>] (platform_driver_unregister) from [<bf0099a4>] (dln2_gpio_driver_exit+0x14/0x1c [gpio_dln2])
[  206.722930] [<bf0099a4>] (dln2_gpio_driver_exit [gpio_dln2]) from [<c00a11b0>] (SyS_delete_module+0x15c/0x1d4)
[  206.722991] [<c00a11b0>] (SyS_delete_module) from [<c000f900>] (ret_fast_syscall+0x0/0x48)

Johan
