Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab3E3QQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:16:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab3E3QCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 58/66] perf evlist: Reset SIGTERM handler in workload child process
Date: Thu, 30 May 2013 19:01:31 +0300
Message-Id: <1369929699-8724-59-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Jiri reported hanging perf tests on latest acme's perf/core and bisected
it to 87f303a9f:

[jolsa@krava2 perf]$ cat /proc/sys/kernel/perf_event_paranoid
1
[jolsa@krava2 perf]$ ./perf record -C 0 kill
Error:
You may not have permission to collect %sstats.
Consider tweaking /proc/sys/kernel/perf_event_paranoid:
 -1 - Not paranoid at all
  0 - Disallow raw tracepoint access for unpriv
  1 - Disallow cpu events for unpriv
  2 - Disallow kernel profiling for unpriv

Need to let default handling kickin for workload process.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1369525839-1261-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f7c7278..99b43dd 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -776,6 +776,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		if (pipe_output)
 			dup2(2, 1);
 
+		signal(SIGTERM, SIG_DFL);
+
 		close(child_ready_pipe[0]);
 		close(go_pipe[1]);
 		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
-- 
1.8.1.4

