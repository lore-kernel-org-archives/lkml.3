Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaJaKzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:55:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45692 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaJaKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:55:43 -0400
Subject: [PATCH perf/core 3/6] perf-probe: Add --output option to write
 commands in a standard file
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:51:49 -0400
Message-ID: <20141031185149.27889.35954.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --output (-o) option to write probe-definition commands
in a standard file (or the stdout if '-' is given) instead
of tracing/*probe_events.

This allows user to add events in a remote machine by
sending the saved command file to the machine.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/Documentation/perf-probe.txt |    5 ++++
 tools/perf/builtin-probe.c              |   26 ++++++++++++++++++++-
 tools/perf/util/probe-event.c           |   39 +++++++++++++++++++++++++------
 tools/perf/util/probe-event.h           |    2 +-
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 239609c..6f183ab 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -118,6 +118,11 @@ OPTIONS
 	Demangle kernel symbols. --no-demangle-kernel is also available
 	for disabling kernel demangling.
 
+-o::
+--output=PATH
+	Output the probe-definition commands to given file. If '-' is
+	passed as PATH, output to stdout.
+
 In absence of -m/-x options, perf probe checks if the first argument after
 the options is an absolute path name. If its an absolute path, perf probe
 uses it as a target module/target user space binary to probe.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 921bb69..c2fa3a3 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -61,6 +61,7 @@ static struct {
 	struct strlist *dellist;
 	struct line_range line_range;
 	char *target;
+	char *output;
 	int max_probe_points;
 	struct strfilter *filter;
 } params;
@@ -207,6 +208,26 @@ static int opt_set_target(const struct option *opt, const char *str,
 	return ret;
 }
 
+static int opt_set_output(const struct option *opt __maybe_unused,
+			  const char *str, int unset __maybe_unused)
+{
+	char *tmp;
+
+	if (!str)
+		return 0;
+
+	if (params.output)
+		return -EINVAL;
+
+	pr_debug("Set output to %s\n", str);
+	tmp = strdup(str);
+	if (!tmp)
+		return -ENOMEM;
+	params.output = tmp;
+	return 0;
+}
+
+
 #ifdef HAVE_DWARF_SUPPORT
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
@@ -284,6 +305,7 @@ static void cleanup_params(void)
 		strlist__delete(params.dellist);
 	line_range__clear(&params.line_range);
 	free(params.target);
+	free(params.output);
 	if (params.filter)
 		strfilter__delete(params.filter);
 	memset(&params, 0, sizeof(params));
@@ -377,6 +399,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		     opt_set_filter),
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
+	OPT_CALLBACK('o', "output", NULL, "file",
+			"output the results to given file", opt_set_output),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Enable symbol demangling"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
@@ -487,7 +511,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (params.nevents) {
 		ret = add_perf_probe_events(params.events, params.nevents,
 					    params.max_probe_points,
-					    params.target,
+					    params.target, params.output,
 					    params.force_add);
 		if (ret < 0) {
 			pr_err_with_code("  Error: Failed to add events.", ret);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb141..2aab9c9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1615,6 +1615,10 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 			goto error;
 		len += ret;
 	}
+	/* Add the last LF */
+	ret = e_snprintf(buf + len, MAX_CMDLEN - len, "\n");
+	if (ret <= 0)
+		goto error;
 
 	return buf;
 error:
@@ -2047,7 +2051,7 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 		return -EINVAL;
 	}
 
-	pr_debug("Writing event: %s\n", buf);
+	pr_debug("Writing event: %s", buf); /* Note: buf has a LF already. */
 	if (!probe_event_dry_run) {
 		ret = write(fd, buf, strlen(buf));
 		if (ret <= 0)
@@ -2097,8 +2101,9 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 }
 
 static int __add_probe_trace_events(struct perf_probe_event *pev,
-				     struct probe_trace_event *tevs,
-				     int ntevs, bool allow_suffix)
+				    struct probe_trace_event *tevs,
+				    int ntevs, int outfd,
+				    bool allow_suffix)
 {
 	int i, fd, ret;
 	struct probe_trace_event *tev = NULL;
@@ -2106,7 +2111,9 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	const char *event, *group;
 	struct strlist *namelist;
 
-	if (pev->uprobes)
+	if (outfd >= 0)
+		fd = outfd;
+	else if (pev->uprobes)
 		fd = open_uprobe_events(true);
 	else
 		fd = open_kprobe_events(true);
@@ -2117,7 +2124,11 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Get current event names */
-	namelist = get_probe_trace_event_names(fd, false);
+	if (fd == STDOUT_FILENO)
+		namelist = strlist__new(true, NULL);
+	else
+		namelist = get_probe_trace_event_names(fd, false);
+
 	if (!namelist) {
 		pr_debug("Failed to get current event list.\n");
 		return -EIO;
@@ -2367,10 +2378,24 @@ struct __event_package {
 };
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-			  int max_tevs, const char *target, bool force_add)
+			  int max_tevs, const char *target, const char *output,
+			  bool force_add)
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
+	int outfd = -1;
+
+	if (output) {
+		if (strcmp(output, "-") != 0) {
+			outfd = open(output, O_RDWR | O_CREAT | O_TRUNC, 0600);
+			if (outfd < 0) {
+				ret = -errno;
+				pr_err("Failed to open %s\n", output);
+				return ret;
+			}
+		} else
+			outfd = STDOUT_FILENO;
+	}
 
 	ret = 0;
 	pkgs = zalloc(sizeof(struct __event_package) * npevs);
@@ -2400,7 +2425,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	/* Loop 2: add all events */
 	for (i = 0; i < npevs; i++) {
 		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
-						pkgs[i].ntevs, force_add);
+					pkgs[i].ntevs, outfd, force_add);
 		if (ret < 0)
 			break;
 	}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index e01e994..df91d0a 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -125,7 +125,7 @@ extern const char *kernel_get_module_path(const char *module);
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 int max_probe_points, const char *module,
-				 bool force_add);
+				 const char *output, bool force_add);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr, const char *module,


