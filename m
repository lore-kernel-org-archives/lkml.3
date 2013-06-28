Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3F1NRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:17:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:10827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3F1NQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090177"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/5] x86: add ability to calculate TSC from perf sample timestamps
Date: Fri, 28 Jun 2013 16:22:18 +0300
Message-Id: <1372425741-1676-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For modern CPUs, perf clock is directly related to TSC.  TSC
can be calculated from perf clock and vice versa using a simple
calculation.  Two of the three componenets of that calculation
are already exported in struct perf_event_mmap_page.  This patch
exports the third.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/include/asm/tsc.h       |  1 +
 arch/x86/kernel/cpu/perf_event.c |  6 ++++++
 arch/x86/kernel/tsc.c            |  6 ++++++
 include/uapi/linux/perf_event.h  | 22 ++++++++++++++++++++--
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index c91e8b9..235be70 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -49,6 +49,7 @@ extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
+extern int check_tsc_disabled(void);
 extern unsigned long native_calibrate_tsc(void);
 
 extern int tsc_clocksource_reliable;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index afc2413..3f74034 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1860,6 +1860,7 @@ static struct pmu pmu = {
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 	userpg->cap_usr_time = 0;
+	userpg->cap_usr_time_zero = 0;
 	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
@@ -1873,6 +1874,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+
+	if (sched_clock_stable && !check_tsc_disabled()) {
+		userpg->cap_usr_time_zero = 1;
+		userpg->time_zero = this_cpu_read(cyc2ns_offset);
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 098b3cf..c810283 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -89,6 +89,12 @@ int check_tsc_unstable(void)
 }
 EXPORT_SYMBOL_GPL(check_tsc_unstable);
 
+int check_tsc_disabled(void)
+{
+	return tsc_disabled;
+}
+EXPORT_SYMBOL_GPL(check_tsc_disabled);
+
 #ifdef CONFIG_X86_TSC
 int __init notsc_setup(char *str)
 {
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 19f6ee5..663be3f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -378,7 +378,8 @@ struct perf_event_mmap_page {
 		struct {
 			__u64	cap_usr_time		: 1,
 				cap_usr_rdpmc		: 1,
-				cap_____res		: 62;
+				cap_usr_time_zero	: 1,
+				cap_____res		: 61;
 		};
 	};
 
@@ -420,12 +421,29 @@ struct perf_event_mmap_page {
 	__u16	time_shift;
 	__u32	time_mult;
 	__u64	time_offset;
+	/*
+	 * If cap_usr_time_zero, the hardware clock (e.g. TSC) can be calculated
+	 * from sample timestamps.
+	 *
+	 *   time = timestamp - time_zero;
+	 *   quot = time / time_mult;
+	 *   rem  = time % time_mult;
+	 *   cyc = (quot << time_shift) + (rem << time_shift) / time_mult;
+	 *
+	 * And vice versa:
+	 *
+	 *   quot = cyc >> time_shift;
+	 *   rem  = cyc & ((1 << time_shift) - 1);
+	 *   timestamp = time_zero + quot * time_mult +
+	 *               ((rem * time_mult) >> time_shift);
+	 */
+	__u64	time_zero;
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[120];	/* align to 1k */
+	__u64	__reserved[119];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
-- 
1.7.11.7

