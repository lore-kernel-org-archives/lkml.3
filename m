Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaIJTNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:13:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55246 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:13:51 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Clark <robdclark@gmail.com>
Subject: [PATCH v2] arm: perf: Don't sleep while atomic when enabling per-cpu interrupts
Date: Wed, 10 Sep 2014 12:13:46 -0700
Message-Id: <1410376426-5707-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Clark reports a sleeping while atomic bug when using perf.

BUG: sleeping function called from invalid context at ../kernel/locking/mutex.c:583
in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/0
------------[ cut here ]------------
WARNING: CPU: 2 PID: 4828 at ../kernel/locking/mutex.c:479 mutex_lock_nested+0x3a0/0x3e8()
DEBUG_LOCKS_WARN_ON(in_interrupt())
Modules linked in:
CPU: 2 PID: 4828 Comm: Xorg.bin Tainted: G        W      3.17.0-rc3-00234-gd535c45-dirty #819
[<c0216690>] (unwind_backtrace) from [<c0212174>] (show_stack+0x10/0x14)
[<c0212174>] (show_stack) from [<c0867cc0>] (dump_stack+0x98/0xb8)
[<c0867cc0>] (dump_stack) from [<c02492a4>] (warn_slowpath_common+0x70/0x8c)
[<c02492a4>] (warn_slowpath_common) from [<c02492f0>] (warn_slowpath_fmt+0x30/0x40)
[<c02492f0>] (warn_slowpath_fmt) from [<c086a3f8>] (mutex_lock_nested+0x3a0/0x3e8)
[<c086a3f8>] (mutex_lock_nested) from [<c0294d08>] (irq_find_host+0x20/0x9c)
[<c0294d08>] (irq_find_host) from [<c0769d50>] (of_irq_get+0x28/0x48)
[<c0769d50>] (of_irq_get) from [<c057d104>] (platform_get_irq+0x1c/0x8c)
[<c057d104>] (platform_get_irq) from [<c021a06c>] (cpu_pmu_enable_percpu_irq+0x14/0x38)
[<c021a06c>] (cpu_pmu_enable_percpu_irq) from [<c02b1634>] (flush_smp_call_function_queue+0x88/0x178)
[<c02b1634>] (flush_smp_call_function_queue) from [<c0214dc0>] (handle_IPI+0x88/0x160)
[<c0214dc0>] (handle_IPI) from [<c0208930>] (gic_handle_irq+0x64/0x68)
[<c0208930>] (gic_handle_irq) from [<c0212d04>] (__irq_svc+0x44/0x5c)
Exception stack(0xe63ddea0 to 0xe63ddee8)
dea0: 00000001 00000001 00000000 c2f3b200 c16db380 c032d4a0 e63ddf40 60010013
dec0: 00000000 001fbfd4 00000100 00000000 00000001 e63ddee8 c0284770 c02a2e30
dee0: 20010013 ffffffff
[<c0212d04>] (__irq_svc) from [<c02a2e30>] (ktime_get_ts64+0x1c8/0x200)
[<c02a2e30>] (ktime_get_ts64) from [<c032d4a0>] (poll_select_set_timeout+0x60/0xa8)
[<c032d4a0>] (poll_select_set_timeout) from [<c032df64>] (SyS_select+0xa8/0x118)
[<c032df64>] (SyS_select) from [<c020e8e0>] (ret_fast_syscall+0x0/0x48)
---[ end trace 0bb583b46342da6f ]---
INFO: lockdep is turned off.

We don't really need to get the platform irq again when we're
enabling or disabling the per-cpu irq. Furthermore, we don't
really need to set and clear bits in the active_irqs bitmask
because that's only used in the non-percpu irq case to figure out
when the last CPU PMU has been disabled. Just pass the irq
directly to the enable/disable functions to clean all this up.
This should be slightly more efficient and also fix the
scheduling while atomic bug.

Reported-by: Rob Clark <robdclark@gmail.com>
Fixes: bbd64559376f "ARM: perf: support percpu irqs for the CPU PMU"
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I'll drop this in the patch tracker tomorrow unless I hear differently.

Changes since v1:
 * Simplify code by skipping active_irqs bit setting.

 arch/arm/kernel/perf_event_cpu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index e6a6edbec613..4bf4cce759fe 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -76,21 +76,15 @@ static struct pmu_hw_events *cpu_pmu_get_cpu_events(void)
 
 static void cpu_pmu_enable_percpu_irq(void *data)
 {
-	struct arm_pmu *cpu_pmu = data;
-	struct platform_device *pmu_device = cpu_pmu->plat_device;
-	int irq = platform_get_irq(pmu_device, 0);
+	int irq = *(int *)data;
 
 	enable_percpu_irq(irq, IRQ_TYPE_NONE);
-	cpumask_set_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
 }
 
 static void cpu_pmu_disable_percpu_irq(void *data)
 {
-	struct arm_pmu *cpu_pmu = data;
-	struct platform_device *pmu_device = cpu_pmu->plat_device;
-	int irq = platform_get_irq(pmu_device, 0);
+	int irq = *(int *)data;
 
-	cpumask_clear_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
 	disable_percpu_irq(irq);
 }
 
@@ -103,7 +97,7 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 
 	irq = platform_get_irq(pmu_device, 0);
 	if (irq >= 0 && irq_is_percpu(irq)) {
-		on_each_cpu(cpu_pmu_disable_percpu_irq, cpu_pmu, 1);
+		on_each_cpu(cpu_pmu_disable_percpu_irq, &irq, 1);
 		free_percpu_irq(irq, &percpu_pmu);
 	} else {
 		for (i = 0; i < irqs; ++i) {
@@ -138,7 +132,7 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 				irq);
 			return err;
 		}
-		on_each_cpu(cpu_pmu_enable_percpu_irq, cpu_pmu, 1);
+		on_each_cpu(cpu_pmu_enable_percpu_irq, &irq, 1);
 	} else {
 		for (i = 0; i < irqs; ++i) {
 			err = 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

