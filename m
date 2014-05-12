Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaELPQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:16:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:27486 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758554AbaELPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:05 -0400
Message-Id: <20140512151203.113684478@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Lameter <cl@linux.com>
Subject: [for-next][PATCH 03/13] tracing: Replace __get_cpu_var uses with this_cpu_ptr
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.

Link: http://lkml.kernel.org/p/alpine.DEB.2.10.1404291415560.18364@gentwo.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kprobes.h | 2 +-
 kernel/trace/ftrace.c   | 4 ++--
 kernel/trace/trace.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf2..7bd2ad0 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -355,7 +355,7 @@ static inline void reset_current_kprobe(void)
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
 int register_kprobe(struct kprobe *p);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9eb1aa0..38e5cf7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -822,7 +822,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip,
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -853,7 +853,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4c392c8..0543169 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1726,7 +1726,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
 
 		if (regs)
-- 
1.8.5.3


