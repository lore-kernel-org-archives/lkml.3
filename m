Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3CSA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:58:59 -0400
Received: from longford.logfs.org ([213.229.74.203]:58726 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CSA65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:58:57 -0400
Date: Mon, 18 Mar 2013 19:34:13 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: [PATCH v3] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130318233413.GD9685@logfs.org>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130318231154.GC9685@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And because I'm lame and stupid, here's v3.

It is possible for one thread to to take se_sess->sess_cmd_lock in
core_tmr_abort_task() before taking a reference count on
se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.

This introduces kref_put_and_lock() and uses it in
target_put_sess_cmd() to close the race window.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/target/target_core_transport.c |   17 +++++++++++------
 include/linux/kref.h                   |   26 ++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 04ec9cb..b98c158 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2207,21 +2207,19 @@ static void target_release_cmd_kref(struct kref *kref)
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
@@ -2232,7 +2230,14 @@ static void target_release_cmd_kref(struct kref *kref)
  */
 int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
-	return kref_put(&se_cmd->cmd_kref, target_release_cmd_kref);
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = kref_put_spinlock(&se_cmd->cmd_kref, target_release_cmd_kref,
+			&se_sess->sess_cmd_lock);
+	local_irq_restore(flags);
+	return ret;
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..1f26a86 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 struct kref {
 	atomic_t refcount;
@@ -95,6 +96,31 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 	return kref_sub(kref, 1, release);
 }
 
+/**
+ * kref_put_and_lock - decrement refcount for object.
+ * @kref: object.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ * @lock: lock to take in release case
+ *
+ * Behaves identical to kref_put with one exception.  If the reference count
+ * drops to zero, the lock will be taken atomically wrt dropping the reference
+ * count.
+ */
+static inline int kref_put_spinlock(struct kref *kref,
+		void (*release)(struct kref *kref),
+		spinlock_t *lock)
+{
+	WARN_ON(release == NULL);
+	if (atomic_dec_and_lock(&kref->refcount, lock)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
+
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
-- 
1.7.10.4

