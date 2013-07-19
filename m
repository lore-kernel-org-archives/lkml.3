Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846Ab3GSHoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:44:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649Ab3GSHov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:44:51 -0400
Date: Fri, 19 Jul 2013 00:44:27 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d4ae0a6f7c79be64c8f3551dd149189f8c4480eb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1372161253-22081-6-git-send-email-jolsa@redhat.com>
References: <1372161253-22081-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Fix perf_session__delete removal
Git-Commit-ID: d4ae0a6f7c79be64c8f3551dd149189f8c4480eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:44:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4ae0a6f7c79be64c8f3551dd149189f8c4480eb
Gitweb:     http://git.kernel.org/tip/d4ae0a6f7c79be64c8f3551dd149189f8c4480eb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 25 Jun 2013 13:54:13 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:07 -0300

perf report: Fix perf_session__delete removal

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
 
