Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaLIKU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:20:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaLIKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:18:30 -0500
Date: Tue, 9 Dec 2014 02:17:36 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-78bff1c8684fb94f1ae7283688f90188b53fc433@git.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de,
        Waiman.Long@hp.com, torvalds@linux-foundation.org,
        peterz@infradead.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jeremy@goop.org
Reply-To: jeremy@goop.org, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Waiman.Long@hp.com, peterz@infradead.org, tglx@linutronix.de,
        oleg@redhat.com, paulmck@linux.vnet.ibm.com
In-Reply-To: <20141201213417.GA5842@redhat.com>
References: <20141201213417.GA5842@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/ticketlock: Fix spin_unlock_wait()
  livelock
Git-Commit-ID: 78bff1c8684fb94f1ae7283688f90188b53fc433
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78bff1c8684fb94f1ae7283688f90188b53fc433
Gitweb:     http://git.kernel.org/tip/78bff1c8684fb94f1ae7283688f90188b53fc433
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 1 Dec 2014 22:34:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Dec 2014 11:36:44 +0100

x86/ticketlock: Fix spin_unlock_wait() livelock

arch_spin_unlock_wait() looks very suboptimal, to the point I
think this is just wrong and can lead to livelock: if the lock
is heavily contended we can never see head == tail.

But we do not need to wait for arch_spin_is_locked() == F. If it
is locked we only need to wait until the current owner drops
this lock. So we could simply spin until old_head !=
lock->tickets.head in this case, but .head can overflow and thus
we can't check "unlocked" only once before the main loop.

Also, the "unlocked" check can ignore TICKET_SLOWPATH_FLAG bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Paul E.McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/r/20141201213417.GA5842@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/spinlock.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156de..abc34e9 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -184,8 +184,20 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 
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
