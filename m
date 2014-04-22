Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaDVT4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:56:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62164 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756276AbaDVTxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:53:06 -0400
Message-Id: <20140422195303.443272648@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 22 Apr 2014 15:48:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] tools lib traceevent: Add options to plugins
References: <20140422194824.319892442@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tools-lib-traceevent-Add-options-to-plugins.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
---
 tools/lib/traceevent/event-parse.h  |  16 ++-
 tools/lib/traceevent/event-plugin.c | 197 ++++++++++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b37e18e..9c38181 100644
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
@@ -355,7 +355,7 @@ enum pevent_func_arg_type {
 enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
 	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
-	PEVENT_DISABLE_PLUGINS		= 1 << 2,
+	PEVENT_DISABLE_PLUGINS		= 1 << 2
 };
 
 #define PEVENT_ERRORS 							      \
@@ -415,6 +415,14 @@ struct plugin_list;
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
index 317466b..a244794 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,6 +18,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <stdio.h>
 #include <string.h>
 #include <dlfcn.h>
 #include <stdlib.h>
@@ -30,12 +31,208 @@
 
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
+ * an (char **)-1 (must check for that)
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
+
+			name = malloc(strlen(op->name) + strlen(alias) + 2);
+			if (!name)
+				goto err;
+
+			sprintf(name, "%s:%s", alias, op->name);
+			list = realloc(list, count + 2);
+			if (!list) {
+				free(name);
+				goto err;
+			}
+			list[count++] = name;
+			list[count] = NULL;
+		}
+	}
+	if (!count)
+		return NULL;
+	return list;
+
+ err:
+	while (--count > 0)
+		free(list[count]);
+	free(list);
+
+	return (char **)((unsigned long)-1);
+}
+
+void traceevent_plugin_free_options_list(char **list)
+{
+	int i;
+
+	if (!list)
+		return;
+
+	if (list == (char **)((unsigned long)-1))
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
+			
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
-- 
1.8.5.3


