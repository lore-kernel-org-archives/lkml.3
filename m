Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaHTNp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:45:57 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62700 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaHTNpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:45:53 -0400
MIME-Version: 1.0
Date: Wed, 20 Aug 2014 09:45:52 -0400
X-Google-Sender-Auth: uptjsae_v9U-ZWQ2kokdVgq3yOM
Message-ID: <CA+5PVA53h6-62bZYkdCH0Fs5H5AAvJi49DrRLn=Lq6XXR016bA@mail.gmail.com>
Subject: ite-cir/nuvoton-cir circular locking dependency with v3.17-rc1-22-g480cadc2b7e0
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        James Hogan <james.hogan@imgtec.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been seeing the following lockdep splat on all of the 3.17
kernels I've tried so far on my Celeron and i7 based NUC machines.
Both the ite-cir and nuvoton-cir drivers seem to have similar issues,
so the problem may be in rc_core itself?  I'm hoping you all will have
better ideas.

Splats for both below.

josh

ite-cir:

[    7.750478] ite_cir: Auto-detected model: ITE8713 CIR transceiver
[    7.750484] ite_cir: Using model: ITE8713 CIR transceiver
[    7.750490] ite_cir: TX-capable: 1
[    7.750493] ite_cir: Sample period (ns): 8680
[    7.750495] ite_cir: TX carrier frequency (Hz): 38000
[    7.750498] ite_cir: TX duty cycle (%): 33
[    7.750500] ite_cir: RX low carrier frequency (Hz): 0
[    7.750503] ite_cir: RX high carrier frequency (Hz): 0
[    7.813687] Registered IR keymap rc-rc6-mce
[    7.815512] input: ITE8713 CIR transceiver as /devices/virtual/rc/rc0/input7
[    7.817682] rc0: ITE8713 CIR transceiver as /devices/virtual/rc/rc0
[    7.861333] IR RC6 protocol handler initialized
[    7.864124] IR RC5(x/sz) protocol handler initialized
[    7.869105] IR NEC protocol handler initialized
[    7.885375] IR Sony protocol handler initialized
[    7.886710] IR JVC protocol handler initialized
[    7.892205] IR SANYO protocol handler initialized
[    7.900678] IR Sharp protocol handler initialized
[    7.917897] IR MCE Keyboard/mouse protocol handler initialized
[    7.927969] lirc_dev: IR Remote Control driver registered, major 249
[    7.944156] input: MCE IR Keyboard/Mouse (ite-cir) as
/devices/virtual/input/input8
[    7.944191] ======================================================
[    7.944194] [ INFO: possible circular locking dependency detected ]
[    7.944197] 3.17.0-0.rc1.git1.1.fc22.x86_64 #1 Not tainted
[    7.944200] -------------------------------------------------------
[    7.944203] systemd-udevd/301 is trying to acquire lock:
[    7.944206]  (input_mutex){+.+.+.}, at: [<ffffffff81601357>]
input_register_device+0x4b7/0x5b0
[    7.944219]
but task is already holding lock:
[    7.944222]  (ir_raw_handler_lock){+.+.+.}, at:
[<ffffffffa0078621>] ir_raw_event_register+0x111/0x1b0 [rc_core]
[    7.944233]
which lock already depends on the new lock.

