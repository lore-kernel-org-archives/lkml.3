Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3KGO5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:57:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:34441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3KGO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:57:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="318270121"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] lockref: Use BLOATED_SPINLOCKS to avoid explicit config dependencies
Date: Thu,  7 Nov 2013 16:57:23 +0200
Message-Id: <1383836243-8987-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Avoid the fragile Kconfig construct guestimating spinlock_t sizes; use a
friendly compile-time test to determine this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[kirill.shutemov@linux.intel.com: drop CONFIG_CMPXCHG_LOCKREF]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/lockref.h | 7 ++++++-
 lib/Kconfig             | 7 -------
 lib/lockref.c           | 2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 13dfd36a3294..c8929c3832db 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -15,10 +15,15 @@
  */
 
 #include <linux/spinlock.h>
+#include <generated/bounds.h>
+
+#define USE_CMPXCHG_LOCKREF \
+	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
+	 IS_ENABLED(CONFIG_SMP) && !BLOATED_SPINLOCKS)
 
 struct lockref {
 	union {
-#ifdef CONFIG_CMPXCHG_LOCKREF
+#if USE_CMPXCHG_LOCKREF
 		aligned_u64 lock_count;
 #endif
 		struct {
diff --git a/lib/Kconfig b/lib/Kconfig
index a16fdb50c252..7c1721ec4909 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -51,13 +51,6 @@ config PERCPU_RWSEM
 config ARCH_USE_CMPXCHG_LOCKREF
 	bool
 
-config CMPXCHG_LOCKREF
-	def_bool y if ARCH_USE_CMPXCHG_LOCKREF
-	depends on SMP
-	depends on !GENERIC_LOCKBREAK
-	depends on !DEBUG_SPINLOCK
-	depends on !DEBUG_LOCK_ALLOC
-
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/lockref.c b/lib/lockref.c
index af6e95d0bed6..d2b123f8456b 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -1,7 +1,7 @@
 #include <linux/export.h>
 #include <linux/lockref.h>
 
-#ifdef CONFIG_CMPXCHG_LOCKREF
+#if USE_CMPXCHG_LOCKREF
 
 /*
  * Allow weakly-ordered memory architectures to provide barrier-less
-- 
1.8.4.2

