Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaDPDKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:10:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59889 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaDPDF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 04/17] perf tools: Support event grouping in hpp ->sort()
Date: Wed, 16 Apr 2014 12:05:41 +0900
Message-Id: <1397617554-26319-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move logic of hist_entry__sort_on_period to __hpp__sort() in order to
support event group report.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a6eea666b443..c65a7fd744c6 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -116,6 +116,62 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	return ret;
 }
 
+static int field_cmp(u64 field_a, u64 field_b)
+{
+	if (field_a > field_b)
+		return 1;
+	if (field_a < field_b)
+		return -1;
+	return 0;
+}
+
+static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
+		       hpp_field_fn get_field)
+{
+	s64 ret;
+	int i, nr_members;
+	struct perf_evsel *evsel;
+	struct hist_entry *pair;
+	u64 *fields_a, *fields_b;
+
+	ret = field_cmp(get_field(a), get_field(b));
+	if (ret || !symbol_conf.event_group)
+		return ret;
+
+	evsel = hists_to_evsel(a->hists);
+	if (!perf_evsel__is_group_event(evsel))
+		return ret;
+
+	nr_members = evsel->nr_members;
+	fields_a = calloc(sizeof(*fields_a), nr_members);
+	fields_b = calloc(sizeof(*fields_b), nr_members);
+
+	if (!fields_a || !fields_b)
+		goto out;
+
+	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		fields_a[perf_evsel__group_idx(evsel)] = get_field(pair);
+	}
+
+	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		fields_b[perf_evsel__group_idx(evsel)] = get_field(pair);
+	}
+
+	for (i = 1; i < nr_members; i++) {
+		ret = fields_a[i] - fields_b[i];
+		if (ret)
+			break;
+	}
+
+out:
+	free(fields_a);
+	free(fields_b);
+
+	return ret;
+}
+
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
 			       struct perf_hpp *hpp,			\
@@ -195,9 +251,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 #define __HPP_SORT_FN(_type, _field)						\
 static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
 {										\
-	s64 __a = he_get_##_field(a);						\
-	s64 __b = he_get_##_field(b);						\
-	return __a - __b;							\
+	return __hpp__sort(a, b, he_get_##_field);				\
 }
 
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
@@ -217,9 +271,7 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 #define __HPP_SORT_RAW_FN(_type, _field)					\
 static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
 {										\
-	s64 __a = he_get_raw_##_field(a);					\
-	s64 __b = he_get_raw_##_field(b);					\
-	return __a - __b;							\
+	return __hpp__sort(a, b, he_get_raw_##_field);				\
 }
 
 
-- 
1.9.2

