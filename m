Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaFKPtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:49:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:12092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaFKPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,458,1400050800"; 
   d="scan'208";a="444332984"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC v2 5/7] perf: add a pmu capability for "exclusive" events
Date: Wed, 11 Jun 2014 18:41:48 +0300
Message-Id: <1402501310-31940-6-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually, pmus that do, for example, instruction tracing, would only ever
be able to have one event per task per cpu (or per perf_context). For such
pmus it makes sense to disallow creating conflicting events early on, so
as to provide consistent behavior for the user.

This patch adds a pmu capability that indicates such constraint on event
creation.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3d68411..b6f7408 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -277,6 +277,7 @@ struct pmu {
 #define PERF_PMU_CAP_NO_INTERRUPT	1
 #define PERF_PMU_CAP_AUX_NO_SG		2
 #define PERF_PMU_CAP_AUX_SW_DOUBLEBUF	4
+#define PERF_PMU_CAP_EXCLUSIVE		8
 
 /**
  * enum perf_event_active_state - the states of a event
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 48ad31b..9783c60 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7113,6 +7113,32 @@ out:
 	return ret;
 }
 
+static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
+{
+	if ((e1->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) &&
+	    (e1->cpu == e2->cpu ||
+	     e1->cpu == -1 ||
+	     e2->cpu == -1))
+		return true;
+	return false;
+}
+
+static bool exclusive_event_ok(struct perf_event *event,
+			      struct perf_event_context *ctx)
+{
+	struct perf_event *iter_event;
+
+	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return true;
+
+	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
+		if (exclusive_event_match(iter_event, event))
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -7261,6 +7287,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if (!exclusive_event_ok(event, ctx)) {
+		err = -EBUSY;
+		goto err_context;
+	}
+
 	if (task) {
 		put_task_struct(task);
 		task = NULL;
@@ -7427,6 +7458,13 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_free;
 	}
 
+	if (!exclusive_event_ok(event, ctx)) {
+		perf_unpin_context(ctx);
+		put_ctx(ctx);
+		err = -EBUSY;
+		goto err_free;
+	}
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
-- 
2.0.0

