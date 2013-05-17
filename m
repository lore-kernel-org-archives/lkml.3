Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3EQVmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:42:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3EQViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 087/102] target: close target_put_sess_cmd() vs. core_tmr_abort_task() race
Date: Fri, 17 May 2013 14:36:42 -0700
Message-Id: <20130517213253.422491092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit ccf5ae83a6cf3d9cfe9a7038bfe7cd38ab03d5e1 upstream.

It is possible for one thread to to take se_sess->sess_cmd_lock in
core_tmr_abort_task() before taking a reference count on
se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.

This introduces kref_put_spinlock_irqsave() and uses it in
target_put_sess_cmd() to close the race window.

Signed-off-by: Joern Engel <joern@logfs.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   11 +++++------
 include/linux/kref.h                   |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 6 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2213,21 +2213,19 @@ static void target_release_cmd_kref(stru
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
-	unsigned long flags;
 
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (list_empty(&se_cmd->se_cmd_list)) {
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		spin_unlock(&se_sess->sess_cmd_lock);
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
 	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		spin_unlock(&se_sess->sess_cmd_lock);
 		complete(&se_cmd->cmd_wait_comp);
 		return;
 	}
 	list_del(&se_cmd->se_cmd_list);
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+	spin_unlock(&se_sess->sess_cmd_lock);
 
 	se_cmd->se_tfo->release_cmd(se_cmd);
 }
@@ -2238,7 +2236,8 @@ static void target_release_cmd_kref(stru
  */
 int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
-	return kref_put(&se_cmd->cmd_kref, target_release_cmd_kref);
+	return kref_put_spinlock_irqsave(&se_cmd->cmd_kref, target_release_cmd_kref,
+			&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 struct kref {
 	atomic_t refcount;
@@ -95,6 +96,38 @@ static inline int kref_put(struct kref *
 	return kref_sub(kref, 1, release);
 }
 
+/**
+ * kref_put_spinlock_irqsave - decrement refcount for object.
+ * @kref: object.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ * @lock: lock to take in release case
+ *
+ * Behaves identical to kref_put with one exception.  If the reference count
+ * drops to zero, the lock will be taken atomically wrt dropping the reference
+ * count.  The release function has to call spin_unlock() without _irqrestore.
+ */
+static inline int kref_put_spinlock_irqsave(struct kref *kref,
+		void (*release)(struct kref *kref),
+		spinlock_t *lock)
+{
+	unsigned long flags;
+
+	WARN_ON(release == NULL);
+	if (atomic_add_unless(&kref->refcount, -1, 1))
+		return 0;
+	spin_lock_irqsave(lock, flags);
+	if (atomic_dec_and_test(&kref->refcount)) {
+		release(kref);
+		local_irq_restore(flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(lock, flags);
+	return 0;
+}
+
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)


