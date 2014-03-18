Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaCRI5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:57:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:13086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaCRI5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:57:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,676,1389772800"; 
   d="scan'208";a="474739769"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/4] perf: allow building PMU driver as module
Date: Tue, 18 Mar 2014 16:56:41 +0800
Message-Id: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for building PMU driver as module. It exports
function perf_pmu_{register,unregister} and adds reference tracking
for PMU driver module. When PMU driver is built as module, each active
event of the PMU holds a reference to the driver module.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..4f0710e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -172,6 +172,7 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	struct module			*module;
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
 	const char			*name;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 661951a..1616b7d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/module.h>
 
 #include "internal.h"
 
@@ -3244,6 +3245,9 @@ static void __free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);
 
+	if (event->pmu)
+		module_put(event->pmu->module);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 static void free_event(struct perf_event *event)
@@ -6566,6 +6570,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6587,6 +6592,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {
@@ -6600,6 +6606,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (ret)
@@ -6608,6 +6618,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
@@ -6786,6 +6800,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 err_pmu:
 	if (event->destroy)
 		event->destroy(event);
+	module_put(pmu->module);
 err_ns:
 	if (event->ns)
 		put_pid_ns(event->ns);
-- 
1.8.5.3

