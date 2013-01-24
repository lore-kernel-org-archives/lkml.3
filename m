Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3AXUNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:13:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50187 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3AXUIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 67/74] perf tools: Remove some needless die() calls from the main routine
Date: Thu, 24 Jan 2013 17:08:16 -0300
Message-Id: <1359058103-31645-68-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.8.1.1.361.gec3ae6e

