Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3AaRaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:30:10 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60084
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/25] perf ui/hist: Add support for event group view
Date: Thu, 31 Jan 2013 14:25:14 -0300
Message-Id: <1359653128-10433-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group member's overhead also when showing the leader's if event
group is enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c       | 62 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/stdio/hist.c |  2 ++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 849c400..a47ce98 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -21,6 +21,53 @@ static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
 	ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			return ret;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			if (!total)
+				continue;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			while (idx_delta--) {
+				/*
+				 * zero-fill group members in the middle which
+				 * have no sample
+				 */
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 0.0);
+			}
+
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, 100.0 * period / total);
+
+			prev_idx = perf_evsel__group_idx(evsel);
+		}
+
+		idx_delta = nr_members - prev_idx - 1;
+
+		while (idx_delta--) {
+			/*
+			 * zero-fill group members at last which have no sample
+			 */
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, 0.0);
+		}
+	}
 	return ret;
 }
 
@@ -40,6 +87,11 @@ static int hpp__header_##_type(struct perf_hpp *hpp)			\
 {									\
 	int len = _min_width;						\
 									\
+	if (symbol_conf.event_group) {					\
+		struct perf_evsel *evsel = hpp->ptr;			\
+									\
+		len = max(len, evsel->nr_members * _unit_width);	\
+	}								\
 	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
 }
 
@@ -48,6 +100,11 @@ static int hpp__width_##_type(struct perf_hpp *hpp __maybe_unused)	\
 {									\
 	int len = _min_width;						\
 									\
+	if (symbol_conf.event_group) {					\
+		struct perf_evsel *evsel = hpp->ptr;			\
+									\
+		len = max(len, evsel->nr_members * _unit_width);	\
+	}								\
 	return len;							\
 }
 
@@ -438,12 +495,15 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	int i = 0, ret = 0;
+	struct perf_hpp dummy_hpp = {
+		.ptr	= hists_to_evsel(hists),
+	};
 
 	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(NULL);
+		ret += fmt->width(&dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index f979829..ff1f60c 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -3,6 +3,7 @@
 #include "../../util/util.h"
 #include "../../util/hist.h"
 #include "../../util/sort.h"
+#include "../../util/evsel.h"
 
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -347,6 +348,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
+		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 
-- 
1.8.1.1.361.gec3ae6e

