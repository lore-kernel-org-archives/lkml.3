Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3LINLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:11:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:55833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab3LINLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:11:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="449172901"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf tools: Fix mmap pages rounding to power of 2
Date: Mon,  9 Dec 2013 15:18:39 +0200
Message-Id: <1386595120-22978-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'next_pow2()' only works for 'unsigned int' but the
argument is 'unsigned long'.  Checking for values
less than (1 << 31) ensures that 'next_pow2()' is
not passed a value out of range but lets anything
else go through unvalidated.

As a result mmap_pages of zero is used e.g.

  perf record -v -m2147483649 uname
  mmap size 0B
  failed to mmap with 22 (Invalid argument)

Fixed:

  perf record -m2147483649 uname
  rounding mmap pages size to 17592186044416 bytes (4294967296 pages)
  Invalid argument for --mmap_pages/-m

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c |  6 ++++--
 tools/perf/util/util.h   | 12 ++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 98ec96b..af25055 100644
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
index adb39f2..659abf3 100644
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
1.7.11.7