[    7.944237]
the existing dependency chain (in reverse order) is:
[    7.944240]
-> #3 (ir_raw_handler_lock){+.+.+.}:
[    7.944247]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    7.944253]        [<ffffffff81819206>] mutex_lock_nested+0x86/0x450
[    7.944260]        [<ffffffffa0078621>]
ir_raw_event_register+0x111/0x1b0 [rc_core]
[    7.944265]        [<ffffffffa0077d30>]
rc_register_device+0x520/0x610 [rc_core]
[    7.944271]        [<ffffffffa01cd2be>] ite_probe+0x45e/0x52c [ite_cir]
[    7.944278]        [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    7.944284]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    7.944289]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    7.944293]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    7.944298]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    7.944302]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    7.944306]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    7.944310]        [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    7.944315]        [<ffffffffa01e2010>] ite_init+0x10/0x1000 [ite_cir]
[    7.944320]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    7.944326]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    7.944331]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    7.944335]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    7.944341]
-> #2 (&dev->lock){+.+.+.}:
[    7.944347]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    7.944351]        [<ffffffff81819206>] mutex_lock_nested+0x86/0x450
[    7.944356]        [<ffffffffa007633a>] rc_open+0x2a/0x80 [rc_core]
[    7.944362]        [<ffffffffa00763a5>] ir_open+0x15/0x20 [rc_core]
[    7.944367]        [<ffffffff815ff201>] input_open_device+0x81/0xb0
[    7.944371]        [<ffffffff814e8000>] kbd_connect+0x70/0x90
[    7.944377]        [<ffffffff81600e47>] input_attach_handler+0x1b7/0x210
[    7.944381]        [<ffffffff8160139b>] input_register_device+0x4fb/0x5b0
[    7.944385]        [<ffffffffa0077bb5>]
rc_register_device+0x3a5/0x610 [rc_core]
[    7.944391]        [<ffffffffa01cd2be>] ite_probe+0x45e/0x52c [ite_cir]
[    7.944397]        [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    7.944401]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    7.944406]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    7.944410]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    7.944414]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    7.944418]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    7.944423]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    7.944427]        [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    7.944431]        [<ffffffffa01e2010>] ite_init+0x10/0x1000 [ite_cir]
[    7.944437]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    7.944441]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    7.944445]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    7.944450]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    7.944454]
-> #1 (&dev->mutex#2){+.+...}:
[    7.944461]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    7.944466]        [<ffffffff81819f67>]
mutex_lock_interruptible_nested+0x87/0x4b0
[    7.944470]        [<ffffffff815ff9ae>] input_register_handle+0x2e/0xb0
[    7.944475]        [<ffffffff814e7fda>] kbd_connect+0x4a/0x90
[    7.944479]        [<ffffffff81600e47>] input_attach_handler+0x1b7/0x210
[    7.944484]        [<ffffffff8160139b>] input_register_device+0x4fb/0x5b0
[    7.944488]        [<ffffffff814ae6a0>] acpi_button_add+0x27e/0x381
[    7.944493]        [<ffffffff8146d765>] acpi_device_probe+0x47/0x18f
[    7.944498]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    7.944503]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    7.944507]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    7.944511]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    7.944515]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    7.944520]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    7.944524]        [<ffffffff8146dec3>] acpi_bus_register_driver+0x3b/0x43
[    7.944528]        [<ffffffff821fb8c0>] acpi_button_driver_init+0x10/0x12
[    7.944534]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    7.944539]        [<ffffffff821b2365>] kernel_init_freeable+0x1f8/0x297
[    7.944544]        [<ffffffff8180437e>] kernel_init+0xe/0xf0
[    7.944550]        [<ffffffff8181e23c>] ret_from_fork+0x7c/0xb0
[    7.944554]
-> #0 (input_mutex){+.+.+.}:
[    7.944560]        [<ffffffff810f92ff>] __lock_acquire+0x1b7f/0x1c90
[    7.944564]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    7.944569]        [<ffffffff81819f67>]
mutex_lock_interruptible_nested+0x87/0x4b0
[    7.944573]        [<ffffffff81601357>] input_register_device+0x4b7/0x5b0
[    7.944577]        [<ffffffffa02d01ed>]
ir_mce_kbd_register+0x11d/0x150 [ir_mce_kbd_decoder]
[    7.944582]        [<ffffffffa007865e>]
ir_raw_event_register+0x14e/0x1b0 [rc_core]
[    7.944588]        [<ffffffffa0077d30>]
rc_register_device+0x520/0x610 [rc_core]
[    7.944593]        [<ffffffffa01cd2be>] ite_probe+0x45e/0x52c [ite_cir]
[    7.944599]        [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    7.944604]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    7.944608]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    7.944612]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    7.944617]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    7.944621]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    7.944625]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    7.944629]        [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    7.944634]        [<ffffffffa01e2010>] ite_init+0x10/0x1000 [ite_cir]
[    7.944639]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    7.944643]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    7.944648]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    7.944652]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    7.944657]
other info that might help us debug this:

