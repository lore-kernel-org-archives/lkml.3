Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3JALfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:35:03 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34562 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3JALfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:35:00 -0400
Date: Tue, 1 Oct 2013 13:34:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] perf autodep: Remove strlcpy feature check, add __weak
 strlcpy implementation
Message-ID: <20131001113456.GA31331@gmail.com>
References: <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930190434.GA3427@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > > > Checking why that strlcpy failed...
> > > 
> > > I don't think glibc does strlcpy. It's not a standard C function, 
> > > and
> > 
> > My concern was more about the thinking: ``Is this red "OFF" thing a 
> > problem?  I feel so much more confortable when all entries have nice 
> > green "on" lights...''
> 
> Yeah, so I think we should add our internal implementation of strlcpy() 
> as a __weak function instead - if the libc does not provide then we 
> provide a fallback.
> 
> That should get rid of another ~50 msecs of build overhead, as failed 
> feature tests are the most expensive ones.

The patch below implements that. I haven't actually tested it on a system 
with a in-libc strlcpy implementation, but it Should Just Work (tm) ;-)

Overhead is down from 0.600 secs to 0.540 secs. The only remaining thing 
is the libperl bug, I'll have a look at that next.

( I also couldn't resist fixing up perf's version of compiler.h a bit, 
  will split that out into a separate patch later on. )

Thanks,

	Ingo

=====================>
Subject: perf autodep: Remove strlcpy feature check, add __weak strlcpy implementation
From: Ingo Molnar <mingo@kernel.org>
Date: Tue Oct 1 13:26:13 CEST 2013

---
 tools/perf/config/Makefile                      |    8 +-------
 tools/perf/config/feature-checks/Makefile       |    3 ---
 tools/perf/config/feature-checks/test-strlcpy.c |    8 --------
 tools/perf/util/cache.h                         |    3 +--
 tools/perf/util/include/linux/compiler.h        |   19 ++++++++++++++-----
 tools/perf/util/path.c                          |   10 +++++++---
 6 files changed, 23 insertions(+), 28 deletions(-)

Index: tip/tools/perf/config/Makefile
===================================================================
--- tip.orig/tools/perf/config/Makefile
+++ tip/tools/perf/config/Makefile
@@ -101,7 +101,7 @@ $(info )
 $(info Auto-detecting system features:)
 $(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
 
-FEATURE_TESTS = stackprotector-all volatile-register-var fortify-source libelf libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 gtk2-infobar libperl libpython libpython-version libbfd strlcpy on-exit backtrace libnuma
+FEATURE_TESTS = stackprotector-all volatile-register-var fortify-source libelf libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 gtk2-infobar libperl libpython libpython-version libbfd on-exit backtrace libnuma
 
 $(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
 
@@ -421,12 +421,6 @@ else
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
Index: tip/tools/perf/config/feature-checks/Makefile
===================================================================
--- tip.orig/tools/perf/config/feature-checks/Makefile
+++ tip/tools/perf/config/feature-checks/Makefile
@@ -93,9 +93,6 @@ test-libpython-version: test-libpython-v
 test-libbfd: test-libbfd.c
 	$(CC) -o $@ $@.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
-test-strlcpy: test-strlcpy.c
-	$(CC) -o $@ $@.c
-
 test-on-exit: test-on-exit.c
 	$(CC) -o $@ $@.c
 
Index: tip/tools/perf/config/feature-checks/test-strlcpy.c
===================================================================
--- tip.orig/tools/perf/config/feature-checks/test-strlcpy.c
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
Index: tip/tools/perf/util/cache.h
===================================================================
--- tip.orig/tools/perf/util/cache.h
+++ tip/tools/perf/util/cache.h
@@ -70,8 +70,7 @@ extern char *perf_path(const char *fmt,
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifndef HAVE_STRLCPY_SUPPORT
+/* Matches the libc/libbsd function attribute so we declare this unconditionally: */
 extern size_t strlcpy(char *dest, const char *src, size_t size);
-#endif
 
 #endif /* __PERF_CACHE_H */
Index: tip/tools/perf/util/include/linux/compiler.h
===================================================================
--- tip.orig/tools/perf/util/include/linux/compiler.h
+++ tip/tools/perf/util/include/linux/compiler.h
@@ -2,20 +2,29 @@
 #define _PERF_LINUX_COMPILER_H_
 
 #ifndef __always_inline
-#define __always_inline	inline
+# define __always_inline	inline __attribute__((always_inline))
 #endif
+
 #define __user
+
 #ifndef __attribute_const__
-#define __attribute_const__
+# define __attribute_const__
 #endif
 
 #ifndef __maybe_unused
-#define __maybe_unused		__attribute__((unused))
+# define __maybe_unused		__attribute__((unused))
+#endif
+
+#ifndef __packed
+# define __packed		__attribute__((__packed__))
 #endif
-#define __packed	__attribute__((__packed__))
 
 #ifndef __force
-#define __force
+# define __force
+#endif
+
+#ifndef __weak
+# define __weak			__attribute__((weak))
 #endif
 
 #endif
Index: tip/tools/perf/util/path.c
===================================================================
--- tip.orig/tools/perf/util/path.c
+++ tip/tools/perf/util/path.c
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
