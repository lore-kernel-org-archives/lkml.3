Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaCBMJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:09:55 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33354 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaCBMJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:09:53 -0500
Date: Sun, 2 Mar 2014 13:09:47 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] futexes: allow architectures to skip
 futex_atomic_cmpxchg_inatomic() test
Message-ID: <20140302120947.GA3641@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030212-3548-0000-0000-0000084287B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an architecture has futex_atomic_cmpxchg_inatomic() implemented and there
is no runtime check necessary, allow to skip the test within futex_init().

This allows to get rid of some code which would always give the same result,
and also allows the compiler to optimize a couple of if statements away.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig     |  1 +
 include/linux/futex.h |  4 ++++
 init/Kconfig          |  7 +++++++
 kernel/futex.c        | 37 ++++++++++++++++++++++++-------------
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a07750f4f9..bb74b21f007a 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -117,6 +117,7 @@ config S390
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
diff --git a/include/linux/futex.h b/include/linux/futex.h
index b0d95cac826e..6435f46d6e13 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -55,7 +55,11 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+#ifdef CONFIG_HAVE_FUTEX_CMPXCHG
+#define futex_cmpxchg_enabled 1
+#else
 extern int futex_cmpxchg_enabled;
+#endif
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 009a797dd242..d56cb03c1b49 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1387,6 +1387,13 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config HAVE_FUTEX_CMPXCHG
+	bool
+	help
+	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
+	  is implemented and always working. This removes a couple of runtime
+	  checks.
+
 config EPOLL
 	bool "Enable eventpoll support" if EXPERT
 	default y
diff --git a/kernel/futex.c b/kernel/futex.c
index 44a1261cb9ff..5d17e3a83f8c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -157,7 +157,9 @@
  * enqueue.
  */
 
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 int __read_mostly futex_cmpxchg_enabled;
+#endif
 
 /*
  * Futex flags used to encode options to functions and preserve them across
@@ -2843,9 +2845,28 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
-static int __init futex_init(void)
+static void __init futex_detect_cmpxchg(void)
 {
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 	u32 curval;
+
+	/*
+	 * This will fail and we want it. Some arch implementations do
+	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
+	 * functionality. We want to know that before we call in any
+	 * of the complex code paths. Also we want to prevent
+	 * registration of robust lists in that case. NULL is
+	 * guaranteed to fault and we get -EFAULT on functional
+	 * implementation, the non-functional ones will return
+	 * -ENOSYS.
+	 */
+	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
+		futex_cmpxchg_enabled = 1;
+#endif
+}
+
+static int __init futex_init(void)
+{
 	unsigned int futex_shift;
 	unsigned long i;
 
@@ -2861,18 +2882,8 @@ static int __init futex_init(void)
 					       &futex_shift, NULL,
 					       futex_hashsize, futex_hashsize);
 	futex_hashsize = 1UL << futex_shift;
-	/*
-	 * This will fail and we want it. Some arch implementations do
-	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
-	 * functionality. We want to know that before we call in any
-	 * of the complex code paths. Also we want to prevent
-	 * registration of robust lists in that case. NULL is
-	 * guaranteed to fault and we get -EFAULT on functional
-	 * implementation, the non-functional ones will return
-	 * -ENOSYS.
-	 */
-	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
-		futex_cmpxchg_enabled = 1;
+
+	futex_detect_cmpxchg();
 
 	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
-- 
1.8.4.5

