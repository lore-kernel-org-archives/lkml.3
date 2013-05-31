Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3EaM2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:28:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab3EaM2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:28:17 -0400
Date: Fri, 31 May 2013 05:28:05 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-0817df08d31cd961be225e601d8ec92acac62027@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1369525839-1261-1-git-send-email-dsahern@gmail.com>
References: <1369525839-1261-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Reset SIGTERM handler in workload child process
Git-Commit-ID: 0817df08d31cd961be225e601d8ec92acac62027
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0817df08d31cd961be225e601d8ec92acac62027
Gitweb:     http://git.kernel.org/tip/0817df08d31cd961be225e601d8ec92acac62027
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 25 May 2013 17:50:39 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 30 May 2013 14:34:56 +0300

perf evlist: Reset SIGTERM handler in workload child process

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
