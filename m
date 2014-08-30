Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaH3HD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 03:03:28 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58567 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaH3HD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 03:03:26 -0400
Message-ID: <1409382202.5141.36.camel@marge.simpson.net>
Subject: [drm/i915/3.17] panic in i915_digport_work_func
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Date: Sat, 30 Aug 2014 09:03:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

My little Toshiba lappy is exploding non-deterministically during boot
with master (<= 3.16 work fine).  I tried to bisect it, but apparently
didn't do quite enough reboots before saying 'good', so ended up...

first bad commit: [5fa9be63a42bd4336448d27cbd1f3b993744dd88]
Merge branch 'msm-fixes-3.17' of git://people.freedesktop.org/~robclark/linux into drm-fixes

...touring bisect lala land.  Setting up netconsole, I now have a
picture of the little bugger at least.

[    4.881500] [drm] Replacing VGA console driver
[    4.889652] checking generic (d0000000 7ff0000) vs hw (d0000000 10000000)
[    4.897930] fb: switching to inteldrmfb from VESA VGA
[    4.906132] Console: switching to colour dummy device 80x25
[    4.906138] usb 7-1: new full-speed USB device number 2 using uhci_hcd
[    4.928120] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[    4.928156] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.928164] [drm] Driver supports precise vblank timestamp query.
[    4.928269] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    5.017563] BUG: unable to handle kernel paging request at ffffc900108c4000
[    5.017586] IP: [<ffffffffa018704d>] gen4_read32+0x3d/0xc0 [i915]
[    5.017649] PGD 13f021067 PUD 13f022067 PMD 1361be067 PTE 0
[    5.017667] Oops: 0000 [#1] SMP 
[    5.017678] Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit processor video thermal thermal_sys button scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh netconsole atl1c
[    5.017735] CPU: 0 PID: 54 Comm: kworker/u4:5 Not tainted 3.17.0-master #210
[    5.017743] Hardware name: TOSHIBA SATELLITE T130/SATELLITE T130, BIOS V1.70    09/29/2009
[    5.017788] Workqueue: i915-dp i915_digport_work_func [i915]
[    5.017798] task: ffff8801360de350 ti: ffff8801360e0000 task.ti: ffff8801360e0000
[    5.017805] RIP: 0010:[<ffffffffa018704d>]  [<ffffffffa018704d>] gen4_read32+0x3d/0xc0 [i915]
[    5.017857] RSP: 0018:ffff8801360e3d48  EFLAGS: 00010086
[    5.017863] RAX: 0000000000000297 RBX: ffff880037290000 RCX: 00000000000000da
[    5.017870] RDX: ffffc900108c4000 RSI: ffff8800372993c8 RDI: ffff880037290068
[    5.017877] RBP: ffff8801360e3d70 R08: 0000000000000001 R09: a000000000000000
[    5.017883] R10: dffeab59e7299400 R11: 00000000fffedfee R12: 00000000000c4000
[    5.017890] R13: ffff880037290068 R14: 0000000000000001 R15: 0000000000000001
[    5.017897] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[    5.017906] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.017912] CR2: ffffc900108c4000 CR3: 0000000001a15000 CR4: 00000000000407f0
[    5.017918] Stack:
[    5.017923]  0000000000800000 0000000000000011 ffff880037067000 0000000000000001
[    5.017939]  ffff880037dcb000 ffff8801360e3d88 ffffffffa01975c3 ffff880037290000
[    5.017955]  ffff8801360e3dc8 ffffffffa01bd883 ffff880037dcb0e0 ffff880037299400
[    5.017970] Call Trace:
[    5.018020]  [<ffffffffa01975c3>] ibx_digital_port_connected+0x63/0xb0 [i915]
[    5.018071]  [<ffffffffa01bd883>] intel_dp_hpd_pulse+0xc3/0x1f0 [i915]
[    5.018115]  [<ffffffffa0175b0d>] i915_digport_work_func+0x9d/0x120 [i915]
[    5.018128]  [<ffffffff81060b26>] process_one_work+0x186/0x3f0
[    5.018136]  [<ffffffff81060eb1>] worker_thread+0x121/0x480
[    5.018145]  [<ffffffff81060d90>] ? process_one_work+0x3f0/0x3f0
[    5.018154]  [<ffffffff81065689>] kthread+0xc9/0xe0
[    5.018163]  [<ffffffff810655c0>] ? kthread_create_on_node+0x170/0x170
[    5.018173]  [<ffffffff8157edac>] ret_from_fork+0x7c/0xb0
[    5.018182]  [<ffffffff810655c0>] ? kthread_create_on_node+0x170/0x170
[    5.018188] Code: 41 54 49 89 f4 53 48 8d b7 c8 93 00 00 48 89 fb 48 8b 3f 4c 8d 6b 68 e8 f2 f1 ff ff 4c 89 ef e8 3a 79 3f e1 4c 89 e2 48 03 53 60 <44> 8b 32 48 89 c6 4c 89 ef e8 95 75 3f e1 8b 05 c7 0f 08 00 85 
[    5.018329] RIP  [<ffffffffa018704d>] gen4_read32+0x3d/0xc0 [i915]
[    5.018377]  RSP <ffff8801360e3d48>
[    5.018383] CR2: ffffc900108c4000
[    5.018390] ---[ end trace d3d1a2cea94fa73a ]---
[    5.018397] Kernel panic - not syncing: Fatal exception
[    5.018422] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

