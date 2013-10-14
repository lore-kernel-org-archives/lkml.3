Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3JNUtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:49:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab3JNUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 015/161] tools/perf/build: Split out feature check: 'libelf-mmap'
Date: Mon, 14 Oct 2013 17:00:04 -0300
Message-Id: <1381780950-25642-16-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-9fxnxjcmrgbSvipxlwsdQ8fg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                          | 6 +++---
 tools/perf/config/feature-checks/Makefile           | 4 ++++
 tools/perf/config/feature-checks/test-libelf-mmap.c | 7 +++++++
 3 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libelf-mmap.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8a27de27f7c2..bf1f021d2467 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -111,6 +111,7 @@ FEATURE_TESTS =				\
 	libelf				\
 	glibc				\
 	dwarf				\
+	libelf-mmap			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -202,7 +203,7 @@ ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif
 
@@ -227,8 +228,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif # try-cc
 endif # NO_LIBELF
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 566a71dd6168..bf96e34509f4 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -9,6 +9,7 @@ FILES=					\
 	test-libelf			\
 	test-glibc			\
 	test-dwarf			\
+	test-libelf-mmap		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -46,6 +47,9 @@ test-glibc:
 test-dwarf:
 	$(BUILD) -ldw
 
+test-libelf-mmap:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf-mmap.c b/tools/perf/config/feature-checks/test-libelf-mmap.c
new file mode 100644
index 000000000000..1c648159c705
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+#
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+	return (long)elf;
+}
-- 
1.8.1.4

