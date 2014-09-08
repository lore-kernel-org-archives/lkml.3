Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaIHS07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:26:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50357 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaIHS05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:26:57 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Clark <robdclark@gmail.com>
Subject: [PATCH] ARM: perf: Don't sleep while atomic when enabling per-cpu interrupts
Date: Mon,  8 Sep 2014 11:26:54 -0700
Message-Id: <1410200814-25878-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
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
enabling or disabling the per-cpu irq. Instead we can pass along
the two pieces of data we need to the enable/disable functions.
This should be slightly more efficient and also fix the
scheduling while atomic bug.

Reported-by: Rob Clark <robdclark@gmail.com>
Fixes: bbd64559376f "ARM: perf: support percpu irqs for the CPU PMU"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/perf_event_cpu.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index e6a6edbec613..1f24b47cd81e 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -74,11 +74,16 @@ static struct pmu_hw_events *cpu_pmu_get_cpu_events(void)
 	return this_cpu_ptr(&cpu_hw_events);
 }
 
+struct pmu_enable {
+	struct arm_pmu *pmu;
+	int irq;
+};
+
 static void cpu_pmu_enable_percpu_irq(void *data)
 {
-	struct arm_pmu *cpu_pmu = data;
-	struct platform_device *pmu_device = cpu_pmu->plat_device;
-	int irq = platform_get_irq(pmu_device, 0);
+	struct pmu_enable *pmu_enable = data;
+	struct arm_pmu *cpu_pmu = pmu_enable->pmu;
+	int irq = pmu_enable->irq;
 
 	enable_percpu_irq(irq, IRQ_TYPE_NONE);
 	cpumask_set_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
@@ -86,9 +91,9 @@ static void cpu_pmu_enable_percpu_irq(void *data)
 
 static void cpu_pmu_disable_percpu_irq(void *data)
 {
-	struct arm_pmu *cpu_pmu = data;
-	struct platform_device *pmu_device = cpu_pmu->plat_device;
-	int irq = platform_get_irq(pmu_device, 0);
+	struct pmu_enable *pmu_enable = data;
+	struct arm_pmu *cpu_pmu = pmu_enable->pmu;
+	int irq = pmu_enable->irq;
 
 	cpumask_clear_cpu(smp_processor_id(), &cpu_pmu->active_irqs);
 	disable_percpu_irq(irq);
@@ -98,12 +103,15 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 {
 	int i, irq, irqs;
 	struct platform_device *pmu_device = cpu_pmu->plat_device;
+	struct pmu_enable pmu_enable;
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 
 	irq = platform_get_irq(pmu_device, 0);
 	if (irq >= 0 && irq_is_percpu(irq)) {
-		on_each_cpu(cpu_pmu_disable_percpu_irq, cpu_pmu, 1);
+		pmu_enable.pmu = cpu_pmu;
+		pmu_enable.irq = irq;
+		on_each_cpu(cpu_pmu_disable_percpu_irq, &pmu_enable, 1);
 		free_percpu_irq(irq, &percpu_pmu);
 	} else {
 		for (i = 0; i < irqs; ++i) {
@@ -120,6 +128,7 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 {
 	int i, err, irq, irqs;
 	struct platform_device *pmu_device = cpu_pmu->plat_device;
+	struct pmu_enable pmu_enable;
 
 	if (!pmu_device)
 		return -ENODEV;
@@ -138,7 +147,9 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 				irq);
 			return err;
 		}
-		on_each_cpu(cpu_pmu_enable_percpu_irq, cpu_pmu, 1);
+		pmu_enable.pmu = cpu_pmu;
+		pmu_enable.irq = irq;
+		on_each_cpu(cpu_pmu_enable_percpu_irq, &pmu_enable, 1);
 	} else {
 		for (i = 0; i < irqs; ++i) {
 			err = 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

