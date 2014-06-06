Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaFFHOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:14:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58905 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaFFHOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:14:01 -0400
Subject: [PATCH -tip 2/4] perf/probe: Show error code and description in
 verbose mode
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Jun 2014 07:13:52 +0000
Message-ID: <20140606071352.6788.76943.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
References: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show error code and description only in verbose mode if
perf probe command is failed. Current perf probe shows
error code with final error message, and that is meaningless
for many users. This changes error messages to show the error
code and its description only in verbose mode (-v option).

Without this patch:
  -----
  # perf probe -a do_execve@hoge
  Probe point 'do_execve@hoge' not found.
    Error: Failed to add events. (-2)
  -----

With this patch, normally the message doesn't show the
misterious error number.
  -----
  # perf probe -a do_execve@hoge
  Probe point 'do_execve@hoge' not found.
    Error: Failed to add events.
  -----

And in verbose mode, it also shows additional error
messages as below:
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 tools/perf/builtin-probe.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cdcd4eb..c63fa29 100644
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


