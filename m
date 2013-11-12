Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3KLWAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:00:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab3KLV5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:36 -0500
Date: Tue, 12 Nov 2013 13:57:24 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-33c2dcfdfe7f114cc656bcb4c839f5939d5e60ba@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1384267617-3446-4-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Refactor mmap_pages parsing
Git-Commit-ID: 33c2dcfdfe7f114cc656bcb4c839f5939d5e60ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33c2dcfdfe7f114cc656bcb4c839f5939d5e60ba
Gitweb:     http://git.kernel.org/tip/33c2dcfdfe7f114cc656bcb4c839f5939d5e60ba
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Nov 2013 07:46:55 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 16:33:22 -0300

perf evlist: Refactor mmap_pages parsing

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
index fb4727d..cb19044 100644
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
 
