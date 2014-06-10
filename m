Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaFJOqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:53730 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaFJOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf probe: Show error code and description in verbose mode
Date: Tue, 10 Jun 2014 11:46:01 -0300
Message-Id: <1402411564-3303-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402411564-3303-1-git-send-email-acme@infradead.org>
References: <1402411564-3303-1-git-send-email-acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Show error code and description only in verbose mode if 'perf probe'
command failed.

Current 'perf probe' shows error code with final error message, and that
is meaningless for many users.

This changes error messages to show the error code and its description
only in verbose mode (-v option).

Without this patch:
  -----
  # perf probe -a do_execve@hoge
  Probe point 'do_execve@hoge' not found.
    Error: Failed to add events. (-2)
  -----

With this patch, normally the message doesn't show the misterious error
number:
  -----
  # perf probe -a do_execve@hoge
  Probe point 'do_execve@hoge' not found.
    Error: Failed to add events.
  -----

And in verbose mode, it also shows additional error messages as below:
  -----
  # perf probe -va do_execve@hoge
  probe-definition(0): do_execve@hoge
  symbol:do_execve file:hoge line:0 offset:0 return:0 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (6 entries long)
  Using /lib/modules/3.15.0-rc8+/build/vmlinux for symbols
  Open Debuginfo file: /lib/modules/3.15.0-rc8+/build/vmlinux
  Try to find probe point from debuginfo.
  Probe point 'do_execve@hoge' not found.
    Error: Failed to add events. Reason: No such file or directory (Code: -2)
  -----

Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140606071352.6788.76943.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cdcd4eb3a57d..c63fa2925075 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -288,6 +288,13 @@ static void cleanup_params(void)
 	memset(&params, 0, sizeof(params));
 }
 
+static void pr_err_with_code(const char *msg, int err)
+{
+	pr_err("%s", msg);
+	pr_debug(" Reason: %s (Code: %d)", strerror(-err), err);
+	pr_err("\n");
+}
+
 static int
 __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 {
@@ -379,7 +386,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 		ret = parse_probe_event_argv(argc, argv);
 		if (ret < 0) {
-			pr_err("  Error: Parse Error.  (%d)\n", ret);
+			pr_err_with_code("  Error: Command Parse Error.", ret);
 			return ret;
 		}
 	}
@@ -419,8 +426,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
-			pr_err("  Error: Failed to show event list. (%d)\n",
-			       ret);
+			pr_err_with_code("  Error: Failed to show event list.", ret);
 		return ret;
 	}
 	if (params.show_funcs) {
@@ -445,8 +451,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		strfilter__delete(params.filter);
 		params.filter = NULL;
 		if (ret < 0)
-			pr_err("  Error: Failed to show functions."
-			       " (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show functions.", ret);
 		return ret;
 	}
 
@@ -464,7 +469,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 
 		ret = show_line_range(&params.line_range, params.target);
 		if (ret < 0)
-			pr_err("  Error: Failed to show lines. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show lines.", ret);
 		return ret;
 	}
 	if (params.show_vars) {
@@ -485,7 +490,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		strfilter__delete(params.filter);
 		params.filter = NULL;
 		if (ret < 0)
-			pr_err("  Error: Failed to show vars. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show vars.", ret);
 		return ret;
 	}
 #endif
@@ -493,7 +498,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (params.dellist) {
 		ret = del_perf_probe_events(params.dellist);
 		if (ret < 0) {
-			pr_err("  Error: Failed to delete events. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to delete events.", ret);
 			return ret;
 		}
 	}
@@ -504,7 +509,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 					    params.target,
 					    params.force_add);
 		if (ret < 0) {
-			pr_err("  Error: Failed to add events. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to add events.", ret);
 			return ret;
 		}
 	}
-- 
1.9.3

