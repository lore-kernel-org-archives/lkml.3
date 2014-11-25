Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaKYNWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:35635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbaKYNWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:38 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/12] perf symbols: Move bfd_demangle stubbing to its only user
Date: Tue, 25 Nov 2014 10:22:02 -0300
Message-Id: <1416921730-5063-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to define bfd_demangle() to either a wrapper for
cplus_demangle() or to a stub when NO_DEMANGLE is defined.

That is at odds with using bfd.h for some other reason, as it defines
bfd_demangle() and then if code that wants to use symbol.h, where the
above stubbing/wrapping is done, and bfd.h for other reasons, we end up
with a build error where bfd_demangle() is found to be redefined.

Avoid that by moving the stubbing/wrapping to symbol-elf.c, that is the
only user of such function. If we ever get to a point where there are
more valid users, we can then introduce a header for that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6wzjpe2fy9xtgchshulixlzw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 21 +++++++++++++++++++++
 tools/perf/util/symbol.h     | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index efc7eb6b8f0f..06fcd1bf98b6 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -11,6 +11,27 @@
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
+#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
+extern char *cplus_demangle(const char *, int);
+
+static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
+{
+	return cplus_demangle(c, i);
+}
+#else
+#ifdef NO_DEMANGLE
+static inline char *bfd_demangle(void __maybe_unused *v,
+				 const char __maybe_unused *c,
+				 int __maybe_unused i)
+{
+	return NULL;
+}
+#else
+#define PACKAGE 'perf'
+#include <bfd.h>
+#endif
+#endif
+
 #ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ded3ca7266de..e0b297c50f9d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -23,27 +23,6 @@
 
 #include "dso.h"
 
-#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
-extern char *cplus_demangle(const char *, int);
-
-static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
-{
-	return cplus_demangle(c, i);
-}
-#else
-#ifdef NO_DEMANGLE
-static inline char *bfd_demangle(void __maybe_unused *v,
-				 const char __maybe_unused *c,
-				 int __maybe_unused i)
-{
-	return NULL;
-}
-#else
-#define PACKAGE 'perf'
-#include <bfd.h>
-#endif
-#endif
-
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
-- 
1.9.3

