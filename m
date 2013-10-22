Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3JVHgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:36:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:58293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3JVHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958592"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 14/14] perf tools: Validate that mmap_pages is not too big
Date: Tue, 22 Oct 2013 10:34:18 +0300
Message-Id: <1382427258-17495-15-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend perf_evlist__parse_mmap_pages() to check that
the mmap_pages entered via the --mmap_pages/-m
option is not too big.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9d17998..9d6d01c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -725,7 +725,8 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 				  int unset __maybe_unused)
 {
-	unsigned int pages, val, *mmap_pages = opt->value;
+	unsigned int *mmap_pages = opt->value;
+	unsigned long pages, val;
 	size_t size;
 	static struct parse_tag tags[] = {
 		{ .tag  = 'B', .mult = 1       },
@@ -736,12 +737,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	};
 
 	val = parse_tag_value(str, tags);
-	if (val != (unsigned int) -1) {
+	if (val != (unsigned long) -1) {
 		/* we got file size value */
 		pages = PERF_ALIGN(val, page_size) / page_size;
-		if (!is_power_of_2(pages)) {
+		if (pages < (1UL << 31) && !is_power_of_2(pages)) {
 			pages = next_pow2(pages);
-			pr_info("rounding mmap pages size to %u (%u pages)\n",
+			pr_info("rounding mmap pages size to %lu (%lu pages)\n",
 				pages * page_size, pages);
 		}
 	} else {
@@ -754,6 +755,11 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		}
 	}
 
+	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
+		pr_err("--mmap_pages/-m value too big\n");
+		return -1;
+	}
+
 	size = perf_evlist__mmap_size(pages);
 	if (!size) {
 		pr_err("--mmap_pages/-m value must be a power of two.");
-- 
1.7.11.7

