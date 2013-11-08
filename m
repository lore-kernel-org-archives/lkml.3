Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3KHEgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:36:42 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33086 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3KHEgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:36:39 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tool: Round mmap pages to power 2
Date: Thu,  7 Nov 2013 21:36:32 -0700
Message-Id: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
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

Signed-off-by: David Ahern <dsahern@gmail.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b939221efd8d..9ec3a5a45f22 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -722,11 +722,6 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
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
@@ -737,6 +732,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		}
 	}
 
+	if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+		pages = next_pow2(pages);
+		pr_info("rounding mmap pages size to %lu (%lu pages)\n",
+			pages * page_size, pages);
+	}
+
 	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
 		pr_err("--mmap_pages/-m value too big\n");
 		return -1;
-- 
1.8.3.4 (Apple Git-47)

