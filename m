Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaA1T1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:27:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaA1TXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:23:25 -0500
Date: Tue, 28 Jan 2014 11:22:44 -0800
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-aff7385b5a16bca6b8d9243f01a9ea5a5b411e1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com
In-Reply-To: <1390347353.3138.62.camel@schen9-DESK>
References: <1390347353.3138.62.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutexes/mcs: Correct barrier usage
Git-Commit-ID: aff7385b5a16bca6b8d9243f01a9ea5a5b411e1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:22:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aff7385b5a16bca6b8d9243f01a9ea5a5b411e1d
Gitweb:     http://git.kernel.org/tip/aff7385b5a16bca6b8d9243f01a9ea5a5b411e1d
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Tue, 21 Jan 2014 15:35:53 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:13:26 +0100

locking/mutexes/mcs: Correct barrier usage

This patch corrects the way memory barriers are used in the MCS lock
with smp_load_acquire and smp_store_release fucnctions.  The previous
barriers could leak critical sections if mcs lock is used by itself.
It is not a problem when mcs lock is embedded in mutex but will be an
issue when the mcs_lock is used elsewhere.

The patch removes the incorrect barriers and put in correct
barriers with the pair of functions smp_load_acquire and smp_store_release.

Suggested-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1390347353.3138.62.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..fbbd2ed 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -136,9 +136,12 @@ void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
 		return;
 	}
 	ACCESS_ONCE(prev->next) = node;
-	smp_wmb();
-	/* Wait until the lock holder passes the lock down */
-	while (!ACCESS_ONCE(node->locked))
+	/*
+	 * Wait until the lock holder passes the lock down.
+	 * Using smp_load_acquire() provides a memory barrier that
+	 * ensures subsequent operations happen after the lock is acquired.
+	 */
+	while (!(smp_load_acquire(&node->locked)))
 		arch_mutex_cpu_relax();
 }
 
@@ -156,8 +159,13 @@ static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
 		while (!(next = ACCESS_ONCE(node->next)))
 			arch_mutex_cpu_relax();
 	}
-	ACCESS_ONCE(next->locked) = 1;
-	smp_wmb();
+	/*
+	 * Pass lock to next waiter.
+	 * smp_store_release() provides a memory barrier to ensure
+	 * all operations in the critical section has been completed
+	 * before unlocking.
+	 */
+	smp_store_release(&next->locked, 1);
 }
 
 /*
