Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaFIUCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaFIUCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:02:46 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 03/15] tools lib traceevent: Add options to function plugin
Date: Mon,  9 Jun 2014 22:02:18 +0200
Message-Id: <1402344150-14860-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the options "parent" and "indent" to the function plugin.

When parent is set, the output looks like this:

function:             fsnotify_modify <-- vfs_write
function:             zone_statistics <-- get_page_from_freelist
function:                __inc_zone_state <-- zone_statistics
function:                inotify_inode_queue_event <-- fsnotify_modify
function:                fsnotify_parent <-- fsnotify_modify
function:                __inc_zone_state <-- zone_statistics
function:                   __fsnotify_parent <-- fsnotify_parent
function:                   inotify_dentry_parent_queue_event <-- fsnotify_parent
function:             add_to_page_cache_lru <-- do_read_cache_page

When it's not set, it looks like:

function:             fsnotify_modify
function:             zone_statistics
function:                __inc_zone_state
function:                inotify_inode_queue_event
function:                fsnotify_parent
function:                __inc_zone_state
function:                   __fsnotify_parent
function:                   inotify_dentry_parent_queue_event
function:             add_to_page_cache_lru

When the otpion "indent" is not set, it looks like this:

function:             fsnotify_modify <-- vfs_write
function:             zone_statistics <-- get_page_from_freelist
function:             __inc_zone_state <-- zone_statistics
function:             inotify_inode_queue_event <-- fsnotify_modify
function:             fsnotify_parent <-- fsnotify_modify
function:             __inc_zone_state <-- zone_statistics
function:             __fsnotify_parent <-- fsnotify_parent
function:             inotify_dentry_parent_queue_event <-- fsnotify_parent
function:             add_to_page_cache_lru <-- do_read_cache_page

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20140603032224.056940410@goodmis.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_function.c | 43 +++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 80ba4ff..a00ec19 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -33,6 +33,29 @@ static int cpus = -1;
 
 #define STK_BLK 10
 
+struct pevent_plugin_option plugin_options[] =
+{
+	{
+		.name = "parent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Print parent of functions for function events",
+	},
+	{
+		.name = "indent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Try to show function call indents, based on parents",
+		.set = 1,
+	},
+	{
+		.name = NULL,
+	}
+};
+
+static struct pevent_plugin_option *ftrace_parent = &plugin_options[0];
+static struct pevent_plugin_option *ftrace_indent = &plugin_options[1];
+
 static void add_child(struct func_stack *stack, const char *child, int pos)
 {
 	int i;
@@ -119,7 +142,8 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 
 	parent = pevent_find_function(pevent, pfunction);
 
-	index = add_and_get_index(parent, func, record->cpu);
+	if (parent && ftrace_indent->set)
+		index = add_and_get_index(parent, func, record->cpu);
 
 	trace_seq_printf(s, "%*s", index*3, "");
 
@@ -128,11 +152,13 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
-	trace_seq_printf(s, " <-- ");
-	if (parent)
-		trace_seq_printf(s, "%s", parent);
-	else
-		trace_seq_printf(s, "0x%llx", pfunction);
+	if (ftrace_parent->set) {
+		trace_seq_printf(s, " <-- ");
+		if (parent)
+			trace_seq_printf(s, "%s", parent);
+		else
+			trace_seq_printf(s, "0x%llx", pfunction);
+	}
 
 	return 0;
 }
@@ -141,6 +167,9 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
+
+	traceevent_plugin_add_options("ftrace", plugin_options);
+
 	return 0;
 }
 
@@ -157,6 +186,8 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 		free(fstack[i].stack);
 	}
 
+	traceevent_plugin_remove_options(plugin_options);
+
 	free(fstack);
 	fstack = NULL;
 	cpus = -1;
-- 
1.8.3.1

