Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FZHRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:17:02 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57313 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3FZHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:29 -0400
X-AuditID: 9c930179-b7cafae000004567-96-51ca94d24efd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/19] perf evlist: Enhance perf_evlist__start_workload()
Date: Wed, 26 Jun 2013 16:14:15 +0900
Message-Id: <1372230862-15861-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When perf tries to start a workload, it relies on a pipe which the
workload was blocked for reading.  After closing the pipe on the
parent, the workload (child) can start the actual work via exec().

However, if another process was forked after creating a workload, this
mechanism cannot work since the other process (child) also inherits
the pipe, so that closing the pipe in parent cannot unblock the
workload.  Fix it by using explicit write call can then closing it.

For similar reason, the pipe fd on parent should be marked as CLOEXEC
so that it can be closed after another child exec'ed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 89aea20984ca..4a901be599ed 100644
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
1.7.11.7

