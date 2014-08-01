Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaHAIYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:24:52 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60458 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:24:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf script: Fix possible memory leaks
Date: Fri,  1 Aug 2014 17:24:46 +0900
Message-Id: <1406881486-5789-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some paths in perf script don't call perf_session__delete() after
creating a new session.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f57035b89c15..df0f84d7e825 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1476,7 +1476,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	char *script_path = NULL;
 	const char **__argv;
-	int i, j, err;
+	int i, j, err = 0;
 	struct perf_script script = {
 		.tool = {
 			.sample		 = process_sample_event,
@@ -1730,14 +1730,15 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (header || header_only) {
 		perf_session__fprintf_info(session, stdout, show_full_info);
 		if (header_only)
-			return 0;
+			goto out_delete;
 	}
 
 	script.session = session;
 
 	if (cpu_list) {
-		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
-			return -1;
+		err = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
+		if (err < 0)
+			goto out_delete;
 	}
 
 	if (!no_callchain)
@@ -1752,53 +1753,57 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (output_set_by_user()) {
 			fprintf(stderr,
 				"custom fields not supported for generated scripts");
-			return -1;
+			err = -EINVAL;
+			goto out_delete;
 		}
 
 		input = open(file.path, O_RDONLY);	/* input_name */
 		if (input < 0) {
 			perror("failed to open file");
-			return -1;
+			err = -errno;
+			goto out_delete;
 		}
 
 		err = fstat(input, &perf_stat);
 		if (err < 0) {
 			perror("failed to stat file");
-			return -1;
+			goto out_delete;
 		}
 
 		if (!perf_stat.st_size) {
 			fprintf(stderr, "zero-sized file, nothing to do!\n");
-			return 0;
+			goto out_delete;
 		}
 
 		scripting_ops = script_spec__lookup(generate_script_lang);
 		if (!scripting_ops) {
 			fprintf(stderr, "invalid language specifier");
-			return -1;
+			err = -ENOENT;
+			goto out_delete;
 		}
 
 		err = scripting_ops->generate_script(session->tevent.pevent,
 						     "perf-script");
-		goto out;
+		goto out_delete;
 	}
 
 	if (script_name) {
 		err = scripting_ops->start_script(script_name, argc, argv);
 		if (err)
-			goto out;
+			goto out_delete;
 		pr_debug("perf script started with script %s\n\n", script_name);
 	}
 
 
 	err = perf_session__check_output_opt(session);
 	if (err < 0)
-		goto out;
+		goto out_delete;
 
 	err = __cmd_script(&script);
 
-	perf_session__delete(session);
 	cleanup_scripting();
+out_delete:
+	perf_session__delete(session);
 out:
 	return err;
 }
-- 
2.0.0

