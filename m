Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBVR5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:57:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaBVR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:57:01 -0500
Date: Sat, 22 Feb 2014 09:56:17 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-xz8p659sjpad396vye5t24gx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Remove some needless container_of usage
Git-Commit-ID: 106395dfda0397a6a88cc309bb7beb1fdf2ed798
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

Commit-ID:  106395dfda0397a6a88cc309bb7beb1fdf2ed798
Gitweb:     http://git.kernel.org/tip/106395dfda0397a6a88cc309bb7beb1fdf2ed798
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 22 Jan 2014 13:21:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:46 -0300

perf report: Remove some needless container_of usage

Since all it wants is to get the 'struct record' from the received
'struct perf_tool', and this is already done at the callers of these
functions, short circuit it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xz8p659sjpad396vye5t24gx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6b7a0a0..d882b6f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,10 +75,9 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
+static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
@@ -127,10 +126,9 @@ out:
 	return err;
 }
 
-static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
+static int report__add_branch_hist_entry(struct report *rep, struct addr_location *al,
 					 struct perf_sample *sample, struct perf_evsel *evsel)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	unsigned i;
 	struct hist_entry *he;
@@ -181,10 +179,9 @@ out:
 	return err;
 }
 
-static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
+static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 				  struct addr_location *al, struct perf_sample *sample)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
 	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
@@ -233,18 +230,18 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
+		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel);
+		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		ret = report__add_hist_entry(tool, evsel, &al, sample);
+		ret = report__add_hist_entry(rep, evsel, &al, sample);
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
