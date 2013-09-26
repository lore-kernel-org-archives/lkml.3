Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3IZPNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:13:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53936 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab3IZPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:13:49 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 4/4] lib: lockref: use relaxed cmpxchg64 variant for lockless updates
Date: Thu, 26 Sep 2013 16:13:31 +0100
Message-Id: <1380208411-31403-4-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
References: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit cmpxchg operation on the lockref is ordered by virtue of
hazarding between the cmpxchg operation and the reference count
manipulation. On weakly ordered memory architectures (such as ARM), it
can be of great benefit to omit the barrier instructions where they are
not needed.

This patch moves the lockless lockref code over to the new
cmpxchg64_relaxed operation, which doesn't provide barrier semantics.

Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

So here's a quick stab at allowing the memory barrier semantics to be
avoided on weakly ordered architectures. This helps ARM, but it would be
interesting to see if ia64 gets a boost too (although I've not relaxed
their cmpxchg because there is uapi stuff involved that I wasn't
comfortable refactoring).

 lib/lockref.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 677d036..6d896ab 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -14,8 +14,9 @@
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

