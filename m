Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3FZMEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:04:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3FZMEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:04:02 -0400
Date: Wed, 26 Jun 2013 05:03:45 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-069e0c3c405814778c7475d95b9fff5318f39834@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1372173153-20215-1-git-send-email-andi@firstfloor.org>
References: <1372173153-20215-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Support full width counting
Git-Commit-ID: 069e0c3c405814778c7475d95b9fff5318f39834
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:03:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  069e0c3c405814778c7475d95b9fff5318f39834
Gitweb:     http://git.kernel.org/tip/069e0c3c405814778c7475d95b9fff5318f39834
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 25 Jun 2013 08:12:33 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 11:59:25 +0200

perf/x86/intel: Support full width counting

Recent Intel CPUs like Haswell and IvyBridge have a new
alternative MSR range for perfctrs that allows writing the full
counter width. Enable this range if the hardware reports it
using a new capability bit.

Currently the perf code queries CPUID to get the counter width,
and sign extends the counter values as needed. The traditional
PERFCTR MSRs always limit to 32bit, even though the counter
internally is larger (usually 48 bits on recent CPUs)

When the new capability is set use the alternative range which
do not have these restrictions.

This lowers the overhead of perf stat slightly because it has to
do less interrupts to accumulate the counter value. On Haswell
it also avoids some problems with TSX aborting when the end of
the counter range is reached.

( See the patch "perf/x86/intel: Avoid checkpointed counters
  causing excessive TSX aborts" for more details. )

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1372173153-20215-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/uapi/asm/msr-index.h  | 3 +++
 arch/x86/kernel/cpu/perf_event.h       | 5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 2af848d..bb04650 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -170,6 +170,9 @@
 #define MSR_KNC_EVNTSEL0               0x00000028
 #define MSR_KNC_EVNTSEL1               0x00000029
 
+/* Alternative perfctr range with full access. */
+#define MSR_IA32_PMC0			0x000004c1
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 108dc75..4809f07 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -310,6 +310,11 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		/*
+		 * PMU supports separate counter range for writing
+		 * values > 32bit.
+		 */
+		u64	full_width_write:1;
 	};
 	u64	capabilities;
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a6eccf1..5877f37 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2340,5 +2340,12 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.full_width_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+		pr_cont("full-width counters, ");
+	}
+
 	return 0;
 }
