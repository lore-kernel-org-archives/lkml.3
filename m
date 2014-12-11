Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaLKPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:13:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662AbaLKPNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:13:22 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/8] perf tools: Add new perf data command
Date: Thu, 11 Dec 2014 16:12:23 +0100
Message-Id: <1418310749-22267-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new 'perf data' command to provide operations over
data files.

The 'perf data convert' sub command is coming in following
patch, but there's possibility for other useful commands
like 'perf data ls' (to display perf data file in directory
in ls style).

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-data.txt | 15 +++++++
 tools/perf/Makefile.perf               |  1 +
 tools/perf/builtin-data.c              | 75 ++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                   |  1 +
 tools/perf/command-list.txt            |  1 +
 tools/perf/perf.c                      |  1 +
 6 files changed, 94 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-data.txt
 create mode 100644 tools/perf/builtin-data.c

diff --git a/tools/perf/Documentation/perf-data.txt b/tools/perf/Documentation/perf-data.txt
new file mode 100644
index 000000000000..b8c83947715c
--- /dev/null
+++ b/tools/perf/Documentation/perf-data.txt
@@ -0,0 +1,15 @@
+perf-data(1)
+==============
+
+NAME
+----
+perf-data - Data file related processing
+
+SYNOPSIS
+--------
+[verse]
+'perf data' [<common options>] <command> [<options>]",
+
+DESCRIPTION
+-----------
+Data file related processing.
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a6a2ec5ebf0e..da851f8a879d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -484,6 +484,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
+BUILTIN_OBJS += $(OUTPUT)builtin-data.o
 
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/builtin-data.c b/tools/perf/builtin-data.c
new file mode 100644
index 000000000000..1eee97d020fa
--- /dev/null
+++ b/tools/perf/builtin-data.c
@@ -0,0 +1,75 @@
+#include <linux/compiler.h>
+#include "builtin.h"
+#include "perf.h"
+#include "debug.h"
+#include "parse-options.h"
+
+typedef int (*data_cmd_fn_t)(int argc, const char **argv, const char *prefix);
+
+struct data_cmd {
+	const char	*name;
+	const char	*summary;
+	data_cmd_fn_t	fn;
+};
+
+static struct data_cmd data_cmds[];
+
+#define for_each_cmd(cmd) \
+	for (cmd = data_cmds; cmd && cmd->name; cmd++)
+
+static const struct option data_options[] = {
+	OPT_END()
+};
+
+static const char * const data_usage[] = {
+	"perf data [<common options>] <command> [<options>]",
+	NULL
+};
+
+static void print_usage(void)
+{
+	struct data_cmd *cmd;
+
+	printf("Usage:\n");
+	printf("\t%s\n\n", data_usage[0]);
+	printf("\tAvailable commands:\n");
+
+	for_each_cmd(cmd) {
+		printf("\t %s\t- %s\n", cmd->name, cmd->summary);
+	}
+
+	printf("\n");
+}
+
+static struct data_cmd data_cmds[] = {
+	{ NULL },
+};
+
+int cmd_data(int argc, const char **argv, const char *prefix)
+{
+	struct data_cmd *cmd;
+	const char *cmdstr;
+
+	/* No command specified. */
+	if (argc < 2)
+		goto usage;
+
+	argc = parse_options(argc, argv, data_options, data_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc < 1)
+		goto usage;
+
+	cmdstr = argv[0];
+
+	for_each_cmd(cmd) {
+		if (strcmp(cmd->name, cmdstr))
+			continue;
+
+		return cmd->fn(argc, argv, prefix);
+	}
+
+	pr_err("Unknown command: %s\n", cmdstr);
+usage:
+	print_usage();
+	return -1;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b210d62907e4..3688ad29085f 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -37,6 +37,7 @@ extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
 extern int cmd_mem(int argc, const char **argv, const char *prefix);
+extern int cmd_data(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 0906fc401c52..00fcaf8a5b8d 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -7,6 +7,7 @@ perf-archive			mainporcelain common
 perf-bench			mainporcelain common
 perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
+perf-data			mainporcelain common
 perf-diff			mainporcelain common
 perf-evlist			mainporcelain common
 perf-inject			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 3700a7faca6c..f3c66b81c6be 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -62,6 +62,7 @@ static struct cmd_struct commands[] = {
 #endif
 	{ "inject",	cmd_inject,	0 },
 	{ "mem",	cmd_mem,	0 },
+	{ "data",	cmd_data,	0 },
 };
 
 struct pager_config {
-- 
1.9.3

