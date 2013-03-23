Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106Ab3CWB1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:27:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:1050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422994Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455615"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 21/29] locking, tsx: Protect assert_spin_locked() with _xtest()
Date: Fri, 22 Mar 2013 18:25:15 -0700
Message-Id: <1364001923-10796-22-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

lock_is_locked aborts with lock elision. Some code does a lot of lock asserts,
which causes a lot of aborts. Add a _xtest() here so that the checking is only
done when the lock is not elided. This always happens occasionally due to
fallbacks, so there is still enough assert coverage.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/spinlock_api_smp.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index cf9bf3b..cd9269b 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -5,6 +5,8 @@
 # error "please don't include this file directly"
 #endif
 
+#include <linux/rtm.h>
+
 /*
  * include/linux/spinlock_api_smp.h
  *
@@ -17,7 +19,10 @@
 
 int in_lock_functions(unsigned long addr);
 
-#define assert_raw_spin_locked(x)	BUG_ON(!raw_spin_is_locked(x))
+#define assert_raw_spin_locked(x) do {			\
+	if (!_xtest())					\
+		BUG_ON(!raw_spin_is_locked(x));		\
+	} while (0)
 
 void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
-- 
1.7.7.6

