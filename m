Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab3E1V0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3E1V0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 48/78] target: close target_put_sess_cmd() vs. core_tmr_abort_task() race
Date: Tue, 28 May 2013 14:19:57 -0700
Message-Id: <1369776027-17859-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_transport.c | 11 +++++------
 include/linux/kref.h                   | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fcf880f..e26f673 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2209,21 +2209,19 @@ static void target_release_cmd_kref(struct kref *kref)
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
@@ -2234,7 +2232,8 @@ static void target_release_cmd_kref(struct kref *kref)
  */
 int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
-	return kref_put(&se_cmd->cmd_kref, target_release_cmd_kref);
+	return kref_put_spinlock_irqsave(&se_cmd->cmd_kref, target_release_cmd_kref,
+			&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..7419c02 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 struct kref {
 	atomic_t refcount;
@@ -95,6 +96,38 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
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
-- 
1.8.1.2

