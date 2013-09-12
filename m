Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab3ILSLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:11:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3ILSEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:04:51 -0400
Date: Thu, 12 Sep 2013 11:04:05 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-2dbf0116aa8c7bfa900352d3f7b2609748fcc1c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1378438661-24765-2-git-send-email-andi@firstfloor.org>
References: <1378438661-24765-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Avoid checkpointed counters causing excessive TSX aborts
Git-Commit-ID: 2dbf0116aa8c7bfa900352d3f7b2609748fcc1c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2dbf0116aa8c7bfa900352d3f7b2609748fcc1c5
Gitweb:     http://git.kernel.org/tip/2dbf0116aa8c7bfa900352d3f7b2609748fcc1c5
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 5 Sep 2013 20:37:38 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:13:33 +0200

perf/x86/intel: Avoid checkpointed counters causing excessive TSX aborts

With checkpointed counters there can be a situation where the counter
is overflowing, aborts the transaction, is set back to a non overflowing
checkpoint, causes interupt. The interrupt doesn't see the overflow
because it has been checkpointed.  This is then a spurious PMI, typically with
a ugly NMI message.  It can also lead to excessive aborts.

Avoid this problem by:

- Using the full counter width for counting counters (earlier patch)

- Forbid sampling for checkpointed counters. It's not too useful anyways,
  checkpointing is mainly for counting. The check is approximate
  (to still handle KVM), but should catch the majority of cases.

- On a PMI always set back checkpointed counters to zero.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378438661-24765-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 37 ++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9db76c3..57d64b7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1282,6 +1282,11 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
+static inline bool event_is_checkpointed(struct perf_event *event)
+{
+	return (event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
+}
+
 /*
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
@@ -1289,6 +1294,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
 int intel_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event);
+	/*
+	 * For a checkpointed counter always reset back to 0.  This
+	 * avoids a situation where the counter overflows, aborts the
+	 * transaction and is then set back to shortly before the
+	 * overflow, and overflows and aborts again.
+	 */
+	if (unlikely(event_is_checkpointed(event))) {
+		/* No race with NMIs because the counter should not be armed */
+		wrmsrl(event->hw.event_base, 0);
+		local64_set(&event->hw.prev_count, 0);
+	}
 	return x86_perf_event_set_period(event);
 }
 
@@ -1372,6 +1388,13 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	/*
+	 * To avoid spurious interrupts with perf stat always reset checkpointed
+	 * counters.
+	 */
+	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
+		status |= (1ULL << 2);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1837,6 +1860,20 @@ static int hsw_hw_config(struct perf_event *event)
 	      event->attr.precise_ip > 0))
 		return -EOPNOTSUPP;
 
+	if (event_is_checkpointed(event)) {
+		/*
+		 * Sampling of checkpointed events can cause situations where
+		 * the CPU constantly aborts because of a overflow, which is
+		 * then checkpointed back and ignored. Forbid checkpointing
+		 * for sampling.
+		 *
+		 * But still allow a long sampling period, so that perf stat
+		 * from KVM works.
+		 */
+		if (event->attr.sample_period > 0 &&
+		    event->attr.sample_period < 0x7fffffff)
+			return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
