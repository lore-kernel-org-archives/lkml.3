Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3EAT2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:28:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8338 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab3EAT2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:28:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,590,1363132800"; 
   d="scan'208";a="21637183"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/3] xen: move do_stolen_accounting to drivers/xen/time.c
Date: Wed, 1 May 2013 20:27:39 +0100
Message-ID: <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move do_stolen_accounting, xen_vcpu_stolen and related functions and
static variables to common code (drivers/xen/time.c).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/time.c   |  127 +-------------------------------------------
 drivers/xen/Makefile  |    2 +-
 drivers/xen/time.c    |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h |    4 ++
 4 files changed, 148 insertions(+), 127 deletions(-)
 create mode 100644 drivers/xen/time.c

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0296a95..278b7c2 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -28,131 +28,6 @@
 
 /* Xen may fire a timer up to this many ns early */
 #define TIMER_SLOP	100000
-#define NS_PER_TICK	(1000000000LL / HZ)
-
-/* runstate info updated by Xen */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
-
-/* snapshots of runstate info */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
-
-/* unused ns of stolen and blocked time */
-static DEFINE_PER_CPU(u64, xen_residual_stolen);
-static DEFINE_PER_CPU(u64, xen_residual_blocked);
-
-/* return an consistent snapshot of 64-bit time/counter value */
-static u64 get64(const u64 *p)
-{
-	u64 ret;
-
-	if (BITS_PER_LONG < 64) {
-		u32 *p32 = (u32 *)p;
-		u32 h, l;
-
-		/*
-		 * Read high then low, and then make sure high is
-		 * still the same; this will only loop if low wraps
-		 * and carries into high.
-		 * XXX some clean way to make this endian-proof?
-		 */
-		do {
-			h = p32[1];
-			barrier();
-			l = p32[0];
-			barrier();
-		} while (p32[1] != h);
-
-		ret = (((u64)h) << 32) | l;
-	} else
-		ret = *p;
-
-	return ret;
-}
-
-/*
- * Runstate accounting
- */
-static void get_runstate_snapshot(struct vcpu_runstate_info *res)
-{
-	u64 state_time;
-	struct vcpu_runstate_info *state;
-
-	BUG_ON(preemptible());
-
-	state = &__get_cpu_var(xen_runstate);
-
-	/*
-	 * The runstate info is always updated by the hypervisor on
-	 * the current CPU, so there's no need to use anything
-	 * stronger than a compiler barrier when fetching it.
-	 */
-	do {
-		state_time = get64(&state->state_entry_time);
-		barrier();
-		*res = *state;
-		barrier();
-	} while (get64(&state->state_entry_time) != state_time);
-}
-
-/* return true when a vcpu could run but has no real cpu to run on */
-bool xen_vcpu_stolen(int vcpu)
-{
-	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
-}
-
-void xen_setup_runstate_info(int cpu)
-{
-	struct vcpu_register_runstate_memory_area area;
-
-	area.addr.v = &per_cpu(xen_runstate, cpu);
-
-	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
-			       cpu, &area))
-		BUG();
-}
-
-static void do_stolen_accounting(void)
-{
-	struct vcpu_runstate_info state;
-	struct vcpu_runstate_info *snap;
-	s64 blocked, runnable, offline, stolen;
-	cputime_t ticks;
-
-	get_runstate_snapshot(&state);
-
-	WARN_ON(state.state != RUNSTATE_running);
-
-	snap = &__get_cpu_var(xen_runstate_snapshot);
-
-	/* work out how much time the VCPU has not been runn*ing*  */
-	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
-	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
-	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
-
-	*snap = state;
-
-	/* Add the appropriate number of ticks of stolen time,
-	   including any left-overs from last time. */
-	stolen = runnable + offline + __this_cpu_read(xen_residual_stolen);
-
-	if (stolen < 0)
-		stolen = 0;
-
-	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
-	__this_cpu_write(xen_residual_stolen, stolen);
-	account_steal_ticks(ticks);
-
-	/* Add the appropriate number of ticks of blocked time,
-	   including any left-overs from last time. */
-	blocked += __this_cpu_read(xen_residual_blocked);
-
-	if (blocked < 0)
-		blocked = 0;
-
-	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__this_cpu_write(xen_residual_blocked, blocked);
-	account_idle_ticks(ticks);
-}
 
 /* Get the TSC speed from Xen */
 static unsigned long xen_tsc_khz(void)
@@ -390,7 +265,7 @@ static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
-	do_stolen_accounting();
+	xen_stolen_accounting();
 
 	return ret;
 }
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index eabd0ee..2bf461a 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -3,7 +3,7 @@ obj-y	+= manage.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
 obj-$(CONFIG_X86)			+= fallback.o
