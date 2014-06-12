Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbaFLMEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827AbaFLMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:04:40 -0400
Date: Thu, 12 Jun 2014 05:04:20 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-b4bf1130cdee7d5247bd3171530869809f5aca54@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140606071352.6788.76943.stgit@kbuild-fedora.novalocal>
References: <20140606071352.6788.76943.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Show error code and description in verbose mode
Git-Commit-ID: b4bf1130cdee7d5247bd3171530869809f5aca54
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

Commit-ID:  b4bf1130cdee7d5247bd3171530869809f5aca54
Gitweb:     http://git.kernel.org/tip/b4bf1130cdee7d5247bd3171530869809f5aca54
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 6 Jun 2014 07:13:52 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Jun 2014 14:34:09 -0300

perf probe: Show error code and description in verbose mode

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
