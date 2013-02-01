Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422795Ab3BAKv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:51:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422779Ab3BAKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:20 -0500
Date: Fri, 1 Feb 2013 02:51:03 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-cb16008bcc6ea53617ca06c9eb4ab0ecafe04585@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, eranina@google.com, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, eranina@google.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1358845787-1350-13-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/browser:
  Add support for event group view
Git-Commit-ID: cb16008bcc6ea53617ca06c9eb4ab0ecafe04585
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:51:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb16008bcc6ea53617ca06c9eb4ab0ecafe04585
Gitweb:     http://git.kernel.org/tip/cb16008bcc6ea53617ca06c9eb4ab0ecafe04585
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:47 -0300

perf gtk/browser: Add support for event group view

Show group members's overhead also when showing leader's if event
group is enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranina@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 38be79d..c87a98c 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,8 +8,7 @@
 
 #define MAX_COLUMNS			32
 
-static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
-					    double percent)
+static int __percent_color_snprintf(char *buf, size_t size, double percent)
 {
 	int ret = 0;
 	const char *markup;
@@ -18,7 +17,7 @@ static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
+	ret += scnprintf(buf + ret, size - ret, " %6.2f%%", percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -37,7 +36,55 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);
+	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
+
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			return ret;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			while (idx_delta--) {
+				/*
+				 * zero-fill group members in the middle which
+				 * have no sample
+				 */
+				ret += __percent_color_snprintf(hpp->buf + ret,
+								hpp->size - ret,
+								0.0);
+			}
+
+			percent = 100.0 * period / total;
+			ret += __percent_color_snprintf(hpp->buf + ret,
+							hpp->size - ret,
+							percent);
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
+			ret += __percent_color_snprintf(hpp->buf + ret,
+							hpp->size - ret,
+							0.0);
+		}
+	}
 	return ret;
 }
 
@@ -96,6 +143,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
+		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
