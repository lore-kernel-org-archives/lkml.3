Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaGKL4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbaGKL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:56:51 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] perf: Move event owner retrieval into perf_event_get_owner
Date: Fri, 11 Jul 2014 13:56:21 +0200
Message-Id: <1405079782-8139-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the code of getting safely event's owner into
perf_event_get_owner function, so it could be used
in following change.

Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..ec6ef94 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -784,6 +784,7 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
+extern struct task_struct *perf_event_get_owner(struct perf_event *event);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a36ebfe..faba9e0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3311,17 +3311,10 @@ static void free_event(struct perf_event *event)
 	_free_event(event);
 }
 
-/*
- * Called when the last reference to the file is gone.
- */
-static void put_event(struct perf_event *event)
+struct task_struct *perf_event_get_owner(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
-	if (!atomic_long_dec_and_test(&event->refcount))
-		return;
-
 	rcu_read_lock();
 	owner = ACCESS_ONCE(event->owner);
 	/*
@@ -3340,7 +3333,21 @@ static void put_event(struct perf_event *event)
 		get_task_struct(owner);
 	}
 	rcu_read_unlock();
+	return owner;
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static void put_event(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct task_struct *owner;
+
+	if (!atomic_long_dec_and_test(&event->refcount))
+		return;
 
+	owner = perf_event_get_owner(event);
 	if (owner) {
 		mutex_lock(&owner->perf_event_mutex);
 		/*
-- 
1.8.3.1

