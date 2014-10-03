Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaJCF3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:29:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60882 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJCF3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:29:06 -0400
Date: Thu, 2 Oct 2014 22:27:54 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-347abad981c1ef815ea5ba861adba6a8c6aa1580@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        schwidefsky@de.ibm.com, peterz@infradead.org, mpe@ellerman.id.au,
        riel@redhat.com, arnd@arndb.de, benh@kernel.crashing.org,
        akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, schwidefsky@de.ibm.com, mpe@ellerman.id.au,
        arnd@arndb.de, riel@redhat.com, benh@kernel.crashing.org,
        akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20140930155947.070cdb1f@annuminas.surriel.com>
References: <20140930155947.070cdb1f@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, time:
  Fix build error with 64 bit cputime_t on 32 bit systems
Git-Commit-ID: 347abad981c1ef815ea5ba861adba6a8c6aa1580
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

Commit-ID:  347abad981c1ef815ea5ba861adba6a8c6aa1580
Gitweb:     http://git.kernel.org/tip/347abad981c1ef815ea5ba861adba6a8c6aa1580
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 30 Sep 2014 15:59:47 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 05:46:55 +0200

sched, time: Fix build error with 64 bit cputime_t on 32 bit systems

On 32 bit systems cmpxchg cannot handle 64 bit values, so
some additional magic is required to allow a 32 bit system
with CONFIG_VIRT_CPU_ACCOUNTING_GEN=y enabled to build.

Make sure the correct cmpxchg function is used when doing
an atomic swap of a cputime_t.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: umgwanakikbuti@gmail.com
Cc: fweisbec@gmail.com
Cc: srao@redhat.com
Cc: lwoodman@redhat.com
Cc: atheurer@redhat.com
Cc: oleg@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux390@de.ibm.com
Cc: linux-arch@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Link: http://lkml.kernel.org/r/20140930155947.070cdb1f@annuminas.surriel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/cputime.h    |  2 ++
 arch/s390/include/asm/cputime.h       |  2 ++
 include/asm-generic/cputime_jiffies.h |  2 ++
 include/asm-generic/cputime_nsecs.h   |  2 ++
 kernel/sched/cputime.c                | 29 +++++++++++++++++++----------
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 607559a..6c840ce 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -32,6 +32,8 @@ static inline void setup_cputime_one_jiffy(void) { }
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg(ptr, old, new)
+
 #ifdef __KERNEL__
 
 /*
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index f65bd36..3001887 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -18,6 +18,8 @@
 typedef unsigned long long __nocast cputime_t;
 typedef unsigned long long __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg64(ptr, old, new)
+
 static inline unsigned long __div(unsigned long long n, unsigned long base)
 {
 #ifndef CONFIG_64BIT
diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
index d5cb78f5..fe386fc 100644
--- a/include/asm-generic/cputime_jiffies.h
+++ b/include/asm-generic/cputime_jiffies.h
@@ -3,6 +3,8 @@
 
 typedef unsigned long __nocast cputime_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg(ptr, old, new)
+
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 #define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
 #define cputime_to_scaled(__ct)		(__ct)
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index 4e81760..0419485 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -21,6 +21,8 @@
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
+#define cmpxchg_cputime(ptr, old, new) cmpxchg64(ptr, old, new)
+
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 
 #define cputime_div(__ct, divisor)  div_u64((__force u64)__ct, divisor)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 64492df..8394b1e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -555,6 +555,23 @@ drop_precision:
 }
 
 /*
+ * Atomically advance counter to the new value. Interrupts, vcpu
+ * scheduling, and scaling inaccuracies can cause cputime_advance
+ * to be occasionally called with a new value smaller than counter.
+ * Let's enforce atomicity.
+ *
+ * Normally a caller will only go through this loop once, or not
+ * at all in case a previous caller updated counter the same jiffy.
+ */
+static void cputime_advance(cputime_t *counter, cputime_t new)
+{
+	cputime_t old;
+
+	while (new > (old = ACCESS_ONCE(*counter)))
+		cmpxchg_cputime(counter, old, new);
+}
+
+/*
  * Adjust tick based cputime random precision against scheduler
  * runtime accounting.
  */
@@ -599,16 +616,8 @@ static void cputime_adjust(struct task_cputime *curr,
 		utime = rtime - stime;
 	}
 
-	/*
-	 * If the tick based count grows faster than the scheduler one,
-	 * the result of the scaling may go backward.
-	 * Let's enforce monotonicity.
-	 * Atomic exchange protects against concurrent cputime_adjust().
-	 */
-	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
-		cmpxchg(&prev->stime, rtime, stime);
-	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
-		cmpxchg(&prev->utime, rtime, utime);
+	cputime_advance(&prev->stime, stime);
+	cputime_advance(&prev->utime, utime);
 
 out:
 	*ut = prev->utime;
