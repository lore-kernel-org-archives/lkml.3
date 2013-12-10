Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3LJB26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:28:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36215 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LJB2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:28:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v5 tip/core/locking 6/7] locking: Add an smp_mb__after_unlock_lock() for UNLOCK+LOCK barrier
Date: Mon,  9 Dec 2013 17:28:02 -0800
Message-Id: <1386638883-25379-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121001-7164-0000-0000-00000414BBE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The Linux kernel has traditionally required that an UNLOCK+LOCK pair
act as a full memory barrier when either (1) that UNLOCK+LOCK pair
was executed by the same CPU or task, or (2) the same lock variable
was used for the UNLOCK and LOCK.  It now seems likely that very few
places in the kernel rely on this full-memory-barrier semantic, and
with the advent of queued locks, providing this semantic either requires
complex reasoning, or for some architectures, added overhead.

This commit therefore adds a smp_mb__after_unlock_lock(), which may be
placed after a LOCK primitive to restore the full-memory-barrier semantic.
All definitions are currently no-ops, but will be upgraded for some
architectures when queued locks arrive.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/arm/include/asm/barrier.h      | 2 ++
 arch/arm64/include/asm/barrier.h    | 2 ++
 arch/ia64/include/asm/barrier.h     | 2 ++
 arch/metag/include/asm/barrier.h    | 2 ++
 arch/mips/include/asm/barrier.h     | 2 ++
 arch/powerpc/include/asm/barrier.h  | 2 ++
 arch/s390/include/asm/barrier.h     | 2 ++
 arch/sparc/include/asm/barrier_64.h | 2 ++
 arch/x86/include/asm/barrier.h      | 2 ++
 include/asm-generic/barrier.h       | 2 ++
 10 files changed, 20 insertions(+)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 2f59f7443396..133aa543dfdb 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -74,6 +74,8 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
 
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 78e20ba8806b..f97efda22e0a 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -91,6 +91,8 @@ do {									\
 
 #endif
 
+#define smp_mb__after_unlock_lock()	do { } while 0
+
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
 
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index bddcfe91d9c8..fb64ead98e65 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -101,6 +101,8 @@ do {									\
 })
 #endif
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 /*
  * XXX check on this ---I suspect what Linus really wants here is
  * acquire vs release semantics but we can't discuss this stuff with
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index 5d6b4b407dda..76a3ff950607 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -97,4 +97,6 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index e1aa4e4c2984..6f9b586241d6 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -195,4 +195,6 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index f89da808ce31..abf645799991 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -84,4 +84,6 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 578680f6207a..c8f12244aed3 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -47,4 +47,6 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index b5aad964558e..a2b73329f89c 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -68,4 +68,6 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index f7053f354ac3..0371fd15f7ee 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -115,6 +115,8 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 6f692f8ac664..938ecf3a7cd8 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -77,5 +77,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__after_unlock_lock()	do { } while (0)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
-- 
1.8.1.5

