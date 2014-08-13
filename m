Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHMIXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:23:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaHMIXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:23:00 -0400
Date: Wed, 13 Aug 2014 01:21:49 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f86977620ee4635f26befcf436700493a38ce002@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, mark.rutland@arm.com, acme@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        mark.rutland@arm.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1406896382-18404-3-git-send-email-jolsa@kernel.org>
References: <1406896382-18404-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Set owner pointer for kernel events
Git-Commit-ID: f86977620ee4635f26befcf436700493a38ce002
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

Commit-ID:  f86977620ee4635f26befcf436700493a38ce002
Gitweb:     http://git.kernel.org/tip/f86977620ee4635f26befcf436700493a38ce002
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 1 Aug 2014 14:33:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:03 +0200

perf: Set owner pointer for kernel events

Adding fake EVENT_OWNER_KERNEL owner pointer value for kernel perf
events, so we could distinguish it from user events, which needs
special care in following patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1406896382-18404-3-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3..bbb3ca2 100644
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
@@ -7366,6 +7383,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
+	/* Mark owner so we could distinguish it from user events. */
+	event->owner = EVENT_OWNER_KERNEL;
+
 	account_event(event);
 
 	ctx = find_get_context(event->pmu, task, cpu);
