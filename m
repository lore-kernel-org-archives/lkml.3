Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbaFLMBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:01:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaFLMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:01:07 -0400
Date: Thu, 12 Jun 2014 05:00:45 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-5827f2faabe40cc285cc67b697277547a19b6c9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20140603184154.0a4c031c@gandalf.local.home>
References: <20140603184154.0a4c031c@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add options to plugins
Git-Commit-ID: 5827f2faabe40cc285cc67b697277547a19b6c9a
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

Commit-ID:  5827f2faabe40cc285cc67b697277547a19b6c9a
Gitweb:     http://git.kernel.org/tip/5827f2faabe40cc285cc67b697277547a19b6c9a
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 3 Jun 2014 18:41:54 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sat, 7 Jun 2014 23:33:36 +0200

tools lib traceevent: Add options to plugins

The traceevent plugins allows developers to have their events print out
information that is more advanced than what can be achieved by the
trace event format files.

As these plugins are used on the userspace side of the tracing tools, it
is only logical that the tools should be able to produce different types
of output for the events. The types of events still need to be defined by
the plugins thus we need a way to pass information from the tool to the
plugin to specify what type of information to be shown.

Not only does the information need to be passed by the tool to plugin, but
the plugin also requires a way to notify the tool of what options it can
provide.

This builds the plugin option infrastructure that is taken from trace-cmd
that is used to allow plugins to produce different output based on the
options specified by the tool.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20140603184154.0a4c031c@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/event-parse.h  |  16 ++-
 tools/lib/traceevent/event-plugin.c | 196 ++++++++++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a68ec3d..56e0e6c 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -107,8 +107,8 @@ typedef int (*pevent_event_handler_func)(struct trace_seq *s,
 typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
 typedef int (*pevent_plugin_unload_func)(struct pevent *pevent);
 
-struct plugin_option {
-	struct plugin_option		*next;
+struct pevent_plugin_option {
+	struct pevent_plugin_option	*next;
 	void				*handle;
 	char				*file;
 	char				*name;
@@ -135,7 +135,7 @@ struct plugin_option {
  * PEVENT_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
  *
- *   struct plugin_option PEVENT_PLUGIN_OPTIONS[] = {
+ *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
  *	{
  *		.name = "option-name",
  *		.plugin_alias = "overide-file-name", (optional)
@@ -412,9 +412,19 @@ enum pevent_errno {
 
 struct plugin_list;
 
+#define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
+
 struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
 void traceevent_unload_plugins(struct plugin_list *plugin_list,
 			       struct pevent *pevent);
+char **traceevent_plugin_list_options(void);
+void traceevent_plugin_free_options_list(char **list);
+int traceevent_plugin_add_options(const char *name,
+				  struct pevent_plugin_option *options);
+void traceevent_plugin_remove_options(struct pevent_plugin_option *options);
+void traceevent_print_plugins(struct trace_seq *s,
+			      const char *prefix, const char *suffix,
+			      const struct plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 317466b..136162c 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,6 +18,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <stdio.h>
 #include <string.h>
 #include <dlfcn.h>
 #include <stdlib.h>
@@ -30,12 +31,207 @@
 
 #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
 
+static struct registered_plugin_options {
+	struct registered_plugin_options	*next;
+	struct pevent_plugin_option		*options;
+} *registered_options;
+
+static struct trace_plugin_options {
+	struct trace_plugin_options	*next;
+	char				*plugin;
+	char				*option;
+	char				*value;
+} *trace_plugin_options;
+
 struct plugin_list {
 	struct plugin_list	*next;
 	char			*name;
 	void			*handle;
 };
 
+/**
+ * traceevent_plugin_list_options - get list of plugin options
+ *
+ * Returns an array of char strings that list the currently registered
+ * plugin options in the format of <plugin>:<option>. This list can be
+ * used by toggling the option.
+ *
+ * Returns NULL if there's no options registered. On error it returns
+ * INVALID_PLUGIN_LIST_OPTION
+ *
+ * Must be freed with traceevent_plugin_free_options_list().
+ */
+char **traceevent_plugin_list_options(void)
+{
+	struct registered_plugin_options *reg;
+	struct pevent_plugin_option *op;
+	char **list = NULL;
+	char *name;
+	int count = 0;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
+			char **temp = list;
+
+			name = malloc(strlen(op->name) + strlen(alias) + 2);
+			if (!name)
+				goto err;
+
+			sprintf(name, "%s:%s", alias, op->name);
+			list = realloc(list, count + 2);
+			if (!list) {
+				list = temp;
+				free(name);
+				goto err;
+			}
+			list[count++] = name;
+			list[count] = NULL;
+		}
+	}
+	return list;
+
+ err:
+	while (--count >= 0)
+		free(list[count]);
+	free(list);
+
+	return INVALID_PLUGIN_LIST_OPTION;
+}
+
+void traceevent_plugin_free_options_list(char **list)
+{
+	int i;
+
+	if (!list)
+		return;
+
+	if (list == INVALID_PLUGIN_LIST_OPTION)
+		return;
+
+	for (i = 0; list[i]; i++)
+		free(list[i]);
+
+	free(list);
+}
+
+static int
+update_option(const char *file, struct pevent_plugin_option *option)
+{
+	struct trace_plugin_options *op;
+	char *plugin;
+
+	if (option->plugin_alias) {
+		plugin = strdup(option->plugin_alias);
+		if (!plugin)
+			return -1;
+	} else {
+		char *p;
+		plugin = strdup(file);
+		if (!plugin)
+			return -1;
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
+	return 0;
+}
+
+/**
+ * traceevent_plugin_add_options - Add a set of options by a plugin
+ * @name: The name of the plugin adding the options
+ * @options: The set of options being loaded
+ *
+ * Sets the options with the values that have been added by user.
+ */
+int traceevent_plugin_add_options(const char *name,
+				  struct pevent_plugin_option *options)
+{
+	struct registered_plugin_options *reg;
+
+	reg = malloc(sizeof(*reg));
+	if (!reg)
+		return -1;
+	reg->next = registered_options;
+	reg->options = options;
+	registered_options = reg;
+
+	while (options->name) {
+		update_option(name, options);
+		options++;
+	}
+	return 0;
+}
+
+/**
+ * traceevent_plugin_remove_options - remove plugin options that were registered
+ * @options: Options to removed that were registered with traceevent_plugin_add_options
+ */
+void traceevent_plugin_remove_options(struct pevent_plugin_option *options)
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
+/**
+ * traceevent_print_plugins - print out the list of plugins loaded
+ * @s: the trace_seq descripter to write to
+ * @prefix: The prefix string to add before listing the option name
+ * @suffix: The suffix string ot append after the option name
+ * @list: The list of plugins (usually returned by traceevent_load_plugins()
+ *
+ * Writes to the trace_seq @s the list of plugins (files) that is
+ * returned by traceevent_load_plugins(). Use @prefix and @suffix for formating:
+ * @prefix = "  ", @suffix = "\n".
+ */
+void traceevent_print_plugins(struct trace_seq *s,
+			      const char *prefix, const char *suffix,
+			      const struct plugin_list *list)
+{
+	while (list) {
+		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
+		list = list->next;
+	}
+}
+
 static void
 load_plugin(struct pevent *pevent, const char *path,
 	    const char *file, void *data)
