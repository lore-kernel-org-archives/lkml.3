Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3GJTXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:23:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3GJTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/23] perf evlist: Enhance perf_evlist__start_workload()
Date: Wed, 10 Jul 2013 16:19:10 -0300
Message-Id: <1373483963-19277-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When perf tries to start a workload, it relies on a pipe which the
workload was blocked for reading.  After closing the pipe on the parent,
the workload (child) can start the actual work via exec().

However, if another process was forked after creating a workload, this
mechanism cannot work since the other process (child) also inherits the
pipe, so that closing the pipe in parent cannot unblock the workload.
Fix it by using explicit write call can then closing it.

For similar reason, the pipe fd on parent should be marked as CLOEXEC so
that it can be closed after another child exec'ed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1372230862-15861-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99b43dd..8065ce8 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -821,6 +821,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		goto out_close_pipes;
 	}
 
+	fcntl(go_pipe[1], F_SETFD, FD_CLOEXEC);
 	evlist->workload.cork_fd = go_pipe[1];
 	close(child_ready_pipe[0]);
 	return 0;
@@ -837,10 +838,17 @@ out_close_ready_pipe:
 int perf_evlist__start_workload(struct perf_evlist *evlist)
 {
 	if (evlist->workload.cork_fd > 0) {
+		char bf;
+		int ret;
 		/*
 		 * Remove the cork, let it rip!
 		 */
-		return close(evlist->workload.cork_fd);
+		ret = write(evlist->workload.cork_fd, &bf, 1);
+		if (ret < 0)
+			perror("enable to write to pipe");
+
+		close(evlist->workload.cork_fd);
+		return ret;
 	}
 
 	return 0;
-- 
1.8.1.4

