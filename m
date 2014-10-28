Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaJ1Dou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaJ1Doq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 073/127] futex: Ensure get_futex_key_refs() always implies a barrier
Date: Tue, 28 Oct 2014 11:35:08 +0800
Message-Id: <20141028033424.043540655@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -343,6 +343,8 @@ static void get_futex_key_refs(union fut
 	case FUT_OFF_MMSHARED:
 		futex_get_mm(key); /* implies MB (B) */
 		break;
+	default:
+		smp_mb(); /* explicit MB (B) */
 	}
 }
 


