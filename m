Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaBRVLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:11:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaBRVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:13 -0500
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
Subject: [PATCH 01/32] perf report: Use al->cpumode where applicable
Date: Tue, 18 Feb 2014 18:08:20 -0300
Message-Id: <1392757731-32619-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We don't need to recalculate cpumode from the perf_event->header field,
as this is already available in the struct addr_location->cpumode field.

Remove the function signature of functions that receive both perf_event
and addr_location parameters but use perf_event just to extract the
cpumode.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tmct07y7mka54allj82trlnx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3c53ec268fbc..8f9d6edb4674 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -76,12 +76,10 @@ static int report__config(const char *var, const char *value, void *cb)
 }
 
 static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      union perf_event *event)
+				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
@@ -90,7 +88,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
+	mi = machine__resolve_mem(al->machine, al->thread, sample, al->cpumode);
 	if (!mi)
 		return -ENOMEM;
 
@@ -240,7 +238,7 @@ static int process_sample_event(struct perf_tool *tool,
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
+		ret = report__add_mem_hist_entry(tool, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {
-- 
1.8.1.4

