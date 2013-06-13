Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3FMEFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:05:17 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39315 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3FMEFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:05:12 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] cgroup: clean up css_[try]get() and css_put()
Date: Wed, 12 Jun 2013 21:04:52 -0700
Message-Id: <1371096298-24402-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371096298-24402-1-git-send-email-tj@kernel.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* __css_get() isn't used by anyone.  Fold it into css_get().

* Add proper function comments to all css reference functions.

This patch is purely cosmetic.

v2: Typo fix as per Li.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0e32855..a494636 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -94,33 +94,31 @@ enum {
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
-/* Caller must verify that the css is not for root cgroup */
-static inline void __css_get(struct cgroup_subsys_state *css, int count)
-{
-	atomic_add(count, &css->refcnt);
-}
-
-/*
- * Call css_get() to hold a reference on the css; it can be used
- * for a reference obtained via:
- * - an existing ref-counted reference to the css
- * - task->cgroups for a locked task
+/**
+ * css_get - obtain a reference on the specified css
+ * @css: target css
+ *
+ * The caller must already have a reference.
  */
-
 static inline void css_get(struct cgroup_subsys_state *css)
 {
 	/* We don't need to reference count the root state */
 	if (!(css->flags & CSS_ROOT))
-		__css_get(css, 1);
+		atomic_inc(&css->refcnt);
 }
 
-/*
- * Call css_tryget() to take a reference on a css if your existing
- * (known-valid) reference isn't already ref-counted. Returns false if
- * the css has been destroyed.
- */
-
 extern bool __css_tryget(struct cgroup_subsys_state *css);
+
+/**
+ * css_tryget - try to obtain a reference on the specified css
+ * @css: target css
+ *
+ * Obtain a reference on @css if it's alive.  The caller naturally needs to
+ * ensure that @css is accessible but doesn't have to be holding a
+ * reference on it - IOW, RCU protected access is good enough for this
+ * function.  Returns %true if a reference count was successfully obtained;
+ * %false otherwise.
+ */
 static inline bool css_tryget(struct cgroup_subsys_state *css)
 {
 	if (css->flags & CSS_ROOT)
@@ -128,12 +126,14 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
 	return __css_tryget(css);
 }
 
-/*
- * css_put() should be called to release a reference taken by
- * css_get() or css_tryget()
- */
-
 extern void __css_put(struct cgroup_subsys_state *css);
+
+/**
+ * css_put - put a css reference
+ * @css: target css
+ *
+ * Put a reference obtained via css_get() and css_tryget().
+ */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
 	if (!(css->flags & CSS_ROOT))
-- 
1.8.2.1

