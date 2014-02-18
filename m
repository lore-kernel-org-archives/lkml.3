Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaBRVMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:12:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35729 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBRVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/32] perf tools: Shorten sample symbol resolving function signature
Date: Tue, 18 Feb 2014 18:08:22 -0300
Message-Id: <1392757731-32619-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since two of the parameters come from the same 'struct
addr_location', rename machine__resolve_bstack() to sample__resolve_bstack()
and pass the that addr_location instead.

This is also for consistency with the same change that resulted in the
sample__resolve_mem() function.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-99ecqt8jiyyksiyx3se7l5ia@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  3 +--
 tools/perf/util/hist.c      |  2 +-
 tools/perf/util/machine.c   | 13 ++++++-------
 tools/perf/util/machine.h   |  5 ++---
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d381dc0e261..6b7a0a0b4fda 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -140,8 +140,7 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 	if (err)
 		return err;
 
-	bi = machine__resolve_bstack(al->machine, al->thread,
-				     sample->branch_stack);
+	bi = sample__resolve_bstack(sample, al);
 	if (!bi)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6240ca42abf4..0466efa71140 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -290,7 +290,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 		if (he->branch_info) {
 			/*
 			 * This branch info is (a part of) allocated from
-			 * machine__resolve_bstack() and will be freed after
+			 * sample__resolve_bstack() and will be freed after
 			 * adding new entries.  So we need to save a copy.
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0d304d84afb4..6c08ab03a697 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1254,20 +1254,19 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	return mi;
 }
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thr,
-					    struct branch_stack *bs)
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al)
 {
-	struct branch_info *bi;
 	unsigned int i;
+	const struct branch_stack *bs = sample->branch_stack;
+	struct branch_info *bi = calloc(bs->nr, sizeof(struct branch_info));
 
-	bi = calloc(bs->nr, sizeof(struct branch_info));
 	if (!bi)
 		return NULL;
 
 	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(machine, thr, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(machine, thr, &bi[i].from, bs->entries[i].from);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].from, bs->entries[i].from);
 		bi[i].flags = bs->entries[i].flags;
 	}
 	return bi;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 9ddacd9b3595..2e6c248c870f 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -91,9 +91,8 @@ void machine__delete_dead_threads(struct machine *machine);
 void machine__delete_threads(struct machine *machine);
 void machine__delete(struct machine *machine);
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thread,
-					    struct branch_stack *bs);
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al);
 struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 				     struct addr_location *al);
 int machine__resolve_callchain(struct machine *machine,
-- 
1.8.1.4

