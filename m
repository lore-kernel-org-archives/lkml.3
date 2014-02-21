Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaBUVOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:14:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbaBUVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:19 -0500
Date: Fri, 21 Feb 2014 13:13:47 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-ced2efb099f4f24ea7030c22b064e5ddd65cd764@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-8-git-send-email-eranian@google.com>
References: <1392132015-14521-8-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  add hrtimer to SNB uncore IMC PMU
Git-Commit-ID: ced2efb099f4f24ea7030c22b064e5ddd65cd764
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

Commit-ID:  ced2efb099f4f24ea7030c22b064e5ddd65cd764
Gitweb:     http://git.kernel.org/tip/ced2efb099f4f24ea7030c22b064e5ddd65cd764
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:13 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:08 +0100

perf/x86/uncore: add hrtimer to SNB uncore IMC PMU

This patch is needed because that PMU uses 32-bit free
running counters with no interrupt capabilities.

On SNB/IVB/HSW, we used 20GB/s theoretical peak to calculate
the hrtimer timeout necessary to avoid missing an overflow.
That delay is set to 5s to be on the cautious side.

The SNB IMC uses free running counters, which are handled
via pseudo fixed counters. The SNB IMC PMU implementation
supports an arbitrary number of events, because the counters
are read-only. Therefore it is not possible to track active
counters. Instead we put active events on a linked list which
is then used by the hrtimer handler to update the SW counts.

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-8-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 12 ++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 66ce5e5..7760aee 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1728,6 +1728,7 @@ static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
 	addr &= ~(PAGE_SIZE - 1);
 
 	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
 }
 
 static void snb_uncore_imc_enable_box(struct intel_uncore_box *box)
@@ -3160,6 +3161,7 @@ again:
 static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 {
 	struct intel_uncore_box *box;
+	struct perf_event *event;
 	unsigned long flags;
 	int bit;
 
@@ -3172,6 +3174,14 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 	 */
 	local_irq_save(flags);
 
+	/*
+	 * handle boxes with an active event list as opposed to active
+	 * counters
+	 */
+	list_for_each_entry(event, &box->active_list, active_entry) {
+		uncore_perf_event_update(box, event);
+	}
+
 	for_each_set_bit(bit, box->active_mask, UNCORE_PMC_IDX_MAX)
 		uncore_perf_event_update(box, box->events[bit]);
 
@@ -3221,6 +3231,8 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	/* set default hrtimer timeout */
 	box->hrtimer_duration = UNCORE_PMU_HRTIMER_INTERVAL;
 
+	INIT_LIST_HEAD(&box->active_list);
+
 	return box;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index fbf45a0..90236f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -6,6 +6,7 @@
 
 #define UNCORE_PMU_NAME_LEN		32
 #define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
+#define UNCORE_SNB_IMC_HRTIMER_INTERVAL (5ULL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
@@ -492,6 +493,7 @@ struct intel_uncore_box {
 	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
+	struct list_head active_list;
 	void *io_addr;
 	struct intel_uncore_extra_reg shared_regs[0];
 };
