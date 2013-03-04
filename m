Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3CDR1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:27:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398Ab3CDR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:18 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UgPFicLonLYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QgIG4jImTz4A:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=hQgOcaguxhxKgGOGdVMA:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=9XJ83icqKTB-iqIN:21 a=snrVA3mKqSYbsE1x:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172616.025880747@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [for-next][PATCH 5/6] tracing: Fix trace events build without modules
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Fix-trace-events-build-without-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The new multi-buffers added a descriptor that kept track of module
events, and the directories they use, with struct ftace_module_file_ops.
This is used to add a ref count to keep modules from unloading while
their files are being accessed.

As the descriptor is only needed when CONFIG_MODULES is enabled, it
is only declared when the config is enabled. But that struct is
dereferenced in a few areas outside the #ifdef CONFIG_MODULES.

By adding some helper routines and moving code around a little,
events can be compiled again without modules.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   55 ++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 63b4bdf..0f1307a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1546,9 +1546,18 @@ struct ftrace_module_file_ops {
 	struct file_operations		filter;
 };
 
-static struct ftrace_module_file_ops *find_ftrace_file_ops(struct module *mod)
+static struct ftrace_module_file_ops *
+find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
 {
-	struct ftrace_module_file_ops *file_ops;
+	/*
+	 * As event_calls are added in groups by module,
+	 * when we find one file_ops, we don't need to search for
+	 * each call in that module, as the rest should be the
+	 * same. Only search for a new one if the last one did
+	 * not match.
+	 */
+	if (file_ops && mod == file_ops->mod)
+		return file_ops;
 
 	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
 		if (file_ops->mod == mod)
@@ -1664,16 +1673,35 @@ static int trace_module_notify(struct notifier_block *self,
 
 	return 0;
 }
+
+static int
+__trace_add_new_mod_event(struct ftrace_event_call *call,
+			  struct trace_array *tr,
+			  struct ftrace_module_file_ops *file_ops)
+{
+	return __trace_add_new_event(call, tr,
+				     &file_ops->id, &file_ops->enable,
+				     &file_ops->filter, &file_ops->format);
+}
+
 #else
-static struct ftrace_module_file_ops *find_ftrace_file_ops(struct module *mod)
+static inline struct ftrace_module_file_ops *
+find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
 {
 	return NULL;
 }
-static int trace_module_notify(struct notifier_block *self,
-			       unsigned long val, void *data)
+static inline int trace_module_notify(struct notifier_block *self,
+				      unsigned long val, void *data)
 {
 	return 0;
 }
+static inline int
+__trace_add_new_mod_event(struct ftrace_event_call *call,
+			  struct trace_array *tr,
+			  struct ftrace_module_file_ops *file_ops)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_MODULES */
 
 /* Create a new event directory structure for a trace directory. */
@@ -1692,20 +1720,11 @@ __trace_add_event_dirs(struct trace_array *tr)
 			 * want the module to disappear when reading one
 			 * of these files). The file_ops keep account of
 			 * the module ref count.
-			 *
-			 * As event_calls are added in groups by module,
-			 * when we find one file_ops, we don't need to search for
-			 * each call in that module, as the rest should be the
-			 * same. Only search for a new one if the last one did
-			 * not match.
 			 */
-			if (!file_ops || call->mod != file_ops->mod)
-				file_ops = find_ftrace_file_ops(call->mod);
+			file_ops = find_ftrace_file_ops(file_ops, call->mod);
 			if (!file_ops)
 				continue; /* Warn? */
-			ret = __trace_add_new_event(call, tr,
-					&file_ops->id, &file_ops->enable,
-					&file_ops->filter, &file_ops->format);
+			ret = __trace_add_new_mod_event(call, tr, file_ops);
 			if (ret < 0)
 				pr_warning("Could not create directory for event %s\n",
 					   call->name);
@@ -1794,9 +1813,7 @@ __add_event_to_tracers(struct ftrace_event_call *call,
 
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		if (file_ops)
-			__trace_add_new_event(call, tr,
-					      &file_ops->id, &file_ops->enable,
-					      &file_ops->filter, &file_ops->format);
+			__trace_add_new_mod_event(call, tr, file_ops);
 		else
 			__trace_add_new_event(call, tr,
 					      &ftrace_event_id_fops,
-- 
1.7.10.4


