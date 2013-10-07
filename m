Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3JGMEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:04:04 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51929 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3JGL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:18 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 31/50] tools/perf/build: Speed up auto-detection of features by adding a 'test-all' target
Date: Mon,  7 Oct 2013 13:56:24 +0200
Message-Id: <1381147003-2574-32-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concatenate all feature checks into test-all.c.

This can be built and checked faster than all the individual tests.

If test-all fails then we still check all the individual features, so
this is a pure speedup, it should have no effects on functionality.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-5hlcb2qorzwfwrWTjiygjjih@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                  |  48 ++++++++++--
 tools/perf/config/feature-checks/Makefile   |   3 +
 tools/perf/config/feature-checks/test-all.c | 196 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+), 7 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1b2a46b..9a27aa9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -89,17 +89,21 @@ CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
-feature_check = $(eval $(feature_check_code)); $(info CHK: config/feature-checks/test-$(1))
+feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(2) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+endef
+
+feature_set = $(eval $(feature_set_code))
+define feature_set_code
+  feature-$(1) := 1
 endef
 
 #
 # Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
 #
-$(info Testing features:)
-$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
-$(info done)
+$(info )
+$(info Auto-detecting system features:)
 
 FEATURE_TESTS =				\
 	hello				\
@@ -126,9 +130,38 @@ FEATURE_TESTS =				\
 	backtrace			\
 	libnuma
 
-$(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
+#
+# Special fast-path for the 'all features are available' case:
+#
+$(call feature_check,all)
+
+ifeq ($(feature-all), 1)
+  $(foreach feat,$(FEATURE_TESTS),$(call feature_set,$(feat)))
+else
+  $(shell $(MAKE) -i -j -C config/feature-checks >/dev/null 2>&1)
+  $(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
+endif
+
+feature_print = $(eval $(feature_print_code))
+
+#
+# Print the result of the feature test:
+#
+define feature_print_code
+  ifeq ($(feature-$(1)), 1)
+    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+  else
+    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+  endif
+  $(info $(MSG))
+endef
+
+$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+
+# newline at the end of the feature printouts:
+$(info )
 
-ifeq ($(stackprotector-all), 1)
+ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
@@ -167,6 +200,7 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
+  $(feature_check,bionic)
   ifeq ($(feature-bionic), 1)
     BIONIC := 1
     EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index c65bdac..b031669 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -32,6 +32,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
+test-all:
+	$(BUILD) -Werror -fstack-protector -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
 test-hello:
 	$(BUILD)
 
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
new file mode 100644
index 0000000..9f7c4b1
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -0,0 +1,196 @@
+
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+
+#include <Python.h>
+
+#include <EXTERN.h>
+#include <perl.h>
+
+#include <stdio.h>
+#include <libelf.h>
+#include <gnu/libc-version.h>
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+#include <libelf.h>
+#include <libunwind.h>
+#include <stdlib.h>
+#include <libaudit.h>
+#include <slang.h>
+#include <gtk/gtk.h>
+#include <bfd.h>
+#include <stdio.h>
+#include <execinfo.h>
+#include <stdio.h>
+#include <numa.h>
+#include <numaif.h>
+
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main1(void)
+{
+	return puts("hi");
+}
+
+int main2(void)
+{
+	return puts("hi");
+}
+
+int main3(void)
+{
+	return puts("hi");
+}
+
+int main4(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
+#
+int main5(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+	return (long)elf;
+}
+
+int main6(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
+int main7(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
+
+int main8(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+int main9(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
+
+int main10(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
+
+int main11(void)
+{
+	return SLsmg_init_smg();
+}
+
+int main12(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
+
+int main13(void)
+{
+	gtk_info_bar_new();
+
+	return 0;
+}
+
+int main14(void)
+{
+	perl_alloc();
+
+	return 0;
+}
+
+int main15(void)
+{
+	Py_Initialize();
+	return 0;
+}
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
+int main16(void)
+{
+	return 0;
+}
+
+int main17(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
+
+void exit_function(int x, void *y)
+{
+}
+
+int main18(void)
+{
+	return on_exit(exit_function, NULL);
+}
+
+int main19(void)
+{
+	void *backtrace_fns[1];
+	size_t entries;
+
+	entries = backtrace(backtrace_fns, 1);
+	backtrace_symbols(backtrace_fns, entries);
+
+	return 0;
+}
+
+int main20(void)
+{
+	numa_available();
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	main1();
+	main2();
+	main3();
+	main4();
+	main5();
+	main6();
+	main7();
+	main8();
+	main9();
+	main10();
+	main11();
+	main12(argc, argv);
+	main13();
+	main14();
+	main15();
+	main16();
+	main17();
+	main18();
+	main19();
+	main20();
+
+	return 0;
+}
-- 
1.7.11.7

