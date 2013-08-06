Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3HFEvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:51:52 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44026 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3HFEvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:51:50 -0400
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] xen/trace: replace old code with __print_symbolic
Date: Tue,  6 Aug 2013 13:51:21 +0900
Message-Id: <1375764681-4618-2-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375764681-4618-1-git-send-email-kpark3469@gmail.com>
References: <1375764681-4618-1-git-send-email-kpark3469@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

The advantage of using __print_symbolic() is that it allows both perf
and trace-cmd to read this event properly. Their parsers are not full C
parsers, and when you open code the the processing, they both will fail
to parse how to read the output, and will just default to printing the
fields via their raw numbers.
Another advantage is if the __entry->action is not one of the defined
fields, instead of outputting "??" it will output the number in hex. Say
if __entry->action is 0x123, the __print_symbolic will return "0x123" as
a string and that will be shown to the user, letting you know the actual
value of the field that was unknown.

Signed-off-by: Sahara <keun-o.park@windriver.com>
---
 include/trace/events/xen.h |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index d06b6da..8c6f945 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -10,6 +10,25 @@
 
 struct multicall_entry;
 
+#define show_paravirt_lazy_mode(val)				\
+	__print_symbolic(val,					\
+		{ PARAVIRT_LAZY_NONE,	"LAZY_NONE" },		\
+		{ PARAVIRT_LAZY_MMU,	"LAZY_MMU" },		\
+		{ PARAVIRT_LAZY_CPU,	"LAZY_CPU" })
+
+#define show_xen_mc_flush_reason(val)				\
+	__print_symbolic(val,					\
+		{ XEN_MC_FL_NONE,	"NONE" },		\
+		{ XEN_MC_FL_BATCH,	"BATCH" },		\
+		{ XEN_MC_FL_ARGS,	"ARGS" },		\
+		{ XEN_MC_FL_CALLBACK,	"CALLBACK" })
+
+#define show_xen_mc_extend_args(val)				\
+	__print_symbolic(val,					\
+		{ XEN_MC_XE_OK,	"OK" },				\
+		{ XEN_MC_XE_BAD_OP,	"BAD_OP" },		\
+		{ XEN_MC_XE_NO_SPACE,	"NO_SPACE" })
+
 /* Multicalls */
 DECLARE_EVENT_CLASS(xen_mc__batch,
 	    TP_PROTO(enum paravirt_lazy_mode mode),
@@ -18,9 +37,8 @@ DECLARE_EVENT_CLASS(xen_mc__batch,
 		    __field(enum paravirt_lazy_mode, mode)
 		    ),
 	    TP_fast_assign(__entry->mode = mode),
-	    TP_printk("start batch LAZY_%s",
-		      (__entry->mode == PARAVIRT_LAZY_MMU) ? "MMU" :
-		      (__entry->mode == PARAVIRT_LAZY_CPU) ? "CPU" : "NONE")
+	    TP_printk("start batch %s",
+		      show_paravirt_lazy_mode(__entry->mode)
 	);
 #define DEFINE_XEN_MC_BATCH(name)			\
 	DEFINE_EVENT(xen_mc__batch, name,		\
@@ -82,10 +100,7 @@ TRACE_EVENT(xen_mc_flush_reason,
 		    ),
 	    TP_fast_assign(__entry->reason = reason),
 	    TP_printk("flush reason %s",
-		      (__entry->reason == XEN_MC_FL_NONE) ? "NONE" :
-		      (__entry->reason == XEN_MC_FL_BATCH) ? "BATCH" :
-		      (__entry->reason == XEN_MC_FL_ARGS) ? "ARGS" :
-		      (__entry->reason == XEN_MC_FL_CALLBACK) ? "CALLBACK" : "??")
+		      show_xen_mc_flush_reason(__entry->reason)
 	);
 
 TRACE_EVENT(xen_mc_flush,
@@ -117,9 +132,7 @@ TRACE_EVENT(xen_mc_extend_args,
 	    TP_printk("extending op %u%s by %zu bytes res %s",
 		      __entry->op, xen_hypercall_name(__entry->op),
 		      __entry->args,
-		      __entry->res == XEN_MC_XE_OK ? "OK" :
-		      __entry->res == XEN_MC_XE_BAD_OP ? "BAD_OP" :
-		      __entry->res == XEN_MC_XE_NO_SPACE ? "NO_SPACE" : "???")
+		      show_xen_mc_extend_args(__entry->res)
 	);
 
 /* mmu */
-- 
1.7.1

