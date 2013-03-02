Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3CBDCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:02:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3CBDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:52 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8xL_3QA5-mAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HuE-X7R1VccA:10 a=20KFwNOVAAAA:8 a=RRa-1xffCMXNHFMu1XQA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030050.455724533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 3/7] tracing: Use direct field, type and system names
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-direct-field-type-and-system-names.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The names used to display the field and type in the event format
files are copied, as well as the system name that is displayed.

All these names are created by constant values passed in.
If one of theses values were to be removed by a module, the module
would also be required to remove any event it created.

By using the strings directly, we can save over 100K of memory.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |    4 ++--
 kernel/trace/trace_events.c |   20 +++-----------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 592e8f2..c597523 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -883,8 +883,8 @@ enum {
 
 struct ftrace_event_field {
 	struct list_head	link;
-	char			*name;
-	char			*type;
+	const char		*name;
+	const char		*type;
 	int			filter_type;
 	int			offset;
 	int			size;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5d8845d..63b4bdf 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -72,13 +72,8 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	if (!field)
 		goto err;
 
-	field->name = kstrdup(name, GFP_KERNEL);
-	if (!field->name)
-		goto err;
-
-	field->type = kstrdup(type, GFP_KERNEL);
-	if (!field->type)
-		goto err;
+	field->name = name;
+	field->type = type;
 
 	if (filter_type == FILTER_OTHER)
 		field->filter_type = filter_assign_type(type);
@@ -94,8 +89,6 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	return 0;
 
 err:
-	if (field)
-		kfree(field->name);
 	kmem_cache_free(field_cachep, field);
 
 	return -ENOMEM;
@@ -146,8 +139,6 @@ void trace_destroy_fields(struct ftrace_event_call *call)
 	head = trace_get_fields(call);
 	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
-		kfree(field->type);
-		kfree(field->name);
 		kmem_cache_free(field_cachep, field);
 	}
 }
@@ -286,7 +277,6 @@ static void __put_system(struct event_subsystem *system)
 		kfree(filter->filter_string);
 		kfree(filter);
 	}
-	kfree(system->name);
 	kfree(system);
 }
 
@@ -1202,10 +1192,7 @@ create_new_subsystem(const char *name)
 		return NULL;
 
 	system->ref_count = 1;
-	system->name = kstrdup(name, GFP_KERNEL);
-
-	if (!system->name)
-		goto out_free;
+	system->name = name;
 
 	system->filter = NULL;
 
@@ -1218,7 +1205,6 @@ create_new_subsystem(const char *name)
 	return system;
 
  out_free:
-	kfree(system->name);
 	kfree(system);
 	return NULL;
 }
-- 
1.7.10.4


