Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbaFLMG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:06:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934027AbaFLMBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:01:15 -0400
Date: Thu, 12 Jun 2014 05:00:58 -0700
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-49440828ad7b809e9d31f6108875e3b1e974690c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20140603032224.056940410@goodmis.org>
References: <20140603032224.056940410@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add options to function plugin
Git-Commit-ID: 49440828ad7b809e9d31f6108875e3b1e974690c
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

Commit-ID:  49440828ad7b809e9d31f6108875e3b1e974690c
Gitweb:     http://git.kernel.org/tip/49440828ad7b809e9d31f6108875e3b1e974690c
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Mon, 2 Jun 2014 23:20:15 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sat, 7 Jun 2014 23:33:37 +0200

tools lib traceevent: Add options to function plugin

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
