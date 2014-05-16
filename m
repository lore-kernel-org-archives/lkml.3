Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaEPOGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:06:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:23603 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932754AbaEPOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:05:08 -0400
Message-Id: <20140516140502.481024166@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 16 May 2014 10:02:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] tools lib traceevent: Add options to function plugin
References: <20140516140215.149535442@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tools-lib-traceevent-Add-options-to-function-plugin.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
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
---
 tools/lib/traceevent/plugin_function.c | 43 +++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 80ba4ff1fe84..a00ec190821a 100644
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
1.8.5.3


