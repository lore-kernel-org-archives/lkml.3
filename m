Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3JNUsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:48:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38467 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3JNUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 018/161] tools/perf/build: Split out feature check: 'libunwind'
Date: Mon, 14 Oct 2013 17:00:07 -0300
Message-Id: <1381780950-25642-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-vTiatsVyva3tfgh3vhxaidxl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                        | 13 ++++++++-----
 tools/perf/config/feature-checks/Makefile         |  4 ++++
 tools/perf/config/feature-checks/test-libunwind.c | 20 ++++++++++++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libunwind.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0d7558790a02..d684a292536e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -113,6 +113,7 @@ FEATURE_TESTS =				\
 	dwarf				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
+	libunwind			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -240,15 +241,17 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+  #
+  # For linking with debug library, run like:
+  #
+  #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+  #
   ifdef LIBUNWIND_DIR
     LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
     LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
   endif
 
-  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+  ifneq ($(feature-libunwind), 1)
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
     NO_LIBUNWIND := 1
   endif
@@ -259,7 +262,7 @@ ifndef NO_LIBUNWIND
   EXTLIBS += $(LIBUNWIND_LIBS)
   CFLAGS += $(LIBUNWIND_CFLAGS)
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif # NO_LIBUNWIND
+endif
 
 ifndef NO_LIBAUDIT
   FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 83b3a02b64d8..d6d9570a038f 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -11,6 +11,7 @@ FILES=					\
 	test-dwarf			\
 	test-libelf-mmap		\
 	test-libelf-getphdrnum		\
+	test-libunwind			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -57,6 +58,9 @@ test-libelf-getphdrnum:
 test-libnuma:
 	$(BUILD) -lnuma
 
+test-libunwind:
+	$(BUILD) -lunwind -lunwind-x86_64 -lelf
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libunwind.c b/tools/perf/config/feature-checks/test-libunwind.c
new file mode 100644
index 000000000000..562274695c76
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libunwind.c
@@ -0,0 +1,20 @@
+#include <libunwind.h>
+#include <stdlib.h>
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
+int main(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
-- 
1.8.1.4

