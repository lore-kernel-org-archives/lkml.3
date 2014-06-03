Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaFCDW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:22:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752003AbaFCDW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:22:27 -0400
Message-Id: <20140603032012.088137043@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 02 Jun 2014 23:20:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] tools lib traceevent: bitmask handling and plugin updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the patch series that added __get_bitmask() as well as
added some plugin code. This version addresses what Namhyung suggested.
The diff from v1 is posted below.

Steven Rostedt (Red Hat) (4):
      tools lib traceevent: Add flag to not load event plugins
      tools lib traceevent: Add options to plugins
      tools lib traceevent: Add options to function plugin
      tools lib traceevent: Added support for __get_bitmask() macro

----
 tools/lib/traceevent/event-parse.c                 | 113 ++++++++++++
 tools/lib/traceevent/event-parse.h                 |  25 ++-
 tools/lib/traceevent/event-plugin.c                | 204 ++++++++++++++++++++-
 tools/lib/traceevent/plugin_function.c             |  43 ++++-
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 6 files changed, 377 insertions(+), 10 deletions(-)


diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2d6aa92..93825a1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3794,7 +3794,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = pevent_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = data2host4(pevent, data + arg->string.offset);
+		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
 		print_bitmask_to_seq(pevent, s, format, len_arg,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 025627f..7a3873f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -362,7 +362,7 @@ enum pevent_func_arg_type {
 enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
 	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
-	PEVENT_DISABLE_PLUGINS		= 1 << 2
+	PEVENT_DISABLE_PLUGINS		= 1 << 2,
 };
 
 #define PEVENT_ERRORS 							      \
@@ -419,6 +419,8 @@ enum pevent_errno {
 
 struct plugin_list;
 
+#define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
+
 struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
 void traceevent_unload_plugins(struct plugin_list *plugin_list,
 			       struct pevent *pevent);
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index a244794..648ef84 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -57,7 +57,7 @@ struct plugin_list {
  * used by toggling the option.
  *
  * Returns NULL if there's no options registered. On error it returns
- * an (char **)-1 (must check for that)
+ * INVALID_PLUGIN_LIST_OPTION
  *
  * Must be freed with traceevent_plugin_free_options_list().
  */
@@ -72,6 +72,7 @@ char **traceevent_plugin_list_options(void)
 	for (reg = registered_options; reg; reg = reg->next) {
 		for (op = reg->options; op->name; op++) {
 			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
+			char **temp = list;
 
 			name = malloc(strlen(op->name) + strlen(alias) + 2);
 			if (!name)
@@ -80,6 +81,7 @@ char **traceevent_plugin_list_options(void)
 			sprintf(name, "%s:%s", alias, op->name);
 			list = realloc(list, count + 2);
 			if (!list) {
+				list = temp;
 				free(name);
 				goto err;
 			}
@@ -87,16 +89,14 @@ char **traceevent_plugin_list_options(void)
 			list[count] = NULL;
 		}
 	}
-	if (!count)
-		return NULL;
 	return list;
 
  err:
-	while (--count > 0)
+	while (--count >= 0)
 		free(list[count]);
 	free(list);
 
-	return (char **)((unsigned long)-1);
+	return INVALID_PLUGIN_LIST_OPTION;
 }
 
 void traceevent_plugin_free_options_list(char **list)