crash> mod -s i915
     MODULE       NAME                      SIZE  OBJECT FILE
ffffffffa01d7760  i915                    935705  /lib/modules/3.17.0-master/kernel/drivers/gpu/drm/i915/i915.ko 
crash> gdb list *gen4_read32+0x3d
0xffffffffa015604d is in gen4_read32 (./arch/x86/include/asm/io.h:56).
51      { asm volatile("mov" size " %0,%1": :reg (val), \
52      "m" (*(volatile type __force *)addr) barrier); }
53      
54      build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
55      build_mmio_read(readw, "w", unsigned short, "=r", :"memory")
56      build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
57      
58      build_mmio_read(__readb, "b", unsigned char, "=q", )
59      build_mmio_read(__readw, "w", unsigned short, "=r", )
60      build_mmio_read(__readl, "l", unsigned int, "=r", )
0xffffffffa01665c3 is in ibx_digital_port_connected (drivers/gpu/drm/i915/intel_display.c:1044).
1039                    default:
1040                            return true;
1041                    }
1042            }
1043    
1044            return I915_READ(SDEISR) & bit;
1045    }
1046    
1047    static const char *state_string(bool enabled)
1048    {
crash> gdb list *intel_dp_hpd_pulse+0xc3/0x1f0
0xffffffffa018c7c0 is in intel_dp_hpd_pulse (drivers/gpu/drm/i915/intel_dp.c:4051).
4046            return;
4047    }
4048    
4049    bool
4050    intel_dp_hpd_pulse(struct intel_digital_port *intel_dig_port, bool long_hpd)
4051    {
4052            struct intel_dp *intel_dp = &intel_dig_port->dp;
4053            struct intel_encoder *intel_encoder = &intel_dig_port->base;
4054            struct drm_device *dev = intel_dig_port->base.base.dev;
4055            struct drm_i915_private *dev_priv = dev->dev_private;
crash> gdb list *i915_digport_work_func+0x9d
0xffffffffa0144b0d is in i915_digport_work_func (drivers/gpu/drm/i915/i915_irq.c:1125).
1120                    } else if (short_port_mask & (1 << i))
1121                            valid = true;
1122    
1123                    if (valid) {
1124                            ret = intel_dig_port->hpd_pulse(intel_dig_port, long_hpd);
1125                            if (ret == true) {
1126                                    /* if we get true fallback to old school hpd */
1127                                    old_bits |= (1 << intel_dig_port->base.hpd_pin);
1128                            }
1129                    }


