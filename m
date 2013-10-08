Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3JHKM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:27 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55295 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3JHKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:16 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/52] tools/perf/build: Split out feature check: 'libelf'
Date: Tue,  8 Oct 2013 12:10:41 +0200
Message-Id: <1381227082-22039-12-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-qznhihaasbysfqO7ffvRsf9q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 4 ++--
 tools/perf/config/feature-checks/Makefile      | 4 ++++
 tools/perf/config/feature-checks/test-libelf.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a2e0e1b..6865428 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -108,6 +108,7 @@ FEATURE_TESTS =				\
 	volatile-register-var		\
 	fortify-source			\
 	bionic				\
+	libelf				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -164,8 +165,7 @@ ifdef NO_LIBELF
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
 else
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+  ifeq ($(feature-libelf), 0)
     FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
     ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
       LIBC_SUPPORT := 1
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 191df97..789a38d 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -6,6 +6,7 @@ FILES=					\
 	test-volatile-register-var	\
 	test-fortify-source		\
 	test-bionic			\
+	test-libelf			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -34,6 +35,9 @@ test-fortify-source:
 test-bionic:
 	$(BUILD)
 
+test-libelf:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf.c
new file mode 100644
index 0000000..1a08f97
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
-- 
1.8.3.1

