Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaDPDF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:05:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59902 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaDPDF4 (ORCPT
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
Subject: [PATCH 03/17] perf tools: Use hpp formats to sort hist entries
Date: Wed, 16 Apr 2014 12:05:40 +0900
Message-Id: <1397617554-26319-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It wrapped sort entries to hpp functions, so using the hpp sort list
to sort entries.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a892477aa50..fd9576e16bbe 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -437,11 +437,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->se_cmp(left, right);
+	perf_hpp__for_each_sort_list(fmt) {
+		cmp = fmt->cmp(left, right);
 		if (cmp)
 			break;
 	}
@@ -452,15 +452,11 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 int64_t
 hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->se_collapse ?: se->se_cmp;
-
-		cmp = f(left, right);
+	perf_hpp__for_each_sort_list(fmt) {
+		cmp = fmt->collapse(left, right);
 		if (cmp)
 			break;
 	}
-- 
1.9.2

