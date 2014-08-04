Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHDQSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:38698 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHDQSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:12 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/33] perf evlist: Don't run workload if not told to
Date: Mon,  4 Aug 2014 13:17:13 -0300
Message-Id: <1407169064-25625-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_evlist__prepare_workload() method works by forking and then
waiting on a fd that must be written to to allow the workload to be
exec()ed.

But if the tool calling it fails to, say, set up the events with which
it wants to sample the workload for, it will not call
perf_evlist__start_workload(), but even in this case the workload ended
up running:

  [acme@zoo linux]$ trace /bin/echo workload ends up running, it should not...
  Couldn't mmap the events: Operation not permitted
  workload ends up running, it should not...
  [acme@zoo linux]$

So check if at least one byte was written before letting exec() be
called.

Now the expected behaviour:

  [acme@zoo linux]$ trace /bin/echo workload ends up running, it should not...
  Couldn't mmap the events: Operation not permitted
  [acme@zoo linux]$

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-oh1ixo8m74rf295a05gfjw8b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 814e954c1318..3b366c085021 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1061,6 +1061,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 	}
 
 	if (!evlist->workload.pid) {
+		int ret;
+
 		if (pipe_output)
 			dup2(2, 1);
 
@@ -1078,8 +1080,22 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		/*
 		 * Wait until the parent tells us to go.
 		 */
-		if (read(go_pipe[0], &bf, 1) == -1)
-			perror("unable to read pipe");
+		ret = read(go_pipe[0], &bf, 1);
+		/*
+		 * The parent will ask for the execvp() to be performed by
+		 * writing exactly one byte, in workload.cork_fd, usually via
+		 * perf_evlist__start_workload().
+		 *
+		 * For cancelling the workload without actuallin running it,
+		 * the parent will just close workload.cork_fd, without writing
+		 * anything, i.e. read will return zero and we just exit()
+		 * here.
+		 */
+		if (ret != 1) {
+			if (ret == -1)
+				perror("unable to read pipe");
+			exit(ret);
+		}
 
 		execvp(argv[0], (char **)argv);
 
-- 
1.9.3

