Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaEHKqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:46:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaEHKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:46:00 -0400
Date: Thu, 8 May 2014 03:45:22 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-rk9pvr6e1d0559lxstltbztc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Rework free paths
Git-Commit-ID: 683ede43dd412c6cad0d23578a018409ac9c683e
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

Commit-ID:  683ede43dd412c6cad0d23578a018409ac9c683e
Gitweb:     http://git.kernel.org/tip/683ede43dd412c6cad0d23578a018409ac9c683e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 May 2014 12:11:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:44:19 +0200

perf: Rework free paths

Primarily make perf_event_release_kernel() into put_event(), this will
allow kernel space to create per-task inherited events, and is safer
in general.

Also, document the free_event() assumptions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rk9pvr6e1d0559lxstltbztc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 66 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0de1997..83505a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3251,7 +3251,8 @@ static void __free_event(struct perf_event *event)
 
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
-static void free_event(struct perf_event *event)
+
+static void _free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
 
@@ -3279,42 +3280,31 @@ static void free_event(struct perf_event *event)
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
 
-
 	__free_event(event);
 }
 
-int perf_event_release_kernel(struct perf_event *event)
+/*
+ * Used to free events which have a known refcount of 1, such as in error paths
+ * where the event isn't exposed yet and inherited events.
+ */
+static void free_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
-
-	WARN_ON_ONCE(ctx->parent_ctx);
-	/*
-	 * There are two ways this annotation is useful:
-	 *
-	 *  1) there is a lock recursion from perf_event_exit_task
-	 *     see the comment there.
-	 *
-	 *  2) there is a lock-inversion with mmap_sem through
-	 *     perf_event_read_group(), which takes faults while
-	 *     holding ctx->mutex, however this is called after
-	 *     the last filedesc died, so there is no possibility
-	 *     to trigger the AB-BA case.
-	 */
-	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	perf_remove_from_context(event, true);
-	mutex_unlock(&ctx->mutex);
-
-	free_event(event);
+	if (WARN(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1,
+				"unexpected event refcount: %ld; ptr=%p\n",
+				atomic_long_read(&event->refcount), event)) {
+		/* leak to avoid use-after-free */
+		return;
+	}
 
-	return 0;
+	_free_event(event);
 }
-EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 /*
  * Called when the last reference to the file is gone.
  */
 static void put_event(struct perf_event *event)
 {
+	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
@@ -3353,9 +3343,33 @@ static void put_event(struct perf_event *event)
 		put_task_struct(owner);
 	}
 
-	perf_event_release_kernel(event);
+	WARN_ON_ONCE(ctx->parent_ctx);
+	/*
+	 * There are two ways this annotation is useful:
+	 *
+	 *  1) there is a lock recursion from perf_event_exit_task
+	 *     see the comment there.
+	 *
+	 *  2) there is a lock-inversion with mmap_sem through
+	 *     perf_event_read_group(), which takes faults while
+	 *     holding ctx->mutex, however this is called after
+	 *     the last filedesc died, so there is no possibility
+	 *     to trigger the AB-BA case.
+	 */
+	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
+	perf_remove_from_context(event, true);
+	mutex_unlock(&ctx->mutex);
+
+	_free_event(event);
 }
 
+int perf_event_release_kernel(struct perf_event *event)
+{
+	put_event(event);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
+
 static int perf_release(struct inode *inode, struct file *file)
 {
 	put_event(file->private_data);
