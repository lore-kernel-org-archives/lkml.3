Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaCDCmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:42:24 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56383 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbaCDCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:19 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 01/10] perf tools: Add ->cmp(), ->collapse() and ->sort() to perf_hpp_fmt
Date: Tue,  4 Mar 2014 11:42:07 +0900
Message-Id: <1393900936-22977-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those function pointers will be used to sort report output based on
the selected fields.  This is a preparation of later change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 39 +++++++++++++++++++++++++++++++++++----
 tools/perf/util/hist.h |  3 +++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 62282eaa9d71..dce3cefbb3ff 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -191,6 +191,14 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			  hpp_entry_scnprintf, true);				\
 }
 
+#define __HPP_SORT_FN(_type, _field)						\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	s64 __a = he_get_##_field(a);						\
+	s64 __b = he_get_##_field(b);						\
+	return __a - __b;							\
+}
+
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
 static u64 he_get_raw_##_field(struct hist_entry *he)				\
 {										\
@@ -205,16 +213,27 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			  hpp_entry_scnprintf, false);				\
 }
 
+#define __HPP_SORT_RAW_FN(_type, _field)					\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	s64 __a = he_get_raw_##_field(a);					\
+	s64 __b = he_get_raw_##_field(b);					\
+	return __a - __b;							\
+}
+
+
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
-__HPP_ENTRY_PERCENT_FN(_type, _field)
+__HPP_ENTRY_PERCENT_FN(_type, _field)					\
+__HPP_SORT_FN(_type, _field)
 
 #define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
-__HPP_ENTRY_RAW_FN(_type, _field)
+__HPP_ENTRY_RAW_FN(_type, _field)					\
+__HPP_SORT_RAW_FN(_type, _field)
 
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
@@ -226,19 +245,31 @@ HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
 HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
 
+static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
+			    struct hist_entry *b __maybe_unused)
+{
+	return 0;
+}
+
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
 		.color	= hpp__color_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 #define HPP__PRINT_FNS(_name)				\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0c502118cc7f..ed583e88696c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -153,6 +153,9 @@ struct perf_hpp_fmt {
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
+	int64_t (*cmp)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*collapse)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
 };
-- 
1.7.11.7

