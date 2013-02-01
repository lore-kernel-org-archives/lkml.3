Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700Ab3BAK4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:56:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161362Ab3BAKu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:50:29 -0500
Date: Fri, 1 Feb 2013 02:49:52 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-371d8c402e8c3562e913c7fda95094f42fbcf0ef@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-12-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-12-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Add suppport for event group view
Git-Commit-ID: 371d8c402e8c3562e913c7fda95094f42fbcf0ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:49:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  371d8c402e8c3562e913c7fda95094f42fbcf0ef
Gitweb:     http://git.kernel.org/tip/371d8c402e8c3562e913c7fda95094f42fbcf0ef
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:39 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:47 -0300

perf hists browser: Add suppport for event group view

Show group members' overhead also when showing the leader's if event
group is enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-12-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 852e4e1..d7112df 100644
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
 
