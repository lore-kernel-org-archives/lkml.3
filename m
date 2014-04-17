Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaDQXoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:44:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:49321 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbaDQXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:43:57 -0400
Message-Id: <20140417234355.658063348@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 17 Apr 2014 19:42:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/2] tracing: Do not try to recreated toplevel set_ftrace_* files
References: <20140417234256.185058335@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Do-not-try-to-recreated-toplevel-set_ftrace_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the restructing of the function tracer working with instances, the
"top level" buffer is a bit special, as the function tracing is mapped
to the same set of filters. This is done by using a "global_ops" descriptor
and having the "set_ftrace_filter" and "set_ftrace_notrace" map to it.

When an instance is created, it creates the same files but its for the
local instance and not the global_ops.

The issues is that the local instance creation shares some code with
the global instance one and we end up trying to create th top level
"set_ftrace_*" files twice, and on boot up, we get an error like this:

 Could not create debugfs 'set_ftrace_filter' entry
 Could not create debugfs 'set_ftrace_notrace' entry

The reason they failed to be created was because they were created
twice, and the second time gives this error as you can not create the
same file twice.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 5b781d2..ffd5635 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -58,12 +58,16 @@ int ftrace_create_function_files(struct trace_array *tr,
 {
 	int ret;
 
-	/* The top level array uses the "global_ops". */
-	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL)) {
-		ret = allocate_ftrace_ops(tr);
-		if (ret)
-			return ret;
-	}
+	/*
+	 * The top level array uses the "global_ops", and the files are
+	 * created on boot up.
+	 */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
+		return 0;
+
+	ret = allocate_ftrace_ops(tr);
+	if (ret)
+		return ret;
 
 	ftrace_create_filter_files(tr->ops, parent);
 
-- 
1.8.5.3


