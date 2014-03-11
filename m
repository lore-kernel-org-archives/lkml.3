Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaCKTND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:13:03 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:53488 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaCKTM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:12:57 -0400
From: Simon Guinot <simon.guinot@sequanux.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <remi.rerolle@seagate.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 1/2] md: move up mddev locking functions
Date: Tue, 11 Mar 2014 20:12:09 +0100
Message-Id: <1394565130-24233-2-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
References: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch slightly moves up the mddev locking functions. This allows
to use them from mddev_suspend().

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
---
 drivers/md/md.c | 135 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 67 insertions(+), 68 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ad5cc4e63e8..fb4296adae80 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -218,6 +218,73 @@ static void md_new_event_inintr(struct mddev *mddev)
 static LIST_HEAD(all_mddevs);
 static DEFINE_SPINLOCK(all_mddevs_lock);
 
+static inline int __must_check mddev_lock(struct mddev * mddev)
+{
+	return mutex_lock_interruptible(&mddev->reconfig_mutex);
+}
+
+/* Sometimes we need to take the lock in a situation where
+ * failure due to interrupts is not acceptable.
+ */
+static inline void mddev_lock_nointr(struct mddev * mddev)
+{
+	mutex_lock(&mddev->reconfig_mutex);
+}
+
+static inline int mddev_is_locked(struct mddev *mddev)
+{
+	return mutex_is_locked(&mddev->reconfig_mutex);
+}
+
+static inline int mddev_trylock(struct mddev * mddev)
+{
+	return mutex_trylock(&mddev->reconfig_mutex);
+}
+
+static struct attribute_group md_redundancy_group;
+
+static void mddev_unlock(struct mddev * mddev)
+{
+	if (mddev->to_remove) {
+		/* These cannot be removed under reconfig_mutex as
+		 * an access to the files will try to take reconfig_mutex
+		 * while holding the file unremovable, which leads to
+		 * a deadlock.
+		 * So hold set sysfs_active while the remove in happeing,
+		 * and anything else which might set ->to_remove or my
+		 * otherwise change the sysfs namespace will fail with
+		 * -EBUSY if sysfs_active is still set.
+		 * We set sysfs_active under reconfig_mutex and elsewhere
+		 * test it under the same mutex to ensure its correct value
+		 * is seen.
+		 */
+		struct attribute_group *to_remove = mddev->to_remove;
+		mddev->to_remove = NULL;
+		mddev->sysfs_active = 1;
+		mutex_unlock(&mddev->reconfig_mutex);
+
+		if (mddev->kobj.sd) {
+			if (to_remove != &md_redundancy_group)
+				sysfs_remove_group(&mddev->kobj, to_remove);
+			if (mddev->pers == NULL ||
+			    mddev->pers->sync_request == NULL) {
+				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+				if (mddev->sysfs_action)
+					sysfs_put(mddev->sysfs_action);
+				mddev->sysfs_action = NULL;
+			}
+		}
+		mddev->sysfs_active = 0;
+	} else
+		mutex_unlock(&mddev->reconfig_mutex);
+
+	/* As we've dropped the mutex we need a spinlock to
+	 * make sure the thread doesn't disappear
+	 */
+	spin_lock(&pers_lock);
+	md_wakeup_thread(mddev->thread);
+	spin_unlock(&pers_lock);
+}
 
 /*
  * iterates through all used mddevs in the system.
@@ -562,74 +629,6 @@ static struct mddev * mddev_find(dev_t unit)
 	goto retry;
 }
 
-static inline int __must_check mddev_lock(struct mddev * mddev)
-{
-	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-}
-
-/* Sometimes we need to take the lock in a situation where
- * failure due to interrupts is not acceptable.
- */
-static inline void mddev_lock_nointr(struct mddev * mddev)
-{
-	mutex_lock(&mddev->reconfig_mutex);
-}
-
-static inline int mddev_is_locked(struct mddev *mddev)
-{
-	return mutex_is_locked(&mddev->reconfig_mutex);
-}
-
-static inline int mddev_trylock(struct mddev * mddev)
-{
-	return mutex_trylock(&mddev->reconfig_mutex);
-}
-
-static struct attribute_group md_redundancy_group;
-
-static void mddev_unlock(struct mddev * mddev)
-{
-	if (mddev->to_remove) {
-		/* These cannot be removed under reconfig_mutex as
-		 * an access to the files will try to take reconfig_mutex
-		 * while holding the file unremovable, which leads to
-		 * a deadlock.
-		 * So hold set sysfs_active while the remove in happeing,
-		 * and anything else which might set ->to_remove or my
-		 * otherwise change the sysfs namespace will fail with
-		 * -EBUSY if sysfs_active is still set.
-		 * We set sysfs_active under reconfig_mutex and elsewhere
-		 * test it under the same mutex to ensure its correct value
-		 * is seen.
-		 */
-		struct attribute_group *to_remove = mddev->to_remove;
-		mddev->to_remove = NULL;
-		mddev->sysfs_active = 1;
-		mutex_unlock(&mddev->reconfig_mutex);
-
-		if (mddev->kobj.sd) {
-			if (to_remove != &md_redundancy_group)
-				sysfs_remove_group(&mddev->kobj, to_remove);
-			if (mddev->pers == NULL ||
-			    mddev->pers->sync_request == NULL) {
-				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-				if (mddev->sysfs_action)
-					sysfs_put(mddev->sysfs_action);
-				mddev->sysfs_action = NULL;
-			}
-		}
-		mddev->sysfs_active = 0;
-	} else
-		mutex_unlock(&mddev->reconfig_mutex);
-
-	/* As we've dropped the mutex we need a spinlock to
-	 * make sure the thread doesn't disappear
-	 */
-	spin_lock(&pers_lock);
-	md_wakeup_thread(mddev->thread);
-	spin_unlock(&pers_lock);
-}
-
 static struct md_rdev * find_rdev_nr(struct mddev *mddev, int nr)
 {
 	struct md_rdev *rdev;
-- 
1.8.5.3