[    7.944660] Chain exists of:
  input_mutex --> &dev->lock --> ir_raw_handler_lock

[    7.944668]  Possible unsafe locking scenario:

[    7.944671]        CPU0                    CPU1
[    7.944674]        ----                    ----
[    7.944676]   lock(ir_raw_handler_lock);
[    7.944680]                                lock(&dev->lock);
[    7.944684]                                lock(ir_raw_handler_lock);
[    7.944687]   lock(input_mutex);
[    7.944691]
 *** DEADLOCK ***

[    7.944695] 4 locks held by systemd-udevd/301:
[    7.944698]  #0:  (&dev->mutex){......}, at: [<ffffffff8151d44b>]
__driver_attach+0x4b/0xa0
[    7.944706]  #1:  (&dev->mutex){......}, at: [<ffffffff8151d459>]
__driver_attach+0x59/0xa0
[    7.944715]  #2:  (&dev->lock){+.+.+.}, at: [<ffffffffa0077bc2>]
rc_register_device+0x3b2/0x610 [rc_core]
[    7.944725]  #3:  (ir_raw_handler_lock){+.+.+.}, at:
[<ffffffffa0078621>] ir_raw_event_register+0x111/0x1b0 [rc_core]
[    7.944735]
stack backtrace:
[    7.944740] CPU: 1 PID: 301 Comm: systemd-udevd Not tainted
3.17.0-0.rc1.git1.1.fc22.x86_64 #1
[    7.944743] Hardware name:
\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff
\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff/DN2820FYK,
BIOS FYBYT10H.86A.0034.2014.0513.1413 05/13/2014
[    7.944746]  0000000000000000 000000002ecba2a5 ffff88003f643898
ffffffff818141eb
[    7.944753]  ffffffff82b6c300 ffff88003f6438d8 ffffffff8180f59d
ffff88003f643930
[    7.944759]  ffff88003f46bfa8 ffff88003f46bfa8 0000000000000004
ffff88003f46b360
[    7.944766] Call Trace:
[    7.944772]  [<ffffffff818141eb>] dump_stack+0x4d/0x66
[    7.944778]  [<ffffffff8180f59d>] print_circular_bug+0x201/0x20f
[    7.944784]  [<ffffffff810f92ff>] __lock_acquire+0x1b7f/0x1c90
[    7.944789]  [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    7.944794]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    7.944799]  [<ffffffff81819f67>] mutex_lock_interruptible_nested+0x87/0x4b0
[    7.944804]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    7.944809]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    7.944814]  [<ffffffff81601349>] ? input_register_device+0x4a9/0x5b0
[    7.944820]  [<ffffffff81228e2a>] ? kfree+0xda/0x2b0
[    7.944825]  [<ffffffff81601357>] input_register_device+0x4b7/0x5b0
[    7.944831]  [<ffffffffa02d01ed>] ir_mce_kbd_register+0x11d/0x150
[ir_mce_kbd_decoder]
[    7.944838]  [<ffffffffa007865e>] ir_raw_event_register+0x14e/0x1b0 [rc_core]
[    7.944844]  [<ffffffffa0077d30>] rc_register_device+0x520/0x610 [rc_core]
[    7.944851]  [<ffffffffa01cd2be>] ite_probe+0x45e/0x52c [ite_cir]
[    7.944859]  [<ffffffffa01cce60>] ? ite_cir_isr+0x250/0x250 [ite_cir]
[    7.944864]  [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    7.944869]  [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    7.944874]  [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    7.944879]  [<ffffffff8151d400>] ? __device_attach+0x40/0x40
[    7.944884]  [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    7.944889]  [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    7.944894]  [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    7.944903]  [<ffffffffa01e2000>] ? 0xffffffffa01e2000
[    7.944908]  [<ffffffff8151df94>] driver_register+0x64/0xf0
[    7.944913]  [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    7.944919]  [<ffffffffa01e2010>] ite_init+0x10/0x1000 [ite_cir]
[    7.944924]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    7.944930]  [<ffffffff8120b892>] ? __vunmap+0xd2/0x120
[    7.944936]  [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    7.944942]  [<ffffffff81138a90>] ? store_uevent+0x70/0x70
[    7.944948]  [<ffffffff810fa028>] ? lock_release_non_nested+0x308/0x350
[    7.944954]  [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    7.944959]  [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    7.945528] ite_cir: driver has been successfully loaded
[    7.947797] rc rc0: lirc_dev: driver ir-lirc-codec (ite-cir)
registered at minor = 0
[    7.947806] IR LIRC bridge handler initialized
[    7.949621] IR XMP protocol handler initialized


