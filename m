Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaLAVfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:35:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbaLAVe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:34:59 -0500
Date: Mon, 1 Dec 2014 22:34:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86, ticketlock: spin_unlock_wait() can livelock
Message-ID: <20141201213417.GA5842@redhat.com>
References: <20141201213357.GA5834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201213357.GA5834@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_spin_unlock_wait() looks very suboptimal, to the point I think
this is just wrong and can lead to livelock: if the lock is heavily
contended we can never see head == tail.

But we do not need to wait for arch_spin_is_locked() == F. If it is
locked we only need to wait until the current owner drops this lock.
So we could simply spin until old_head != lock->tickets.head in this
case, but .head can overflow and thus we can't check "unlocked" only
once before the main loop.

Also, the "unlocked" check can ignore TICKET_SLOWPATH_FLAG bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/spinlock.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 9295016..a4efe47 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -183,8 +183,20 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (arch_spin_is_locked(lock))
+	__ticket_t head = ACCESS_ONCE(lock->tickets.head);
+
+	for (;;) {
+		struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+		/*
+		 * We need to check "unlocked" in a loop, tmp.head == head
+		 * can be false positive because of overflow.
+		 */
+		if (tmp.head == (tmp.tail & ~TICKET_SLOWPATH_FLAG) ||
+		    tmp.head != head)
+			break;
+
 		cpu_relax();
+	}
 }
 
 /*
-- 
1.5.5.1


