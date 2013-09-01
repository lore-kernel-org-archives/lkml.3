Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3IAKtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3IAKtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/24] tools list traceevent: Add options support
Date: Sun,  1 Sep 2013 12:48:30 +0200
Message-Id: <1378032529-18498-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting options support for traceevent lib.

It's now possible to use following interface
to load options for 'struct pevent' object:

void traceevent_add_options(const char *name, struct plugin_option *options);
  - adds a set of options by a plugin

void traceevent_remove_options(struct plugin_option *options);
  - removes plugin options that were registered

void traceevent_add_option(const char *name, const char *val);
  - modifies plugin option

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile       |   2 +-
 tools/lib/traceevent/event-option.c | 278 ++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h  |   4 +
 3 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/event-option.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 539f3e5..99da843 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -180,7 +180,7 @@ $(obj)/%.o: $(src)/%.c
 %.o: $(src)/%.c
 	$(Q)$(call do_compile)
 
-PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o
+PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
 ALL_OBJS = $(PEVENT_LIB_OBJS)
diff --git a/tools/lib/traceevent/event-option.c b/tools/lib/traceevent/event-option.c
new file mode 100644
index 0000000..61181be
--- /dev/null
+++ b/tools/lib/traceevent/event-option.c
@@ -0,0 +1,278 @@
+
+#include <stdlib.h>
+#include <string.h>
+#include "event-parse.h"
+#include "event-utils.h"
+
+static struct trace_plugin_options {
+	struct trace_plugin_options	*next;
+	char				*plugin;
+	char				*option;
+	char				*value;
+} *trace_plugin_options;
+
+static struct registered_plugin_options {
+	struct registered_plugin_options	*next;
+	struct plugin_option			*options;
+} *registered_options;
+
+static void update_option(const char *file, struct plugin_option *option)
+{
+	struct trace_plugin_options *op;
+	char *plugin;
+
+	if (option->plugin_alias) {
+		plugin = strdup(option->plugin_alias);
+		if (!plugin)
+			die("malloc");
+	} else {
+		char *p;
+		plugin = strdup(file);
+		if (!plugin)
+			die("malloc");
+		p = strstr(plugin, ".");
+		if (p)
+			*p = '\0';
+	}
+
+	/* first look for named options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (!op->plugin)
+			continue;
+		if (strcmp(op->plugin, plugin) != 0)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set ^= 1;
+		goto out;
+	}
+
+	/* first look for unnamed options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (op->plugin)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set ^= 1;
+		break;
+	}
+
+ out:
+	free(plugin);
+}
+
+/**
+ * trace_util_add_options - Add a set of options by a plugin
+ * @name: The name of the plugin adding the options
+ * @options: The set of options being loaded
+ *
+ * Sets the options with the values that have been added by user.
+ */
+void traceevent_add_options(const char *name, struct plugin_option *options)
+{
+	struct registered_plugin_options *reg;
+
+	reg = malloc_or_die(sizeof(*reg));
+	reg->next = registered_options;
+	reg->options = options;
+	registered_options = reg;
+
+	while (options->name) {
+		update_option("ftrace", options);
+		options++;
+	}
+}
+
+/**
+ * trace_util_remove_options - remove plugin options that were registered
+ * @options: Options to removed that were registered with trace_util_add_options
+ */
+void traceevent_remove_options(struct plugin_option *options)
+{
+	struct registered_plugin_options **last;
+	struct registered_plugin_options *reg;
+
+	for (last = &registered_options; *last; last = &(*last)->next) {
+		if ((*last)->options == options) {
+			reg = *last;
+			*last = reg->next;
+			free(reg);
+			return;
+		}
+	}
+}
+
+static struct plugin_option *
+find_registered_option(const char *plugin, const char *option)
+{
+	struct registered_plugin_options *reg;
+	struct plugin_option *op;
+	const char *op_plugin;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			if (op->plugin_alias)
+				op_plugin = op->plugin_alias;
+			else
+				op_plugin = op->file;
+
+			if (plugin && strcmp(plugin, op_plugin) != 0)
+				continue;
+			if (strcmp(option, op->name) != 0)
+				continue;
+
+			return op;
+		}
+	}
+
+	return NULL;
+}
+
+static void lower_case(char *str)
+{
+	if (!str)
+		return;
+	for (; *str; str++)
+		*str = tolower(*str);
+}
+
+static int update_option_value(struct plugin_option *op, const char *val)
+{
+	char *op_val;
+	int ret = 1;
+
+	if (!val) {
+		/* toggle, only if option is boolean */
+		if (op->value)
+			/* Warn? */
+			return 0;
+		op->set ^= 1;
+		return 1;
+	}
+
+	/*
+	 * If the option has a value then it takes a string
+	 * otherwise the option is a boolean.
+	 */
+	if (op->value) {
+		op->value = (char *) val;
+		return 1;
+	}
+
+	/* Option is boolean, must be either "1", "0", "true" or "false" */
+
+	op_val = strdup(val);
+	if (!op_val)
+		die("malloc");
+	lower_case(op_val);
+
+	if (strcmp(val, "1") == 0 || strcmp(val, "true") == 0)
+		op->set = 1;
+	else if (strcmp(val, "0") == 0 || strcmp(val, "false") == 0)
+		op->set = 0;
+	else
+		/* Warn on else? */
+		ret = 0;
+	free(op_val);
+
+	return ret;
+}
+
+static int process_option(const char *plugin, const char *option, const char *val)
+{
+	struct plugin_option *op;
+
+	op = find_registered_option(plugin, option);
+	if (!op)
+		return 0;
+
+	return update_option_value(op, val);
+}
+
+static void parse_option_name(char **option, char **plugin)
+{
+	char *p;
+
+	*plugin = NULL;
+
+	if ((p = strstr(*option, ":"))) {
+		*plugin = *option;
+		*p = '\0';
+		*option = strdup(p + 1);
+		if (!*option)
+			die("malloc");
+	}
+}
+
+/**
+ * trace_util_add_option - add an option/val pair to set plugin options
+ * @name: The name of the option (format: <plugin>:<option> or just <option>)
+ * @val: (optiona) the value for the option
+ *
+ * Modify a plugin option. If @val is given than the value of the option
+ * is set (note, some options just take a boolean, so @val must be either
+ * "1" or "0" or "true" or "false").
+ */
+void traceevent_add_option(const char *name, const char *val)
+{
+	struct trace_plugin_options *op;
+	char *option_str;
+	char *plugin;
+
+	option_str = strdup(name);
+	if (!option_str)
+		die("malloc");
+
+	parse_option_name(&option_str, &plugin);
+
+	/* If the option exists, update the val */
+	for (op = trace_plugin_options; op; op = op->next) {
+		/* Both must be NULL or not NULL */
+		if ((!plugin || !op->plugin) && plugin != op->plugin)
+			continue;
+		if (plugin && strcmp(plugin, op->plugin) != 0)
+			continue;
+		if (strcmp(op->option, option_str) != 0)
+			continue;
+
+		/* update option */
+		free(op->value);
+		if (val) {
+			op->value = strdup(val);
+			if (!op->value)
+				die("malloc");
+		} else
+			op->value = NULL;
+
+		/* plugin and option_str don't get freed at the end */
+		free(plugin);
+		free(option_str);
+
+		plugin = op->plugin;
+		option_str = op->option;
+		break;
+	}
+
+	/* If not found, create */
+	if (!op) {
+		op = malloc_or_die(sizeof(*op));
+		memset(op, 0, sizeof(*op));
+		op->next = trace_plugin_options;
+		trace_plugin_options = op;
+
+		op->plugin = plugin;
+		op->option = option_str;
+
+		if (val) {
+			op->value = strdup(val);
+			if (!op->value)
+				die("malloc");
+		}
+	}
+
+	process_option(plugin, option_str, val);
+}
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 8273c6e..3aaf668 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -110,6 +110,10 @@ struct plugin_option {
 	int				set;
 };
 
+void traceevent_add_options(const char *name, struct plugin_option *options);
+void traceevent_remove_options(struct plugin_option *options);
+void traceevent_add_option(const char *name, const char *val);
+
 /*
  * Plugin hooks that can be called:
  *
-- 
1.7.11.7

