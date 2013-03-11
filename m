Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3CKRim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3CKRik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:38:40 -0400
Date: Mon, 11 Mar 2013 18:36:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kthread: introduce to_live_kthread()
Message-ID: <20130311173643.GA13543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311173625.GA13525@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"k->vfork_done != NULL" with a barrier() after to_kthread(k) in
task_get_live_kthread(k) looks unclear, and sub-optimal because
we load ->vfork_done twice.

All we need is to ensure that we do not return to_kthread(NULL).
Add a new trivial helper which loads/checks ->vfork_done once,
this also looks more understandable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kthread.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..fa4a013 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -52,8 +52,21 @@ enum KTHREAD_BITS {
 	KTHREAD_IS_PARKED,
 };
 
-#define to_kthread(tsk)	\
-	container_of((tsk)->vfork_done, struct kthread, exited)
+#define __to_kthread(vfork)	\
+	container_of(vfork, struct kthread, exited)
+
+static inline struct kthread *to_kthread(struct task_struct *k)
+{
+	return __to_kthread(k->vfork_done);
+}
+
+static struct kthread *to_live_kthread(struct task_struct *k)
+{
+	struct completion *vfork = ACCESS_ONCE(k->vfork_done);
+	if (likely(vfork))
+		return __to_kthread(vfork);
+	return NULL;
+}
 
 /**
  * kthread_should_stop - should this kthread return now?
@@ -313,15 +326,8 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 
 static struct kthread *task_get_live_kthread(struct task_struct *k)
 {
-	struct kthread *kthread;
-
 	get_task_struct(k);
-	kthread = to_kthread(k);
-	/* It might have exited */
-	barrier();
-	if (k->vfork_done != NULL)
-		return kthread;
-	return NULL;
+	return to_live_kthread(k);
 }
 
 /**
-- 
1.5.5.1

