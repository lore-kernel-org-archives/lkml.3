Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaHaMFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 08:05:42 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57599 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaHaMFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 08:05:40 -0400
Message-ID: <1409486735.4991.19.camel@marge.simpson.net>
Subject: Re: [drm/i915/3.17] panic in i915_digport_work_func
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Date: Sun, 31 Aug 2014 14:05:35 +0200
In-Reply-To: <1409382202.5141.36.camel@marge.simpson.net>
References: <1409382202.5141.36.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-deterministic explosion culprit is the below.  The commit says it
adds mysterious acronyms to Haswell, so I suspect my little core2 lappy
isn't ever supposed to see this code.  The ftrace buffer is in fact
empty after a successful boot. 

commit 0e32b39ceed665bfa4a77a4bc307b6652b991632
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri May 2 14:02:48 2014 +1000

    drm/i915: add DP 1.2 MST support (v0.7)
    
    This adds DP 1.2 MST support on Haswell systems.
    
[    4.251017] **********************************************************
[    4.251018] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    4.251019] **                                                      **
[    4.251020] ** trace_printk() being used. Allocating extra memory.  **
[    4.251021] **                                                      **
[    4.251021] ** This means that this is a DEBUG kernel and it is     **
[    4.251022] ** unsafe for produciton use.                           **
[    4.251023] **                                                      **
[    4.251024] ** If you see this message and you are not debugging    **
[    4.251024] ** the kernel, report this immediately to your vendor!  **
[    4.251025] **                                                      **
[    4.251026] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    4.251027] **********************************************************
[    4.375162] [drm] Memory usable by graphics device = 2048M
[    4.382963] [drm] Replacing VGA console driver
[    4.390710] checking generic (d0000000 7ff0000) vs hw (d0000000 10000000)
[    4.398617] fb: switching to inteldrmfb from VESA VGA
[    4.406578] Console: switching to colour dummy device 80x25
[    4.432283] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[    4.432327] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.432335] [drm] Driver supports precise vblank timestamp query.
[    4.432437] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.521746] BUG: unable to handle kernel paging request at ffffc900108c4000
[    4.521781] IP: [<ffffffffa014323d>] gen4_read32+0x3d/0xc0 [i915]
[    4.521843] PGD 13f021067 PUD 13f022067 PMD 136193067 PTE 0
[    4.521860] Oops: 0000 [#1] SMP 
[    4.521872] Dumping ftrace buffer:
[    4.521880] ---------------------------------
[    4.521936]    udevd-120     1d.h. 4672095us : i9xx_hpd_irq_handler: PIN 1 continue
[    4.521987]    udevd-120     1d.h. 4672097us : i9xx_hpd_irq_handler: PIN 2 continue
[    4.522036]    udevd-120     1d.h. 4672098us : i9xx_hpd_irq_handler: PIN 3 continue
[    4.522085]    udevd-120     1d.h. 4672099us : i9xx_hpd_irq_handler: PIN 4 continue
[    4.522134]    udevd-120     1d.h. 4672099us : i9xx_hpd_irq_handler: PIN 5 continue
[    4.522183]    udevd-120     1d.h. 4672100us : i9xx_hpd_irq_handler: PORT 3 PIN 6 continue
[    4.522233]    udevd-120     1d.h. 4672101us : i9xx_hpd_irq_handler: PORT 3 PIN 6 sets queue_dig = true
[    4.522283]    udevd-120     1d.h. 4672102us : i9xx_hpd_irq_handler: QUEUE
[    4.522331]    <...>-6       0.... 4672125us : i915_digport_work_func: WORK
[    4.522339] ---------------------------------
[    4.522345] Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit thermal video processor thermal_sys button scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh netconsole atl1c
[    4.522401] CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.17.0-bisect #222
[    4.522408] Hardware name: TOSHIBA SATELLITE T130/SATELLITE T130, BIOS V1.70    09/29/2009
[    4.522453] Workqueue: i915-dp i915_digport_work_func [i915]
[    4.522462] task: ffff88013f166150 ti: ffff88013f168000 task.ti: ffff88013f168000
[    4.522470] RIP: 0010:[<ffffffffa014323d>]  [<ffffffffa014323d>] gen4_read32+0x3d/0xc0 [i915]
[    4.522520] RSP: 0018:ffff88013f16bd48  EFLAGS: 00010086
[    4.522527] RAX: 0000000000000297 RBX: ffff88013b1f0000 RCX: 00000000000000da
[    4.522533] RDX: ffffc900108c4000 RSI: ffff88013b1f93c8 RDI: ffff88013b1f0068
[    4.522540] RBP: ffff88013f16bd70 R08: 0000000000000001 R09: 0000000000000024
[    4.522547] R10: 00000001167af8eb R11: 0000000000000006 R12: 00000000000c4000
[    4.522553] R13: ffff88013b1f0068 R14: 0000000000000001 R15: 0000000000000001
[    4.522560] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[    4.522568] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.522575] CR2: ffffc900108c4000 CR3: 0000000001a15000 CR4: 00000000000407f0
[    4.522581] Stack:
[    4.522586]  0000000000800000 0000000000000011 ffff88013584e000 0000000000000001
[    4.522601]  ffff880036c92000 ffff88013f16bd88 ffffffffa01537b3 ffff88013b1f0000
[    4.522617]  ffff88013f16bdc8 ffffffffa0179a73 ffff880036c920e0 ffff88013b1f9400
[    4.522632] Call Trace:
[    4.522681]  [<ffffffffa01537b3>] ibx_digital_port_connected+0x63/0xb0 [i915]
[    4.522733]  [<ffffffffa0179a73>] intel_dp_hpd_pulse+0xc3/0x1f0 [i915]
[    4.522777]  [<ffffffffa0131d60>] i915_digport_work_func+0xb0/0x130 [i915]
[    4.522789]  [<ffffffff81060b26>] process_one_work+0x186/0x3f0
[    4.522797]  [<ffffffff81060eb1>] worker_thread+0x121/0x480
[    4.522806]  [<ffffffff81060d90>] ? process_one_work+0x3f0/0x3f0
[    4.522815]  [<ffffffff81065689>] kthread+0xc9/0xe0
[    4.522824]  [<ffffffff810655c0>] ? kthread_create_on_node+0x170/0x170
[    4.522834]  [<ffffffff8157edac>] ret_from_fork+0x7c/0xb0
[    4.522843]  [<ffffffff810655c0>] ? kthread_create_on_node+0x170/0x170
[    4.522849] Code: 41 54 49 89 f4 53 48 8d b7 c8 93 00 00 48 89 fb 48 8b 3f 4c 8d 6b 68 e8 f2 f1 ff ff 4c 89 ef e8 4a b7 43 e1 4c 89 e2 48 03 53 60 <44> 8b 32 48 89 c6 4c 89 ef e8 a5 b3 43 e1 8b 05 f7 0d 08 00 85 
[    4.523001] RIP  [<ffffffffa014323d>] gen4_read32+0x3d/0xc0 [i915]
[    4.523050]  RSP <ffff88013f16bd48>
[    4.523055] CR2: ffffc900108c4000
[    4.523064] ---[ end trace 08b04cb79531ee7e ]---
[    4.523070] Kernel panic - not syncing: Fatal exception
[    4.523096] Dumping ftrace buffer:
[    4.523101]    (ftrace buffer empty)
[    4.523109] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    4.523118] Rebooting in 10 seconds..

