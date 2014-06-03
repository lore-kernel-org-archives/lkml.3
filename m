Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaFCSce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:32:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbaFCSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:32:29 -0400
Date: Tue, 3 Jun 2014 11:32:12 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7a13aa28aa268359cee006059731f49bcd1f839e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-6-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Accumulate hist entry stat based on the callchain
Git-Commit-ID: 7a13aa28aa268359cee006059731f49bcd1f839e
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

Commit-ID:  7a13aa28aa268359cee006059731f49bcd1f839e
Gitweb:     http://git.kernel.org/tip/7a13aa28aa268359cee006059731f49bcd1f839e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 11 Sep 2012 14:13:04 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:34:57 +0200

perf hists: Accumulate hist entry stat based on the callchain

Call __hists__add_entry() for each callchain node to get an
accumulated stat for an entry.  Introduce new cumulative_iter ops to
process them properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-6-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-report.c |  2 +
 tools/perf/util/callchain.c |  3 +-
 tools/perf/util/hist.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h      |  1 +
 4 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3201bdf..e8fa9fe 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -115,6 +115,8 @@ static int process_sample_event(struct perf_tool *tool,
 		iter.ops = &hist_iter_branch;
 	else if (rep->mem_mode)
 		iter.ops = &hist_iter_mem;
+	else if (symbol_conf.cumulate_callchain)
+		iter.ops = &hist_iter_cumulative;
 	else
 		iter.ops = &hist_iter_normal;
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9a42382..2af69c4 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -616,7 +616,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 	if (sample->callchain == NULL)
 		return 0;
 
-	if (symbol_conf.use_callchain || sort__has_parent) {
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
 		return machine__resolve_callchain(al->machine, evsel, al->thread,
 						  sample, parent, al, max_stack);
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b9facf3..6079b5a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -696,6 +696,94 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 	return hist_entry__append_callchain(he, sample);
 }
 
+static int
+iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
+			      struct addr_location *al __maybe_unused)
+{
+	callchain_cursor_commit(&callchain_cursor);
+	return 0;
+}
+
+static int
+iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
+				 struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
+	int err = 0;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	iter->he = he;
+
+	/*
+	 * The iter->he will be over-written after ->add_next_entry()
+	 * called so inc stats for the original entry now.
+	 */
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
+
+	return err;
+}
+
+static int
+iter_next_cumulative_entry(struct hist_entry_iter *iter,
+			   struct addr_location *al)
+{
+	struct callchain_cursor_node *node;
+
+	node = callchain_cursor_current(&callchain_cursor);
+	if (node == NULL)
+		return 0;
+
+	al->map = node->map;
+	al->sym = node->sym;
+	if (node->map)
+		al->addr = node->map->map_ip(node->map, node->ip);
+	else
+		al->addr = node->ip;
+
+	if (iter->hide_unresolved && al->sym == NULL)
+		return 0;
+
+	callchain_cursor_advance(&callchain_cursor);
+	return 1;
+}
+
+static int
+iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
+			       struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, false);
+	if (he == NULL)
+		return -ENOMEM;
+
+	iter->he = he;
+
+	return 0;
+}
+
+static int
+iter_finish_cumulative_entry(struct hist_entry_iter *iter,
+			     struct addr_location *al __maybe_unused)
+{
+	iter->he = NULL;
+	return 0;
+}
+
 const struct hist_iter_ops hist_iter_mem = {
 	.prepare_entry 		= iter_prepare_mem_entry,
 	.add_single_entry 	= iter_add_single_mem_entry,
@@ -720,6 +808,14 @@ const struct hist_iter_ops hist_iter_normal = {
 	.finish_entry 		= iter_finish_normal_entry,
 };
 
+const struct hist_iter_ops hist_iter_cumulative = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
 			 int max_stack_depth)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bedb24d..78409f9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -124,6 +124,7 @@ struct hist_entry_iter {
 extern const struct hist_iter_ops hist_iter_normal;
 extern const struct hist_iter_ops hist_iter_branch;
 extern const struct hist_iter_ops hist_iter_mem;
+extern const struct hist_iter_ops hist_iter_cumulative;
 
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
