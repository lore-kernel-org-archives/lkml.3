Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3COFuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:50:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64519 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3COFs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:57 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-dd-5142b6461fec
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/6] perf trace: Free evlist resources properly on return path
Date: Fri, 15 Mar 2013 14:48:50 +0900
Message-Id: <1363326533-3310-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The trace_run() function calls several evlist functions but misses
some pair-wise cleanup routines on return path.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 49fedb51d569..ab3ed4af1466 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -452,7 +452,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	err = trace__symbols_init(trace, evlist);
 	if (err < 0) {
 		printf("Problems initializing symbol libraries!\n");
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	perf_evlist__config(evlist, &trace->opts);
@@ -465,20 +465,20 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 						    argv, false, false);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
-			goto out_delete_evlist;
+			goto out_delete_maps;
 		}
 	}
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		printf("Couldn't create the events: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		printf("Couldn't mmap the events: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_close_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -534,7 +534,7 @@ again:
 
 	if (trace->nr_events == before) {
 		if (done)
-			goto out_delete_evlist;
+			goto out_unmap_evlist;
 
 		poll(evlist->pollfd, evlist->nr_fds, -1);
 	}
@@ -544,6 +544,12 @@ again:
 
 	goto again;
 
+out_unmap_evlist:
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
-- 
1.7.11.7

