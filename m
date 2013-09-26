Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3IZQ1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:27:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55484 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab3IZQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:27:40 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2] lib: lockref: allow relaxed cmpxchg64 variant for lockless updates
Date: Thu, 26 Sep 2013 17:27:00 +0100
Message-Id: <1380212820-6803-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit cmpxchg operation on the lockref is ordered by virtue of
hazarding between the cmpxchg operation and the reference count
manipulation. On weakly ordered memory architectures (such as ARM), it
can be of great benefit to omit the barrier instructions where they are
not needed.

This patch moves the lockless lockref code over to a cmpxchg64_relaxed
operation, which doesn't provide barrier semantics. If the operation
isn't defined, we simply #define it as the usual 64-bit cmpxchg macro.

Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 lib/lockref.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 677d036..e294ae4 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -4,6 +4,14 @@
 #ifdef CONFIG_CMPXCHG_LOCKREF
 
 /*
+ * Allow weakly-ordered memory architectures to provide barrier-less
+ * cmpxchg semantics for lockref updates.
+ */
+#ifndef cmpxchg64_relaxed
+# define cmpxchg64_relaxed cmpxchg64
+#endif
+
+/*
  * Note that the "cmpxchg()" reloads the "old" value for the
  * failure case.
  */
@@ -14,8 +22,9 @@
 	while (likely(arch_spin_value_unlocked(old.lock.rlock.raw_lock))) {  	\
 		struct lockref new = old, prev = old;				\
 		CODE								\
-		old.lock_count = cmpxchg64(&lockref->lock_count,		\
-					   old.lock_count, new.lock_count);	\
+		old.lock_count = cmpxchg64_relaxed(&lockref->lock_count,	\
+						   old.lock_count,		\
+						   new.lock_count);		\
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-- 
1.8.2.2

