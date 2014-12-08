Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaLHGzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:55:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaLHGuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:50:05 -0500
Date: Sun, 7 Dec 2014 22:49:15 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6wzjpe2fy9xtgchshulixlzw@git.kernel.org>
Cc: adrian.hunter@intel.com, mingo@kernel.org, jolsa@redhat.com,
        peterz@infradead.org, eranian@google.com, tglx@linutronix.de,
        bp@suse.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, dzickus@redhat.com, namhyung@kernel.org,
        dsahern@gmail.com, ak@linux.intel.com, efault@gmx.de, acme@redhat.com
Reply-To: eranian@google.com, tglx@linutronix.de, bp@suse.de,
        adrian.hunter@intel.com, peterz@infradead.org, mingo@kernel.org,
        jolsa@redhat.com, efault@gmx.de, ak@linux.intel.com, acme@redhat.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        namhyung@kernel.org, dzickus@redhat.com, dsahern@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Move bfd_demangle stubbing to its only user
Git-Commit-ID: aaba4e12a99cc56fc8614a3f2a3ec6db4fcde76e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aaba4e12a99cc56fc8614a3f2a3ec6db4fcde76e
Gitweb:     http://git.kernel.org/tip/aaba4e12a99cc56fc8614a3f2a3ec6db4fcde76e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 24 Nov 2014 17:10:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:47 -0300

perf symbols: Move bfd_demangle stubbing to its only user

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
index efc7eb6..06fcd1b 100644
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
index ded3ca7..e0b297c 100644
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
