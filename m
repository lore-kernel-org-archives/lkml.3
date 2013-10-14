Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab3JNUSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:18:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39042 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3JNUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 086/161] perf tools: Add possibility to specify mmap size
Date: Mon, 14 Oct 2013 17:01:15 -0300
Message-Id: <1381780950-25642-87-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378031796-17892-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index ac84db2d2334..6a06cefe9642 100644
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
index f732eaa6a500..f10ab63576d7 100644
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
index 6d70fbfe28a2..f65777c1f723 100644
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
index 37773854d5c4..7f70d3640edd 100644
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
index 4283f49ca0ab..d21ab0812926 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -687,14 +687,33 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
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
@@ -738,6 +757,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
+	pr_debug("mmap size %luB\n", evlist->mmap_len);
 	mask = evlist->mmap_len - page_size - 1;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index ccfdeb62f576..ab71d6216803 100644
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
index a53535949043..c29ecaabf461 100644
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
1.8.1.4

