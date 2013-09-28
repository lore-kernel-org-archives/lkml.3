Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3I1K6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:58:48 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53298 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3I1K6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:58:18 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 1/3] mutex: replace CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX with simple ifdef
Date: Sat, 28 Sep 2013 12:58:09 +0200
Message-Id: <1380365891-34457-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092810-6892-0000-0000-000006725427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus suggested to replace

 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
 #define arch_mutex_cpu_relax() cpu_relax()
 #endif

with just a simple

  #ifndef arch_mutex_cpu_relax
  # define arch_mutex_cpu_relax() cpu_relax()
  #endif

to get rid of CONFIG_HAVE_CPU_RELAX_SIMPLE. So architectures can
simply define arch_mutex_cpu_relax if they want an architecture
specific function instead of having to add a select statement in
their Kconfig in addition.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig                      | 3 ---
 arch/s390/Kconfig                 | 1 -
 arch/s390/include/asm/mutex.h     | 2 --
 arch/s390/include/asm/processor.h | 2 ++
 include/linux/mutex.h             | 6 +++---
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..af2cc6e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -286,9 +286,6 @@ config HAVE_PERF_USER_STACK_DUMP
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
-config HAVE_ARCH_MUTEX_CPU_RELAX
-	bool
-
 config HAVE_RCU_TABLE_FREE
 	bool
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcc6ac2..d3fa840 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -102,7 +102,6 @@ config S390
 	select GENERIC_TIME_VSYSCALL_OLD
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
-	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
diff --git a/arch/s390/include/asm/mutex.h b/arch/s390/include/asm/mutex.h
index 688271f..458c1f7 100644
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,5 +7,3 @@
  */
 
 #include <asm-generic/mutex-dec.h>
-
-#define arch_mutex_cpu_relax()	barrier()
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 0eb3750..ca7821f 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -198,6 +198,8 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
+#define arch_mutex_cpu_relax()  barrier()
+
 static inline void psw_set_key(unsigned int key)
 {
 	asm volatile("spka 0(%0)" : : "d" (key));
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index ccd4260..bab49da 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -15,8 +15,8 @@
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
-
 #include <linux/atomic.h>
+#include <asm/processor.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
@@ -175,8 +175,8 @@ extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
-#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
-#define arch_mutex_cpu_relax()	cpu_relax()
+#ifndef arch_mutex_cpu_relax
+# define arch_mutex_cpu_relax() cpu_relax()
 #endif
 
 #endif
-- 
1.8.3.4

