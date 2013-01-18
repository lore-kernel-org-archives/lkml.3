Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3ARWKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:10:37 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:36155 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3ARWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:10:35 -0500
Date: Fri, 18 Jan 2013 14:10:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/5] workqueue: rename kernel/workqueue_sched.h to
 kernel/workqueue_internal.h
Message-ID: <20130118221030.GD24579@htj.dyndns.org>
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

>From ea138446e51f7bfe55cdeffa3f1dd9cafc786bd8 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 14:05:55 -0800

Workqueue wants to expose more interface internal to kernel/.  Instead
of adding a new header file, repurpose kernel/workqueue_sched.h.
Rename it to workqueue_internal.h and add include protector.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Ingo, Peter, changes to scheduler is trivial.  If there's no
objection, I'd like to route this with the rest of workqueue and async
changes.

Thanks.

 kernel/sched/core.c         |  2 +-
 kernel/workqueue.c          |  2 +-
 kernel/workqueue_internal.h | 18 ++++++++++++++++++
 kernel/workqueue_sched.h    |  9 ---------
 4 files changed, 20 insertions(+), 11 deletions(-)
 create mode 100644 kernel/workqueue_internal.h
 delete mode 100644 kernel/workqueue_sched.h

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..c6737f4f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -83,7 +83,7 @@
 #endif
 
 #include "sched.h"
-#include "../workqueue_sched.h"
+#include "../workqueue_internal.h"
 #include "../smpboot.h"
 
 #define CREATE_TRACE_POINTS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6b99ac7..b4e9206 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -43,7 +43,7 @@
 #include <linux/idr.h>
 #include <linux/hashtable.h>
 
-#include "workqueue_sched.h"
+#include "workqueue_internal.h"
 
 enum {
 	/*
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
new file mode 100644
index 0000000..b3ea6ad
--- /dev/null
+++ b/kernel/workqueue_internal.h
@@ -0,0 +1,18 @@
+/*
+ * kernel/workqueue_internal.h
+ *
+ * Workqueue internal header file.  Only to be included by workqueue and
+ * core kernel subsystems.
+ */
+#ifndef _KERNEL_WORKQUEUE_INTERNAL_H
+#define _KERNEL_WORKQUEUE_INTERNAL_H
+
+/*
+ * Scheduler hooks for concurrency managed workqueue.  Only to be used from
+ * sched.c and workqueue.c.
+ */
+void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
+struct task_struct *wq_worker_sleeping(struct task_struct *task,
+				       unsigned int cpu);
+
+#endif /* _KERNEL_WORKQUEUE_INTERNAL_H */
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
deleted file mode 100644
index 2d10fc9..0000000
--- a/kernel/workqueue_sched.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * kernel/workqueue_sched.h
- *
- * Scheduler hooks for concurrency managed workqueue.  Only to be
- * included from sched.c and workqueue.c.
- */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
-- 
1.8.0.2

