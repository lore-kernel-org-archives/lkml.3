Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaCCQ0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:26:33 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48751 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaCCQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:26:31 -0500
Date: Mon, 3 Mar 2014 17:26:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tools/lib/lockdep fixes
Message-ID: <20140303162628.GA17135@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 9b158f53a8da5394cb48310da9fda80b34c72bbc Merge branch 'liblockdep-fixes' of https://github.com/sashalevin/liblockdep into core/urgent

A handful of build fixes for liblockdep.

 Thanks,

	Ingo

------------------>
Ira W. Snyder (3):
      tools/liblockdep: Fix initialization code path
      tools/liblockdep: Fix include of asm/hash.h
      tools/liblockdep: Add include directory to allow tests to compile

Sasha Levin (2):
      tools/liblockdep: Mark runtests.sh as executable
      tools/liblockdep: Add a stub for new rcu_is_watching

Wang Nan (1):
      tools/liblockdep: Use realpath for srctree and objtree


 tools/lib/lockdep/Makefile             | 6 +++---
 tools/lib/lockdep/preload.c            | 2 +-
 tools/lib/lockdep/run_tests.sh         | 0
 tools/lib/lockdep/uinclude/asm/hash.h  | 6 ++++++
 tools/lib/lockdep/uinclude/linux/rcu.h | 5 +++++
 5 files changed, 15 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 tools/lib/lockdep/run_tests.sh
 create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index da8b7aa..07b0b75 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -87,8 +87,8 @@ endif # BUILD_SRC
 # We process the rest of the Makefile if this is the final invocation of make
 ifeq ($(skip-makefile),)
 
-srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
+objtree		:= $(realpath $(CURDIR))
 src		:= $(srctree)
 obj		:= $(objtree)
 
@@ -112,7 +112,7 @@ export Q VERBOSE
 
 LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include -I./uinclude $(CONFIG_INCLUDES)
+INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
index f8465a8..23bd69c 100644
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -418,7 +418,7 @@ int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)
 
 __attribute__((constructor)) static void init_preload(void)
 {
-	if (__init_state != done)
+	if (__init_state == done)
 		return;
 
 #ifndef __GLIBC__
diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
old mode 100644
new mode 100755
diff --git a/tools/lib/lockdep/uinclude/asm/hash.h b/tools/lib/lockdep/uinclude/asm/hash.h
new file mode 100644
index 0000000..d82b170b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/asm/hash.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_HASH_H
+#define __ASM_GENERIC_HASH_H
+
+/* Stub */
+
+#endif /* __ASM_GENERIC_HASH_H */
diff --git a/tools/lib/lockdep/uinclude/linux/rcu.h b/tools/lib/lockdep/uinclude/linux/rcu.h
index 4c99fcb..042ee8e 100644
--- a/tools/lib/lockdep/uinclude/linux/rcu.h
+++ b/tools/lib/lockdep/uinclude/linux/rcu.h
@@ -13,4 +13,9 @@ static inline int rcu_is_cpu_idle(void)
 	return 1;
 }
 
+static inline bool rcu_is_watching(void)
+{
+	return false;
+}
+
 #endif
