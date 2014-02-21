Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaBUCuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65424 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753187AbaBUCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:03 -0500
Message-Id: <20140221025001.623267630@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 05/18] ftrace: Add private data to ftrace_ops
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-ftrace-Add-private-data-to-ftrace_ops.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Passing data to the function callback was originally done by adding the
ftrace_ops in another structure, and using the container_of() to get
the field. But this adds a bit more complexity than it is worth, and
adding a simple .private field to ftrace_ops makes things a lot easier.

But be warned, the .private data should not be freed once it is used
unless the ftrace_ops itself has gone through the necessary freeing
routines. A simple synchronize_sched() is not enough as functions
can be traced that are called outside the view of RCU and all its
concoctions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f4233b1..ef1607e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -105,11 +105,23 @@ enum {
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
 };
 
+/*
+ * Note, ftrace_ops can be referenced outside of RCU protection.
+ * (Although, for perf, the control ops prevent that). If ftrace_ops is
+ * allocated and not part of kernel core data, the unregistering of it will
+ * perform a scheduling on all CPUs to make sure that there are no more users.
+ * Depending on the load of the system that may take a bit of time.
+ *
+ * Any private data added must also take care not to be freed and if private
+ * data is added to a ftrace_ops that is in core code, the user of the
+ * ftrace_ops must perform a schedule_on_each_cpu() before freeing it.
+ */
 struct ftrace_ops {
 	ftrace_func_t			func;
 	struct ftrace_ops		*next;
 	unsigned long			flags;
 	int __percpu			*disabled;
+	void				*private;
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
-- 
1.8.5.3


