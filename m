Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab3BMMHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:07:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab3BMMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:07:37 -0500
Date: Wed, 13 Feb 2013 04:06:13 -0800
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        rostedt@goodmiss.org, akpm@linux-foundation.org, aquini@redhat.com,
        tglx@linutronix.de, walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        rostedt@goodmiss.org, aquini@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, walken@google.com
In-Reply-To: <20130206150403.006e5294@cuia.bos.redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/smp:
  Move waiting on contended ticket lock out of line
Git-Commit-ID: 4aef331850b637169ff036ed231f0d236874f310
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 04:06:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4aef331850b637169ff036ed231f0d236874f310
Gitweb:     http://git.kernel.org/tip/4aef331850b637169ff036ed231f0d236874f310
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 6 Feb 2013 15:04:03 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Feb 2013 09:06:28 +0100

x86/smp: Move waiting on contended ticket lock out of line

Moving the wait loop for congested loops to its own function
allows us to add things to that wait loop, without growing the
size of the kernel text appreciably.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmiss.org>
Reviewed-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rafael Aquini <aquini@redhat.com>
Cc: eric.dumazet@gmail.com
Cc: lwoodman@redhat.com
Cc: knoel@redhat.com
Cc: chegu_vinod@hp.com
Cc: raghavendra.kt@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130206150403.006e5294@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/spinlock.h | 11 +++++------
 arch/x86/kernel/smp.c           | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..dc492f6 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -34,6 +34,8 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+extern void ticket_spin_lock_wait(arch_spinlock_t *, struct __raw_tickets);
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -53,12 +55,9 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 
 	inc = xadd(&lock->tickets, inc);
 
-	for (;;) {
-		if (inc.head == inc.tail)
-			break;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
-	}
+	if (inc.head != inc.tail)
+		ticket_spin_lock_wait(lock, inc);
+
 	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..20da354 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -113,6 +113,20 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
 /*
+ * Wait on a congested ticket spinlock.
+ */
+void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
+{
+	for (;;) {
+		cpu_relax();
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+
+		if (inc.head == inc.tail)
+			break;
+	}
+}
+
+/*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
