Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423027Ab3CWB0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:26:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:24640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422997Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455616"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/29] x86, tsx: Add adaption support for spinlocks
Date: Fri, 22 Mar 2013 18:25:19 -0700
Message-Id: <1364001923-10796-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add adaptation support for ticket spinlocks. Each spinlock keeps a skip count
on how often to skip elision. This is controlled by the abort rate.
The actual adaptation algorithm is generic and shared with other lock types.
This avoids us having to tune each spinlock individually for elision.

This adds 2 bytes to a 32bit spinlock for systems configured for more than 256
CPUs, so it's now 6 bytes instead of 4. For systems with less than 256 CPUs it expands
spinlock_t from 2 to 4 bytes.

I played around with various schemes to merge the elision count with the main
tickets, but they all reduced the maximum CPU count support too much and caused
other problems. So in the end I just added the additional 2 bytes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/spinlock_types.h |    3 +++
 arch/x86/kernel/rtm-locks.c           |   10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index ad0ad07..614159c 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -24,6 +24,9 @@ typedef struct arch_spinlock {
 			__ticket_t head, tail;
 		} tickets;
 	};
+#ifdef CONFIG_RTM_LOCKS
+	short  elision_adapt;
+#endif
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
diff --git a/arch/x86/kernel/rtm-locks.c b/arch/x86/kernel/rtm-locks.c
index a313a81..1651049 100644
--- a/arch/x86/kernel/rtm-locks.c
+++ b/arch/x86/kernel/rtm-locks.c
@@ -76,16 +76,22 @@ static DEFINE_PER_CPU(bool, cli_elided);
 static struct static_key spinlock_elision = STATIC_KEY_INIT_TRUE;
 module_param(spinlock_elision, static_key, 0644);
 
+static __read_mostly struct elision_config spinlock_elision_config =
+	DEFAULT_ELISION_CONFIG;
+TUNE_ELISION_CONFIG(spinlock, spinlock_elision_config);
+
 static int rtm_spin_trylock(struct arch_spinlock *lock)
 {
-	if (elide_lock(spinlock_elision, !__ticket_spin_is_locked(lock)))
+	if (elide_lock_adapt(spinlock_elision, !__ticket_spin_is_locked(lock),
+			     &lock->elision_adapt, &spinlock_elision_config))
 		return 1;
 	return __ticket_spin_trylock(lock);
 }
 
 static inline void rtm_spin_lock(struct arch_spinlock *lock)
 {
-	if (!elide_lock(spinlock_elision, !__ticket_spin_is_locked(lock)))
+	if (!elide_lock_adapt(spinlock_elision, !__ticket_spin_is_locked(lock),
+			      &lock->elision_adapt, &spinlock_elision_config))
 		__ticket_spin_lock(lock);
 }
 
-- 
1.7.7.6

