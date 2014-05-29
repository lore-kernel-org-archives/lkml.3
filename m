Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaE2EDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:03:03 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53352 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaE2D6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 11/27] perf ui/browser: Add support to accumulated hist stat
Date: Thu, 29 May 2014 12:58:14 +0900
Message-Id: <1401335910-16832-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print accumulated stat of a hist entry if requested.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1c331b934ffc..2dcbe3d15a5f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -651,13 +651,36 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 			  __hpp__slsmg_color_printf, true);		\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)			\
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
+	if (!symbol_conf.cumulate_callchain) {				\
+		int ret = scnprintf(hpp->buf, hpp->size, "%8s", "N/A");	\
+		slsmg_printf("%s", hpp->buf);				\
+									\
+		return ret;						\
+	}								\
+	return __hpp__fmt(hpp, he, __hpp_get_acc_##_field, " %6.2f%%",	\
+			  __hpp__slsmg_color_printf, true);		\
+}
+
 __HPP_COLOR_PERCENT_FN(overhead, period)
 __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
 __HPP_COLOR_PERCENT_FN(overhead_us, period_us)
 __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
 __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period)
 
 #undef __HPP_COLOR_PERCENT_FN
+#undef __HPP_COLOR_ACC_PERCENT_FN
 
 void hist_browser__init_hpp(void)
 {
@@ -671,6 +694,8 @@ void hist_browser__init_hpp(void)
 				hist_browser__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				hist_browser__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				hist_browser__hpp_color_overhead_acc;
 }
 
 static int hist_browser__show_entry(struct hist_browser *browser,
-- 
1.9.2

