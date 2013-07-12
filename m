Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3GLI54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:57:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3GLIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:51:10 -0400
Date: Fri, 12 Jul 2013 01:50:47 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bcf3145fbeb1bd91ad2ca67b1946077530f7bfb1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1372230862-15861-13-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Enhance perf_evlist__start_workload()
Git-Commit-ID: bcf3145fbeb1bd91ad2ca67b1946077530f7bfb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:50:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcf3145fbeb1bd91ad2ca67b1946077530f7bfb1
Gitweb:     http://git.kernel.org/tip/bcf3145fbeb1bd91ad2ca67b1946077530f7bfb1
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 26 Jun 2013 16:14:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:38:30 -0300

perf evlist: Enhance perf_evlist__start_workload()

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
