Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3I1MrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:47:22 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43933 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3I1MrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:47:20 -0400
From: Pauli Nieminen <suokkos@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pauli Nieminen <suokkos@gmail.com>
Subject: [RFC] trace-cmd: Add decoder plugin for raw syscalls
Date: Sat, 28 Sep 2013 15:47:10 +0300
Message-Id: <1380372430-15039-1-git-send-email-suokkos@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kernel packagers like to disable syscalls ftrace events claiming it
would be runtime overhead. But those kernels still can have raw_syscalls
events enabled. To be able to use stock kernels for tracing system
behavior I decided to write simple translation plugin for trace-cmd.

Translation tables are automatically generated from asm/unistd*.h files
during compilation. Those translation tables are then used to find
possible matches from all supported syscall ids for the running system.

Possible improvements to build on top of this:
* Is it possible to figure out the architecture for sure from trace data?
* UI communication to allow user to select process architecture
* Heuristics to guess the process architecture from syscall patterns

Is this idea worth of cleaning to be good enough to apply?
Is auto generated or manual syscall tables better idea?

Signed-off-by: Pauli Nieminen <suokkos@gmail.com>
---
 .gitignore            |   1 +
 Makefile              |  40 +++++++++++++++--
 plugin_raw_syscalls.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++
 plugin_raw_syscalls.h |  12 +++++
 unistd.c.in           |   7 +++
 5 files changed, 178 insertions(+), 3 deletions(-)
 create mode 100644 plugin_raw_syscalls.c
 create mode 100644 plugin_raw_syscalls.h
 create mode 100644 unistd.c.in

diff --git a/.gitignore b/.gitignore
index b7b405f..870c4f3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,3 +20,4 @@ TAGS
 cscope*
 trace_plugin_dir
 trace_python_dir
+plugin_raw_syscall_unistd*.c
diff --git a/Makefile b/Makefile
index 1964949..b2584e4 100644
--- a/Makefile
+++ b/Makefile
@@ -248,6 +248,7 @@ ifeq ($(VERBOSE),1)
   print_plugin_obj_compile =
   print_plugin_build =
   print_install =
+  print_unistd_source_gen =
 else
   Q = @
   print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
@@ -258,6 +259,7 @@ else
   print_plugin_build =		echo '  $(GUI)BUILD PLUGIN       '$(GOBJ);
   print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
   print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
+  print_unistd_source_gen =	echo '  $(GUI)GEN                '$(GOBJ);
 endif
 
 do_fpic_compile =					\
@@ -276,9 +278,30 @@ do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
 	$(CC) -c $(CFLAGS) -fPIC -o $@ $<)
 
+do_gen_unistd_source =								\
+	($(print_unistd_source_gen)						\
+	ARCH_UNISTD=$<;								\
+	ARCH=`echo $$ARCH_UNISTD | sed 's/^.*d_\(.*\).h$$/\1/'` || exit $$?;	\
+	ARCH_UNISTD_INCL=`echo $$ARCH_UNISTD | sed 's/^.*asm/asm/'`;		\
+	PREFIX=raw_syscalls_$$ARCH; 						\
+	echo "const char $${PREFIX}_arch[] = \"$$ARCH\";" > $@;			\
+	echo "/* $(UNISTD_H_PATH) defines */" >> $@;				\
+	grep "\#\s*define\s\+[A-Za-z_0-9]\+\s\+[A-Za-z_0-9(]\+" $(UNISTD_H_PATH) >> $@; \
+										\
+	echo "/* $(ARCH_UNISTD) defines */" >> $@;				\
+	echo "\#include <$$ARCH_UNISTD_INCL>" >> $@;				\
+										\
+	echo "/* syscall table */" >> $@;					\
+	echo "\#include \"plugin_raw_syscalls.h\"" >> $@;				\
+	echo "static const struct raw_syscalls_entry $${PREFIX}_syscalls[] = {" >> $@; \
+	sed -n "s/^.*\#\s*define\s\+__NR_\([A-Za-z_0-9]\+\)\s\+\(.*\)\s*$$/{\"\1\", \2},/p" < $$ARCH_UNISTD >> $@; \
+	echo "};" >> $@;							\
+										\
+	sed "s/PREFIX/$$PREFIX/g" < $(UNISTD_TEMPLATE) >> $@)
+
 do_plugin_build =				\
 	($(print_plugin_build)			\
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
+	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $^)
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
@@ -318,7 +341,7 @@ TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
 
 PLUGIN_OBJS = plugin_hrtimer.o plugin_kmem.o plugin_sched_switch.o \
 	plugin_mac80211.o plugin_jbd2.o plugin_function.o plugin_kvm.o \
-	plugin_blk.o
+	plugin_blk.o plugin_raw_syscalls.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
@@ -332,6 +355,11 @@ GUI_TARGETS = ks_version.h trace-graph trace-view kernelshark
 
 TARGETS = $(CMD_TARGETS) $(GUI_TARGETS)
 
+ARCH_INCL_PATH ?= /usr/include/$(shell $(CC) $(CFLAGS) -print-multiarch)/asm
+UNISTD_H_PATH ?= $(ARCH_INCL_PATH)/unistd.h
+UNISTD_ARCH_HEADERS = $(notdir $(shell sed -n 's/^\s*\#\s*include\s\+<\(.*\)>\s*$$/\1/p' $(UNISTD_H_PATH)))
+UNISTD_OBJS = $(patsubst %.h,plugin_raw_syscalls_%.o, $(UNISTD_ARCH_HEADERS))
+UNISTD_TEMPLATE = unistd.c.in
 
 #	cpp $(INCLUDES)
 
