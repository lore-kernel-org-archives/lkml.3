Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaHNItr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:49:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaHNIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:49:44 -0400
Date: Thu, 14 Aug 2014 01:49:26 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-701937bd59cc94b6913086feb62f05ae565ff2de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix -z option behavior
Git-Commit-ID: 701937bd59cc94b6913086feb62f05ae565ff2de
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

Commit-ID:  701937bd59cc94b6913086feb62f05ae565ff2de
Gitweb:     http://git.kernel.org/tip/701937bd59cc94b6913086feb62f05ae565ff2de
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 17:16:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 17:28:07 -0300

perf top: Fix -z option behavior

The current -z option does almost nothing.  It doesn't zero the existing
samples so that we can see profiles of exited process after last
refresh.  It seems it only affects annotation.

This patch clears existing entries before processing if -z option is
given.  For this original decaying logic also moved before processing.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407831366-28892-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 23 +++++++++++++++++------
 tools/perf/util/hist.c   | 22 ++++++++++++++++++++++
 tools/perf/util/hist.h   |  1 +
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4b0e15c..87a6615 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -276,11 +276,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
+	if (top->zero) {
+		hists__delete_entries(&top->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&top->sym_evsel->hists,
+				     top->hide_user_symbols,
+				     top->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&top->sym_evsel->hists, NULL);
 	hists__output_resort(&top->sym_evsel->hists);
-	hists__decay_entries(&top->sym_evsel->hists,
-			     top->hide_user_symbols,
-			     top->hide_kernel_symbols);
+
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->print_entries - printed);
 	putchar('\n');
@@ -542,11 +548,16 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
+	if (t->zero) {
+		hists__delete_entries(&t->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&t->sym_evsel->hists,
+				     t->hide_user_symbols,
+				     t->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&t->sym_evsel->hists, NULL);
 	hists__output_resort(&t->sym_evsel->hists);
-	hists__decay_entries(&t->sym_evsel->hists,
-			     t->hide_user_symbols,
-			     t->hide_kernel_symbols);
 }
 
 static void *display_thread_tui(void *arg)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30df618..86569fa 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -277,6 +277,28 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 	}
 }
 
+void hists__delete_entries(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &hists->entries);
+
+		if (sort__need_collapse)
+			rb_erase(&n->rb_node_in, &hists->entries_collapsed);
+
+		--hists->nr_entries;
+		if (!n->filtered)
+			--hists->nr_non_filtered_entries;
+
+		hist_entry__free(n);
+	}
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 95405a8..8c9c70e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -152,6 +152,7 @@ void hists__output_resort(struct hists *hists);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
+void hists__delete_entries(struct hists *hists);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
