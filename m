Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3LRKeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:34:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3LRKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:34:00 -0500
Date: Wed, 18 Dec 2013 02:33:27 -0800
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-91f30a17024ff0d8345e11228af33ee938b13426@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1386136693.3650.48.camel@cliu38-desktop-build>
References: <1386136693.3650.48.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutexes:
  Give more informative mutex warning in the !lock->owner case
Git-Commit-ID: 91f30a17024ff0d8345e11228af33ee938b13426
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91f30a17024ff0d8345e11228af33ee938b13426
Gitweb:     http://git.kernel.org/tip/91f30a17024ff0d8345e11228af33ee938b13426
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Wed, 4 Dec 2013 13:58:13 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:35:10 +0100

mutexes: Give more informative mutex warning in the !lock->owner case

When mutex debugging is enabled and an imbalanced mutex_unlock()
is called, we get the following, slightly confusing warning:

  [  364.208284] DEBUG_LOCKS_WARN_ON(lock->owner != current)

But in that case the warning is due to an imbalanced mutex_unlock() call,
and the lock->owner is NULL - so the message is misleading.

So improve the message by testing for this case specifically:

   DEBUG_LOCKS_WARN_ON(!lock->owner)

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1386136693.3650.48.camel@cliu38-desktop-build
[ Improved the changelog, changed the patch to use !lock->owner consistently. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex-debug.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 7e3443f..faf6f5b 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -75,7 +75,12 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
+	if (!lock->owner)
+		DEBUG_LOCKS_WARN_ON(!lock->owner);
+	else
+		DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
