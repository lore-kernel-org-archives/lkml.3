Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3J1TRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:17:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58551 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3J1TRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:17:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf hists: Add color overhead for stdio output buffer
Date: Mon, 28 Oct 2013 16:16:38 -0300
Message-Id: <1382987801-21896-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382987801-21896-1-git-send-email-acme@infradead.org>
References: <1382987801-21896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Following commit tightened up the buffer size for output to strict width
of used format columns:

  99cf666 perf hists: Fix formatting of long symbol names

This works fine until you hit color overhead output which places extra
bytes into output buffer. We need to account for color overhead in the
output buffer. Adding maximum color byte size to the output buffer size.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382700293-1803-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c |  9 ++++-----
 tools/perf/util/hist.h     | 13 +++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 194e2f42ff5d..6c152686e837 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -315,8 +315,7 @@ static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 }
 
 static int hist_entry__period_snprintf(struct perf_hpp *hpp,
-				       struct hist_entry *he,
-				       bool color)
+				       struct hist_entry *he)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct perf_hpp_fmt *fmt;
@@ -338,7 +337,7 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 		} else
 			first = false;
 
-		if (color && fmt->color)
+		if (perf_hpp__use_color() && fmt->color)
 			ret = fmt->color(fmt, hpp, he);
 		else
 			ret = fmt->entry(fmt, hpp, he);
@@ -358,12 +357,11 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.buf		= bf,
 		.size		= size,
 	};
-	bool color = !symbol_conf.field_sep;
 
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he, color);
+	ret = hist_entry__period_snprintf(&hpp, he);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
@@ -482,6 +480,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 print_entries:
 	linesz = hists__sort_list_width(hists) + 3 + 1;
+	linesz += perf_hpp__color_overhead();
 	line = malloc(linesz);
 	if (line == NULL) {
 		ret = -1;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1329b6b6ffe6..ce8dc61ce2c3 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "color.h"
 
 extern struct callchain_param callchain_param;
 
@@ -175,6 +176,18 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+static inline size_t perf_hpp__use_color(void)
+{
+	return !symbol_conf.field_sep;
+}
+
+static inline size_t perf_hpp__color_overhead(void)
+{
+	return perf_hpp__use_color() ?
+	       (COLOR_MAXLEN + sizeof(PERF_COLOR_RESET)) * PERF_HPP__MAX_INDEX
+	       : 0;
+}
+
 struct perf_evlist;
 
 struct hist_browser_timer {
-- 
1.8.1.4

