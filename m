Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbbA2IK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51691 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbbA2IKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:21 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <namhyung@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 41/42] perf tools: Add new perf data command
Date: Thu, 29 Jan 2015 17:07:22 +0900
Message-Id: <1422518843-25818-42-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <namhyung@kernel.org>

Adding new 'perf data' command to provide operations over
data files.

The 'perf data convert' sub command is coming in following
patch, but there's possibility for other useful commands
like 'perf data ls' (to display perf data file in directory
in ls style).

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index 2f8c8b918cac..16ff21fbde55 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -498,6 +498,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
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
2.2.2

