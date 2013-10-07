Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3JGMEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:04:36 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:32898 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3JGL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:17 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 30/50] tools/perf: Turn strlcpy() into a __weak function
Date: Mon,  7 Oct 2013 13:56:23 +0200
Message-Id: <1381147003-2574-31-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 tools/perf/config/Makefile                      |  6 ------
 tools/perf/config/feature-checks/Makefile       |  3 ---
 tools/perf/config/feature-checks/test-strlcpy.c |  8 --------
 tools/perf/util/cache.h                         |  3 +--
 tools/perf/util/include/linux/compiler.h        |  4 ++++
 tools/perf/util/path.c                          | 10 +++++++---
 6 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e190f9c..1b2a46b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -424,12 +424,6 @@ else
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
index ddc4c33..c65bdac 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -118,9 +118,6 @@ test-libpython-version:
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
-test-strlcpy:
-	$(BUILD)
-
 test-on-exit:
 	$(BUILD)
 
diff --git a/tools/perf/config/feature-checks/test-strlcpy.c b/tools/perf/config/feature-checks/test-strlcpy.c
deleted file mode 100644
index 4a6b6ff..0000000
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
index 442953c..7b176dd 100644
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
index bef4d3d..b003ad7 100644
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
index f395874..5d13cb4 100644
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
1.7.11.7

