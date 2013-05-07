Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3EGXFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:05:03 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:54116 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3EGXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:05:01 -0400
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 19:05:01 EDT
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] kref: minor cleanup
Date: Tue,  7 May 2013 15:37:48 -0700
Message-Id: <1367966268-18826-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* make warning smp-safe
* result of atomic _unless_zero functions should be checked by caller
    to avoid use-after-free error
* minor stylistic fixes

Link: https://lkml.org/lkml/2013/4/12/391

Tested: compile x86, boot machine and run xfstests
Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/linux/kref.h | 9 ++++++---
 lib/kobject.c        | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..817d7f1 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -39,8 +39,11 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	WARN_ON(!atomic_read(&kref->refcount));
-	atomic_inc(&kref->refcount);
+	/* If refcount was 0 before incrementing then we have a race
+	 * condition when this kref is freeing by some other thread right now.
+	 * In this case one should use kref_get_unless_zero()
+	 */
+	WARN_ON(atomic_inc_return(&kref->refcount) < 2);
 }
 
 /**
@@ -100,7 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
 				 struct mutex *lock)
 {
 	WARN_ON(release == NULL);
-        if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
+	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
 		mutex_lock(lock);
 		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
 			mutex_unlock(lock);
diff --git a/lib/kobject.c b/lib/kobject.c
index a654866..7b13611 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,7 +529,8 @@ struct kobject *kobject_get(struct kobject *kobj)
 	return kobj;
 }
 
-static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
+static struct kobject * __must_check kobject_get_unless_zero(
+	struct kobject *kobj)
 {
 	if (!kref_get_unless_zero(&kobj->kref))
 		kobj = NULL;
-- 
1.8.2.1

