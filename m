Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaFEPVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:21:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:63203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751683AbaFEPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:21:16 -0400
Message-Id: <20140605152114.331909098@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 11:15:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 5/5] tracing: Add __get_dynamic_array_len() macro for trace events
References: <20140605151540.672365024@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-Add-__get_dynamic_array_len-macro-for-trace-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a trace event uses a dynamic array for something other than a string
then there's currently no way the TP_printk() can figure out what size
it is. A __get_dynamic_array_len() is required to know the length.

This also simplifies the __get_bitmask() macro which required it as well,
but instead just hardcoded it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 9b7a989dcbcc..0fd06fef9fac 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -203,6 +203,10 @@
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
@@ -211,7 +215,7 @@
 	({								\
 		void *__bitmask = __get_dynamic_array(field);		\
 		unsigned int __bitmask_size;				\
-		__bitmask_size = (__entry->__data_loc_##field >> 16) & 0xffff; \
+		__bitmask_size = __get_dynamic_array_len(field);	\
 		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
 	})
 
@@ -636,6 +640,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __print_symbolic
 #undef __print_hex
 #undef __get_dynamic_array
+#undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
 
@@ -700,6 +705,10 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
-- 
2.0.0.rc2


