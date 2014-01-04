Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaADSXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:23:09 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:18139 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755160AbaADSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:23:06 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: [PATCH RFC v2 2/4] perf/x86: IRQ-bound performance events
Date: Sat,  4 Jan 2014 19:22:34 +0100
Message-Id: <833e7a4acc0c9e96bdef189297ea600bbdcc881a.1388858996.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
References: <cover.1388858996.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   55 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h       |   10 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++
 arch/x86/kernel/cpu/perf_event_knc.c   |    2 +
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 +
 include/uapi/linux/perf_event.h        |    1 -
 kernel/events/core.c                   |   34 ++++++--------------
 9 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..3a925e2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -532,15 +532,66 @@ void x86_pmu_enable_all(int added)
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
+		struct perf_event *event = cpuc->events[idx];
+		struct hw_perf_event *hwc = &event->hw;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
+		if (is_hardirq_event(event))
+			continue;
+
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
+void x86_pmu_enable_hardirq(struct perf_event *events[], int count)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < count; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+		struct hw_perf_event *hwc = &event->hw;
+
+		BUG_ON(!test_bit(idx, cpuc->active_mask));
+		BUG_ON(!is_hardirq_event(event));
+
+		if (event->hw.state)
+			continue;
 
 		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 	}
 }
 
+void x86_pmu_disable_hardirq(struct perf_event *events[], int count)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < count; idx++) {
+		struct perf_event *event = events[idx];
+
+		BUG_ON(!test_bit(idx, cpuc->active_mask));
+		BUG_ON(!is_hardirq_event(event));
+
+		x86_pmu_disable_event(event);
+	}
+}
+
+void x86_pmu_nop_hardirq(struct perf_event *events[], int count)
+{
+}
+
+static void x86_pmu_start_hardirq(struct perf_event *events[], int count)
+{
+	x86_pmu.enable_hardirq(events, count);
+}
+
+static void x86_pmu_stop_hardirq(struct perf_event *events[], int count)
+{
+	x86_pmu.disable_hardirq(events, count);
+}
+
 static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
@@ -1871,6 +1922,8 @@ static struct pmu pmu = {
 	.del			= x86_pmu_del,
 	.start			= x86_pmu_start,
 	.stop			= x86_pmu_stop,
+	.start_hardirq		= x86_pmu_start_hardirq,
+	.stop_hardirq		= x86_pmu_stop_hardirq,
 	.read			= x86_pmu_read,
 
 	.start_txn		= x86_pmu_start_txn,
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fd00bb2..03c9595 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -367,6 +367,8 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
+	void		(*enable_hardirq)(struct perf_event *[], int);
+	void		(*disable_hardirq)(struct perf_event *[], int);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -538,6 +540,8 @@ int x86_pmu_hw_config(struct perf_event *event);
 
 void x86_pmu_disable_all(void);
 
+void x86_pmu_disable_hardirq(struct perf_event *events[], int count);
+
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
@@ -550,6 +554,12 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
+void x86_pmu_enable_hardirq(struct perf_event *events[], int count);
+
+void x86_pmu_nop_hardirq(struct perf_event *events[], int count);
+
+void x86_pmu_nop_hardirq_void_int(int irq);
+
 int perf_assign_events(struct perf_event **events, int n,
 			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index beeb7cc..fa51cae 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -621,6 +621,8 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= x86_pmu_enable_all,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= amd_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0fa4f24..c656997 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1931,6 +1931,8 @@ static __initconst const struct x86_pmu core_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= core_pmu_enable_all,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.enable			= core_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
@@ -2076,6 +2078,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.disable_all		= intel_pmu_disable_all,
 	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_event,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.disable		= intel_pmu_disable_event,
 	.hw_config		= intel_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 838fa87..3adffae 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -289,6 +289,8 @@ static const struct x86_pmu knc_pmu __initconst = {
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
 	.enable_all		= knc_pmu_enable_all,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.enable			= knc_pmu_enable_event,
 	.disable		= knc_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3486e66..377edc3 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1286,6 +1286,8 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.handle_irq		= p4_pmu_handle_irq,
 	.disable_all		= p4_pmu_disable_all,
 	.enable_all		= p4_pmu_enable_all,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.enable			= p4_pmu_enable_event,
 	.disable		= p4_pmu_disable_event,
 	.eventsel		= MSR_P4_BPU_CCCR0,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b1e2fe1..94755bf 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -202,6 +202,8 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,
 	.enable_all		= p6_pmu_enable_all,
+	.disable_hardirq	= x86_pmu_nop_hardirq,
+	.enable_hardirq		= x86_pmu_nop_hardirq,
 	.enable			= p6_pmu_enable_event,
 	.disable		= p6_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index a033014..066b53c 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -726,7 +726,6 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
-#define PERF_FLAG_PID_HARDIRQ		(1U << 3) /* pid=irq number */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 465ce681..ec1dfac 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -119,8 +119,7 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
 		       PERF_FLAG_FD_OUTPUT |\
-		       PERF_FLAG_PID_CGROUP |\
-		       PERF_FLAG_PID_HARDIRQ)
+		       PERF_FLAG_PID_CGROUP)
 
 /*
  * branch priv levels that need permission checks
@@ -7028,7 +7027,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
-	int hardirq = -1;
 	int event_fd;
 	int move_group = 0;
 	int err;
@@ -7037,27 +7035,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	if ((flags & (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_HARDIRQ)) ==
-	    (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_HARDIRQ))
-		return -EINVAL;
-
-	/*
-	 * In irq mode, the pid argument is used to pass irq number.
-	 */
-	if (flags & PERF_FLAG_PID_HARDIRQ) {
-		hardirq = pid;
-		pid = -1;
-	}
-
-	/*
-	 * In cgroup mode, the pid argument is used to pass the fd
-	 * opened to the cgroup directory in cgroupfs. The cpu argument
-	 * designates the cpu on which to monitor threads from that
-	 * cgroup.
-	 */
-	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
-		return -EINVAL;
-
 	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
@@ -7072,6 +7049,15 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/*
+	 * In cgroup mode, the pid argument is used to pass the fd
+	 * opened to the cgroup directory in cgroupfs. The cpu argument
+	 * designates the cpu on which to monitor threads from that
+	 * cgroup.
+	 */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	event_fd = get_unused_fd();
 	if (event_fd < 0)
 		return event_fd;
-- 
1.7.7.6