nuvoton-cir:
[    6.308136] nuvoton-cir 00:05: [io  0x0240-0x024f]
[    6.308382] nuvoton-cir 00:05: [irq 3]
[    6.308396] nuvoton-cir 00:05: [io  0x0250-0x025f]
[    6.310735] nuvoton-cir 00:05: activated
[    6.349116] Registered IR keymap rc-rc6-mce
[    6.352540] input: Nuvoton w836x7hg Infrared Remote Transceiver as
/devices/pnp0/00:05/rc/rc0/input3
[    6.354903] rc0: Nuvoton w836x7hg Infrared Remote Transceiver as
/devices/pnp0/00:05/rc/rc0
[    6.364456] IR RC6 protocol handler initialized
[    6.375229] IR JVC protocol handler initialized
[    6.377060] IR Sony protocol handler initialized
[    6.380256] IR NEC protocol handler initialized
[    6.382302] nuvoton_cir: driver has been successfully loaded
[    6.382944] IR SANYO protocol handler initialized
[    6.386933] IR RC5(x/sz) protocol handler initialized
[    6.391892] IR Sharp protocol handler initialized
[    6.396079] IR XMP protocol handler initialized
[    6.400013] lirc_dev: IR Remote Control driver registered, major 247
[    6.400152] input: MCE IR Keyboard/Mouse (nuvoton-cir) as
/devices/virtual/input/input4

[    6.400176] ======================================================
[    6.400179] [ INFO: possible circular locking dependency detected ]
[    6.400182] 3.17.0-0.rc1.git1.1.fc22.x86_64 #1 Not tainted
[    6.400184] -------------------------------------------------------
[    6.400187] modprobe/448 is trying to acquire lock:
[    6.400190]  (input_mutex){+.+.+.}, at: [<ffffffff81601357>]
input_register_device+0x4b7/0x5b0
[    6.400203]
but task is already holding lock:
[    6.400206]  (ir_raw_handler_lock){+.+.+.}, at:
[<ffffffffa00f43cd>] ir_raw_handler_register+0x1d/0x90 [rc_core]
[    6.400218]
which lock already depends on the new lock.

