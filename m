Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3IYMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab3IYMva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/21] perf: Split allocation and initialization code
Date: Wed, 25 Sep 2013 14:50:37 +0200
Message-Id: <1380113447-17144-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Do this in order to prepare for toggle event inheritance support
that will rely on pre-allocated perf event.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 59 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2a19b64..fa1d229 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6673,31 +6673,23 @@ static void account_event(struct perf_event *event)
 	account_event_cpu(event, event->cpu);
 }
 
-/*
- * Allocate and initialize a event structure
- */
-static struct perf_event *
-perf_event_alloc(struct perf_event_attr *attr, int cpu,
-		 struct task_struct *task,
-		 struct perf_event *group_leader,
-		 struct perf_event *parent_event,
-		 perf_overflow_handler_t overflow_handler,
-		 void *context)
+static int perf_init_event(struct perf_event *event,
+			   struct perf_event_attr *attr, int cpu,
+			   struct task_struct *task,
+			   struct perf_event *group_leader,
+			   struct perf_event *parent_event,
+			   perf_overflow_handler_t overflow_handler,
+			   void *context)
 {
 	struct pmu *pmu;
-	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	long err = -EINVAL;
+	int err = -EINVAL;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
 		if (!task || cpu != -1)
-			return ERR_PTR(-EINVAL);
+			return err;
 	}
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return ERR_PTR(-ENOMEM);
-
 	/*
 	 * Single events are their own group leaders, with an
 	 * empty sibling list:
@@ -6791,7 +6783,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		}
 	}
 
-	return event;
+	return 0;
 
 err_pmu:
 	if (event->destroy)
@@ -6799,9 +6791,36 @@ err_pmu:
 err_ns:
 	if (event->ns)
 		put_pid_ns(event->ns);
-	kfree(event);
 
-	return ERR_PTR(err);
+	return err;
+}
+
+/*
+ * Allocate and initialize a event structure
+ */
+static struct perf_event *
+perf_event_alloc(struct perf_event_attr *attr, int cpu,
+		 struct task_struct *task,
+		 struct perf_event *group_leader,
+		 struct perf_event *parent_event,
+		 perf_overflow_handler_t overflow_handler,
+		 void *context)
+{
+	struct perf_event *event;
+	int err;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return ERR_PTR(-ENOMEM);
+
+	err = perf_init_event(event, attr, cpu, task, group_leader,
+			      parent_event, overflow_handler, context);
+	if (err) {
+		kfree(event);
+		return ERR_PTR(err);
+	}
+
+	return event;
 }
 
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
-- 
1.7.11.7

