Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3CBDBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:01:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3CBDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:52 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EPJFq4A4-J4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=f3F_32DLUBcA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=zQAduZ78e74r6mv6zUYA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030050.323262801@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [for-next][PATCH 2/7] tracing: Use kmem_cache_alloc instead of kmalloc in trace_events.c
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Use-kmem_cache_alloc-instead-of-kmalloc-in-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The event structures used by the trace events are mostly persistent,
but they are also allocated by kmalloc, which is not the best at
allocating space for what is used. By converting these kmallocs
into kmem_cache_allocs, we can save over 50K of space that is
permanently allocated.

After boot we have:

 slab name          active allocated size
 ---------          ------ --------- ----
ftrace_event_file    979   1005     56   67    1
ftrace_event_field   2301   2310     48   77    1

The ftrace_event_file has at boot up 979 active objects out of
1005 allocated in the slabs. Each object is 56 bytes. In a normal
kmalloc, that would allocate 64 bytes for each object.

 1005 - 979  = 26 objects not used
 26 * 56 = 1456 bytes wasted

But if we used kmalloc:

 64 - 56 = 8 bytes unused per allocation
 8 * 979 = 7832 bytes wasted

 7832 - 1456 = 6376 bytes in savings

Doing the same for ftrace_event_field where there's 2301 objects
allocated in a slab that can hold 2310 with 48 bytes each we have:

 2310 - 2301 = 9 objects not used
 9 * 48 = 432 bytes wasted

A kmalloc would also use 64 bytes per object:

 64 - 48 = 16 bytes unused per allocation
 16 * 2301 = 36816 bytes wasted!

 36816 - 432 = 36384 bytes in savings

This change gives us a total of 42760 bytes in savings. At least
on my machine, but as there's a lot of these persistent objects
for all configurations that use trace points, this is a net win.

Thanks to Ezequiel Garcia for his trace_analyze presentation which
pointed out the wasted space in my code.

Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 21fe83b..5d8845d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -36,6 +36,11 @@ EXPORT_SYMBOL_GPL(event_storage);
 LIST_HEAD(ftrace_events);
 LIST_HEAD(ftrace_common_fields);
 
+#define GFP_TRACE (GFP_KERNEL | __GFP_ZERO)
+
+static struct kmem_cache *field_cachep;
+static struct kmem_cache *file_cachep;
+
 /* Double loops, do not use break, only goto's work */
 #define do_for_each_event_file(tr, file)			\
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
@@ -63,7 +68,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 {
 	struct ftrace_event_field *field;
 
-	field = kzalloc(sizeof(*field), GFP_KERNEL);
+	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
 	if (!field)
 		goto err;
 
@@ -91,7 +96,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 err:
 	if (field)
 		kfree(field->name);
-	kfree(field);
+	kmem_cache_free(field_cachep, field);
 
 	return -ENOMEM;
 }
@@ -143,7 +148,7 @@ void trace_destroy_fields(struct ftrace_event_call *call)
 		list_del(&field->link);
 		kfree(field->type);
 		kfree(field->name);
-		kfree(field);
+		kmem_cache_free(field_cachep, field);
 	}
 }
 
@@ -1383,7 +1388,7 @@ static void remove_event_from_tracers(struct ftrace_event_call *call)
 		list_del(&file->list);
 		debugfs_remove_recursive(file->dir);
 		remove_subsystem(file->system);
-		kfree(file);
+		kmem_cache_free(file_cachep, file);
 
 		/*
 		 * The do_for_each_event_file_safe() is
@@ -1462,7 +1467,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 {
 	struct ftrace_event_file *file;
 
-	file = kzalloc(sizeof(*file), GFP_KERNEL);
+	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
 	if (!file)
 		return -ENOMEM;
 
@@ -1484,7 +1489,7 @@ __trace_early_add_new_event(struct ftrace_event_call *call,
 {
 	struct ftrace_event_file *file;
 
-	file = kzalloc(sizeof(*file), GFP_KERNEL);
+	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
 	if (!file)
 		return -ENOMEM;
 
@@ -1791,7 +1796,7 @@ __trace_remove_event_dirs(struct trace_array *tr)
 		list_del(&file->list);
 		debugfs_remove_recursive(file->dir);
 		remove_subsystem(file->system);
-		kfree(file);
+		kmem_cache_free(file_cachep, file);
 	}
 }
 
@@ -1947,6 +1952,13 @@ int event_trace_del_tracer(struct trace_array *tr)
 	return 0;
 }
 
+static __init int event_trace_memsetup(void)
+{
+	field_cachep = KMEM_CACHE(ftrace_event_field, SLAB_PANIC);
+	file_cachep = KMEM_CACHE(ftrace_event_file, SLAB_PANIC);
+	return 0;
+}
+
 static __init int event_trace_enable(void)
 {
 	struct trace_array *tr = top_trace_array();
@@ -2021,6 +2033,7 @@ static __init int event_trace_init(void)
 
 	return 0;
 }
+early_initcall(event_trace_memsetup);
 core_initcall(event_trace_enable);
 fs_initcall(event_trace_init);
 
-- 
1.7.10.4


