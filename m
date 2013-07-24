Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3GXD4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:56:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3GXD4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:56:30 -0400
Date: Tue, 23 Jul 2013 20:56:13 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c73deb6aecda2955716f31572516f09d930ef450@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372425741-1676-3-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add ability to calculate TSC from perf sample timestamps
Git-Commit-ID: c73deb6aecda2955716f31572516f09d930ef450
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:56:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c73deb6aecda2955716f31572516f09d930ef450
Gitweb:     http://git.kernel.org/tip/c73deb6aecda2955716f31572516f09d930ef450
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 28 Jun 2013 16:22:18 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 12:17:45 +0200

perf/x86: Add ability to calculate TSC from perf sample timestamps

For modern CPUs, perf clock is directly related to TSC.  TSC
can be calculated from perf clock and vice versa using a simple
calculation.  Two of the three componenets of that calculation
are already exported in struct perf_event_mmap_page.  This patch
exports the third.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1372425741-1676-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index a7c7305..8355c84 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1884,6 +1884,7 @@ static struct pmu pmu = {
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 	userpg->cap_usr_time = 0;
+	userpg->cap_usr_time_zero = 0;
 	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
@@ -1897,6 +1898,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
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
index 6ff4924..930e5d4 100644
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
index 0041aed..efef1d3 100644
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
