Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaJQQi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:38:58 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45520 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaJQQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:38:57 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] futex: Ensure get_futex_key_refs() always implies a barrier
Date: Fri, 17 Oct 2014 17:38:49 +0100
Message-Id: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/futex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 815d7af2ffe8..f3a3a071283c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -343,6 +343,8 @@ static void get_futex_key_refs(union futex_key *key)
 	case FUT_OFF_MMSHARED:
 		futex_get_mm(key); /* implies MB (B) */
 		break;
+	default:
+		smp_mb(); /* explicit MB (B) */
 	}
 }
 
