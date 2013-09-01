Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3IAKhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3IAKhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:37:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/25] perf tools: Add possibility to specify mmap size
Date: Sun,  1 Sep 2013 12:36:13 +0200
Message-Id: <1378031796-17892-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding possibility to specify mmap size via -m/--mmap-pages
by appending unit size character (B/K/M/G) to the
number, like:
  $ perf record -m 8K ls
  $ perf record -m 2M ls

The size is rounded up appropriately to follow perf
mmap restrictions.

If no unit is specified the number provides pages as
of now, like:
  $ perf record -m 8 ls

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-kvm.txt    |  4 +++-
 tools/perf/Documentation/perf-record.txt |  4 +++-
 tools/perf/Documentation/perf-top.txt    |  4 +++-
 tools/perf/Documentation/perf-trace.txt  |  4 +++-
 tools/perf/util/evlist.c                 | 32 ++++++++++++++++++++++++++------
 tools/perf/util/util.c                   | 25 +++++++++++++++++++++++++
 tools/perf/util/util.h                   | 14 ++++++++++++++
 7 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index ac84db2..6a06cef 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -109,7 +109,9 @@ STAT LIVE OPTIONS
 
 -m::
 --mmap-pages=::
-    Number of mmap data pages. Must be a power of two.
+    Number of mmap data pages (must be a power of two) or size
+    specification with appended unit character - B/K/M/G. The
+    size is rounded up to have nearest pages power of two value.
 
 -a::
 --all-cpus::
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e297b74..400e9bb 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -87,7 +87,9 @@ OPTIONS
 
 -m::
 --mmap-pages=::
-	Number of mmap data pages. Must be a power of two.
+	Number of mmap data pages (must be a power of two) or size
+	specification with appended unit character - B/K/M/G. The
+	size is rounded up to have nearest pages power of two value.
 
 -g::
 --call-graph::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 58d6598..19ab69e 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -68,7 +68,9 @@ Default is to monitor all CPUS.
 
 -m <pages>::
 --mmap-pages=<pages>::
-	Number of mmapped data pages.
+	Number of mmap data pages (must be a power of two) or size
+	specification with appended unit character - B/K/M/G. The
+	size is rounded up to have nearest pages power of two value.
 
 -p <pid>::
 --pid=<pid>::
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c..d390efa 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -59,7 +59,9 @@ OPTIONS
 
 -m::
 --mmap-pages=::
-	Number of mmap data pages. Must be a power of two.
+	Number of mmap data pages (must be a power of two) or size
+	specification with appended unit character - B/K/M/G. The
+	size is rounded up to have nearest pages power of two value.
 
 -C::
 --cpu::
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4780b9e..8ea933f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -634,14 +634,33 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 				  int unset __maybe_unused)
 {
-	unsigned int pages, *mmap_pages = opt->value;
+	unsigned int pages, val, *mmap_pages = opt->value;
 	size_t size;
-	char *eptr;
+	static struct parse_tag tags[] = {
+		{ .tag  = 'B', .mult = 1       },
+		{ .tag  = 'K', .mult = 1 << 10 },
+		{ .tag  = 'M', .mult = 1 << 20 },
+		{ .tag  = 'G', .mult = 1 << 30 },
+		{ .tag  = 0 },
+	};
 
-	pages = strtoul(str, &eptr, 10);
-	if (*eptr != '\0') {
-		pr_err("failed to parse --mmap_pages/-m value\n");
-		return -1;
+	val = parse_tag_value(str, tags);
+	if (val != (unsigned int) -1) {
+		/* we got file size value */
+		pages = PERF_ALIGN(val, page_size) / page_size;
+		if (!is_power_of_2(pages)) {
+			pages = next_pow2(pages);
+			pr_info("rounding mmap pages size to %u (%u pages)\n",
+				pages * page_size, pages);
+		}
+	} else {
+		/* we got pages count value */
+		char *eptr;
+		pages = strtoul(str, &eptr, 10);
+		if (*eptr != '\0') {
+			pr_err("failed to parse --mmap_pages/-m value\n");
+			return -1;
+		}
 	}
 
 	size = perf_evlist__mmap_size(pages);
@@ -685,6 +704,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
+	pr_debug("mmap size %luB\n", evlist->mmap_len);
 	mask = evlist->mmap_len - page_size - 1;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 6d17b18..141317e 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -361,3 +361,28 @@ int parse_nsec_time(const char *str, u64 *ptime)
 	*ptime = time_sec * NSEC_PER_SEC + time_nsec;
 	return 0;
 }
+
+unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
+{
+	struct parse_tag *i = tags;
+
+	while (i->tag) {
+		char *s;
+
+		s = strchr(str, i->tag);
+		if (s) {
+			unsigned long int value;
+			char *endptr;
+
+			value = strtoul(str, &endptr, 10);
+			if (s != endptr)
+				break;
+
+			value *= i->mult;
+			return value;
+		}
+		i++;
+	}
+
+	return (unsigned long) -1;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a535359..c29ecaa 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -270,6 +270,13 @@ bool is_power_of_2(unsigned long n)
 	return (n != 0 && ((n & (n - 1)) == 0));
 }
 
+static inline unsigned next_pow2(unsigned x)
+{
+	if (!x)
+		return 1;
+	return 1ULL << (32 - __builtin_clz(x - 1));
+}
+
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
@@ -281,4 +288,11 @@ void dump_stack(void);
 extern unsigned int page_size;
 
 void get_term_dimensions(struct winsize *ws);
+
+struct parse_tag {
+	char tag;
+	int mult;
+};
+
+unsigned long parse_tag_value(const char *str, struct parse_tag *tags);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.7.11.7

