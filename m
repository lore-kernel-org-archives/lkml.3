Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaHTMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:45:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:23277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaHTMpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="579290675"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 18/22] perf: Add a helper for looking up pmus by type
Date: Wed, 20 Aug 2014 15:36:15 +0300
Message-Id: <1408538179-792-19-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper for looking up a registered pmu by its type.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b82392911a..550c22a2b7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6930,6 +6930,18 @@ void perf_pmu_unregister(struct pmu *pmu)
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
+/* call under pmus_srcu */
+static struct pmu *__perf_find_pmu(u32 type)
+{
+	struct pmu *pmu;
+
+	rcu_read_lock();
+	pmu = idr_find(&pmu_idr, type);
+	rcu_read_unlock();
+
+	return pmu;
+}
+
 struct pmu *perf_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
@@ -6938,9 +6950,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 
 	idx = srcu_read_lock(&pmus_srcu);
 
-	rcu_read_lock();
-	pmu = idr_find(&pmu_idr, event->attr.type);
-	rcu_read_unlock();
+	pmu = __perf_find_pmu(event->attr.type);
 	if (pmu) {
 		if (!try_module_get(pmu->module)) {
 			pmu = ERR_PTR(-ENODEV);
-- 
2.1.0

