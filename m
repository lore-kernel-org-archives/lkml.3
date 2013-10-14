Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3JNUC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3JNUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 031/161] tools/perf: Turn strlcpy() into a __weak function
Date: Mon, 14 Oct 2013 17:00:20 -0300
Message-Id: <1381780950-25642-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

The strlcpy() feature check slows every build unnecessarily - so make it
a __weak function so it does not have to be auto-detected.

If the libc (or any other library) has an strlcpy() implementation it will
be used - otherwise our fallback is active.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-zjbrcupapu08ePsyYhhhxiwk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      |  7 -------
 tools/perf/config/feature-checks/Makefile       |  4 ----
 tools/perf/config/feature-checks/test-strlcpy.c |  8 --------
 tools/perf/util/cache.h                         |  3 +--
 tools/perf/util/include/linux/compiler.h        |  4 ++++
 tools/perf/util/path.c                          | 10 +++++++---
 6 files changed, 12 insertions(+), 24 deletions(-)
 delete mode 100644 tools/perf/config/feature-checks/test-strlcpy.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c0c83440de97..3207c25b15f0 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,7 +121,6 @@ FEATURE_TESTS =				\
 	libperl				\
 	libpython			\
 	libpython-version		\
-	strlcpy				\
 	libbfd				\
 	on-exit				\
 	backtrace			\
@@ -436,12 +435,6 @@ else
   endif
 endif
 
-ifndef NO_STRLCPY
-  ifeq ($(feature-strlcpy), 1)
-    CFLAGS += -DHAVE_STRLCPY_SUPPORT
-  endif
-endif
-
 ifndef NO_ON_EXIT
   ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 0e4dbc2d5c8a..c65bdac0ebe2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -19,7 +19,6 @@ FILES=					\
 	test-libperl			\
 	test-libpython			\
 	test-libpython-version		\
-	test-strlcpy			\
 	test-libbfd			\
 	test-on-exit			\
 	test-backtrace			\
@@ -116,9 +115,6 @@ test-libpython:
 test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
-test-strlcpy:
-	$(BUILD)
-
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
deleted file mode 100644
index 4a6b6ff06f74..000000000000
--- a/tools/perf/config/feature-checks/test-strlcpy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <stdlib.h>
-extern size_t strlcpy(char *dest, const char *src, size_t size);
-
-int main(void)
-{
-	strlcpy(NULL, NULL, 0);
-	return 0;
-}
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 442953c1ce85..7b176dd02e1a 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -70,8 +70,7 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifndef HAVE_STRLCPY_SUPPORT
+/* Matches the libc/libbsd function attribute so we declare this unconditionally: */
 extern size_t strlcpy(char *dest, const char *src, size_t size);
-#endif
 
 #endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index bef4d3ddc493..b003ad7200b2 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -23,4 +23,8 @@
 # define __force
 #endif
 
+#ifndef __weak
+# define __weak			__attribute__((weak))
+#endif
+
 #endif
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index f3958743b743..5d13cb45b317 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -22,19 +22,23 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
-#ifndef HAVE_STRLCPY_SUPPORT
-size_t strlcpy(char *dest, const char *src, size_t size)
+/*
+ * If libc has strlcpy() then that version will override this
+ * implementation:
+ */
+size_t __weak strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
 
 	if (size) {
 		size_t len = (ret >= size) ? size - 1 : ret;
+
 		memcpy(dest, src, len);
 		dest[len] = '\0';
 	}
+
 	return ret;
 }
-#endif
 
 static char *get_pathname(void)
 {
-- 
1.8.1.4

