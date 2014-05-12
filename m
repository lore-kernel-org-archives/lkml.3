Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaELGdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:33:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57337 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaELG3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:00 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 03/20] perf tools: Use hpp formats to sort hist entries
Date: Mon, 12 May 2014 15:28:36 +0900
Message-Id: <1399876133-17963-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
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
index 7f0236cea4fe..38373c986e97 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -432,11 +432,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
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
@@ -447,15 +447,11 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
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

