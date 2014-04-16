Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaDPLjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:39:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39857 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaDPLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:39:46 -0400
Date: Wed, 16 Apr 2014 13:39:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fixes
Message-ID: <20140416113939.GA11159@gmail.com>
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

   # HEAD: 65063ced73077b9add610b413d87bc6a51e40bab Merge branch 'liblockdep-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux into core/urgent

liblockdep fixes and mutex debugging fixes.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      locking/mutex: Fix debug_mutexes

Sasha Levin (2):
      tools/liblockdep: Ignore asmlinkage and visible
      tools/liblockdep: Add proper versioning to the shared obj


 kernel/locking/mutex-debug.c               | 19 +++++++++----------
 tools/lib/lockdep/Makefile                 | 15 ++++-----------
 tools/lib/lockdep/uinclude/linux/lockdep.h |  3 +++
 3 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index e1191c9..5cf6731 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -71,18 +71,17 @@ void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 
 void debug_mutex_unlock(struct mutex *lock)
 {
-	if (unlikely(!debug_locks))
-		return;
+	if (likely(debug_locks)) {
+		DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 
-	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+		if (!lock->owner)
+			DEBUG_LOCKS_WARN_ON(!lock->owner);
+		else
+			DEBUG_LOCKS_WARN_ON(lock->owner != current);
 
-	if (!lock->owner)
-		DEBUG_LOCKS_WARN_ON(!lock->owner);
-	else
-		DEBUG_LOCKS_WARN_ON(lock->owner != current);
-
-	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	mutex_clear_owner(lock);
+		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
+		mutex_clear_owner(lock);
+	}
 
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index 07b0b75..cb09d3f 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -1,13 +1,8 @@
-# liblockdep version
-LL_VERSION = 0
-LL_PATCHLEVEL = 0
-LL_EXTRAVERSION = 1
-
 # file format version
 FILE_VERSION = 1
 
 MAKEFLAGS += --no-print-directory
-
+LIBLOCKDEP_VERSION=$(shell make -sC ../../.. kernelversion)
 
 # Makefiles suck: This macro sets a default value of $(2) for the
 # variable named by $(1), unless the variable has been set by
@@ -98,7 +93,7 @@ export prefix libdir bindir src obj
 libdir_SQ = $(subst ','\'',$(libdir))
 bindir_SQ = $(subst ','\'',$(bindir))
 
-LIB_FILE = liblockdep.a liblockdep.so
+LIB_FILE = liblockdep.a liblockdep.so.$(LIBLOCKDEP_VERSION)
 BIN_FILE = lockdep
 
 CONFIG_INCLUDES =
@@ -110,8 +105,6 @@ N		=
 
 export Q VERBOSE
 
-LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
-
 INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
@@ -146,7 +139,7 @@ do_app_build =						\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -o $@ -lpthread -ldl)
+	$(CC) --shared $^ -o $@ -lpthread -ldl -Wl,-soname='"$@"';$(shell ln -s $@ liblockdep.so))
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
@@ -177,7 +170,7 @@ all: all_cmd
 
 all_cmd: $(CMD_TARGETS)
 
-liblockdep.so: $(PEVENT_LIB_OBJS)
+liblockdep.so.$(LIBLOCKDEP_VERSION): $(PEVENT_LIB_OBJS)
 	$(Q)$(do_compile_shared_library)
 
 liblockdep.a: $(PEVENT_LIB_OBJS)
diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
index d0f5d6e..c1552c2 100644
--- a/tools/lib/lockdep/uinclude/linux/lockdep.h
+++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
@@ -10,6 +10,9 @@
 
 #define MAX_LOCK_DEPTH 2000UL
 
+#define asmlinkage
+#define __visible
+
 #include "../../../include/linux/lockdep.h"
 
 struct task_struct {
