Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3JGL6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:18 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60755 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3JGL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:12 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 26/50] tools/perf/build: Split out feature check: 'libbfd'
Date: Mon,  7 Oct 2013 13:56:19 +0200
Message-Id: <1381147003-2574-27-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-cdxdfv7Corpfvjg9Skezhvjn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 6 +++---
 tools/perf/config/feature-checks/Makefile       | 7 +++++++
 tools/perf/config/feature-checks/test-libbfd.c  | 7 +++++++
 tools/perf/config/feature-checks/test-strlcpy.c | 8 ++++++++
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 77a2e6b..4f60ecc 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
+	libbfd				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -393,8 +394,7 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-    ifeq ($(has_bfd),y)
+    ifeq ($(feature-libbfd), 1)
       EXTLIBS += -lbfd
     else
       FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
@@ -423,7 +423,7 @@ else
 endif
 
 ifndef NO_STRLCPY
-  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY_SUPPORT),y)
+  ifeq ($(feature-strlcpy), 1)
     CFLAGS += -DHAVE_STRLCPY_SUPPORT
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d15074d..2a3473e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -19,6 +19,7 @@ FILES=					\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
+	test-libbfd			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -112,6 +113,12 @@ test-libpython:
 test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-libbfd:
+	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
+test-strlcpy:
+	$(BUILD)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
new file mode 100644
index 0000000..d03339c
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -0,0 +1,7 @@
+#include <bfd.h>
+
+int main(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
new file mode 100644
index 0000000..4a6b6ff
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-strlcpy.c
@@ -0,0 +1,8 @@
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
-- 
1.7.11.7

