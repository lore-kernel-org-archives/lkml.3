Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387Ab3E3QPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:15:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50810 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323Ab3E3QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/66] perf hists: Move locking to its call-sites
Date: Thu, 30 May 2013 19:00:54 +0300
Message-Id: <1369929699-8724-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a preparation patch to eliminate unneeded locking in the perf
report path.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 26 ++++++++++++++------------
 tools/perf/builtin-top.c    |  3 +++
 tools/perf/util/hist.c      |  6 +-----
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d45bf9b..63febd2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -297,6 +297,7 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct addr_location al;
+	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  rep->annotate_init) < 0) {
@@ -311,28 +312,29 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
+	pthread_mutex_lock(&evsel->hists.lock);
+
 	if (sort__mode == SORT_MODE__BRANCH) {
-		if (perf_report__add_branch_hist_entry(tool, &al, sample,
-						       evsel, machine)) {
+		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
+							 evsel, machine);
+		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
-			return -1;
-		}
 	} else if (rep->mem_mode == 1) {
-		if (perf_report__add_mem_hist_entry(tool, &al, sample,
-						    evsel, machine, event)) {
+		ret = perf_report__add_mem_hist_entry(tool, &al, sample,
+						      evsel, machine, event);
+		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
-			return -1;
-		}
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
+		ret = perf_evsel__add_hist_entry(evsel, &al, sample, machine);
+		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
-			return -1;
-		}
 	}
-	return 0;
+	pthread_mutex_unlock(&evsel->hists.lock);
+
+	return ret;
 }
 
 static int process_read_event(struct perf_tool *tool,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5cd41ec..c2c9734 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -245,8 +245,11 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
+	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
 				sample->weight);
+	pthread_mutex_unlock(&evsel->hists.lock);
+
 	if (he == NULL)
 		return NULL;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7e0fa62..b11a6cf 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -347,8 +347,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	struct hist_entry *he;
 	int cmp;
 
-	pthread_mutex_lock(&hists->lock);
-
 	p = &hists->entries_in->rb_node;
 
 	while (*p != NULL) {
@@ -394,14 +392,12 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 	he = hist_entry__new(entry);
 	if (!he)
-		goto out_unlock;
+		return NULL;
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
-out_unlock:
-	pthread_mutex_unlock(&hists->lock);
 	return he;
 }
 
-- 
1.8.1.4

