Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLPQ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:59:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:47162 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaLPQ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:59:03 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/18] perf evlist: Use roundup_pow_of_two
Date: Tue, 16 Dec 2014 13:57:19 -0300
Message-Id: <1418749040-31807-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And remove the equivalent next_pow2{_l} functions.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hl9ct3wcbs5deai3v5ljmuws@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |  2 +-
 tools/perf/util/util.h   | 18 ------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7d88327d94a9..cbab1fb77b1d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -948,7 +948,7 @@ static long parse_pages_arg(const char *str, unsigned long min,
 		/* leave number of pages at 0 */
 	} else if (!is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
-		pages = next_pow2_l(pages);
+		pages = roundup_pow_of_two(pages);
 		if (!pages)
 			return -EINVAL;
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 25b22bbea066..be198ac27031 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -269,24 +269,6 @@ void event_attr_init(struct perf_event_attr *attr);
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-static inline unsigned next_pow2(unsigned x)
-{
-	if (!x)
-		return 1;
-	return 1ULL << (32 - __builtin_clz(x - 1));
-}
-
-static inline unsigned long next_pow2_l(unsigned long x)
-{
-#if BITS_PER_LONG == 64
-	if (x <= (1UL << 31))
-		return next_pow2(x);
-	return (unsigned long)next_pow2(x >> 32) << 32;
-#else
-	return next_pow2(x);
-#endif
-}
-
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
-- 
1.9.3

