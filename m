Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaAHIwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:52:03 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47900 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaAHIqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:49 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-1c-52cd106f8212
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 15/28] perf ui/browser: Add support to accumulated hist stat
Date: Wed,  8 Jan 2014 17:46:20 +0900
Message-Id: <1389170793-21926-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print accumulated stat of a hist entry if requested.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a7045ea6d1d5..250f42b1ad81 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -693,11 +693,26 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field, _cb)			\
+static u64 __hpp_get_acc_##_field(struct hist_entry *he)		\
+{									\
+	return he->stat_acc->_field;					\
+}									\
+									\
+static int								\
+hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
+				struct perf_hpp *hpp,			\
+				struct hist_entry *he)			\
+{									\
+	return __hpp__color_fmt(hpp, he, __hpp_get_acc_##_field, _cb);	\
+}
+
 __HPP_COLOR_PERCENT_FN(overhead, period, __hpp__color_callchain)
 __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, NULL)
 __HPP_COLOR_PERCENT_FN(overhead_us, period_us, NULL)
 __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, NULL)
 __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period, NULL)
 
 #undef __HPP_COLOR_PERCENT_FN
 
@@ -715,6 +730,8 @@ void hist_browser__init_hpp(void)
 				hist_browser__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				hist_browser__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				hist_browser__hpp_color_overhead_acc;
 }
 
 static int hist_browser__show_entry(struct hist_browser *browser,
-- 
1.7.11.7

