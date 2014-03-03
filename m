Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaCCKew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:34:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaCCKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:34:50 -0500
Date: Mon, 3 Mar 2014 02:34:19 -0800
From: tip-bot for Heiko Carstens <tipbot@zytor.com>
Message-ID: <tip-03b8c7b623c80af264c4c8d6111e5c6289933666@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, fthain@telegraphics.com.au,
        heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        fthain@telegraphics.com.au, tglx@linutronix.de
In-Reply-To: <20140302120947.GA3641@osiris>
References: <20140302120947.GA3641@osiris>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex:
  Allow architectures to skip futex_atomic_cmpxchg_inatomic() test
Git-Commit-ID: 03b8c7b623c80af264c4c8d6111e5c6289933666
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

Commit-ID:  03b8c7b623c80af264c4c8d6111e5c6289933666
Gitweb:     http://git.kernel.org/tip/03b8c7b623c80af264c4c8d6111e5c6289933666
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Sun, 2 Mar 2014 13:09:47 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Mar 2014 11:32:08 +0100

futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test

If an architecture has futex_atomic_cmpxchg_inatomic() implemented and there
is no runtime check necessary, allow to skip the test within futex_init().

This allows to get rid of some code which would always give the same result,
and also allows the compiler to optimize a couple of if statements away.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/20140302120947.GA3641@osiris
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/Kconfig     |  1 +
 include/linux/futex.h |  4 ++++
 init/Kconfig          |  7 +++++++
 kernel/futex.c        | 37 ++++++++++++++++++++++++-------------
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a0775..bb74b21 100644
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
index b0d95ca..6435f46 100644
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
index 009a797..d56cb03 100644
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
index 44a1261..5d17e3a 100644
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
