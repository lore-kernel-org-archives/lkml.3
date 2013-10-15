Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3JOFPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3JOFPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:15:17 -0400
Date: Mon, 14 Oct 2013 22:15:02 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-058f952de9b3075cd888dc3cea60691db0ec4d3f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libunwind'
Git-Commit-ID: 058f952de9b3075cd888dc3cea60691db0ec4d3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:15:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  058f952de9b3075cd888dc3cea60691db0ec4d3f
Gitweb:     http://git.kernel.org/tip/058f952de9b3075cd888dc3cea60691db0ec4d3f
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:45:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:39 +0200

tools/perf/build: Split out feature check: 'libunwind'

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0d75587..d684a29 100644
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