---
 drivers/gpu/drm/i915/i915_drv.c |    2 ++
 drivers/gpu/drm/i915/i915_irq.c |   11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -496,6 +496,7 @@ bool i915_semaphore_is_enabled(struct dr
 
 void intel_hpd_cancel_work(struct drm_i915_private *dev_priv)
 {
+	trace_printk("CANCEL\n");
 	spin_lock_irq(&dev_priv->irq_lock);
 
 	dev_priv->long_hpd_port_mask = 0;
@@ -507,6 +508,7 @@ void intel_hpd_cancel_work(struct drm_i9
 	cancel_work_sync(&dev_priv->dig_port_work);
 	cancel_work_sync(&dev_priv->hotplug_work);
 	cancel_delayed_work_sync(&dev_priv->hotplug_reenable_work);
+	trace_printk("CANCEL DONE\n");
 }
 
 static void intel_suspend_encoders(struct drm_i915_private *dev_priv)
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1100,6 +1100,7 @@ static void i915_digport_work_func(struc
 	int i, ret;
 	u32 old_bits = 0;
 
+	trace_printk("WORK\n");
 	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
 	long_port_mask = dev_priv->long_hpd_port_mask;
 	dev_priv->long_hpd_port_mask = 0;
@@ -1757,10 +1758,13 @@ static inline void intel_hpd_irq_handler
 
 	spin_lock(&dev_priv->irq_lock);
 	for (i = 1; i < HPD_NUM_PINS; i++) {
-		if (!(hpd[i] & hotplug_trigger))
+		if (!(hpd[i] & hotplug_trigger)) {
+			trace_printk("PIN %d continue\n", i);
 			continue;
+		}
 
 		port = get_port_from_pin(i);
+		trace_printk("PORT %d PIN %d continue\n", port, i);
 		if (port && dev_priv->hpd_irq_port[port]) {
 			bool long_hpd;
 
@@ -1784,6 +1788,7 @@ static inline void intel_hpd_irq_handler
 				hotplug_trigger &= ~hpd[i];
 			}
 			queue_dig = true;
+			trace_printk("PORT %d PIN %d sets queue_dig = true\n", port, i);
 		}
 	}
 
@@ -1840,8 +1845,10 @@ static inline void intel_hpd_irq_handler
 	 * queue for otherwise the flush_work in the pageflip code will
 	 * deadlock.
 	 */
-	if (queue_dig)
+	if (queue_dig) {
+		trace_printk("QUEUE\n");
 		queue_work(dev_priv->dp_wq, &dev_priv->dig_port_work);
+	}
 	if (queue_hp)
 		schedule_work(&dev_priv->hotplug_work);
 }


