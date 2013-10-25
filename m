Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3JYLjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3JYLjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:39:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf hists: Add color overhead for stdio output buffer
Date: Fri, 25 Oct 2013 13:24:53 +0200
Message-Id: <1382700293-1803-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit tightened up the buffer size for output
to strict width of used format columns:
  99cf666 perf hists: Fix formatting of long symbol names

This works fine until you hit color overhead output which
places extra bytes into output buffer. We need to account
for color overhead in the output buffer. Adding maximum
color byte size to the output buffer size.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c |  9 ++++-----
 tools/perf/util/hist.h     | 13 +++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 194e2f4..6c15268 100644
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
index 0c7ce8b..9d2d022 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "color.h"
 #include "ui/progress.h"
 
 extern struct callchain_param callchain_param;
@@ -180,6 +181,18 @@ void perf_hpp__init(void);
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
1.7.11.7

