Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaHAMdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaHAMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:33:41 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] perf: Set owner pointer for kernel events
Date: Fri,  1 Aug 2014 14:33:01 +0200
Message-Id: <1406896382-18404-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
References: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding fake EVENT_OWNER_KERNEL owner pointer value for kernel perf
events, so we could distinguish it from user events, which needs
special care in following patch.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 75c4ff8d1590..c2fba5736405 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -119,6 +119,13 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 	return data.ret;
 }
 
+#define EVENT_OWNER_KERNEL ((void *) -1)
+
+static bool is_kernel_event(struct perf_event *event)
+{
+	return event->owner == EVENT_OWNER_KERNEL;
+}
+
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
 		       PERF_FLAG_FD_OUTPUT  |\
 		       PERF_FLAG_PID_CGROUP |\
@@ -3312,16 +3319,12 @@ static void free_event(struct perf_event *event)
 }
 
 /*
- * Called when the last reference to the file is gone.
+ * Remove user event from the owner task.
  */
-static void put_event(struct perf_event *event)
+static void perf_remove_from_owner(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
-	if (!atomic_long_dec_and_test(&event->refcount))
-		return;
-
 	rcu_read_lock();
 	owner = ACCESS_ONCE(event->owner);
 	/*
@@ -3354,6 +3357,20 @@ static void put_event(struct perf_event *event)
 		mutex_unlock(&owner->perf_event_mutex);
 		put_task_struct(owner);
 	}
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static void put_event(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+
+	if (!atomic_long_dec_and_test(&event->refcount))
+		return;
+
+	if (!is_kernel_event(event))
+		perf_remove_from_owner(event);
 
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
@@ -7369,6 +7386,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
+	/* Mark owner so we could distinguish it from user events. */
+	event->owner = EVENT_OWNER_KERNEL;
+
 	account_event(event);
 
 	ctx = find_get_context(event->pmu, task, cpu);
-- 
1.8.3.1

