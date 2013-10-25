Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3JYKdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:33:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3JYKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:33:15 -0400
Date: Fri, 25 Oct 2013 03:32:50 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2fbe4abe944868aafdde233557ac85379b60ce46@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-15-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-15-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Validate that mmap_pages is not too big
Git-Commit-ID: 2fbe4abe944868aafdde233557ac85379b60ce46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fbe4abe944868aafdde233557ac85379b60ce46
Gitweb:     http://git.kernel.org/tip/2fbe4abe944868aafdde233557ac85379b60ce46
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:18 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 11:06:03 -0300

perf evlist: Validate that mmap_pages is not too big

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
index 85c4c80..2ce92ec 100644
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
