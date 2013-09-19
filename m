Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3ISSHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:07:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61820 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab3ISSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:07:29 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Will Deacon <will.deacon@arm.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
Date: Thu, 19 Sep 2013 19:06:46 +0100
Message-Id: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmpxchg() function tends not to support 64-bit arguments on 32-bit
architectures. This could be either due to use of unsigned long arguments
(like on ARM) or lack of instruction support (cmpxchgq on x86). However,
these architectures may implement a specific cmpxchg64() function to
provide 64-bit cmpxchg support instead.

Since the lockref code requires a 64-bit cmpxchg and relies on the
architecture selecting ARCH_USE_CMPXCHG_LOCKREF, move to using cmpxchg64
instead of cmpxchg and allow 32-bit architectures to make use of the
lockless lockref implementation.

Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

An alternative to this patch is to go through the 32-bit architectures
that implement cmpxchg64, reworking their cmpxchg definitions to switch
to the 64-bit version based on the sizeof the argument.

 lib/lockref.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index e2cd2c0..677d036 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -14,8 +14,8 @@
 	while (likely(arch_spin_value_unlocked(old.lock.rlock.raw_lock))) {  	\
 		struct lockref new = old, prev = old;				\
 		CODE								\
-		old.lock_count = cmpxchg(&lockref->lock_count,			\
-					 old.lock_count, new.lock_count);	\
+		old.lock_count = cmpxchg64(&lockref->lock_count,		\
+					   old.lock_count, new.lock_count);	\
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-- 
1.8.2.2

