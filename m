Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaDRNWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:22:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaDRNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:07 -0400
Date: Fri, 18 Apr 2014 06:08:19 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-c464c76eec4be587604ca082e8cded7e6b89f3bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Allow building PMU drivers as modules
Git-Commit-ID: c464c76eec4be587604ca082e8cded7e6b89f3bf
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

Commit-ID:  c464c76eec4be587604ca082e8cded7e6b89f3bf
Gitweb:     http://git.kernel.org/tip/c464c76eec4be587604ca082e8cded7e6b89f3bf
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 18 Mar 2014 16:56:41 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:54:45 +0200

perf: Allow building PMU drivers as modules

This patch adds support for building PMU driver as module. It exports
the functions perf_pmu_{register,unregister}() and adds reference tracking
for the PMU driver module.

When the PMU driver is built as a module, each active event of the PMU
holds a reference to the driver module.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1395133004-23205-1-git-send-email-zheng.z.yan@intel.com
Cc: eranian@google.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3356abc..af6dcf1 100644
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
index f83a71a..5129b12 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/module.h>
 
 #include "internal.h"
 
@@ -3229,6 +3230,9 @@ static void __free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);
 
+	if (event->pmu)
+		module_put(event->pmu->module);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 static void free_event(struct perf_event *event)
@@ -6551,6 +6555,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6572,6 +6577,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {
@@ -6585,6 +6591,10 @@ struct pmu *perf_init_event(struct perf_event *event)
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
@@ -6593,6 +6603,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
@@ -6771,6 +6785,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 err_pmu:
 	if (event->destroy)
 		event->destroy(event);
+	module_put(pmu->module);
 err_ns:
 	if (event->ns)
 		put_pid_ns(event->ns);
