Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab3LITlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:41:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342Ab3LIThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/21] perf evlist: Fix mmap pages rounding to power of 2
Date: Mon,  9 Dec 2013 16:36:58 -0300
Message-Id: <1386617830-18926-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

'next_pow2()' only works for 'unsigned int' but the argument is
'unsigned long'.  Checking for values less than (1 << 31) ensures that
'next_pow2()' is not passed a value out of range but lets anything else
go through unvalidated.

As a result mmap_pages of zero is used e.g.

  perf record -v -m2147483649 uname
  mmap size 0B
  failed to mmap with 22 (Invalid argument)

Fixed:

  perf record -m2147483649 uname
  rounding mmap pages size to 17592186044416 bytes (4294967296 pages)
  Invalid argument for --mmap_pages/-m

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386595120-22978-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |  6 ++++--
 tools/perf/util/util.h   | 12 ++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 98ec96b3a744..af250556b33f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -734,9 +734,11 @@ static long parse_pages_arg(const char *str, unsigned long min,
 
 	if (pages == 0 && min == 0) {
 		/* leave number of pages at 0 */
-	} else if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+	} else if (!is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
-		pages = next_pow2(pages);
+		pages = next_pow2_l(pages);
+		if (!pages)
+			return -EINVAL;
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
 			pages * page_size, pages);
 	}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index adb39f251f90..659abf30e01b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -73,6 +73,7 @@
 #include <sys/ttydefaults.h>
 #include <lk/debugfs.h>
 #include <termios.h>
+#include <linux/bitops.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -281,6 +282,17 @@ static inline unsigned next_pow2(unsigned x)
 	return 1ULL << (32 - __builtin_clz(x - 1));
 }
 
+static inline unsigned long next_pow2_l(unsigned long x)
+{
+#if BITS_PER_LONG == 64
+	if (x <= (1UL << 31))
+		return next_pow2(x);
+	return (unsigned long)next_pow2(x >> 32) << 32;
+#else
+	return next_pow2(x);
+#endif
+}
+
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
-- 
1.8.1.4

