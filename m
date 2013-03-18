Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3CRQ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:28:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49428
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab3CRQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:26:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 47/54] perf trace: Free evlist resources properly on return path
Date: Mon, 18 Mar 2013 13:25:32 -0300
Message-Id: <1363623939-10748-48-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 tools/perf/builtin-trace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

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
-- 
1.7.1

