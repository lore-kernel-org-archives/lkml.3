Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaEWKJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:09:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49131 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaEWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:35 -0400
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
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 13/26] perf tools: Add more hpp helper functions
Date: Fri, 23 May 2014 19:04:10 +0900
Message-Id: <1400839463-21933-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it needs to disable some columns at runtime.  Add help
functions to support that.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 17 +++++++++++++++++
 tools/perf/util/hist.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0ce3e79b2ca7..8ca638754acc 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -489,6 +489,11 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format)
 	list_add_tail(&format->list, &perf_hpp__list);
 }
 
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format)
+{
+	list_del(&format->list);
+}
+
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format)
 {
 	list_add_tail(&format->sort_list, &perf_hpp__sort_list);
@@ -500,6 +505,18 @@ void perf_hpp__column_enable(unsigned col)
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
 void perf_hpp__setup_output_field(void)
 {
 	struct perf_hpp_fmt *fmt;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ad955fbd194f..e8efb43b2355 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -237,7 +237,11 @@ enum {
 
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__column_disable(unsigned col);
+void perf_hpp__cancel_cumulate(void);
+
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
 void perf_hpp__setup_output_field(void);
 void perf_hpp__reset_output_field(void);
-- 
1.9.2

