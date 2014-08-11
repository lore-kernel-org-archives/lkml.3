Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaHKFcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:32:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:49446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbaHKFcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:32:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="556698908"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 19/23] perf: Add a helper for looking up pmus by type
Date: Mon, 11 Aug 2014 08:19:48 +0300
Message-Id: <1407734392-31097-20-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper for looking up a registered pmu by its type.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d4b5e33b74..c0f05f8748 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6831,6 +6831,18 @@ void perf_pmu_unregister(struct pmu *pmu)
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
@@ -6839,9 +6851,7 @@ struct pmu *perf_init_event(struct perf_event *event)
 
 	idx = srcu_read_lock(&pmus_srcu);
 
-	rcu_read_lock();
-	pmu = idr_find(&pmu_idr, event->attr.type);
-	rcu_read_unlock();
+	pmu = __perf_find_pmu(event->attr.type);
 	if (pmu) {
 		if (!try_module_get(pmu->module)) {
 			pmu = ERR_PTR(-ENODEV);
-- 
2.1.0.rc1