-obj-y	+= grant-table.o features.o events.o balloon.o
+obj-y	+= grant-table.o features.o events.o balloon.o time.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/drivers/xen/time.c b/drivers/xen/time.c
new file mode 100644
index 0000000..d00ed24
--- /dev/null
+++ b/drivers/xen/time.c
@@ -0,0 +1,142 @@
+/*
+ * Xen stolen ticks accounting.
+ */
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/math64.h>
+#include <linux/gfp.h>
+
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/events.h>
+#include <xen/features.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/vcpu.h>
+#include <xen/xen-ops.h>
+
+#define NS_PER_TICK	(1000000000LL / HZ)
+
+/* runstate info updated by Xen */
+static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
+
+/* snapshots of runstate info */
+static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
+
+/* unused ns of stolen and blocked time */
+static DEFINE_PER_CPU(u64, xen_residual_stolen);
+static DEFINE_PER_CPU(u64, xen_residual_blocked);
+
+/* return an consistent snapshot of 64-bit time/counter value */
+static u64 get64(const u64 *p)
+{
+	u64 ret;
+
+	if (BITS_PER_LONG < 64) {
+		u32 *p32 = (u32 *)p;
+		u32 h, l;
+
+		/*
+		 * Read high then low, and then make sure high is
+		 * still the same; this will only loop if low wraps
+		 * and carries into high.
+		 * XXX some clean way to make this endian-proof?
+		 */
+		do {
+			h = p32[1];
+			barrier();
+			l = p32[0];
+			barrier();
+		} while (p32[1] != h);
+
+		ret = (((u64)h) << 32) | l;
+	} else
+		ret = *p;
+
+	return ret;
+}
+
+/*
+ * Runstate accounting
+ */
+static void get_runstate_snapshot(struct vcpu_runstate_info *res)
+{
+	u64 state_time;
+	struct vcpu_runstate_info *state;
+
+	BUG_ON(preemptible());
+
+	state = &__get_cpu_var(xen_runstate);
+
+	/*
+	 * The runstate info is always updated by the hypervisor on
+	 * the current CPU, so there's no need to use anything
+	 * stronger than a compiler barrier when fetching it.
+	 */
+	do {
+		state_time = get64(&state->state_entry_time);
+		barrier();
+		*res = *state;
+		barrier();
+	} while (get64(&state->state_entry_time) != state_time);
+}
+
+/* return true when a vcpu could run but has no real cpu to run on */
+bool xen_vcpu_stolen(int vcpu)
+{
+	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
+}
+
+void xen_setup_runstate_info(int cpu)
+{
+	struct vcpu_register_runstate_memory_area area;
+
+	area.addr.v = &per_cpu(xen_runstate, cpu);
+
+	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
+			       cpu, &area))
+		BUG();
+}
+
+void xen_stolen_accounting(void)
+{
+	struct vcpu_runstate_info state;
+	struct vcpu_runstate_info *snap;
+	s64 blocked, runnable, offline, stolen;
+	cputime_t ticks;
+
+	get_runstate_snapshot(&state);
+
+	WARN_ON(state.state != RUNSTATE_running);
+
+	snap = &__get_cpu_var(xen_runstate_snapshot);
+
+	/* work out how much time the VCPU has not been runn*ing*  */
+	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
+	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
+	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
+
+	*snap = state;
+
+	/* Add the appropriate number of ticks of stolen time,
+	   including any left-overs from last time. */
+	stolen = runnable + offline + __this_cpu_read(xen_residual_stolen);
+
+	if (stolen < 0)
+		stolen = 0;
+
+	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
+	__this_cpu_write(xen_residual_stolen, stolen);
+	account_steal_ticks(ticks);
+
+	/* Add the appropriate number of ticks of blocked time,
+	   including any left-overs from last time. */
+	blocked += __this_cpu_read(xen_residual_blocked);
+
+	if (blocked < 0)
+		blocked = 0;
+
+	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
+	__this_cpu_write(xen_residual_blocked, blocked);
+	account_idle_ticks(ticks);
+}
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index d6fe062..85bb673 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -16,6 +16,10 @@ void xen_mm_unpin_all(void);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
+bool xen_vcpu_stolen(int vcpu);
+void xen_setup_runstate_info(int cpu);
+void xen_stolen_accounting(void);
+
 int xen_setup_shutdown_event(void);
 
 extern unsigned long *xen_contiguous_bitmap;
-- 
1.7.2.5

