Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaE3Euq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:50:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59586 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaE3Euo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:50:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 18/27] perf tools: Add callback function to hist_entry_iter
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
	<1401335910-16832-19-git-send-email-namhyung@kernel.org>
	<20140529131651.GA27903@krava.brq.redhat.com>
Date: Fri, 30 May 2014 13:50:42 +0900
In-Reply-To: <20140529131651.GA27903@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 29 May 2014 15:16:51 +0200")
Message-ID: <87k393g999.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 15:16:51 +0200, Jiri Olsa wrote:
> On Thu, May 29, 2014 at 12:58:21PM +0900, Namhyung Kim wrote:
>> +static int hist_iter__report_callback(struct hist_entry_iter *iter,
>> +				      struct addr_location *al, void *arg)
>> +{
>> +	int err = 0;
>> +	struct hist_entry *he = iter->he;
>> +	struct perf_evsel *evsel = iter->evsel;
>> +	struct report *rep = arg;
>> +
>> +	if (ui__has_annotation())
>> +		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
>
> if we put the annotation stats in here, shouldn't we remove all other
> instancies of above call from:
>
>   iter_finish_normal_entry
>   iter_add_single_cumulative_entry
>   iter_finish_mem_entry

Right, they were double counted..  :-/  I changed this as below and push
to perf/cumulate-v12.  Would you please check it again?

Thanks,
Namhyung


>From 0be9139edf446a5d6d753698f42809b2212dcf76 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 7 Jan 2014 17:02:25 +0900
Subject: [PATCH] perf tools: Add callback function to hist_entry_iter

The new ->add_entry_cb() will be called after an entry was added to
the histogram.  It's used for code sharing between perf report and
perf top.  Note that ops->add_*_entry() should set iter->he properly
in order to call the ->add_entry_cb.

Also pass @arg to the callback function.  It'll be used by perf top
later.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c     | 61 ++++++++++++++++++++++++++++++++-----
 tools/perf/tests/hists_filter.c |  2 +-
 tools/perf/tests/hists_output.c |  2 +-
 tools/perf/util/hist.c          | 67 +++++++++++++++--------------------------
 tools/perf/util/hist.h          |  5 ++-
 5 files changed, 84 insertions(+), 53 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6cac509212ee..21d830bafff3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -80,14 +80,59 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static void report__inc_stats(struct report *rep,
-			      struct hist_entry *he __maybe_unused)
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
 {
 	/*
-	 * We cannot access @he at this time.  Just assume it's a new entry.
-	 * It'll be fixed once we have a callback mechanism in hist_iter.
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
 	 */
-	rep->nr_entries++;
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
+}
+
+static int hist_iter__report_callback(struct hist_entry_iter *iter,
+				      struct addr_location *al, bool single,
+				      void *arg)
+{
+	int err = 0;
+	struct report *rep = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct mem_info *mi;
+	struct branch_info *bi;
+
+	report__inc_stats(rep, he);
+
+	if (!ui__has_annotation())
+		return 0;
+
+	if (sort__mode == SORT_MODE__BRANCH) {
+		bi = he->branch_info;
+		err = addr_map_symbol__inc_samples(&bi->from, evsel->idx);
+		if (err)
+			goto out;
+
+		err = addr_map_symbol__inc_samples(&bi->to, evsel->idx);
+
+	} else if (rep->mem_mode) {
+		mi = he->mem_info;
+		err = addr_map_symbol__inc_samples(&mi->daddr, evsel->idx);
+		if (err)
+			goto out;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	} else if (symbol_conf.cumulate_callchain) {
+		if (single)
+			err = hist_entry__inc_addr_samples(he, evsel->idx,
+							   al->addr);
+	} else {
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	}
+
+out:
+	return err;
 }
 
 static int process_sample_event(struct perf_tool *tool,
@@ -100,6 +145,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct addr_location al;
 	struct hist_entry_iter iter = {
 		.hide_unresolved = rep->hide_unresolved,
+		.add_entry_cb = hist_iter__report_callback,
 	};
 	int ret;
 
@@ -127,9 +173,8 @@ static int process_sample_event(struct perf_tool *tool,
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	report__inc_stats(rep, NULL);
-
-	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack);
+	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
+				   rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 76b02e1de701..3539403bbad4 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -82,7 +82,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
 				goto out;
 
 			if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-						 PERF_MAX_STACK_DEPTH) < 0)
