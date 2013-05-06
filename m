Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3EFSYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:24:31 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44665 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3EFSYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:24:30 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf record: handle death by SIGTERM
Date: Mon,  6 May 2013 12:24:23 -0600
Message-Id: <1367864663-1309-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf data files cannot be processed until the header file is update
which is done via an on_exit handler. If perf is killed due to a SIGTERM
it does not run the on_exit hooks leaving the perf.data file in a
random state which perf-report will happily spin on trying to read. As
noted by Mike an easy reproducer is:
  perf record -a -g & sleep 1; killall perf

Fix by catching SIGTERM like it does SIGINT.  Also need to remove the
kill which was added via commit f7b7c26e.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..fff985c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -198,7 +198,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 		return;
 
 	signal(signr, SIG_DFL);
-	kill(getpid(), signr);
 }
 
 static bool perf_evlist__equal(struct perf_evlist *evlist,
@@ -404,6 +403,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
+	signal(SIGTERM, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-- 
1.7.10.1

