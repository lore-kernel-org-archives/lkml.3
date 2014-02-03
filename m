Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBCPe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:34:28 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:51022 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaBCPe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:34:26 -0500
Date: Mon, 3 Feb 2014 16:34:13 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [3.14-rc1] cirrus driver problem (qemu)
Message-ID: <20140203153413.GA12991@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot 3.14-rc1 in qemu, I get the trace below. The console stops
updating and I don't get a login prompt. I can login, but I can't see
what I'm doing. I can login normally via SSH.

If I revert the last commit in drivers/gpu/drm/cirrus:

f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 drm: ast,cirrus,mgag200: use drm_can_sleep

the problem is solved.


[    1.749341] ------------[ cut here ]------------
[    1.749347] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:856 mutex_trylock+0x1e5/0x250()
[    1.749348] DEBUG_LOCKS_WARN_ON(in_interrupt())
[    1.749360] Modules linked in: ppdev cirrus syscopyarea sysfillrect sysimgblt drm_kms_helper evdev psmouse microcode serio_raw pcspkr ttm e1000 parport_pc parport processor button intel_agp drm intel_gtt i2c_piix4 ipv6 ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix 9pnet_virtio 9pnet libata scsi_mod
[    1.749362] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc1-t1 #34
[    1.749364] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.749366]  0000000000000009 ffff88001fc038c8 ffffffff814e8456 ffff88001fc03910
[    1.749367]  ffff88001fc03900 ffffffff8106a0dd ffff88001d3ff990 0000000000000010
[    1.749368]  0000000000000000 00000000000001e0 ffff88001cc3b000 ffff88001fc03960
[    1.749369] Call Trace:
[    1.749372]  <IRQ>  [<ffffffff814e8456>] dump_stack+0x4d/0x6f
[    1.749374]  [<ffffffff8106a0dd>] warn_slowpath_common+0x7d/0xa0
[    1.749375]  [<ffffffff8106a14c>] warn_slowpath_fmt+0x4c/0x50
[    1.749377]  [<ffffffff814ebf45>] mutex_trylock+0x1e5/0x250
[    1.749380]  [<ffffffffa037888c>] cirrus_dirty_update+0x7c/0x2f0 [cirrus]
[    1.749381]  [<ffffffffa0378b2f>] cirrus_imageblit+0x2f/0x40 [cirrus]
[    1.749388]  [<ffffffff813188f4>] soft_cursor+0x1b4/0x250
[    1.749390]  [<ffffffff813181a3>] bit_cursor+0x613/0x650
[    1.749391]  [<ffffffff81313891>] ? get_color.isra.15+0x31/0x140
[    1.749392]  [<ffffffff8131442b>] fbcon_cursor+0x13b/0x1c0
[    1.749393]  [<ffffffff81317b90>] ? update_attr.isra.2+0x90/0x90
[    1.749398]  [<ffffffff81380fd8>] hide_cursor+0x28/0xa0
[    1.749400]  [<ffffffff81382428>] vt_console_print+0x398/0x3d0
[    1.749405]  [<ffffffff810bc0af>] ? print_prefix+0x6f/0xb0
[    1.749407]  [<ffffffff810bcc03>] call_console_drivers.constprop.18+0x93/0x110
[    1.749409]  [<ffffffff810bd33f>] console_unlock+0x3cf/0x410
[    1.749410]  [<ffffffff810bd501>] vprintk_emit+0x181/0x4f0
[    1.749412]  [<ffffffff814e60dd>] printk+0x54/0x56
[    1.749414]  [<ffffffff81397bca>] credit_entropy_bits+0x2ea/0x300
[    1.749415]  [<ffffffff81398166>] ? mix_pool_bytes.constprop.30+0x56/0xc0
[    1.749416]  [<ffffffff8139866e>] add_timer_randomness+0xee/0x120
[    1.749418]  [<ffffffff81399463>] add_disk_randomness+0x33/0xb0
[    1.749424]  [<ffffffff8127d4bc>] blk_update_bidi_request+0x5c/0x80
[    1.749426]  [<ffffffff8127d79f>] blk_end_bidi_request+0x1f/0x60
[    1.749427]  [<ffffffff8127d7f0>] blk_end_request+0x10/0x20
[    1.749433]  [<ffffffffa0009db9>] scsi_io_completion+0xa9/0x640 [scsi_mod]
[    1.749436]  [<ffffffffa00014b2>] scsi_finish_command+0xa2/0xe0 [scsi_mod]
[    1.749440]  [<ffffffffa0009c1e>] scsi_softirq_done+0x10e/0x130 [scsi_mod]
[    1.749441]  [<ffffffff81283fb3>] blk_done_softirq+0x93/0xb0
[    1.749443]  [<ffffffff8106ee15>] __do_softirq+0x105/0x2f0
[    1.749444]  [<ffffffff8106f2b2>] irq_exit+0x92/0xc0
[    1.749446]  [<ffffffff814fa798>] do_IRQ+0x58/0xf0
[    1.749447]  [<ffffffff814f03ad>] common_interrupt+0x6d/0x6d
[    1.749450]  <EOI>  [<ffffffff810546d6>] ? native_safe_halt+0x6/0x10
[    1.749453]  [<ffffffff8102047d>] default_idle+0x2d/0x110
[    1.749454]  [<ffffffff81020e9e>] arch_cpu_idle+0x2e/0x40
[    1.749455]  [<ffffffff810bec05>] cpu_startup_entry+0xa5/0x2e0
[    1.749464]  [<ffffffff81ae2120>] ? early_idt_handlers+0x120/0x120
[    1.749466]  [<ffffffff814daad4>] rest_init+0x84/0x90
[    1.749467]  [<ffffffff81ae2fa9>] start_kernel+0x443/0x44e
[    1.749468]  [<ffffffff81ae296f>] ? repair_env_string+0x5c/0x5c
[    1.749469]  [<ffffffff81ae25f6>] x86_64_start_reservations+0x2a/0x2c
[    1.749470]  [<ffffffff81ae2761>] x86_64_start_kernel+0x169/0x178
[    1.749471] ---[ end trace d478ba7c30908d4d ]---


-- 
Sabrina Dubroca
