Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3ARWMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:12:05 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45787 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3ARWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:12:02 -0500
Date: Fri, 18 Jan 2013 14:11:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] workqueue: implement current_is_async()
Message-ID: <20130118221157.GF24579@htj.dyndns.org>
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

>From 84b233adcca3cacd5cfa8013a5feda7a3db4a9af Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 14:05:56 -0800

This function queries whether %current is an async worker executing an
async item.  This will be used to implement warning on synchronous
request_module() from async workers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/async.h       |  1 +
 kernel/async.c              | 14 ++++++++++++++
 kernel/workqueue_internal.h | 11 +++++++++++
 3 files changed, 26 insertions(+)

diff --git a/include/linux/async.h b/include/linux/async.h
index 7a24fe9..345169c 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -52,4 +52,5 @@ extern void async_synchronize_full_domain(struct async_domain *domain);
 extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct async_domain *domain);
+extern bool current_is_async(void);
 #endif
diff --git a/kernel/async.c b/kernel/async.c
index 9d31183..d9bf2a9 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -57,6 +57,8 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
+#include "workqueue_internal.h"
+
 static async_cookie_t next_cookie = 1;
 
 #define MAX_WORK	32768
@@ -337,3 +339,15 @@ void async_synchronize_cookie(async_cookie_t cookie)
 	async_synchronize_cookie_domain(cookie, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
+
+/**
+ * current_is_async - is %current an async worker task?
+ *
+ * Returns %true if %current is an async worker task.
+ */
+bool current_is_async(void)
+{
+	struct worker *worker = current_wq_worker();
+
+	return worker && worker->current_func == async_run_entry_fn;
+}
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 02549fa..cc35e7e 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -8,6 +8,7 @@
 #define _KERNEL_WORKQUEUE_INTERNAL_H
 
 #include <linux/workqueue.h>
+#include <linux/kthread.h>
 
 struct global_cwq;
 struct worker_pool;
@@ -44,6 +45,16 @@ struct worker {
 	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
 };
 
+/**
+ * current_wq_worker - return struct worker if %current is a workqueue worker
+ */
+static inline struct worker *current_wq_worker(void)
+{
+	if (current->flags & PF_WQ_WORKER)
+		return kthread_data(current);
+	return NULL;
+}
+
 /*
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
  * sched.c and workqueue.c.
-- 
1.8.0.2

