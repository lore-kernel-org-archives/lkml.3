Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaLRGdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:33:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLRGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:33:43 -0500
Date: Wed, 17 Dec 2014 22:33:01 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-hl9ct3wcbs5deai3v5ljmuws@git.kernel.org>
Cc: acme@redhat.com, peterz@infradead.org, efault@gmx.de, dsahern@gmail.com,
        mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        jolsa@redhat.com, adrian.hunter@intel.com, dzickus@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, eranian@google.com,
        bp@suse.de, namhyung@kernel.org, fweisbec@gmail.com
Reply-To: peterz@infradead.org, acme@redhat.com, jolsa@redhat.com,
        paulus@samba.org, tglx@linutronix.de, efault@gmx.de, mingo@kernel.org,
        dsahern@gmail.com, eranian@google.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, dzickus@redhat.com, hpa@zytor.com,
        fweisbec@gmail.com, namhyung@kernel.org, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Use roundup_pow_of_two
Git-Commit-ID: 91529834d1dea9afccb72843c3e547e703ec177f
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

Commit-ID:  91529834d1dea9afccb72843c3e547e703ec177f
Gitweb:     http://git.kernel.org/tip/91529834d1dea9afccb72843c3e547e703ec177f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 13:24:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:58:16 -0300

perf evlist: Use roundup_pow_of_two

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
index 7d88327..cbab1fb 100644
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
index 25b22bb..be198ac 100644
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
 
