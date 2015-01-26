Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbbAZMzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:12 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45972 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbbAZMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:03 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 1/3] ftrace: allow architectures to specify ftrace compile options
Date: Mon, 26 Jan 2015 13:54:52 +0100
Message-Id: <1422276894-31302-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012612-0029-0000-0000-00000319D13D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is compiled with function tracer support the -pg compile option
is passed to gcc to generate extra code into the prologue of each function.

This patch replaces the "open-coded" -pg compile flag with a CC_FLAGS_FTRACE
makefile variable which architectures can override if a different option
should be used for code generation.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 Makefile                | 6 +++++-
 kernel/Makefile         | 4 ++--
 kernel/events/Makefile  | 2 +-
 kernel/locking/Makefile | 8 ++++----
 kernel/sched/Makefile   | 2 +-
 kernel/trace/Makefile   | 4 ++--
 lib/Makefile            | 2 +-
 scripts/Makefile.build  | 5 +++--
 8 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 109c17397e4e..069599c9c96b 100644
--- a/Makefile
+++ b/Makefile
@@ -742,10 +742,14 @@ KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
 endif
 
 ifdef CONFIG_FUNCTION_TRACER
+ifndef CC_FLAGS_FTRACE
+CC_FLAGS_FTRACE := -pg
+endif
+export CC_FLAGS_FTRACE
 ifdef CONFIG_HAVE_FENTRY
 CC_USING_FENTRY	:= $(call cc-option, -mfentry -DCC_USING_FENTRY)
 endif
-KBUILD_CFLAGS	+= -pg $(CC_USING_FENTRY)
+KBUILD_CFLAGS	+= $(CC_FLAGS_FTRACE) $(CC_USING_FENTRY)
 KBUILD_AFLAGS	+= $(CC_USING_FENTRY)
 ifdef CONFIG_DYNAMIC_FTRACE
 	ifdef CONFIG_HAVE_C_RECORDMCOUNT
diff --git a/kernel/Makefile b/kernel/Makefile
index 616994f0a76f..07737e50fe6e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -13,8 +13,8 @@ obj-y     = fork.o exec_domain.o panic.o \
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
-CFLAGS_REMOVE_cgroup-debug.o = -pg
-CFLAGS_REMOVE_irq_work.o = -pg
+CFLAGS_REMOVE_cgroup-debug.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_irq_work.o = $(CC_FLAGS_FTRACE)
 endif
 
 # cond_syscall is currently not LTO compatible
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d147b2f..2925188f50ea 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -1,5 +1,5 @@
 ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_core.o = -pg
+CFLAGS_REMOVE_core.o = $(CC_FLAGS_FTRACE)
 endif
 
 obj-y := core.o ring_buffer.o callchain.o
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 4ca8eb151975..de7a416cca2a 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -2,10 +2,10 @@
 obj-y += mutex.o semaphore.o rwsem.o
 
 ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_lockdep.o = -pg
-CFLAGS_REMOVE_lockdep_proc.o = -pg
-CFLAGS_REMOVE_mutex-debug.o = -pg
-CFLAGS_REMOVE_rtmutex-debug.o = -pg
+CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_lockdep_proc.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_mutex-debug.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_rtmutex-debug.o = $(CC_FLAGS_FTRACE)
 endif
 
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index ab32b7b0db5c..46be87024875 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -1,5 +1,5 @@
 ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_clock.o = -pg
+CFLAGS_REMOVE_clock.o = $(CC_FLAGS_FTRACE)
 endif
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 979ccde26720..98f26588255e 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -3,11 +3,11 @@
 
 ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
-KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
 
 ifdef CONFIG_FTRACE_SELFTEST
 # selftest needs instrumentation
-CFLAGS_trace_selftest_dynamic.o = -pg
+CFLAGS_trace_selftest_dynamic.o = $(CC_FLAGS_FTRACE)
 obj-y += trace_selftest_dynamic.o
 endif
 endif
diff --git a/lib/Makefile b/lib/Makefile
index 3dca86fa7dc9..b1dbda74ef65 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -4,7 +4,7 @@
 
 ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
-KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
 endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 649ce6844033..1a170cbaa4e5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -234,8 +234,9 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(if $(part-of-module),1,0)" "$(@)";
 recordmcount_source := $(srctree)/scripts/recordmcount.pl
 endif
-cmd_record_mcount = 						\
-	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
+cmd_record_mcount =						\
+	if [ "$(findstring $(CC_FLAGS_FTRACE),$(_c_flags))" =	\
+	     "$(CC_FLAGS_FTRACE)" ]; then 		    	\
 		$(sub_cmd_record_mcount)			\
 	fi;
 endif
-- 
2.1.4

