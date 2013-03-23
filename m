Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118Ab3CWB1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:27:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422990Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455612"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/29] locking, tsx: Abort is mutex_is_locked()
Date: Fri, 22 Mar 2013 18:25:12 -0700
Message-Id: <1364001923-10796-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Inside a elided mutex we cannot tell if the mutex is really locked
or not. Aborting it he safe answer.

Callers who frequently abort (e.g. BUG_ONs) need to be fixed
separately.

Noop without RTM.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/mutex.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..0574095 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
+#include <linux/elide.h>
 
 #include <linux/atomic.h>
 
@@ -123,6 +124,7 @@ extern void __mutex_init(struct mutex *lock, const char *name,
  */
 static inline int mutex_is_locked(struct mutex *lock)
 {
+	elide_abort();
 	return atomic_read(&lock->count) != 1;
 }
 
-- 
1.7.7.6

