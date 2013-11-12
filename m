Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3KLUsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:48:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KLUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf evlist: Refactor mmap_pages parsing
Date: Tue, 12 Nov 2013 17:46:15 -0300
Message-Id: <1384289178-31374-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Logic will be re-used for the out-pages argument for mmap based writes
in perf-record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1384267617-3446-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index fb4727d3df85..cb19044601bb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -705,10 +705,9 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 	return (pages + 1) * page_size;
 }
 
-int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
-				  int unset __maybe_unused)
+static long parse_pages_arg(const char *str, unsigned long min,
+			    unsigned long max)
 {
-	unsigned int *mmap_pages = opt->value;
 	unsigned long pages, val;
 	static struct parse_tag tags[] = {
 		{ .tag  = 'B', .mult = 1       },
@@ -719,7 +718,7 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	};
 
 	if (str == NULL)
-		return -1;
+		return -EINVAL;
 
 	val = parse_tag_value(str, tags);
 	if (val != (unsigned long) -1) {
@@ -729,20 +728,38 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		/* we got pages count value */
 		char *eptr;
 		pages = strtoul(str, &eptr, 10);
-		if (*eptr != '\0') {
-			pr_err("failed to parse --mmap_pages/-m value\n");
-			return -1;
-		}
+		if (*eptr != '\0')
+			return -EINVAL;
 	}
 
-	if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+	if ((pages == 0) && (min == 0)) {
+		/* leave number of pages at 0 */
+	} else if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+		/* round pages up to next power of 2 */
 		pages = next_pow2(pages);
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
 			pages * page_size, pages);
 	}
 
-	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
-		pr_err("--mmap_pages/-m value too big\n");
+	if (pages > max)
+		return -EINVAL;
+
+	return pages;
+}
+
+int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	unsigned int *mmap_pages = opt->value;
+	unsigned long max = UINT_MAX;
+	long pages;
+
+	if (max < SIZE_MAX / page_size)
+		max = SIZE_MAX / page_size;
+
+	pages = parse_pages_arg(str, 1, max);
+	if (pages < 0) {
+		pr_err("Invalid argument for --mmap_pages/-m\n");
 		return -1;
 	}
 
-- 
1.8.1.4

