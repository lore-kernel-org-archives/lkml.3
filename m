Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3KLV54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:57:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3KLV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:27 -0500
Date: Tue, 12 Nov 2013 13:57:15 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-9639837e95db90d056f4683c911717921519320e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1384267617-3446-3-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Round mmap pages to power 2 - v2
Git-Commit-ID: 9639837e95db90d056f4683c911717921519320e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9639837e95db90d056f4683c911717921519320e
Gitweb:     http://git.kernel.org/tip/9639837e95db90d056f4683c911717921519320e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Nov 2013 07:46:54 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 16:31:53 -0300

perf evlist: Round mmap pages to power 2 - v2

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
index 3960560..fb4727d 100644
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
 
