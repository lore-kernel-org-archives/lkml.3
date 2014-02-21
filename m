Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaBUCvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:51:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65361 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753361AbaBUCuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:08 -0500
Message-Id: <20140221025003.729406716@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 18/18] ftrace: Have static function trace clear ENABLED flag on unregister
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0018-ftrace-Have-static-function-trace-clear-ENABLED-flag.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The ENABLED flag needs to be cleared when a ftrace_ops is unregistered
otherwise it wont be able to be registered again.

This is only for static tracing and does not affect DYNAMIC_FTRACE at
all.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dcee546..5313c11 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4463,7 +4463,13 @@ static inline void ftrace_startup_enable(int command) { }
 			(ops)->flags |= FTRACE_OPS_FL_ENABLED;		\
 		___ret;							\
 	})
-# define ftrace_shutdown(ops, command) __unregister_ftrace_function(ops)
+# define ftrace_shutdown(ops, command)					\
+	({								\
+		int ___ret = __unregister_ftrace_function(ops);		\
+		if (!___ret)						\
+			(ops)->flags &= ~FTRACE_OPS_FL_ENABLED;		\
+		___ret;							\
+	})
 
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
-- 
1.8.5.3


