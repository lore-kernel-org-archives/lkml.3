Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaJMNsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:63833 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaJMNsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="604522085"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 05/20] perf: Add a pmu capability for "exclusive" events
Date: Mon, 13 Oct 2014 16:45:33 +0300
Message-Id: <1413207948-28202-6-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
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
 kernel/events/core.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e7a15f5c3f..5c3dee021c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -173,6 +173,7 @@ struct perf_event;
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
 #define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
+#define PERF_PMU_CAP_EXCLUSIVE			0x08
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 86b0577229..ced9b0819f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7286,6 +7286,32 @@ out:
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
@@ -7437,6 +7463,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	if ((pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) && group_leader) {
+		err = -EBUSY;
+		goto err_context;
+	}
+
 	if (task) {
 		put_task_struct(task);
 		task = NULL;
@@ -7522,6 +7553,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	if (!exclusive_event_ok(event, ctx)) {
+		mutex_unlock(&ctx->mutex);
+		fput(event_file);
+		goto err_context;
+	}
+
 	perf_install_in_context(ctx, event, event->cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
@@ -7608,6 +7645,14 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
+	if (!exclusive_event_ok(event, ctx)) {
+		mutex_unlock(&ctx->mutex);
+		perf_unpin_context(ctx);
+		put_ctx(ctx);
+		err = -EBUSY;
+		goto err_free;
+	}
+
 	perf_install_in_context(ctx, event, cpu);
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
-- 
2.1.0

