Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LKLFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3LKLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:14 -0500
Date: Wed, 11 Dec 2013 03:04:49 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1dbfa9387b397f2c4b8c65411b3e3fdf9284d2b1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1386595120-22978-4-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Fix mmap pages rounding to power of 2
Git-Commit-ID: 1dbfa9387b397f2c4b8c65411b3e3fdf9284d2b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:04:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dbfa9387b397f2c4b8c65411b3e3fdf9284d2b1
Gitweb:     http://git.kernel.org/tip/1dbfa9387b397f2c4b8c65411b3e3fdf9284d2b1
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 9 Dec 2013 15:18:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:18:05 -0300

perf evlist: Fix mmap pages rounding to power of 2

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
 
