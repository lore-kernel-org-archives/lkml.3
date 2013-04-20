Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513Ab3DTBk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:40:59 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61897 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965453Ab3DTBk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:40:58 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: torvalds@linux-foundation.org, Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] kref: minor cleanup
Date: Fri, 19 Apr 2013 18:33:54 -0700
Message-Id: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow-up for https://lkml.org/lkml/2013/4/12/391

* make warning smp-safe
* result of atomic _unless_zero functions should be checked by caller
    to avoid use-after-free error

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/linux/kref.h | 9 ++++++---
 lib/kobject.c        | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..092529a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -39,8 +39,11 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	WARN_ON(!atomic_read(&kref->refcount));
-	atomic_inc(&kref->refcount);
+	/* If refcount was 0 before incrementing then we have a race
+	 * condition when this kref is freing by some other thread right now.
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
index a654866..bbd7362 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,7 +529,8 @@ struct kobject *kobject_get(struct kobject *kobj)
 	return kobj;
 }
 
-static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
+static struct kobject *__must_check kobject_get_unless_zero(
+		struct kobject *kobj)
 {
 	if (!kref_get_unless_zero(&kobj->kref))
 		kobj = NULL;
-- 
1.8.2.1