[    6.400222]
the existing dependency chain (in reverse order) is:
[    6.400225]
-> #3 (ir_raw_handler_lock){+.+.+.}:
[    6.400232]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    6.400239]        [<ffffffff81819206>] mutex_lock_nested+0x86/0x450
[    6.400246]        [<ffffffffa00f4621>]
ir_raw_event_register+0x111/0x1b0 [rc_core]
[    6.400252]        [<ffffffffa00f3d30>]
rc_register_device+0x520/0x610 [rc_core]
[    6.400258]        [<ffffffffa00ab6b3>] nvt_probe+0x623/0xe9c [nuvoton_cir]
[    6.400264]        [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    6.400270]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    6.400276]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    6.400281]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    6.400285]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    6.400290]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    6.400295]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    6.400299]        [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    6.400304]        [<ffffffffa0210010>] ir_xmp_decode+0x10/0x5c4
[ir_xmp_decoder]
[    6.400309]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    6.400315]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    6.400321]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    6.400326]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    6.400331]
-> #2 (&dev->lock){+.+.+.}:
[    6.400338]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    6.400343]        [<ffffffff81819206>] mutex_lock_nested+0x86/0x450
[    6.400349]        [<ffffffffa00f233a>] rc_open+0x2a/0x80 [rc_core]
[    6.400355]        [<ffffffffa00f23a5>] ir_open+0x15/0x20 [rc_core]
[    6.400361]        [<ffffffff815ff201>] input_open_device+0x81/0xb0
[    6.400367]        [<ffffffff814e8000>] kbd_connect+0x70/0x90
[    6.400373]        [<ffffffff81600e47>] input_attach_handler+0x1b7/0x210
[    6.400377]        [<ffffffff8160139b>] input_register_device+0x4fb/0x5b0
[    6.400382]        [<ffffffffa00f3bb5>]
rc_register_device+0x3a5/0x610 [rc_core]
[    6.400389]        [<ffffffffa00ab6b3>] nvt_probe+0x623/0xe9c [nuvoton_cir]
[    6.400394]        [<ffffffff814bc445>] pnp_device_probe+0x65/0xd0
[    6.400399]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    6.400404]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    6.400409]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    6.400414]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    6.400418]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    6.400423]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    6.400428]        [<ffffffff814bc270>] pnp_register_driver+0x20/0x30
[    6.400433]        [<ffffffffa0210010>] ir_xmp_decode+0x10/0x5c4
[ir_xmp_decoder]
[    6.400438]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    6.400444]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    6.400448]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    6.400451]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    6.400454]
-> #1 (&dev->mutex#2){+.+...}:
[    6.400459]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    6.400462]        [<ffffffff81819f67>]
mutex_lock_interruptible_nested+0x87/0x4b0
[    6.400466]        [<ffffffff815ff9ae>] input_register_handle+0x2e/0xb0
[    6.400469]        [<ffffffff814e7fda>] kbd_connect+0x4a/0x90
[    6.400473]        [<ffffffff81600e47>] input_attach_handler+0x1b7/0x210
[    6.400476]        [<ffffffff8160139b>] input_register_device+0x4fb/0x5b0
[    6.400479]        [<ffffffff814ae6a0>] acpi_button_add+0x27e/0x381
[    6.400482]        [<ffffffff8146d765>] acpi_device_probe+0x47/0x18f
[    6.400488]        [<ffffffff8151d11d>] driver_probe_device+0x12d/0x3d0
[    6.400493]        [<ffffffff8151d493>] __driver_attach+0x93/0xa0
[    6.400497]        [<ffffffff8151aed3>] bus_for_each_dev+0x73/0xc0
[    6.400501]        [<ffffffff8151caee>] driver_attach+0x1e/0x20
[    6.400506]        [<ffffffff8151c6c8>] bus_add_driver+0x188/0x260
[    6.400510]        [<ffffffff8151df94>] driver_register+0x64/0xf0
[    6.400515]        [<ffffffff8146dec3>] acpi_bus_register_driver+0x3b/0x43
[    6.400520]        [<ffffffff821fb8c0>] acpi_button_driver_init+0x10/0x12
[    6.400527]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    6.400531]        [<ffffffff821b2365>] kernel_init_freeable+0x1f8/0x297
[    6.400538]        [<ffffffff8180437e>] kernel_init+0xe/0xf0
[    6.400544]        [<ffffffff8181e23c>] ret_from_fork+0x7c/0xb0
[    6.400549]
-> #0 (input_mutex){+.+.+.}:
[    6.400556]        [<ffffffff810f92ff>] __lock_acquire+0x1b7f/0x1c90
[    6.400560]        [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    6.400565]        [<ffffffff81819f67>]
mutex_lock_interruptible_nested+0x87/0x4b0
[    6.400570]        [<ffffffff81601357>] input_register_device+0x4b7/0x5b0
[    6.400575]        [<ffffffffa02401ed>]
ir_mce_kbd_register+0x11d/0x150 [ir_mce_kbd_decoder]
[    6.400580]        [<ffffffffa00f440e>]
ir_raw_handler_register+0x5e/0x90 [rc_core]
[    6.400587]        [<ffffffffa0245010>]
ir_mce_kbd_decode_init+0x10/0x1000 [ir_mce_kbd_decoder]
[    6.400592]        [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    6.400597]        [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    6.400602]        [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    6.400606]        [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    6.400612]
other info that might help us debug this:

