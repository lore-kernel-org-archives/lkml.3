Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaKKL1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:27:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:29736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaKKL1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:27:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="634998667"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v6 05/14] perf: Add a pmu capability for "exclusive" events
Date: Tue, 11 Nov 2014 13:26:51 +0200
Message-Id: <1415705221-182873-6-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
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
index ac7bfb43fc..2399c12e49 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7298,6 +7298,32 @@ out:
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
@@ -7449,6 +7475,11 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -7534,6 +7565,12 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -7620,6 +7657,14 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
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
2.1.1

