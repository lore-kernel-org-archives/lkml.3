Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaDRJt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45886 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 06/72] futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test
Date: Fri, 18 Apr 2014 11:21:39 +0200
Message-Id: <cee41ea056923d9fca61bf3ccccaf7f245d2ea7b.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/Kconfig     |  1 +
 include/linux/futex.h |  4 ++++
 init/Kconfig          |  7 +++++++
 kernel/futex.c        | 14 ++++++++++++--
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3e01afa21710..6671e8db1861 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,6 +116,7 @@ config S390
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
index 3ecd8a1178f1..d42dc7c6ba64 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1406,6 +1406,13 @@ config FUTEX
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
index 231754863a87..d8347b7a064f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -68,7 +68,9 @@
 
 #include "rtmutex_common.h"
 
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 int __read_mostly futex_cmpxchg_enabled;
+#endif
 
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
@@ -2731,10 +2733,10 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
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
-- 
1.9.2

