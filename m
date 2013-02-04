Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3BDNtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:49:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:49:22 -0500
Date: Mon, 4 Feb 2013 05:48:52 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-d8685a659c9ed8c23af0bb69289d51ad9a05bf84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Wrap kernel/
 lockdep.c to allow usage from userspace
Git-Commit-ID: d8685a659c9ed8c23af0bb69289d51ad9a05bf84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:49:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8685a659c9ed8c23af0bb69289d51ad9a05bf84
Gitweb:     http://git.kernel.org/tip/d8685a659c9ed8c23af0bb69289d51ad9a05bf84
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:38 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:04 +0100

liblockdep: Wrap kernel/lockdep.c to allow usage from userspace

kernel/lockdep.c deals with validating locking scenarios for
various architectures supported by the kernel. There isn't
anything kernel specific going on in lockdep, and when we
compare userspace to other architectures that don't have to deal
with irqs such as s390, they become all too similar.

We wrap kernel/lockdep.c and include/linux/lockdep.h with
several headers which allow us to build and use lockdep from
userspace. We don't touch the kernel code itself which means
that any work done on lockdep in the kernel will automatically
benefit userspace lockdep as well!

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/Makefile                         | 247 +++++++++++++++++++++
 tools/lib/lockdep/common.c                         |  22 ++
 tools/lib/lockdep/lockdep.c                        |   2 +
 tools/lib/lockdep/lockdep_internals.h              |   1 +
 tools/lib/lockdep/lockdep_states.h                 |   1 +
 .../lockdep/uinclude/asm/hweight.h}                |   0
 .../lockdep/uinclude/asm/sections.h}               |   0
 .../lockdep/uinclude/linux/bitops.h}               |   0
 tools/lib/lockdep/uinclude/linux/compiler.h        |   7 +
 tools/lib/lockdep/uinclude/linux/debug_locks.h     |  12 +
 .../lockdep/uinclude/linux/delay.h}                |   0
 tools/lib/lockdep/uinclude/linux/export.h          |   7 +
 .../lockdep/uinclude/linux/ftrace.h}               |   0
 .../hrtimer.h => lib/lockdep/uinclude/linux/gfp.h} |   0
 tools/lib/lockdep/uinclude/linux/hardirq.h         |  11 +
 tools/lib/lockdep/uinclude/linux/hash.h            |   1 +
 .../lockdep/uinclude/linux/interrupt.h}            |   0
 tools/lib/lockdep/uinclude/linux/irqflags.h        |  38 ++++
 tools/lib/lockdep/uinclude/linux/kallsyms.h        |  32 +++
 tools/lib/lockdep/uinclude/linux/kernel.h          |  34 +++
 tools/lib/lockdep/uinclude/linux/kmemcheck.h       |   8 +
 .../lockdep/uinclude/linux/linkage.h}              |   0
 tools/lib/lockdep/uinclude/linux/list.h            |   1 +
 tools/lib/lockdep/uinclude/linux/lockdep.h         |  58 +++++
 .../lockdep/uinclude/linux/mm_types.h}             |   0
 tools/lib/lockdep/uinclude/linux/module.h          |   6 +
 .../lockdep/uinclude/linux/mutex.h}                |   0
 tools/lib/lockdep/uinclude/linux/poison.h          |   1 +
 tools/lib/lockdep/uinclude/linux/prefetch.h        |   6 +
 .../lockdep/uinclude/linux/proc_fs.h}              |   0
 tools/lib/lockdep/uinclude/linux/rcu.h             |  16 ++
 .../lockdep/uinclude/linux/seq_file.h}             |   0
 tools/lib/lockdep/uinclude/linux/spinlock.h        |  25 +++
 tools/lib/lockdep/uinclude/linux/stacktrace.h      |  32 +++
 tools/lib/lockdep/uinclude/linux/stringify.h       |   7 +
 .../lockdep/uinclude/linux/system.h}               |   0
 tools/lib/lockdep/uinclude/linux/types.h           |  58 +++++
 .../lockdep/uinclude/linux/util.h}                 |   0
 .../lockdep/uinclude/trace/events/lock.h}          |   0
 39 files changed, 633 insertions(+)

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
new file mode 100644
index 0000000..e82ffe9
--- /dev/null
+++ b/tools/lib/lockdep/Makefile
@@ -0,0 +1,247 @@
+# liblockdep version
+LL_VERSION = 0
+LL_PATCHLEVEL = 0
+LL_EXTRAVERSION = 1
+
+# file format version
+FILE_VERSION = 1
+
+MAKEFLAGS += --no-print-directory
+
+
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
+INSTALL = install
+
+# Use DESTDIR for installing into a different root directory.
+# This is useful for building a package. The program will be
+# installed in this directory as if it was the root directory.
+# Then the build tool can move it later.
+DESTDIR ?=
+DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
+
+prefix ?= /usr/local
+bindir_relative = lib
+bindir = $(prefix)/$(bindir_relative)
+
+export DESTDIR DESTDIR_SQ INSTALL
+
+# copy a bit from Linux kbuild
+
+ifeq ("$(origin V)", "command line")
+  VERBOSE = $(V)
+endif
+ifndef VERBOSE
+  VERBOSE = 0
+endif
+
+ifeq ("$(origin O)", "command line")
+  BUILD_OUTPUT := $(O)
+endif
+
+ifeq ($(BUILD_SRC),)
+ifneq ($(BUILD_OUTPUT),)
+
+define build_output
+	$(if $(VERBOSE:1=),@)$(MAKE) -C $(BUILD_OUTPUT) 	\
+	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
+endef
+
+saved-output := $(BUILD_OUTPUT)
+BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
+$(if $(BUILD_OUTPUT),, \
+     $(error output directory "$(saved-output)" does not exist))
+
+all: sub-make
+
+gui: force
+	$(call build_output, all_cmd)
+
+$(filter-out gui,$(MAKECMDGOALS)): sub-make
+
+sub-make: force
+	$(call build_output, $(MAKECMDGOALS))
+
+
+# Leave processing to above invocation of make
+skip-makefile := 1
+
+endif # BUILD_OUTPUT
+endif # BUILD_SRC
+
+# We process the rest of the Makefile if this is the final invocation of make
+ifeq ($(skip-makefile),)
+
+srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
+objtree		:= $(CURDIR)
+src		:= $(srctree)
+obj		:= $(objtree)
+
+export prefix bindir src obj
+
+# Shell quotes
+bindir_SQ = $(subst ','\'',$(bindir))
+bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
+
+LIB_FILE = liblockdep.a liblockdep.so
+
+CONFIG_INCLUDES =
+CONFIG_LIBS	=
+CONFIG_FLAGS	=
+
+OBJ		= $@
+N		=
+
+export Q VERBOSE
+
+LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
+
+INCLUDES = -I. -I/usr/local/include -I./uinclude $(CONFIG_INCLUDES)
+
+# Set compile option CFLAGS if not set elsewhere
+CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=64 -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic
+
+override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
+
+ifeq ($(VERBOSE),1)
+  Q =
+  print_compile =
+  print_app_build =
+  print_fpic_compile =
+  print_shared_lib_compile =
+  print_install =
+else
+  Q = @
+  print_compile =		echo '  CC                 '$(OBJ);
+  print_app_build =		echo '  BUILD              '$(OBJ);
+  print_fpic_compile =		echo '  CC FPIC            '$(OBJ);
+  print_shared_lib_compile =	echo '  BUILD SHARED LIB   '$(OBJ);
+  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(OBJ);
+  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+endif
+
+do_fpic_compile =					\
+	($(print_fpic_compile)				\
+	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
+
+do_app_build =						\
+	($(print_app_build)				\
+	$(CC) $^ -rdynamic -o $@ $(CONFIG_LIBS) $(LIBS))
+
+do_compile_shared_library =			\
+	($(print_shared_lib_compile)		\
+	$(CC) --shared $^ -o $@)
+
+do_build_static_lib =				\
+	($(print_static_lib_build)		\
+	$(RM) $@;  $(AR) rcs $@ $^)
+
+
+define do_compile
+	$(print_compile)						\
+	$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
+endef
+
+$(obj)/%.o: $(src)/%.c
+	$(Q)$(call do_compile)
+
+%.o: $(src)/%.c
+	$(Q)$(call do_compile)
+
+PEVENT_LIB_OBJS = common.o lockdep.o
+
+ALL_OBJS = $(PEVENT_LIB_OBJS)
+
+CMD_TARGETS = $(LIB_FILE)
+
+TARGETS = $(CMD_TARGETS)
+
+
+all: all_cmd
+
+all_cmd: $(CMD_TARGETS)
+
+liblockdep.so: $(PEVENT_LIB_OBJS)
+	$(Q)$(do_compile_shared_library)
+
+liblockdep.a: $(PEVENT_LIB_OBJS)
+	$(Q)$(do_build_static_lib)
+
+$(PEVENT_LIB_OBJS): %.o: $(src)/%.c
+	$(Q)$(do_fpic_compile)
+
+## make deps
+
+all_objs := $(sort $(ALL_OBJS))
+all_deps := $(all_objs:%.o=.%.d)
+
+# let .d file also depends on the source and header files
+define check_deps
+		@set -e; $(RM) $@; \
+		$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
+		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
+		$(RM) $@.$$$$
+endef
+
+$(all_deps): .%.d: $(src)/%.c
+	$(Q)$(call check_deps)
+
+$(all_objs) : %.o : .%.d
+
+dep_includes := $(wildcard $(all_deps))
+
+ifneq ($(dep_includes),)
+ include $(dep_includes)
+endif
+
+### Detect environment changes
+TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
+
+tags:	force
+	$(RM) tags
+	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
+	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
+
+TAGS:	force
+	$(RM) TAGS
+	find . -name '*.[ch]' | xargs etags \
+	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
+
+define do_install
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+endef
+
+install_lib: all_cmd
+	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
+
+install: install_lib
+
+clean:
+	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
+	$(RM) tags TAGS
+
+endif # skip-makefile
+
+PHONY += force
+force:
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# information in a variable so we can use it in if_changed and friends.
+.PHONY: $(PHONY)
diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
new file mode 100644
index 0000000..99d3b4b
--- /dev/null
+++ b/tools/lib/lockdep/common.c
@@ -0,0 +1,22 @@
+#include <stddef.h>
+#include <stdbool.h>
+#include <linux/compiler.h>
+#include <linux/lockdep.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+
+__thread struct task_struct current_obj;
+
+bool debug_locks = true;
+bool debug_locks_silent;
+
+void liblockdep_init(void)
+{
+	lockdep_init();
+}
+
+void liblockdep_set_thread(void)
+{
+	prctl(PR_GET_NAME, current->comm);
+	current->pid = syscall(__NR_gettid);
+}
diff --git a/tools/lib/lockdep/lockdep.c b/tools/lib/lockdep/lockdep.c
new file mode 100644
index 0000000..8ddd0ff
--- /dev/null
+++ b/tools/lib/lockdep/lockdep.c
@@ -0,0 +1,2 @@
+#include <linux/lockdep.h>
+#include "../../../kernel/lockdep.c"
diff --git a/tools/lib/lockdep/lockdep_internals.h b/tools/lib/lockdep/lockdep_internals.h
new file mode 100644
index 0000000..109e96f
--- /dev/null
+++ b/tools/lib/lockdep/lockdep_internals.h
@@ -0,0 +1 @@
+#include "../../../kernel/lockdep_internals.h"
diff --git a/tools/lib/lockdep/lockdep_states.h b/tools/lib/lockdep/lockdep_states.h
new file mode 100644
index 0000000..6b75423
--- /dev/null
+++ b/tools/lib/lockdep/lockdep_states.h
@@ -0,0 +1 @@
+#include "../../../kernel/lockdep_states.h"
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/asm/hweight.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/asm/hweight.h
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/asm/sections.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/asm/sections.h
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/bitops.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/bitops.h
diff --git a/tools/lib/lockdep/uinclude/linux/compiler.h b/tools/lib/lockdep/uinclude/linux/compiler.h
new file mode 100644
index 0000000..7ac838a
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/compiler.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_COMPILER_H_
+#define _LIBLOCKDEP_LINUX_COMPILER_H_
+
+#define __used		__attribute__((__unused__))
+#define unlikely
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/debug_locks.h b/tools/lib/lockdep/uinclude/linux/debug_locks.h
new file mode 100644
index 0000000..f38eb64
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/debug_locks.h
@@ -0,0 +1,12 @@
+#ifndef _LIBLOCKDEP_DEBUG_LOCKS_H_
+#define _LIBLOCKDEP_DEBUG_LOCKS_H_
+
+#include <stddef.h>
+#include <linux/compiler.h>
+
+#define DEBUG_LOCKS_WARN_ON(x) (x)
+
+extern bool debug_locks;
+extern bool debug_locks_silent;
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/delay.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/delay.h
diff --git a/tools/lib/lockdep/uinclude/linux/export.h b/tools/lib/lockdep/uinclude/linux/export.h
new file mode 100644
index 0000000..6bdf349
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/export.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_EXPORT_H_
+#define _LIBLOCKDEP_LINUX_EXPORT_H_
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/ftrace.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/ftrace.h
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/gfp.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/gfp.h
diff --git a/tools/lib/lockdep/uinclude/linux/hardirq.h b/tools/lib/lockdep/uinclude/linux/hardirq.h
new file mode 100644
index 0000000..c8f3f8f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/hardirq.h
@@ -0,0 +1,11 @@
+#ifndef _LIBLOCKDEP_LINUX_HARDIRQ_H_
+#define _LIBLOCKDEP_LINUX_HARDIRQ_H_
+
+#define SOFTIRQ_BITS	0UL
+#define HARDIRQ_BITS	0UL
+#define SOFTIRQ_SHIFT	0UL
+#define HARDIRQ_SHIFT	0UL
+#define hardirq_count()	0UL
+#define softirq_count()	0UL
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/hash.h b/tools/lib/lockdep/uinclude/linux/hash.h
new file mode 100644
index 0000000..0f84798
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/hash.h
@@ -0,0 +1 @@
+#include "../../../include/linux/hash.h"
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/interrupt.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/interrupt.h
diff --git a/tools/lib/lockdep/uinclude/linux/irqflags.h b/tools/lib/lockdep/uinclude/linux/irqflags.h
new file mode 100644
index 0000000..6cc296f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/irqflags.h
@@ -0,0 +1,38 @@
+#ifndef _LIBLOCKDEP_LINUX_TRACE_IRQFLAGS_H_
+#define _LIBLOCKDEP_LINUX_TRACE_IRQFLAGS_H_
+
+# define trace_hardirq_context(p)	0
+# define trace_softirq_context(p)	0
+# define trace_hardirqs_enabled(p)	0
+# define trace_softirqs_enabled(p)	0
+# define trace_hardirq_enter()		do { } while (0)
+# define trace_hardirq_exit()		do { } while (0)
+# define lockdep_softirq_enter()	do { } while (0)
+# define lockdep_softirq_exit()		do { } while (0)
+# define INIT_TRACE_IRQFLAGS
+
+# define stop_critical_timings() do { } while (0)
+# define start_critical_timings() do { } while (0)
+
+#define raw_local_irq_disable() do { } while (0)
+#define raw_local_irq_enable() do { } while (0)
+#define raw_local_irq_save(flags) ((flags) = 0)
+#define raw_local_irq_restore(flags) do { } while (0)
+#define raw_local_save_flags(flags) ((flags) = 0)
+#define raw_irqs_disabled_flags(flags) do { } while (0)
+#define raw_irqs_disabled() 0
+#define raw_safe_halt()
+
+#define local_irq_enable() do { } while (0)
+#define local_irq_disable() do { } while (0)
+#define local_irq_save(flags) ((flags) = 0)
+#define local_irq_restore(flags) do { } while (0)
+#define local_save_flags(flags)	((flags) = 0)
+#define irqs_disabled() (1)
+#define irqs_disabled_flags(flags) (0)
+#define safe_halt() do { } while (0)
+
+#define trace_lock_release(x, y)
+#define trace_lock_acquire(a, b, c, d, e, f, g)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kallsyms.h b/tools/lib/lockdep/uinclude/linux/kallsyms.h
new file mode 100644
index 0000000..b0f2dbd
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kallsyms.h
@@ -0,0 +1,32 @@
+#ifndef _LIBLOCKDEP_LINUX_KALLSYMS_H_
+#define _LIBLOCKDEP_LINUX_KALLSYMS_H_
+
+#include <linux/kernel.h>
+#include <stdio.h>
+
+#define KSYM_NAME_LEN 128
+
+struct module;
+
+static inline const char *kallsyms_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname, char *namebuf)
+{
+	return NULL;
+}
+
+#include <execinfo.h>
+#include <stdlib.h>
+static inline void print_ip_sym(unsigned long ip)
+{
+	char **name;
+
+	name = backtrace_symbols((void **)&ip, 1);
+
+	printf("%s\n", *name);
+
+	free(name);
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kernel.h b/tools/lib/lockdep/uinclude/linux/kernel.h
new file mode 100644
index 0000000..da97ce8
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kernel.h
@@ -0,0 +1,34 @@
+#ifndef _LIBLOCKDEP_LINUX_KERNEL_H_
+#define _LIBLOCKDEP_LINUX_KERNEL_H_
+
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/rcu.h>
+#include <linux/hardirq.h>
+
+#ifndef container_of
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define WARN_ON(x) (x)
+#define WARN_ON_ONCE(x) (x)
+#define likely(x) (x)
+#define WARN(x, y, z) (x)
+#define uninitialized_var(x) x
+#define __init
+#define noinline
+#define list_add_tail_rcu list_add_tail
+
+#define _THIS_IP_ CALLER_ADDR0
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/kmemcheck.h b/tools/lib/lockdep/uinclude/linux/kmemcheck.h
new file mode 100644
index 0000000..94d598b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/kmemcheck.h
@@ -0,0 +1,8 @@
+#ifndef _LIBLOCKDEP_LINUX_KMEMCHECK_H_
+#define _LIBLOCKDEP_LINUX_KMEMCHECK_H_
+
+static inline void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+}
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/linkage.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/linkage.h
diff --git a/tools/lib/lockdep/uinclude/linux/list.h b/tools/lib/lockdep/uinclude/linux/list.h
new file mode 100644
index 0000000..6e9ef31
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/list.h
@@ -0,0 +1 @@
+#include "../../../include/linux/list.h"
diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
new file mode 100644
index 0000000..1ed83a5
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
@@ -0,0 +1,58 @@
+#ifndef _LIBLOCKDEP_LOCKDEP_H_
+#define _LIBLOCKDEP_LOCKDEP_H_
+
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <string.h>
+#include <limits.h>
+#include <linux/utsname.h>
+
+
+#define MAX_LOCK_DEPTH 200UL
+
+#include "../../../include/linux/lockdep.h"
+
+struct task_struct {
+	u64 curr_chain_key;
+	int lockdep_depth;
+	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
+	gfp_t lockdep_reclaim_gfp;
+	int pid;
+	char comm[17];
+};
+
+extern __thread struct task_struct current_obj;
+#define current (&current_obj)
+
+void liblockdep_init(void);
+void liblockdep_set_thread(void);
+
+#define debug_locks_off() 1
+#define task_pid_nr(tsk) ((tsk)->pid)
+
+#define KSYM_NAME_LEN 128
+#define printk printf
+
+#define KERN_ERR
+#define KERN_CONT
+
+#define list_del_rcu list_del
+
+#define atomic_t unsigned long
+#define atomic_inc(x) ((*(x))++)
+
+static struct new_utsname *init_utsname(void)
+{
+	static struct new_utsname n = (struct new_utsname) {
+		.release = "liblockdep",
+		.version = LIBLOCKDEP_VERSION,
+	};
+
+	return &n;
+}
+
+#define print_tainted() ""
+#define static_obj(x) 1
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/mm_types.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/mm_types.h
diff --git a/tools/lib/lockdep/uinclude/linux/module.h b/tools/lib/lockdep/uinclude/linux/module.h
new file mode 100644
index 0000000..09c7a7b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/module.h
@@ -0,0 +1,6 @@
+#ifndef _LIBLOCKDEP_LINUX_MODULE_H_
+#define _LIBLOCKDEP_LINUX_MODULE_H_
+
+#define module_param(name, type, perm)
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/mutex.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/mutex.h
diff --git a/tools/lib/lockdep/uinclude/linux/poison.h b/tools/lib/lockdep/uinclude/linux/poison.h
new file mode 100644
index 0000000..0c27bdf
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/poison.h
@@ -0,0 +1 @@
+#include "../../../include/linux/poison.h"
diff --git a/tools/lib/lockdep/uinclude/linux/prefetch.h b/tools/lib/lockdep/uinclude/linux/prefetch.h
new file mode 100644
index 0000000..d73fe6f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/prefetch.h
@@ -0,0 +1,6 @@
+#ifndef _LIBLOCKDEP_LINUX_PREFETCH_H_
+#define _LIBLOCKDEP_LINUX_PREFETCH_H
+
+static inline void prefetch(void *a __attribute__((unused))) { }
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/proc_fs.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/proc_fs.h
diff --git a/tools/lib/lockdep/uinclude/linux/rcu.h b/tools/lib/lockdep/uinclude/linux/rcu.h
new file mode 100644
index 0000000..4c99fcb
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/rcu.h
@@ -0,0 +1,16 @@
+#ifndef _LIBLOCKDEP_RCU_H_
+#define _LIBLOCKDEP_RCU_H_
+
+int rcu_scheduler_active;
+
+static inline int rcu_lockdep_current_cpu_online(void)
+{
+	return 1;
+}
+
+static inline int rcu_is_cpu_idle(void)
+{
+	return 1;
+}
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/seq_file.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/seq_file.h
diff --git a/tools/lib/lockdep/uinclude/linux/spinlock.h b/tools/lib/lockdep/uinclude/linux/spinlock.h
new file mode 100644
index 0000000..68c1aa2
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/spinlock.h
@@ -0,0 +1,25 @@
+#ifndef _LIBLOCKDEP_SPINLOCK_H_
+#define _LIBLOCKDEP_SPINLOCK_H_
+
+#include <pthread.h>
+#include <stdbool.h>
+
+#define arch_spinlock_t pthread_mutex_t
+#define __ARCH_SPIN_LOCK_UNLOCKED PTHREAD_MUTEX_INITIALIZER
+
+static inline void arch_spin_lock(arch_spinlock_t *mutex)
+{
+	pthread_mutex_lock(mutex);
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *mutex)
+{
+	pthread_mutex_unlock(mutex);
+}
+
+static inline bool arch_spin_is_locked(arch_spinlock_t *mutex)
+{
+	return true;
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/stacktrace.h b/tools/lib/lockdep/uinclude/linux/stacktrace.h
new file mode 100644
index 0000000..39aecc6
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/stacktrace.h
@@ -0,0 +1,32 @@
+#ifndef _LIBLOCKDEP_LINUX_STACKTRACE_H_
+#define _LIBLOCKDEP_LINUX_STACKTRACE_H_
+
+#include <execinfo.h>
+
+struct stack_trace {
+	unsigned int nr_entries, max_entries;
+	unsigned long *entries;
+	int skip;
+};
+
+static inline void print_stack_trace(struct stack_trace *trace, int spaces)
+{
+	backtrace_symbols_fd((void **)trace->entries, trace->nr_entries, 1);
+}
+
+#define save_stack_trace(trace)	\
+	((trace)->nr_entries =	\
+		backtrace((void **)(trace)->entries, (trace)->max_entries))
+
+static inline int dump_stack(void)
+{
+	void *array[64];
+	size_t size;
+
+	size = backtrace(array, 64);
+	backtrace_symbols_fd(array, size, 1);
+
+	return 0;
+}
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/stringify.h b/tools/lib/lockdep/uinclude/linux/stringify.h
new file mode 100644
index 0000000..05dfcd1
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/stringify.h
@@ -0,0 +1,7 @@
+#ifndef _LIBLOCKDEP_LINUX_STRINGIFY_H_
+#define _LIBLOCKDEP_LINUX_STRINGIFY_H_
+
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/system.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/system.h
diff --git a/tools/lib/lockdep/uinclude/linux/types.h b/tools/lib/lockdep/uinclude/linux/types.h
new file mode 100644
index 0000000..929938f
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/linux/types.h
@@ -0,0 +1,58 @@
+#ifndef _LIBLOCKDEP_LINUX_TYPES_H_
+#define _LIBLOCKDEP_LINUX_TYPES_H_
+
+#include <stdbool.h>
+#include <stddef.h>
+
+#define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
+#include <asm/types.h>
+
+struct page;
+struct kmem_cache;
+
+typedef unsigned gfp_t;
+
+typedef __u64 u64;
+typedef __s64 s64;
+
+typedef __u32 u32;
+typedef __s32 s32;
+
+typedef __u16 u16;
+typedef __s16 s16;
+
+typedef __u8  u8;
+typedef __s8  s8;
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
+
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+struct hlist_node {
+	struct hlist_node *next, **pprev;
+};
+
+#endif
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/linux/util.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/linux/util.h
diff --git a/tools/virtio/linux/hrtimer.h b/tools/lib/lockdep/uinclude/trace/events/lock.h
similarity index 100%
copy from tools/virtio/linux/hrtimer.h
copy to tools/lib/lockdep/uinclude/trace/events/lock.h
