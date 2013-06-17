Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3FQRts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:49:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3FQRfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 57/84] xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.
Date: Mon, 17 Jun 2013 10:31:01 -0700
Message-Id: <1371490288-23167-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 466318a87f28cb3ba0d08a3b7ef1a37ae73d5aa7 upstream.

The xen_play_dead is an undead function. When the vCPU is told to
offline it ends up calling xen_play_dead wherin it calls the
VCPUOP_down hypercall which offlines the vCPU. However, when the
vCPU is onlined back, it resumes execution right after
VCPUOP_down hypercall.

That was OK (albeit the API for play_dead assumes that the CPU
stays dead and never returns) but with commit 4b0c0f294
(tick: Cleanup NOHZ per cpu data on cpu down) that is no longer safe
as said commit resets the ts->inidle which at the start of the
cpu_idle loop was set.

The net effect is that we get this warn:

Broke affinity for irq 16
installing Xen timer for CPU 1
cpu 1 spinlock event irq 48
------------[ cut here ]------------
WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935 tick_nohz_idle_exit+0x195/0x1b0()
Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.0-rc3upstream-00068-gdcdbe33 #1
Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 09/03/2009
 ffffffff8193b448 ffff880039da5e60 ffffffff816707c8 ffff880039da5ea0
 ffffffff8108ce8b ffff880039da4010 ffff88003fa8e500 ffff880039da4010
 0000000000000001 ffff880039da4000 ffff880039da4010 ffff880039da5eb0
Call Trace:
 [<ffffffff816707c8>] dump_stack+0x19/0x1b
 [<ffffffff8108ce8b>] warn_slowpath_common+0x6b/0xa0
 [<ffffffff8108ced5>] warn_slowpath_null+0x15/0x20
 [<ffffffff810e4745>] tick_nohz_idle_exit+0x195/0x1b0
 [<ffffffff810da755>] cpu_startup_entry+0x205/0x250
 [<ffffffff81661070>] cpu_bringup_and_idle+0x13/0x15
---[ end trace 915c8c486004dda1 ]---

b/c ts_inidle is set to zero. Thomas suggested that we just add a workaround
to call tick_nohz_idle_enter before returning from xen_play_dead() - and
that is what this patch does and fixes the issue.

We also add the stable part b/c git commit 4b0c0f294 is on the stable
tree.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/xen/smp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 48d7b2c..5f8e4fb 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/irq_work.h>
+#include <linux/tick.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
@@ -432,6 +433,13 @@ static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
 	cpu_bringup();
+	/*
+	 * commit 4b0c0f294 (tick: Cleanup NOHZ per cpu data on cpu down)
+	 * clears certain data that the cpu_idle loop (which called us
+	 * and that we return from) expects. The only way to get that
+	 * data back is to call:
+	 */
+	tick_nohz_idle_enter();
 }
 
 #else /* !CONFIG_HOTPLUG_CPU */
-- 
1.8.1.2

