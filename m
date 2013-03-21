Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3CULod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:44:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab3CULoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:44:30 -0400
Date: Thu, 21 Mar 2013 04:42:58 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3beb0861438f63bc2025f8afba213dc3d0458bc5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363326533-3310-3-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Free evlist resources properly on return path
Git-Commit-ID: 3beb0861438f63bc2025f8afba213dc3d0458bc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:43:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3beb0861438f63bc2025f8afba213dc3d0458bc5
Gitweb:     http://git.kernel.org/tip/3beb0861438f63bc2025f8afba213dc3d0458bc5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 15 Mar 2013 14:48:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:11 -0300

perf trace: Free evlist resources properly on return path

The trace_run() function calls several evlist functions but misses some
pair-wise cleanup routines on return path.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363326533-3310-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 49fedb5..ab3ed4a 100644
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
