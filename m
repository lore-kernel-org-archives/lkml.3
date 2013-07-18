Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab3GRUC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:02:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450Ab3GRTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/76] perf report: Fix perf_session__delete removal
Date: Thu, 18 Jul 2013 16:48:59 -0300
Message-Id: <1374177003-3706-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

There's no point of having out_delete label with perf_session__delete
call within __cmd_report function, because it's called at the end of the
cmd_report function.

The speed up due to commenting out the perf_session__delete at the end
does not seem relevant anymore. Measured speedup for ~1GB data file with
222466 FORKS events is around 0.5%.

  $ perf report -i perf.data.delete -P perf_session__delete -s parent

  +  99.51%  [other]
  +   0.49%  perf_session__delete

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372161253-22081-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6ab49da..ee2ca3e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -497,7 +497,7 @@ static int __cmd_report(struct perf_report *rep)
 		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
 					       rep->cpu_bitmap);
 		if (ret)
-			goto out_delete;
+			return ret;
 	}
 
 	if (use_browser <= 0)
@@ -508,11 +508,11 @@ static int __cmd_report(struct perf_report *rep)
 
 	ret = perf_report__setup_sample_type(rep);
 	if (ret)
-		goto out_delete;
+		return ret;
 
 	ret = perf_session__process_events(session, &rep->tool);
 	if (ret)
-		goto out_delete;
+		return ret;
 
 	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
 	kernel_kmap = map__kmap(kernel_map);
@@ -547,7 +547,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
-		goto out_delete;
+		return 0;
 	}
 
 	nr_samples = 0;
@@ -572,7 +572,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (nr_samples == 0) {
 		ui__error("The %s file has no samples!\n", session->filename);
-		goto out_delete;
+		return 0;
 	}
 
 	list_for_each_entry(pos, &session->evlist->entries, node)
@@ -598,19 +598,6 @@ static int __cmd_report(struct perf_report *rep)
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
 
-out_delete:
-	/*
-	 * Speed up the exit process, for large files this can
-	 * take quite a while.
-	 *
-	 * XXX Enable this when using valgrind or if we ever
-	 * librarize this command.
-	 *
-	 * Also experiment with obstacks to see how much speed
-	 * up we'll get here.
-	 *
- 	 * perf_session__delete(session);
- 	 */
 	return ret;
 }
 
-- 
1.8.1.4

