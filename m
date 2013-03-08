Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab3CHSB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:01:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542Ab3CHSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:01:53 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=oJneQH_4DZwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rg4p-nn-OvQA:10 a=QyXUC8HyAAAA:8 a=UxLCWRIOoSQmhNVY6vcA:9 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308180151.844531416@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Mar 2013 12:59:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [for-next][PATCH 2/2] tracing: Fix the branch tracer that broke with buffer change
References: <20130308175931.135352630@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-the-branch-tracer-that-broke-with-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The changce to add the trace_buffer struct to have the trace array
have both the main buffer and max buffer broke the branch tracer
because the change did not update that code. As the branch tracer
adds a significant amount of overhead, and must be selected via
a selection (not a allyesconfig) it was missed in testing.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 6dadbef..d594da0 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -52,12 +52,12 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	if (atomic_inc_return(&data->disabled) != 1)
 		goto out;
 
 	pc = preempt_count();
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
-- 
1.7.10.4


