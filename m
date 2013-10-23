Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3JWU6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:58:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3JWU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:32 -0400
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
Subject: [PATCH 12/16] perf evlist: Validate that mmap_pages is not too big
Date: Wed, 23 Oct 2013 17:58:11 -0300
Message-Id: <1382561895-8237-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Amend perf_evlist__parse_mmap_pages() to check that the mmap_pages
entered via the --mmap_pages/-m option is not too big.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-15-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 85c4c80bcac8..2ce92eceb424 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -698,7 +698,8 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 				  int unset __maybe_unused)
 {
-	unsigned int pages, val, *mmap_pages = opt->value;
+	unsigned int *mmap_pages = opt->value;
+	unsigned long pages, val;
 	size_t size;
 	static struct parse_tag tags[] = {
 		{ .tag  = 'B', .mult = 1       },
@@ -709,12 +710,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
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
@@ -727,6 +728,11 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
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
1.8.1.4

