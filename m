Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaBUVNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:13:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaBUVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:13:44 -0500
Date: Fri, 21 Feb 2014 13:13:14 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-79859cce5a551c3bcd8d36a6287f9d83568ccedb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-5-git-send-email-eranian@google.com>
References: <1392132015-14521-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  make hrtimer timeout configurable per box
Git-Commit-ID: 79859cce5a551c3bcd8d36a6287f9d83568ccedb
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

Commit-ID:  79859cce5a551c3bcd8d36a6287f9d83568ccedb
Gitweb:     http://git.kernel.org/tip/79859cce5a551c3bcd8d36a6287f9d83568ccedb
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:07 +0100

perf/x86/uncore: make hrtimer timeout configurable per box

This patch makes the hrtimer timeout configurable per PMU
box. Not all counters have necessarily the same width and
rate, thus the default timeout of 60s may need to be adjusted.

This patch adds box->hrtimer_duration. It is set to default
when the box is allocated. It can be overriden when the box
is initialized.

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-5-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 7 +++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index e6f32b3..ea823b8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2798,14 +2798,14 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 
 	local_irq_restore(flags);
 
-	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
+	hrtimer_forward_now(hrtimer, ns_to_ktime(box->hrtimer_duration));
 	return HRTIMER_RESTART;
 }
 
 static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
 {
 	__hrtimer_start_range_ns(&box->hrtimer,
-			ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
+			ns_to_ktime(box->hrtimer_duration), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
 }
 
@@ -2839,6 +2839,9 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	box->cpu = -1;
 	box->phys_id = -1;
 
+	/* set default hrtimer timeout */
+	box->hrtimer_duration = UNCORE_PMU_HRTIMER_INTERVAL;
+
 	return box;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 77dc9a5..7efd298 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -489,6 +489,7 @@ struct intel_uncore_box {
 	u64 tags[UNCORE_PMC_IDX_MAX];
 	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
+	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
 	struct intel_uncore_extra_reg shared_regs[0];
