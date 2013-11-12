Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3KLOrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:47:21 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34880 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3KLOrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:16 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf tool: Round mmap pages to power 2 - v2
Date: Tue, 12 Nov 2013 07:46:54 -0700
Message-Id: <1384267617-3446-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.3.4 (Apple Git-47)

