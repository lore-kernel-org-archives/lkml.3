Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3LRFWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:22:03 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48783 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3LRFVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:33 -0500
X-AuditID: 9c93017d-b7c5eae000004296-36-52b130d96a16
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 16/18] perf tools: Add more hpp helper functions
Date: Wed, 18 Dec 2013 14:21:24 +0900
Message-Id: <1387344086-12744-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it needs to disable some columns at runtime.  Add help
functions to support that.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 17 +++++++++++++++++
 tools/perf/util/hist.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b365260645d3..2a076dd86518 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -275,12 +275,29 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format)
 	list_add_tail(&format->list, &perf_hpp__list);
 }
 
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format)
+{
+	list_del(&format->list);
+}
+
 void perf_hpp__column_enable(unsigned col)
 {
 	BUG_ON(col >= PERF_HPP__MAX_INDEX);
 	perf_hpp__column_register(&perf_hpp__format[col]);
 }
 
+void perf_hpp__column_disable(unsigned col)
+{
+	BUG_ON(col >= PERF_HPP__MAX_INDEX);
+	perf_hpp__column_unregister(&perf_hpp__format[col]);
+}
+
+void perf_hpp__cancel_cumulate(void)
+{
+	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
+	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
+}
+
 int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			      struct hists *hists)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 60134e79103d..5a3bccb5413e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -169,7 +169,10 @@ enum {
 
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__column_disable(unsigned col);
+void perf_hpp__cancel_cumulate(void);
 
 static inline size_t perf_hpp__use_color(void)
 {
-- 
1.7.11.7

