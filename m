Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbbA1VQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:16:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbA1Uui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:38 -0500
Date: Wed, 28 Jan 2015 06:28:39 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-c05199e5a57a579fea1e8fa65e2b511ceb524ffc@git.kernel.org>
Cc: tglx@linutronix.de, kan.liang@intel.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, mingo@kernel.org,
        hpa@zytor.com, zheng.z.yan@intel.com, peterz@infradead.org
Reply-To: kan.liang@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, acme@kernel.org, eranian@google.com,
        hpa@zytor.com, peterz@infradead.org, zheng.z.yan@intel.com,
        mingo@kernel.org
In-Reply-To: <1421729665-5912-1-git-send-email-kan.liang@intel.com>
References: <1421729665-5912-1-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore: Move uncore_box_init()
  out of driver initialization
Git-Commit-ID: c05199e5a57a579fea1e8fa65e2b511ceb524ffc
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

Commit-ID:  c05199e5a57a579fea1e8fa65e2b511ceb524ffc
Gitweb:     http://git.kernel.org/tip/c05199e5a57a579fea1e8fa65e2b511ceb524ffc
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 20 Jan 2015 04:54:25 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 13:04:34 +0100

perf/x86/intel/uncore: Move uncore_box_init() out of driver initialization

There were some issues about the uncore driver tried to access
non-existing boxes, which caused boot crashes. These issues have
been all fixed. But we should avoid boot failures if that ever
happens again.

This patch intends to prevent this kind of potential issues.
It moves uncore_box_init out of driver initialization. The box
will be initialized when it's first enabled.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421729665-5912-1-git-send-email-kan.liang@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  9 ++-------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 10b8d3e..c635b8b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -840,7 +840,6 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	box->phys_id = phys_id;
 	box->pci_dev = pdev;
 	box->pmu = pmu;
-	uncore_box_init(box);
 	pci_set_drvdata(pdev, box);
 
 	raw_spin_lock(&uncore_box_lock);
@@ -1004,10 +1003,8 @@ static int uncore_cpu_starting(int cpu)
 			pmu = &type->pmus[j];
 			box = *per_cpu_ptr(pmu->box, cpu);
 			/* called by uncore_cpu_init? */
-			if (box && box->phys_id >= 0) {
-				uncore_box_init(box);
+			if (box && box->phys_id >= 0)
 				continue;
-			}
 
 			for_each_online_cpu(k) {
 				exist = *per_cpu_ptr(pmu->box, k);
@@ -1023,10 +1020,8 @@ static int uncore_cpu_starting(int cpu)
 				}
 			}
 
-			if (box) {
+			if (box)
 				box->phys_id = phys_id;
-				uncore_box_init(box);
-			}
 		}
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 863d9b0..6c8c1e7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -257,6 +257,14 @@ static inline int uncore_num_counters(struct intel_uncore_box *box)
 	return box->pmu->type->num_counters;
 }
 
+static inline void uncore_box_init(struct intel_uncore_box *box)
+{
+	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
+		if (box->pmu->type->ops->init_box)
+			box->pmu->type->ops->init_box(box);
+	}
+}
+
 static inline void uncore_disable_box(struct intel_uncore_box *box)
 {
 	if (box->pmu->type->ops->disable_box)
@@ -265,6 +273,8 @@ static inline void uncore_disable_box(struct intel_uncore_box *box)
 
 static inline void uncore_enable_box(struct intel_uncore_box *box)
 {
+	uncore_box_init(box);
+
 	if (box->pmu->type->ops->enable_box)
 		box->pmu->type->ops->enable_box(box);
 }
@@ -287,14 +297,6 @@ static inline u64 uncore_read_counter(struct intel_uncore_box *box,
 	return box->pmu->type->ops->read_counter(box, event);
 }
 
-static inline void uncore_box_init(struct intel_uncore_box *box)
-{
-	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
-		if (box->pmu->type->ops->init_box)
-			box->pmu->type->ops->init_box(box);
-	}
-}
-
 static inline bool uncore_box_is_fake(struct intel_uncore_box *box)
 {
 	return (box->phys_id < 0);
