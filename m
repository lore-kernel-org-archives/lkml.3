Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3DTQP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:15:27 -0400
Received: from mail-ye0-f201.google.com ([209.85.213.201]:34666 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3DTQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:15:26 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] kref: minor cleanup
Date: Sat, 20 Apr 2013 09:15:10 -0700
Message-Id: <1366474510-9427-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
References: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow-up for https://lkml.org/lkml/2013/4/12/391

* make warning smp-safe
* result of atomic _unless_zero functions should be checked by caller
    to avoid use-after-free error

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/linux/kobject.h | 1 +
 include/linux/kref.h    | 9 ++++++---
 lib/kobject.c           | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 939b112..bfad936 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -101,6 +101,7 @@ extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
 extern struct kobject *kobject_get(struct kobject *kobj);
+extern struct kobject * __must_check kobject_get_unless_zero(struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
 
 extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
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
index a654866..af32119 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,7 +529,7 @@ struct kobject *kobject_get(struct kobject *kobj)
 	return kobj;
 }
 
-static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
+struct kobject *kobject_get_unless_zero(struct kobject *kobj)
 {
 	if (!kref_get_unless_zero(&kobj->kref))
 		kobj = NULL;
-- 
1.8.2.1

