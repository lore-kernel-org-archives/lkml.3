Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbaFCSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:33:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbaFCSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:33:43 -0400
Date: Tue, 3 Jun 2014 11:33:27 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-0434ddd21466a61cfc539ffc3a4cb3bdc67d82ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-12-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-12-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/browser:
  Add support to accumulated hist stat
Git-Commit-ID: 0434ddd21466a61cfc539ffc3a4cb3bdc67d82ec
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

Commit-ID:  0434ddd21466a61cfc539ffc3a4cb3bdc67d82ec
Gitweb:     http://git.kernel.org/tip/0434ddd21466a61cfc539ffc3a4cb3bdc67d82ec
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 30 Oct 2013 16:12:59 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:01 +0200

perf ui/browser: Add support to accumulated hist stat

Print accumulated stat of a hist entry if requested.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-12-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1c331b9..2dcbe3d 100644
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
