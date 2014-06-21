Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaFULuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 07:50:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:7212 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751803AbaFULub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 07:50:31 -0400
Date: Sat, 21 Jun 2014 07:50:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [for-next][PATCH] tracing: Add __field_struct macro for
 TRACE_EVENT()
Message-ID: <20140621075025.1aadb1f6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Updates to the RAS tracepoints found that the __field() macro has a bug
in it where you can not use it with structures. It only works with
primitives. This is because of an added check to determine if the field
is signed or not.

A new macro is created called __field_struct() that can be used to save
structured data directly in the tracepoint and not have to settle for
storing as an array with memcpy.

-- Steve



  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 4d4c9cc839a308be3289a361ccba4447ee140552


Steven Rostedt (1):
      tracing: Add __field_struct macro for TRACE_EVENT()

----
 include/trace/ftrace.h                     | 33 ++++++++++++++++++++++++++++++
 samples/trace_events/trace-events-sample.h |  3 ++-
 2 files changed, 35 insertions(+), 1 deletion(-)
---------------------------
commit 4d4c9cc839a308be3289a361ccba4447ee140552
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Tue Jun 17 08:59:16 2014 -0400

    tracing: Add __field_struct macro for TRACE_EVENT()
    
    Currently the __field() macro in TRACE_EVENT is only good for primitive
    values, such as integers and pointers, but it fails on complex data types
    such as structures or unions. This is because the __field() macro
    determines if the variable is signed or not with the test of:
    
      (((type)(-1)) < (type)1)
    
    Unfortunately, that fails when type is a structure.
    
    Since trace events should support structures as fields a new macro
    is created for such a case called __field_struct() which acts exactly
    the same as __field() does but it does not do the signed type check
    and just uses a constant false for that answer.
    
    Cc: Tony Luck <tony.luck@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0fd06fef9fac..26b4f2e13275 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -44,6 +44,12 @@
 #undef __field_ext
 #define __field_ext(type, item, filter_type)	type	item;
 
+#undef __field_struct
+#define __field_struct(type, item)	type	item;
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)	type	item;
+
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
@@ -122,6 +128,12 @@
 #undef __field_ext
 #define __field_ext(type, item, filter_type)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
@@ -315,9 +327,21 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	if (ret)							\
 		return ret;
 
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)			\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item),			\
+				 0, filter_type);			\
+	if (ret)							\
+		return ret;
+
 #undef __field
 #define __field(type, item)	__field_ext(type, item, FILTER_OTHER)
 
+#undef __field_struct
+#define __field_struct(type, item) __field_struct_ext(type, item, FILTER_OTHER)
+
 #undef __array
 #define __array(type, item, len)					\
 	do {								\
@@ -379,6 +403,12 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __field_ext
 #define __field_ext(type, item, filter_type)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
+#undef __field_struct_ext
+#define __field_struct_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
@@ -550,6 +580,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef __field
 #define __field(type, item)
 
+#undef __field_struct
+#define __field_struct(type, item)
+
 #undef __array
 #define __array(type, item, len)
 
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 6af373236d73..4b0113f73ee9 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -56,7 +56,8 @@
  * struct:  This defines the way the data will be stored in the ring buffer.
  *    There are currently two types of elements. __field and __array.
  *    a __field is broken up into (type, name). Where type can be any
- *    type but an array.
+ *    primitive type (integer, long or pointer). __field_struct() can
+ *    be any static complex data value (struct, union, but not an array).
  *    For an array. there are three fields. (type, name, size). The
  *    type of elements in the array, the name of the field and the size
  *    of the array.
