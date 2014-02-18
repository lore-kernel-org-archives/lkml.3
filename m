Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBRVLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:11:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35745 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaBRVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:14 -0500
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
Subject: [PATCH 02/32] perf tools: Shorten sample symbol resolving function signature
Date: Tue, 18 Feb 2014 18:08:21 -0300
Message-Id: <1392757731-32619-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since three of the parameters come from the same 'struct addr_location',
rename machine__resolve_mem() to sample__resolve_mem() and pass the
that addr_location instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3f5otpssefh9l5hi1t259h8n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  2 +-
 tools/perf/util/hist.c      |  2 +-
 tools/perf/util/machine.c   | 11 +++++------
 tools/perf/util/machine.h   |  5 ++---
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8f9d6edb4674..0d381dc0e261 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -88,7 +88,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(al->machine, al->thread, sample, al->cpumode);
+	mi = sample__resolve_mem(sample, al);
 	if (!mi)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e4e6249b87d4..6240ca42abf4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -369,7 +369,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			he_stat__add_period(&he->stat, period, weight);
 
 			/*
-			 * This mem info was allocated from machine__resolve_mem
+			 * This mem info was allocated from sample__resolve_mem
 			 * and will not be used anymore.
 			 */
 			zfree(&entry->mem_info);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c872991e0f65..0d304d84afb4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1238,18 +1238,17 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 	ams->map = al.map;
 }
 
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thr,
-				      struct perf_sample *sample,
-				      u8 cpumode)
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al)
 {
 	struct mem_info *mi = zalloc(sizeof(*mi));
 
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
-	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
+	ip__resolve_ams(al->machine, al->thread, &mi->iaddr, sample->ip);
+	ip__resolve_data(al->machine, al->thread, al->cpumode,
+			 &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index f77e91e483dc..9ddacd9b3595 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -94,9 +94,8 @@ void machine__delete(struct machine *machine);
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thread,
 					    struct branch_stack *bs);
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thread,
-				      struct perf_sample *sample, u8 cpumode);
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al);
 int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
-- 
1.8.1.4