@@ -388,12 +416,17 @@ libtracecmd.a: $(TCMD_LIB_OBJS)
 
 trace-util.o: trace_plugin_dir
 
-$(PLUGIN_OBJS): %.o : $(src)/%.c
+$(PLUGIN_OBJS) $(UNISTD_OBJS): %.o : $(src)/%.c
 	$(Q)$(do_compile_plugin_obj)
 
+$(CURDIR)/plugin_raw_syscalls_%.c: $(ARCH_INCL_PATH)/%.h Makefile
+	$(Q)$(do_gen_unistd_source)
+
 $(PLUGINS): %.so: %.o
 	$(Q)$(do_plugin_build)
 
+plugin_raw_syscalls.so: $(UNISTD_OBJS)
+
 define make_version.h
 	(echo '/* This file is automatically generated. Do not modify. */';		\
 	echo \#define VERSION_CODE $(shell						\
@@ -546,6 +579,7 @@ install_doc:
 clean:
 	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c .*.d
 	$(RM) tags TAGS cscope*
+	$(RM) plugin_raw_syscalls_unistd*.c
 
 
 ##### PYTHON STUFF #####
diff --git a/plugin_raw_syscalls.c b/plugin_raw_syscalls.c
new file mode 100644
index 0000000..e6270c0
--- /dev/null
+++ b/plugin_raw_syscalls.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (C) 2013 Pauli Nieminen <suokkos@gmail.com
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <limits.h>
+#include <search.h>
+
+#include "trace-cmd.h"
+#include "plugin_raw_syscalls.h"
+
+static struct raw_syscalls_tables {
+	const char *name;
+	size_t nr_calls;
+	const struct raw_syscalls_entry *table;
+	int in_order;
+	struct raw_syscalls_tables *next;
+} *raw_syscalls_tables = NULL;
+
+static int syscalls_cmp(const void *va, const void *vb)
+{
+	const struct raw_syscalls_entry *a = va, *b = vb;
+	return (int)(a->id - b->id);
+}
+
+static int raw_syscalls_handler(struct trace_seq *s, struct pevent_record *record,
+				struct event_format *event, void *context)
+{
+	unsigned long long val;
+	long id;
+	struct raw_syscalls_tables *table = raw_syscalls_tables;
+
+	if (pevent_get_field_val(s, event, "id", record, &val, 1))
+		return trace_seq_putc(s, '!');
+
+	id = val;
+
+	while (table) {
+		struct raw_syscalls_entry key = { .id = id };
+		const struct raw_syscalls_entry *syscalls;
+		if (table->in_order) {
+			syscalls = bsearch(&key, table->table,
+					   table->nr_calls,
+					   sizeof(table->table[0]),
+					   syscalls_cmp);
+		} else {
+			syscalls = lfind(&key, table->table,
+					 &table->nr_calls,
+					 sizeof(table->table[0]),
+					 syscalls_cmp);
+		}
+
+		if (syscalls) {
+			trace_seq_printf(s, "%s(%s) ",
+					 syscalls->name, table->name);
+		}
+		table = table->next;
+	}
+
+	return 1;
+}
+
+void raw_syscalls_register_table(const char *arch,
+				 size_t nr_calls,
+				 const struct raw_syscalls_entry *table)
+{
+	int i;
+	long current_id = LONG_MIN;
+	struct raw_syscalls_tables *lookup = malloc_or_die(sizeof(*lookup));
+
+	lookup->next = raw_syscalls_tables;
+	raw_syscalls_tables = lookup;
+
+	lookup->name = arch;
+	lookup->nr_calls = nr_calls;
+	lookup->table = table;
+	lookup->in_order = 1;
+
+	for (i = 0; i < nr_calls; i++) {
+		if (table[i].id < current_id) {
+			lookup->in_order = 0;
+			break;
+		}
+		current_id = table[i].id;
+	}
+}
+
+int PEVENT_PLUGIN_UNLOADER(void)
+{
+	struct raw_syscalls_tables *next = raw_syscalls_tables;
+	while (next) {
+		struct raw_syscalls_tables *cur = next;
+		next = cur->next;
+		free(cur);
+	}
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "raw_syscalls", "sys_enter",
+			raw_syscalls_handler, NULL);
+	pevent_register_event_handler(pevent, -1, "raw_syscalls", "sys_exit",
+			raw_syscalls_handler, NULL);
+	return 0;
+}
diff --git a/plugin_raw_syscalls.h b/plugin_raw_syscalls.h
new file mode 100644
index 0000000..daf968f
--- /dev/null
+++ b/plugin_raw_syscalls.h
@@ -0,0 +1,12 @@
+#pragma once
+
+#include <stddef.h>
+
+struct raw_syscalls_entry {
+	const char *name;
+	long id;
+};
+
+void raw_syscalls_register_table(const char *arch,
+				 size_t nr_calls,
+				 const struct raw_syscalls_entry *table);
diff --git a/unistd.c.in b/unistd.c.in
new file mode 100644
index 0000000..377dd27
--- /dev/null
+++ b/unistd.c.in
@@ -0,0 +1,7 @@
+
+static __attribute__((constructor)) void PREFIX_init(void)
+{
+	raw_syscalls_register_table(PREFIX_arch,
+				    sizeof PREFIX_syscalls/sizeof PREFIX_syscalls[0],
+				    PREFIX_syscalls);
+};
-- 
1.8.4.rc3

