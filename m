Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3ARWLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:11:23 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43041 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3ARWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:11:17 -0500
Date: Fri, 18 Jan 2013 14:11:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/5] workqueue: move struct worker definition to
 workqueue_internal.h
Message-ID: <20130118221111.GE24579@htj.dyndns.org>
References: <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
 <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
 <20130118025936.GJ16568@mtj.dyndns.org>
 <20130118030407.GK16568@mtj.dyndns.org>
 <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2eaebdb33e1911c0cf3d44fd3596c42c6f502fab Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 14:05:55 -0800

This will be used to implement an inline function to query whether
%current is a workqueue worker and, if so, allow determining which
work item it's executing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/workqueue.c          | 32 +-------------------------------
 kernel/workqueue_internal.h | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b4e9206..2ffa240 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -122,37 +122,7 @@ enum {
  * W: workqueue_lock protected.
  */
 
-struct global_cwq;
-struct worker_pool;
-
-/*
- * The poor guys doing the actual heavy lifting.  All on-duty workers
- * are either serving the manager role, on idle list or on busy hash.
- */
-struct worker {
-	/* on idle list while idle, on busy hash table while busy */
-	union {
-		struct list_head	entry;	/* L: while idle */
-		struct hlist_node	hentry;	/* L: while busy */
-	};
-
-	struct work_struct	*current_work;	/* L: work being processed */
-	work_func_t		current_func;	/* L: current_work's fn */
-	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
-	struct list_head	scheduled;	/* L: scheduled works */
-	struct task_struct	*task;		/* I: worker task */
-	struct worker_pool	*pool;		/* I: the associated pool */
-	/* 64 bytes boundary on 64bit, 32 on 32bit */
-	unsigned long		last_active;	/* L: last active timestamp */
-	unsigned int		flags;		/* X: flags */
-	int			id;		/* I: worker id */
-
-	/* for rebinding worker to CPU */
-	struct work_struct	rebind_work;	/* L: for busy worker */
-
-	/* used only by rescuers to point to the target workqueue */
-	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
-};
+/* struct worker is defined in workqueue_internal.h */
 
 struct worker_pool {
 	struct global_cwq	*gcwq;		/* I: the owning gcwq */
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index b3ea6ad..02549fa 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -7,6 +7,43 @@
 #ifndef _KERNEL_WORKQUEUE_INTERNAL_H
 #define _KERNEL_WORKQUEUE_INTERNAL_H
 
+#include <linux/workqueue.h>
+
+struct global_cwq;
+struct worker_pool;
+
+/*
+ * The poor guys doing the actual heavy lifting.  All on-duty workers are
+ * either serving the manager role, on idle list or on busy hash.  For
+ * details on the locking annotation (L, I, X...), refer to workqueue.c.
+ *
+ * Only to be used in workqueue and async.
+ */
+struct worker {
+	/* on idle list while idle, on busy hash table while busy */
+	union {
+		struct list_head	entry;	/* L: while idle */
+		struct hlist_node	hentry;	/* L: while busy */
+	};
+
+	struct work_struct	*current_work;	/* L: work being processed */
+	work_func_t		current_func;	/* L: current_work's fn */
+	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
+	struct list_head	scheduled;	/* L: scheduled works */
+	struct task_struct	*task;		/* I: worker task */
+	struct worker_pool	*pool;		/* I: the associated pool */
+	/* 64 bytes boundary on 64bit, 32 on 32bit */
+	unsigned long		last_active;	/* L: last active timestamp */
+	unsigned int		flags;		/* X: flags */
+	int			id;		/* I: worker id */
+
+	/* for rebinding worker to CPU */
+	struct work_struct	rebind_work;	/* L: for busy worker */
+
+	/* used only by rescuers to point to the target workqueue */
+	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
+};
+
 /*
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
  * sched.c and workqueue.c.
-- 
1.8.0.2

