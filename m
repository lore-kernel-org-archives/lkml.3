Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaJ0TCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:02:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaJ0TCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/105] futex: Ensure get_futex_key_refs() always implies a barrier
Date: Mon, 27 Oct 2014 11:57:18 -0700
Message-Id: <1414436240-13879-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 76835b0ebf8a7fe85beb03c75121419a7dec52f0 upstream.

Commit b0c29f79ecea (futexes: Avoid taking the hb->lock if there's
nothing to wake up) changes the futex code to avoid taking a lock when
there are no waiters. This code has been subsequently fixed in commit
11d4616bd07f (futex: revert back to the explicit waiter counting code).
Both the original commit and the fix-up rely on get_futex_key_refs() to
always imply a barrier.

However, for private futexes, none of the cases in the switch statement
of get_futex_key_refs() would be hit and the function completes without
a memory barrier as required before checking the "waiters" in
futex_wake() -> hb_waiters_pending(). The consequence is a race with a
thread waiting on a futex on another CPU, allowing the waker thread to
read "waiters == 0" while the waiter thread to have read "futex_val ==
locked" (in kernel).

Without this fix, the problem (user space deadlocks) can be seen with
Android bionic's mutex implementation on an arm64 multi-cluster system.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Matteo Franchin <Matteo.Franchin@arm.com>
Fixes: b0c29f79ecea (futexes: Avoid taking the hb->lock if there's nothing to wake up)
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/futex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4741b1f..2b1583e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -194,6 +194,8 @@ static void get_futex_key_refs(union futex_key *key)
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
 		break;
+	default:
+		smp_mb(); /* explicit MB (B) */
 	}
 }
 
-- 
1.9.1

