Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3ARBZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:25:14 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46047 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3ARBZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:25:10 -0500
Date: Thu, 17 Jan 2013 17:25:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/3] workqueue, async: implement work/async_current_func()
Message-ID: <20130118012503.GH16568@mtj.dyndns.org>
References: <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement work/async_current_func() which query whether the current
task is a workqueue or async worker respectively and, if so, return
the current function being executed along with work / async item
related information.

This will be used to implement warning on synchronous request_module()
from async workers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h     |  2 ++
 include/linux/workqueue.h |  1 +
 kernel/async.c            | 25 +++++++++++++++++++++++++
 kernel/workqueue.c        | 22 ++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/linux/async.h b/include/linux/async.h
index 7a24fe9..6c49157 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -52,4 +52,6 @@ extern void async_synchronize_full_domain(struct async_domain *domain);
 extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct async_domain *domain);
+extern async_func_ptr *async_current_func(void **datap,
+					  async_cookie_t *cookiep);
 #endif
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2b58905..984fbef 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -428,6 +428,7 @@ extern void workqueue_set_max_active(struct workqueue_struct *wq,
 extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
 extern unsigned int work_cpu(struct work_struct *work);
 extern unsigned int work_busy(struct work_struct *work);
+extern work_func_t work_current_func(struct work_struct **workp);
 
 /*
  * Like above, but uses del_timer() instead of del_timer_sync(). This means,
diff --git a/kernel/async.c b/kernel/async.c
index 9d31183..ed1eda0 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -337,3 +337,28 @@ void async_synchronize_cookie(async_cookie_t cookie)
 	async_synchronize_cookie_domain(cookie, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
+
+/**
+ * async_current_func - determine the async entry %current is executing
+ * @datap: optional out param for the data
+ * @cookiep: optional out param for the cookie
+ *
+ * Determine whether %current is an async worker executing an async_entry
+ * and if so return the async function and, if @cookiep is not %NULL, the
+ * cookie.  If %current isn't executing an async_entry, %NULL is returned.
+ */
+async_func_ptr *async_current_func(void **datap, async_cookie_t *cookiep)
+{
+	struct work_struct *work;
+	struct async_entry *entry;
+
+	if (work_current_func(&work) != async_run_entry_fn)
+		return NULL;
+
+	entry = container_of(work, struct async_entry, work);
+	if (datap)
+		*datap = entry->data;
+	if (cookiep)
+		*cookiep = entry->cookie;
+	return entry->func;
+}
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6b99ac7..9fc1549 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3492,6 +3492,28 @@ unsigned int work_busy(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(work_busy);
 
+/**
+ * work_current_func - determine the work fn and item %current is executing
+ * @workp: optional out param for the current work item
+ *
+ * Determine whether %current is a kworker executing a work item and if so
+ * return the work function and, if @workp is not %NULL, the work item.  If
+ * %current isn't executing a work item, %NULL is returned.
+ */
+work_func_t work_current_func(struct work_struct **workp)
+{
+	struct worker *worker;
+
+	/* am I a kworker? */
+	if (!(current->flags & PF_WQ_WORKER))
+		return NULL;
+
+	worker = kthread_data(current);
+	if (workp)
+		*workp = worker->current_work;
+	return worker->current_func;
+}
+
 /*
  * CPU hotplug.
  *
-- 
1.8.0.2

