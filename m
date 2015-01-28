Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbbA1ETA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:19:00 -0500
Received: from mail.kernel.org ([198.145.29.136]:38677 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882AbbA1ES4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:56 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 057/177] futex: Ensure get_futex_key_refs() always implies a barrier
Date: Wed, 28 Jan 2015 12:08:01 +0800
Message-Id: <1422418236-12852-114-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/futex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 41dfb18..fafc54f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -212,6 +212,8 @@ static void drop_futex_key_refs(union futex_key *key)
 	case FUT_OFF_MMSHARED:
 		mmdrop(key->private.mm);
 		break;
+	default:
+		smp_mb(); /* explicit MB (B) */
 	}
 }
 
-- 
1.9.1

