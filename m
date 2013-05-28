Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab3E1NCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:02:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3E1NCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:02:33 -0400
Date: Tue, 28 May 2013 06:01:46 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-2b923c8f5de6722393e614b096d5040b6d4eaf98@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <20130521105337.GA2879@quad>
References: <20130521105337.GA2879@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Check branch sampling priv level in generic code
Git-Commit-ID: 2b923c8f5de6722393e614b096d5040b6d4eaf98
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b923c8f5de6722393e614b096d5040b6d4eaf98
Gitweb:     http://git.kernel.org/tip/2b923c8f5de6722393e614b096d5040b6d4eaf98
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 21 May 2013 12:53:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:13:54 +0200

perf/x86: Check branch sampling priv level in generic code

This patch moves commit 7cc23cd to the generic code:

 perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

The check is now implemented in generic code instead of x86 specific
code. That way we do not have to repeat the test in each arch
supporting branch sampling.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/20130521105337.GA2879@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 13 +++----------
 kernel/events/core.c                       |  9 ++++-----
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d978353..de341d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,11 +318,8 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
 		mask |= X86_BR_KERNEL;
-	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -342,8 +339,6 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
-
-	return 0;
 }
 
 /*
@@ -391,9 +386,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	ret = intel_pmu_setup_sw_lbr_filter(event);
-	if (ret)
-		return ret;
+	intel_pmu_setup_sw_lbr_filter(event);
 
 	/*
 	 * setup HW LBR filter, if any
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 53d1b30..a0780b3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6481,11 +6481,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
 			return -EINVAL;
 
-		/* kernel level capture: check permissions */
-		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
-		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-
 		/* propagate priv level, when not set for branch */
 		if (!(mask & PERF_SAMPLE_BRANCH_PLM_ALL)) {
 
@@ -6503,6 +6498,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			 */
 			attr->branch_sample_type = mask;
 		}
+		/* kernel level capture: check permissions */
+		if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
+		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 	}
 
 	if (attr->sample_type & PERF_SAMPLE_REGS_USER) {
