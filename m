Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3JGMIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:08:36 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62581 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab3JGL6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:01 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 15/50] tools/perf/build: Split out feature check: 'libelf-mmap'
Date: Mon,  7 Oct 2013 13:56:08 +0200
Message-Id: <1381147003-2574-16-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3129c2d..1846559 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -111,6 +111,7 @@ FEATURE_TESTS =				\
 	libelf				\
 	glibc				\
 	dwarf				\
+	libelf-mmap			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -201,7 +202,7 @@ ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif
 
@@ -226,8 +227,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif # try-cc
 endif # NO_LIBELF
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 566a71d..bf96e34 100644
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
index 0000000..1c64815
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
1.7.11.7

