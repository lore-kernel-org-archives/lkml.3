Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3DUIQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:16:39 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48818 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3DUIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:16:36 -0400
Date: Sun, 21 Apr 2013 10:16:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130421081630.GA28643@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: f1923820c447e986a9da0fc6bf60c1dccdf0408e perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Misc fixes.

 Thanks,

	Ingo

------------------>
Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()


 arch/x86/kernel/cpu/perf_event_intel.c | 20 ++++++++++++++++----
 kernel/events/core.c                   |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dab7580..cc45deb 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -153,8 +153,14 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 };
 
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
+static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
@@ -2097,7 +2103,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 45)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
@@ -2123,7 +2132,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_ivb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 62)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7e0962e..4d3124b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5331,7 +5331,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
