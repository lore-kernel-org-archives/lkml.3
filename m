Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbaFCScz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:32:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFCScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:32:53 -0400
Date: Tue, 3 Jun 2014 11:32:38 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b4d3c8bd86c4eda08456691121f83b4e1db46866@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-8-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Cache cumulative callchains
Git-Commit-ID: b4d3c8bd86c4eda08456691121f83b4e1db46866
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

Commit-ID:  b4d3c8bd86c4eda08456691121f83b4e1db46866
Gitweb:     http://git.kernel.org/tip/b4d3c8bd86c4eda08456691121f83b4e1db46866
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Oct 2013 10:05:29 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:34:58 +0200

perf report: Cache cumulative callchains

It is possble that a callchain has cycles or recursive calls.  In that
case it'll end up having entries more than 100% overhead in the
output.  In order to prevent such entries, cache each callchain node
and skip if same entry already cumulated.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-8-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 37c28fc..bf03db5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -700,7 +700,22 @@ static int
 iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
 			      struct addr_location *al __maybe_unused)
 {
+	struct hist_entry **he_cache;
+
 	callchain_cursor_commit(&callchain_cursor);
+
+	/*
+	 * This is for detecting cycles or recursions so that they're
+	 * cumulated only one time to prevent entries more than 100%
+	 * overhead.
+	 */
+	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
+	if (he_cache == NULL)
+		return -ENOMEM;
+
+	iter->priv = he_cache;
+	iter->curr = 0;
+
 	return 0;
 }
 
@@ -710,6 +725,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
 
@@ -720,6 +736,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 		return -ENOMEM;
 
 	iter->he = he;
+	he_cache[iter->curr++] = he;
 
 	/*
 	 * The iter->he will be over-written after ->add_next_entry()
@@ -754,7 +771,29 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
+	struct hist_entry he_tmp = {
+		.cpu = al->cpu,
+		.thread = al->thread,
+		.comm = thread__comm(al->thread),
+		.ip = al->addr,
+		.ms = {
+			.map = al->map,
+			.sym = al->sym,
+		},
+		.parent = iter->parent,
+	};
+	int i;
+
+	/*
+	 * Check if there's duplicate entries in the callchain.
+	 * It's possible that it has cycles or recursive calls.
+	 */
+	for (i = 0; i < iter->curr; i++) {
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
+			return 0;
+	}
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
@@ -763,6 +802,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		return -ENOMEM;
 
 	iter->he = he;
+	he_cache[iter->curr++] = he;
 
 	return 0;
 }
@@ -771,7 +811,9 @@ static int
 iter_finish_cumulative_entry(struct hist_entry_iter *iter,
 			     struct addr_location *al __maybe_unused)
 {
+	zfree(&iter->priv);
 	iter->he = NULL;
+
 	return 0;
 }
 
