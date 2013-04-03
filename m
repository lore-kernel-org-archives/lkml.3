Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3DCTY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:24:57 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43664 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3DCTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:24:53 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, akpm@linux-foundation.org
Cc: jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/3] kthread: implement probe_kthread_data()
Date: Wed,  3 Apr 2013 12:24:30 -0700
Message-Id: <1365017072-32213-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365017072-32213-1-git-send-email-tj@kernel.org>
References: <1365017072-32213-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement probe_kthread_data() which returns kthread_data if
accessible.  The function is equivalent to kthread_data() except that
the specified @task may not be a kthread or its vfork_done is already
cleared rendering struct kthread inaccessible.  In the former case,
probe_kthread_data() may return any value.  In the latter, NULL.

This will be used to safely print debug information without affecting
synchronization in the normal paths.  Workqueue debug info printing on
dump_stack() and friends will make use of it.

v2: Spelling error in comment fixed as suggested by Jan Kara.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d81664..7dcef33 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -43,6 +43,7 @@ bool kthread_should_stop(void);
 bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
+void *probe_kthread_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index b9db231..a279c55 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/freezer.h>
 #include <linux/ptrace.h>
+#include <linux/uaccess.h>
 #include <trace/events/sched.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -135,6 +136,24 @@ void *kthread_data(struct task_struct *task)
 	return to_kthread(task)->data;
 }
 
+/**
+ * probe_kthread_data - speculative version of kthread_data()
+ * @task: possible kthread task in question
+ *
+ * @task could be a kthread task.  Return the data value specified when it
+ * was created if accessible.  If @task isn't a kthread task or its data is
+ * inaccessible for any reason, %NULL is returned.  This function requires
+ * that @task itself is safe to dereference.
+ */
+void *probe_kthread_data(struct task_struct *task)
+{
+	struct kthread *kthread = to_kthread(task);
+	void *data = NULL;
+
+	probe_kernel_read(&data, &kthread->data, sizeof(data));
+	return data;
+}
+
 static void __kthread_parkme(struct kthread *self)
 {
 	__set_current_state(TASK_INTERRUPTIBLE);
-- 
1.8.1.4

