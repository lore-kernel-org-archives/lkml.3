Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaFANhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbaFANcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:05 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 12/27] perf ui/gtk: Add support to accumulated hist stat
Date: Sun,  1 Jun 2014 15:31:23 +0200
Message-Id: <1401629498-8726-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Print accumulated stat of a hist entry if requested.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-13-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 9d90683..7e5da4a 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -47,11 +47,26 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 			  __percent_color_snprintf, true);			\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+static u64 he_get_acc_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat_acc->_field;						\
+}										\
+										\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+				       struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
+{										\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+			      __percent_color_snprintf, true);			\
+}
+
 __HPP_COLOR_PERCENT_FN(overhead, period)
 __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
 __HPP_COLOR_PERCENT_FN(overhead_us, period_us)
 __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
 __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period)
 
 #undef __HPP_COLOR_PERCENT_FN
 
@@ -68,6 +83,8 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				perf_gtk__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				perf_gtk__hpp_color_overhead_acc;
 }
 
 static void callchain_list__sym_name(struct callchain_list *cl,
-- 
1.8.3.1

