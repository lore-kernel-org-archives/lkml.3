Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaANF3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:29:33 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53535 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaANF0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:06 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-a2-52d4ca675cdb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/24] perf ui/hist: Add support to accumulated hist stat
Date: Tue, 14 Jan 2014 14:25:46 +0900
Message-Id: <1389677157-30513-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print accumulated stat of a hist entry if requested.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h |  1 +
 2 files changed, 46 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 78f4c92e9b73..eb9c07bcdb01 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -129,6 +129,28 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			  scnprintf, true);					\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+static u64 he_get_acc_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat_acc->_field;						\
+}										\
+										\
+static int hpp__color_acc_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	return __hpp__fmt(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+			  (hpp_snprint_fn)percent_color_snprintf, true);	\
+}
+
+#define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
+static int hpp__entry_acc_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,	\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
+	return __hpp__fmt(hpp, he, he_get_acc_##_field, fmt,			\
+			  scnprintf, true);					\
+}
+
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
 static u64 he_get_raw_##_field(struct hist_entry *he)				\
 {										\
@@ -148,17 +170,25 @@ __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
 __HPP_ENTRY_PERCENT_FN(_type, _field)
 
+#define HPP_PERCENT_ACC_FNS(_type, _str, _field, _min_width, _unit_width)\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+__HPP_ENTRY_ACC_PERCENT_FN(_type, _field)
+
 #define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_ENTRY_RAW_FN(_type, _field)
 
+__HPP_HEADER_FN(overhead_self, "Self", 8, 8)
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
 HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
 HPP_PERCENT_FNS(overhead_us, "usr", period_us, 8, 8)
 HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys, 9, 8)
 HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
+HPP_PERCENT_ACC_FNS(overhead_acc, "Children", period, 8, 8)
 
 HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
@@ -171,6 +201,14 @@ HPP_RAW_FNS(period, "Period", period, 12, 12)
 		.entry	= hpp__entry_ ## _name		\
 	}
 
+#define HPP__COLOR_ACC_PRINT_FNS(_name)			\
+	{						\
+		.header	= hpp__header_ ## _name,	\
+		.width	= hpp__width_ ## _name,		\
+		.color	= hpp__color_acc_ ## _name,	\
+		.entry	= hpp__entry_acc_ ## _name	\
+	}
+
 #define HPP__PRINT_FNS(_name)				\
 	{						\
 		.header	= hpp__header_ ## _name,	\
@@ -184,6 +222,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	HPP__COLOR_PRINT_FNS(overhead_us),
 	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
 	HPP__COLOR_PRINT_FNS(overhead_guest_us),
+	HPP__COLOR_ACC_PRINT_FNS(overhead_acc),
 	HPP__PRINT_FNS(samples),
 	HPP__PRINT_FNS(period)
 };
@@ -208,6 +247,12 @@ void perf_hpp__init(void)
 {
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 
+	if (symbol_conf.cumulate_callchain) {
+		perf_hpp__format[PERF_HPP__OVERHEAD].header =
+						hpp__header_overhead_self;
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD_ACC);
+	}
+
 	if (symbol_conf.show_cpu_utilization) {
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_SYS);
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_US);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 091bf81df8c3..59d8ba4665a4 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -199,6 +199,7 @@ enum {
 	PERF_HPP__OVERHEAD_US,
 	PERF_HPP__OVERHEAD_GUEST_SYS,
 	PERF_HPP__OVERHEAD_GUEST_US,
+	PERF_HPP__OVERHEAD_ACC,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
 
-- 
1.7.11.7

