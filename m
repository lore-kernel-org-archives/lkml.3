Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3AYTV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234Ab3AYTUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:20:35 -0500
Date: Fri, 25 Jan 2013 14:16:26 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: [PATCH -v4 1/5] x86,smp: move waiting on contended ticket lock out
 of line
Message-ID: <20130125141626.48faa6c6@annuminas.surriel.com>
In-Reply-To: <20130125140553.060b8ced@annuminas.surriel.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the wait loop for congested loops to its own function allows
us to add things to that wait loop, without growing the size of the
kernel text appreciably.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmiss.org>
Reviewed-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rafael Aquini <aquini@redhat.com>
---
v2: clean up the code a little, after Michel's suggestion 

 arch/x86/include/asm/spinlock.h |   11 +++++------
 arch/x86/kernel/smp.c           |   14 ++++++++++++++
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

