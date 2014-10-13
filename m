Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaJMNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:47:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:59827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbaJMNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:47:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399419866"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 16/20] perf: Add a helper for looking up pmus by type
Date: Mon, 13 Oct 2014 16:45:44 +0300
Message-Id: <1413207948-28202-17-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper for looking up a registered pmu by its type.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d4057dff27..92da1aecc7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6963,6 +6963,18 @@ void perf_pmu_unregister(struct pmu *pmu)
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
@@ -6971,9 +6983,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 
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

