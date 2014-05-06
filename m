Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbaEFNoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:44:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:52372 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001AbaEFNoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:44:09 -0400
Date: Tue, 6 May 2014 09:44:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
Message-ID: <20140506094407.507b6435@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are some code paths in the kernel that need to do some preparations
before it calls a tracepoint. As that code is worthless overhead when
the tracepoint is not enabled, it would be prudent to have that code
only run when the tracepoint is active. To accomplish this, all tracepoints
now get a static inline function called "trace_<tracepoint-name>_enabled()"
which returns true when the tracepoint is enabled and false otherwise.

As an added bonus, that function uses the static_key of the tracepoint
such that no branch is needed.

  if (trace_mytracepoint_enabled()) {
	arg = process_tp_arg();
	trace_mytracepoint(arg);
  }

Will keep the "process_tp_arg()" (which may be expensive to run) from
being executed when the tracepoint isn't enabled.

It's best to encapsulate the tracepoint itself in the if statement
just to keep races. For example, if you had:

  if (trace_mytracepoint_enabled())
	arg = process_tp_arg();
  trace_mytracepoint(arg);

There's a chance that the tracepoint could be enabled just after the
if statement, and arg will be undefined when calling the tracepoint.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9d30ee4..2e2a5f7 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -185,6 +185,11 @@ extern void syscall_unregfunc(void);
 	static inline void						\
 	check_trace_callback_type_##name(void (*cb)(data_proto))	\
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return static_key_false(&__tracepoint_##name.key);	\
 	}
 
 /*
@@ -230,6 +235,11 @@ extern void syscall_unregfunc(void);
 	}								\
 	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return false;						\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
-- 
1.8.1.4

