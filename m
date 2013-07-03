Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab3GCTMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:12:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636Ab3GCTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:22 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=k4lVatg4FdQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XUF306OsxTMA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=JQHUHPG8PnEEckhp7b0A:9 a=7DSvI1NPTFQA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184105.116684551@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [111/141] xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0111-xen-smp-Fixup-NOHZ-per-cpu-data-when-onlining-an-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[ Upstream commit 466318a87f28cb3ba0d08a3b7ef1a37ae73d5aa7 ]

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

CC: stable@vger.kernel.org
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/xen/smp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 641c91e..76bce6e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/irq_work.h>
+#include <linux/tick.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
@@ -435,6 +436,13 @@ static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
 	cpu_bringup();
 	/*
+	 * commit 4b0c0f294 (tick: Cleanup NOHZ per cpu data on cpu down)
+	 * clears certain data that the cpu_idle loop (which called us
+	 * and that we return from) expects. The only way to get that
+	 * data back is to call:
+	 */
+	tick_nohz_idle_enter();
+	/*
 	 * Balance out the preempt calls - as we are running in cpu_idle
 	 * loop which has been called at bootup from cpu_bringup_and_idle.
 	 * The cpucpu_bringup_and_idle called cpu_bringup which made a
-- 
1.7.10.4


