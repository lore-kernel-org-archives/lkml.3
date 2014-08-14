Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaHNIu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:50:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaHNIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:50:57 -0400
Date: Thu, 14 Aug 2014 01:45:38 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6cc870f09da4d50722bc1caa27cad51733ce36f6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-2-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix possible memory leaks
Git-Commit-ID: 6cc870f09da4d50722bc1caa27cad51733ce36f6
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

Commit-ID:  6cc870f09da4d50722bc1caa27cad51733ce36f6
Gitweb:     http://git.kernel.org/tip/6cc870f09da4d50722bc1caa27cad51733ce36f6
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:29:43 -0300

perf script: Fix possible memory leaks

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
---
 tools/perf/builtin-script.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 868c17d..c84d723 100644
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
