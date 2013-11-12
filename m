Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3KLUqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:46:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3KLUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/13] perf evlist: Round mmap pages to power 2 - v2
Date: Tue, 12 Nov 2013 17:46:14 -0300
Message-Id: <1384289178-31374-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Currently perf requires the -m / --mmap_pages option to be a power of 2.

To be more user friendly perf should automatically round this up to the
next power of 2.

Currently:
  $ perf record -m 3 -a -- sleep 1
  --mmap_pages/-m value must be a power of two.sleep: Terminated

With patch:
  $ perf record -m 3 -a -- sleep 1
  rounding mmap pages size to 16384 (4 pages)
  ...

v2: Add bytes units to rounding message per Ingo's request. Other
    suggestions (e.g., prefixing INFO) should be addressed by wrapping
    pr_info to catch all instances.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1384267617-3446-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3960560f873a..fb4727d3df85 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -710,7 +710,6 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 {
 	unsigned int *mmap_pages = opt->value;
 	unsigned long pages, val;
-	size_t size;
 	static struct parse_tag tags[] = {
 		{ .tag  = 'B', .mult = 1       },
 		{ .tag  = 'K', .mult = 1 << 10 },
@@ -726,11 +725,6 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	if (val != (unsigned long) -1) {
 		/* we got file size value */
 		pages = PERF_ALIGN(val, page_size) / page_size;
-		if (pages < (1UL << 31) && !is_power_of_2(pages)) {
-			pages = next_pow2(pages);
-			pr_info("rounding mmap pages size to %lu (%lu pages)\n",
-				pages * page_size, pages);
-		}
 	} else {
 		/* we got pages count value */
 		char *eptr;
@@ -741,14 +735,14 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		}
 	}
 
-	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
-		pr_err("--mmap_pages/-m value too big\n");
-		return -1;
+	if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+		pages = next_pow2(pages);
+		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
+			pages * page_size, pages);
 	}
 
-	size = perf_evlist__mmap_size(pages);
-	if (!size) {
-		pr_err("--mmap_pages/-m value must be a power of two.");
+	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
+		pr_err("--mmap_pages/-m value too big\n");
 		return -1;
 	}
 
-- 
1.8.1.4