+						 PERF_MAX_STACK_DEPTH, NULL) < 0)
 				goto out;
 
 			fake_samples[i].thread = al.thread;
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index 1308f88a9169..d40461ecd210 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -71,7 +71,7 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 			goto out;
 
 		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-					 PERF_MAX_STACK_DEPTH) < 0)
+					 PERF_MAX_STACK_DEPTH, NULL) < 0)
 			goto out;
 
 		fake_samples[i].thread = al.thread;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c6f5f5251aad..5a0a4b2cadc4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -517,27 +517,16 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 }
 
 static int
-iter_finish_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+iter_finish_mem_entry(struct hist_entry_iter *iter,
+		      struct addr_location *al __maybe_unused)
 {
 	struct perf_evsel *evsel = iter->evsel;
 	struct hist_entry *he = iter->he;
-	struct mem_info *mx;
 	int err = -EINVAL;
 
 	if (he == NULL)
 		goto out;
 
-	if (ui__has_annotation()) {
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			goto out;
-
-		mx = he->mem_info;
-		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-		if (err)
-			goto out;
-	}
-
 	hists__inc_nr_samples(&evsel->hists, he->filtered);
 
 	err = hist_entry__append_callchain(he, iter->sample);
@@ -575,6 +564,9 @@ static int
 iter_add_single_branch_entry(struct hist_entry_iter *iter __maybe_unused,
 			     struct addr_location *al __maybe_unused)
 {
+	/* to avoid calling callback function */
+	iter->he = NULL;
+
 	return 0;
 }
 
@@ -599,7 +591,7 @@ iter_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
 static int
 iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
-	struct branch_info *bi, *bx;
+	struct branch_info *bi;
 	struct perf_evsel *evsel = iter->evsel;
 	struct hist_entry *he = NULL;
 	int i = iter->curr;
@@ -619,17 +611,6 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	if (he == NULL)
 		return -ENOMEM;
 
-	if (ui__has_annotation()) {
-		bx = he->branch_info;
-		err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-		if (err)
-			goto out;
-
-		err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-		if (err)
-			goto out;
-	}
-
 	hists__inc_nr_samples(&evsel->hists, he->filtered);
 
 out:
@@ -673,9 +654,9 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 }
 
 static int
-iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
+iter_finish_normal_entry(struct hist_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
 {
-	int err;
 	struct hist_entry *he = iter->he;
 	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
@@ -685,12 +666,6 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
 	iter->he = NULL;
 
-	if (ui__has_annotation()) {
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			return err;
-	}
-
 	hists__inc_nr_samples(&evsel->hists, he->filtered);
 
 	return hist_entry__append_callchain(he, sample);
@@ -746,13 +721,6 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	/*
-	 * The iter->he will be over-written after ->add_next_entry()
-	 * called so inc stats for the original entry now.
-	 */
-	if (ui__has_annotation())
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-
 	hists__inc_nr_samples(&evsel->hists, he->filtered);
 
 	return err;
@@ -802,8 +770,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	 * It's possible that it has cycles or recursive calls.
 	 */
 	for (i = 0; i < iter->curr; i++) {
-		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0) {
+			/* to avoid calling callback function */
+			iter->he = NULL;
 			return 0;
+		}
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
@@ -863,7 +834,7 @@ const struct hist_iter_ops hist_iter_cumulative = {
 
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth)
+			 int max_stack_depth, void *arg)
 {
 	int err, err2;
 
@@ -883,10 +854,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 	if (err)
 		goto out;
 
+	if (iter->he && iter->add_entry_cb) {
+		err = iter->add_entry_cb(iter, al, true, arg);
+		if (err)
+			goto out;
+	}
+
 	while (iter->ops->next_entry(iter, al)) {
 		err = iter->ops->add_next_entry(iter, al);
 		if (err)
 			break;
+
+		if (iter->he && iter->add_entry_cb) {
+			err = iter->add_entry_cb(iter, al, false, arg);
+			if (err)
+				goto out;
+		}
 	}
 
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 99ad3cb433fb..82b28ff98062 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,6 +119,9 @@ struct hist_entry_iter {
 	void *priv;
 
 	const struct hist_iter_ops *ops;
+	/* user-defined callback function (optional) */
+	int (*add_entry_cb)(struct hist_entry_iter *iter,
+			    struct addr_location *al, bool single, void *arg);
 };
 
 extern const struct hist_iter_ops hist_iter_normal;
@@ -135,7 +138,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth);
+			 int max_stack_depth, void *arg);
 
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
-- 
1.9.2

