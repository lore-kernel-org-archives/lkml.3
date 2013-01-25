Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3AYMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:07:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3AYMHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:07:38 -0500
Date: Fri, 25 Jan 2013 04:07:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-nzq0sdur6oq6lgkt2ipf4o8s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove some needless die()
  calls from the main routine
Git-Commit-ID: 2a16bf8c1333aa5107ce6474c4df9988d62b41d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:07:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a16bf8c1333aa5107ce6474c4df9988d62b41d3
Gitweb:     http://git.kernel.org/tip/2a16bf8c1333aa5107ce6474c4df9988d62b41d3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 15:18:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:52 -0300

perf tools: Remove some needless die() calls from the main routine

Some would just call exit() anyway right after calling die() and the
main routine doesn't have to call it, just return the exit value.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nzq0sdur6oq6lgkt2ipf4o8s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 0f661fb..095b882 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -328,14 +328,23 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (S_ISFIFO(st.st_mode) || S_ISSOCK(st.st_mode))
 		return 0;
 
+	status = 1;
 	/* Check for ENOSPC and EIO errors.. */
-	if (fflush(stdout))
-		die("write failure on standard output: %s", strerror(errno));
-	if (ferror(stdout))
-		die("unknown write failure on standard output");
-	if (fclose(stdout))
-		die("close failed on standard output: %s", strerror(errno));
-	return 0;
+	if (fflush(stdout)) {
+		fprintf(stderr, "write failure on standard output: %s", strerror(errno));
+		goto out;
+	}
+	if (ferror(stdout)) {
+		fprintf(stderr, "unknown write failure on standard output");
+		goto out;
+	}
+	if (fclose(stdout)) {
+		fprintf(stderr, "close failed on standard output: %s", strerror(errno));
+		goto out;
+	}
+	status = 0;
+out:
+	return status;
 }
 
 static void handle_internal_command(int argc, const char **argv)
@@ -467,7 +476,8 @@ int main(int argc, const char **argv)
 		cmd += 5;
 		argv[0] = cmd;
 		handle_internal_command(argc, argv);
-		die("cannot handle %s internally", cmd);
+		fprintf(stderr, "cannot handle %s internally", cmd);
+		goto out;
 	}
 
 	/* Look for flags.. */
@@ -485,7 +495,7 @@ int main(int argc, const char **argv)
 		printf("\n usage: %s\n\n", perf_usage_string);
 		list_common_cmds_help();
 		printf("\n %s\n\n", perf_more_info_string);
-		exit(1);
+		goto out;
 	}
 	cmd = argv[0];
 
@@ -517,7 +527,7 @@ int main(int argc, const char **argv)
 			fprintf(stderr, "Expansion of alias '%s' failed; "
 				"'%s' is not a perf-command\n",
 				cmd, argv[0]);
-			exit(1);
+			goto out;
 		}
 		if (!done_help) {
 			cmd = argv[0] = help_unknown_cmd(cmd);
@@ -528,6 +538,6 @@ int main(int argc, const char **argv)
 
 	fprintf(stderr, "Failed to run command '%s': %s\n",
 		cmd, strerror(errno));
-
+out:
 	return 1;
 }
