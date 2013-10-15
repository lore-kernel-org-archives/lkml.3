Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3JOFRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:17:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3JOFRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:17:14 -0400
Date: Mon, 14 Oct 2013 22:16:59 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-fb1c9185e36cf9c616ac15f54e54a01f052672bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf: Turn strlcpy() into a __weak function
Git-Commit-ID: fb1c9185e36cf9c616ac15f54e54a01f052672bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:17:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb1c9185e36cf9c616ac15f54e54a01f052672bd
Gitweb:     http://git.kernel.org/tip/fb1c9185e36cf9c616ac15f54e54a01f052672bd
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 1 Oct 2013 13:26:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:49 +0200

tools/perf: Turn strlcpy() into a __weak function

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c0c8344..3207c25 100644
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
index 0e4dbc2..c65bdac 100644
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
