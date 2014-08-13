Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaHMWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:55064 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbaHMWtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:40 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/41] perf script: Fix possible memory leaks
Date: Wed, 13 Aug 2014 19:48:00 -0300
Message-Id: <1407970107-24540-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Some paths in perf script don't call perf_session__delete() after
creating a new session.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-2-git-send-email-namhyung@kernel.org
[ Saved errno value before calling perror(), as pointed out by Adrian Hunter ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 868c17d09762..c84d723e0484 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1471,12 +1471,13 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	bool show_full_info = false;
 	bool header = false;
 	bool header_only = false;
+	bool script_started = false;
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
 	char *script_path = NULL;
 	const char **__argv;
-	int i, j, err;
+	int i, j, err = 0;
 	struct perf_script script = {
 		.tool = {
 			.sample		 = process_sample_event,
@@ -1730,14 +1731,15 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1752,53 +1754,60 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (output_set_by_user()) {
 			fprintf(stderr,
 				"custom fields not supported for generated scripts");
-			return -1;
+			err = -EINVAL;
+			goto out_delete;
 		}
 
 		input = open(file.path, O_RDONLY);	/* input_name */
 		if (input < 0) {
+			err = -errno;
 			perror("failed to open file");
-			return -1;
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
+		script_started = true;
 	}
 
 
 	err = perf_session__check_output_opt(session);
 	if (err < 0)
-		goto out;
+		goto out_delete;
 
 	err = __cmd_script(&script);
 
+out_delete:
 	perf_session__delete(session);
-	cleanup_scripting();
+
+	if (script_started)
+		cleanup_scripting();
 out:
 	return err;
 }
-- 
1.9.3

