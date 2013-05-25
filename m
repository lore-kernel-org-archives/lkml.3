Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab3EYXur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 19:50:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64971 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab3EYXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 19:50:45 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: reset SIGTERM handler in workload child process
Date: Sat, 25 May 2013 17:50:39 -0600
Message-Id: <1369525839-1261-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/evlist.c |    2 ++
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
1.7.10.1

