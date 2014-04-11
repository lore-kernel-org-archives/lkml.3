Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbaDKQ0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:26:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432AbaDKQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.13 63/65] futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test
Date: Fri, 11 Apr 2014 09:11:35 -0700
Message-Id: <20140411161006.295440517@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 03b8c7b623c80af264c4c8d6111e5c6289933666 upstream.

If an architecture has futex_atomic_cmpxchg_inatomic() implemented and there
is no runtime check necessary, allow to skip the test within futex_init().

This allows to get rid of some code which would always give the same result,
and also allows the compiler to optimize a couple of if statements away.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/20140302120947.GA3641@osiris
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[geert: Backported to v3.10..v3.13]
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig     |    1 +
 include/linux/futex.h |    4 ++++
 init/Kconfig          |    7 +++++++
 kernel/futex.c        |   14 ++++++++++++--
 4 files changed, 24 insertions(+), 2 deletions(-)

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
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1399,6 +1399,13 @@ config FUTEX
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
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -68,7 +68,9 @@
 
 #include "locking/rtmutex_common.h"
 
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 int __read_mostly futex_cmpxchg_enabled;
+#endif
 
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
@@ -2731,10 +2733,10 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
-static int __init futex_init(void)
+static void __init futex_detect_cmpxchg(void)
 {
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 	u32 curval;
-	int i;
 
 	/*
 	 * This will fail and we want it. Some arch implementations do
@@ -2748,6 +2750,14 @@ static int __init futex_init(void)
 	 */
 	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
+#endif
+}
+
+static int __init futex_init(void)
+{
+	int i;
+
+	futex_detect_cmpxchg();
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		plist_head_init(&futex_queues[i].chain);


