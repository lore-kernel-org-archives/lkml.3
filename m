Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaEVMVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaEVMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:14 -0400
Date: Thu, 22 May 2014 05:21:03 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f156d84e427c9e1a855a4bb41156c7d82d87fb47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-5-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Support event grouping in hpp ->sort(
 )
Git-Commit-ID: f156d84e427c9e1a855a4bb41156c7d82d87fb47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f156d84e427c9e1a855a4bb41156c7d82d87fb47
Gitweb:     http://git.kernel.org/tip/f156d84e427c9e1a855a4bb41156c7d82d87fb47
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 14:14:03 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:34 +0200

perf tools: Support event grouping in hpp ->sort()

Move logic of hist_entry__sort_on_period to __hpp__sort() in order to
support event group report.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-5-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a6eea66..0299385 100644
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
+		ret = field_cmp(fields_a[i], fields_b[i]);
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
 
 
