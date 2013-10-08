Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3JHKMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:34 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52091 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3JHKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:23 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 18/52] tools/perf/build: Split out feature check: 'libunwind'
Date: Tue,  8 Oct 2013 12:10:48 +0200
Message-Id: <1381227082-22039-19-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-vTiatsVyva3tfgh3vhxaidxl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                        | 13 +++----------
 tools/perf/config/feature-checks/Makefile         |  4 ++++
 tools/perf/config/feature-checks/test-libunwind.c | 20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0d75587..c3f73be 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -113,6 +113,7 @@ FEATURE_TESTS =				\
 	dwarf				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
+	libunwind			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -240,15 +241,7 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-  ifdef LIBUNWIND_DIR
-    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-  endif
-
-  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+  ifneq ($(feature-libunwind), 1)
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
     NO_LIBUNWIND := 1
   endif
@@ -259,7 +252,7 @@ ifndef NO_LIBUNWIND
   EXTLIBS += $(LIBUNWIND_LIBS)
   CFLAGS += $(LIBUNWIND_CFLAGS)
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif # NO_LIBUNWIND
+endif
 
 ifndef NO_LIBAUDIT
   FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 83b3a02..d6d9570 100644
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
index 0000000..5622746
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
1.8.3.1

