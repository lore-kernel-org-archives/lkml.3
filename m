Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3AVJK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:10:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3AVJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:10:52 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-c2-50fe579636e1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/19] perf hist browser: Add suppport for event group view
Date: Tue, 22 Jan 2013 18:09:39 +0900
Message-Id: <1358845787-1350-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members' overhead also when showing the leader's if event
group is enabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 852e4e10c7c4..d7112dfa89cc 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -602,6 +602,63 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 	slsmg_printf("%s", hpp->buf);
 
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			goto out;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			if (!total)
+				continue;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			while (idx_delta--) {
+				/*
+				 * zero-fill group members in the middle which
+				 * have no sample
+				 */
+				ui_browser__set_percent_color(arg->b, 0.0,
+							arg->current_entry);
+				ret += scnprintf(hpp->buf, hpp->size,
+						 " %6.2f%%", 0.0);
+				slsmg_printf("%s", hpp->buf);
+			}
+
+			percent = 100.0 * period / total;
+			ui_browser__set_percent_color(arg->b, percent,
+						      arg->current_entry);
+			ret += scnprintf(hpp->buf, hpp->size,
+					 " %6.2f%%", percent);
+			slsmg_printf("%s", hpp->buf);
+
+			prev_idx = perf_evsel__group_idx(evsel);
+		}
+
+		idx_delta = nr_members - prev_idx - 1;
+
+		while (idx_delta--) {
+			/*
+			 * zero-fill group members at last which have no sample
+			 */
+			ui_browser__set_percent_color(arg->b, 0.0,
+						      arg->current_entry);
+			ret += scnprintf(hpp->buf, hpp->size,
+					 " %6.2f%%", 0.0);
+			slsmg_printf("%s", hpp->buf);
+		}
+	}
+out:
 	if (!arg->current_entry || !arg->b->navkeypressed)
 		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
 
-- 
1.7.11.7