[    6.400616] Chain exists of:
  input_mutex --> &dev->lock --> ir_raw_handler_lock

[    6.400625]  Possible unsafe locking scenario:

[    6.400629]        CPU0                    CPU1
[    6.400631]        ----                    ----
[    6.400633]   lock(ir_raw_handler_lock);
[    6.400638]                                lock(&dev->lock);
[    6.400642]                                lock(ir_raw_handler_lock);
[    6.400646]   lock(input_mutex);
[    6.400651]
 *** DEADLOCK ***
[    6.400655] 1 lock held by modprobe/448:
[    6.400658]  #0:  (ir_raw_handler_lock){+.+.+.}, at:
[<ffffffffa00f43cd>] ir_raw_handler_register+0x1d/0x90 [rc_core]
[    6.400671]
stack backtrace:
[    6.400676] CPU: 3 PID: 448 Comm: modprobe Not tainted
3.17.0-0.rc1.git1.1.fc22.x86_64 #1
[    6.400680] Hardware name:                  /D34010WYK, BIOS
WYLPT10H.86A.0026.2014.0514.1714 05/14/2014
[    6.400682]  0000000000000000 0000000064f97d22 ffff880406333a78
ffffffff818141eb
[    6.400690]  ffffffff82b6cac0 ffff880406333ab8 ffffffff8180f59d
ffff880406333b10
[    6.400697]  ffff880404b7a550 ffff880404b7a550 0000000000000001
ffff880404b799b0
[    6.400704] Call Trace:
[    6.400711]  [<ffffffff818141eb>] dump_stack+0x4d/0x66
[    6.400718]  [<ffffffff8180f59d>] print_circular_bug+0x201/0x20f
[    6.400724]  [<ffffffff810f92ff>] __lock_acquire+0x1b7f/0x1c90
[    6.400730]  [<ffffffff810f71e5>] ? mark_held_locks+0x75/0xa0
[    6.400735]  [<ffffffff810f9be9>] lock_acquire+0x99/0x1d0
[    6.400741]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    6.400746]  [<ffffffff81819f67>] mutex_lock_interruptible_nested+0x87/0x4b0
[    6.400752]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    6.400757]  [<ffffffff81601357>] ? input_register_device+0x4b7/0x5b0
[    6.400762]  [<ffffffff81601349>] ? input_register_device+0x4a9/0x5b0
[    6.400768]  [<ffffffff81601357>] input_register_device+0x4b7/0x5b0
[    6.400774]  [<ffffffffa02401ed>] ir_mce_kbd_register+0x11d/0x150
[ir_mce_kbd_decoder]
[    6.400781]  [<ffffffffa0245000>] ? 0xffffffffa0245000
[    6.400788]  [<ffffffffa00f440e>] ir_raw_handler_register+0x5e/0x90 [rc_core]
[    6.400794]  [<ffffffffa0245010>]
ir_mce_kbd_decode_init+0x10/0x1000 [ir_mce_kbd_decoder]
[    6.400800]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    6.400807]  [<ffffffff8120b892>] ? __vunmap+0xd2/0x120
[    6.400813]  [<ffffffff8113d361>] load_module+0x1c81/0x2720
[    6.400820]  [<ffffffff81138a90>] ? store_uevent+0x70/0x70
[    6.400826]  [<ffffffff810fa028>] ? lock_release_non_nested+0x308/0x350
[    6.400832]  [<ffffffff8113dedf>] SyS_init_module+0xdf/0x130
[    6.400839]  [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    6.408873] IR MCE Keyboard/mouse protocol handler initialized
[    6.416339] rc rc0: lirc_dev: driver ir-lirc-codec (nuvoton-cir)
registered at minor = 0
[    6.416346] IR LIRC bridge handler initialized
