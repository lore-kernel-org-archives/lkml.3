Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaIYUiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:38:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:12662 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752943AbaIYUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:38:49 -0400
Date: Thu, 25 Sep 2014 16:38:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jens Axboe \<axboe\@kernel.dk\> \(axboe\@kernel.dk\)" 
	<axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: ftrace function-graph and interprocessor interrupts
Message-ID: <20140925163843.23b28701@gandalf.local.home>
In-Reply-To: <87mw9oelje.fsf@tassilo.jf.intel.com>
References: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
	<87mw9oelje.fsf@tassilo.jf.intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 14:49:41 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> "Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:
> 
> > The function-graph tracer marks some interrupt handler functions
> > with ==========>  and <========== labels.
> 
> I'm not sure the marking is really that useful. Isn't it always obvious
> from the function names where an interrupt starts/end?
> 

Note, I find the markings useful, if anything, it makes it easier to
see when the system was interrupted. Not to mention, if it's broken, we
need to fix it.

Does, this patch fix it for you?

-- Steve

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 488273458bfd..bb48ec08edf8 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -50,6 +50,7 @@ struct fgraph_cpu_data {
 	int		depth;
 	int		depth_irq;
 	int		ignore;
+	int		in_irq;
 	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
 };
 
@@ -693,16 +694,64 @@ static int print_graph_abs_time(u64 t, struct trace_seq *s)
 			(unsigned long)t, usecs_rem);
 }
 
+enum {
+	FGRAPH_IRQ_ADDR		= 1,
+	FGRAPH_IRQ_FLAG		= 2,
+};
+
+static int fgraph_in_irq(struct trace_entry *ent, unsigned long addr)
+{
+	if ((addr >= (unsigned long)__irqentry_text_start) &&
+	     (addr < (unsigned long)__irqentry_text_end))
+		return FGRAPH_IRQ_ADDR;
+
+	if (ent->flags & TRACE_FLAG_HARDIRQ)
+		return FGRAPH_IRQ_FLAG;
+
+	return 0;
+}
+
 static enum print_line_t
-print_graph_irq(struct trace_iterator *iter, unsigned long addr,
-		enum trace_type type, int cpu, pid_t pid, u32 flags)
+print_graph_irq(struct trace_iterator *iter, struct trace_entry *ent,
+		unsigned long addr, enum trace_type type, int cpu,
+		pid_t pid, u32 flags)
 {
-	int ret;
+	unsigned int irq_flags = ent->flags;
+	struct fgraph_data *data = iter->private;
 	struct trace_seq *s = &iter->seq;
+	int *cpu_in_irq;
+	int in_irq;
+	int ret;
 
-	if (addr < (unsigned long)__irqentry_text_start ||
-		addr >= (unsigned long)__irqentry_text_end)
-		return TRACE_TYPE_UNHANDLED;
+	cpu_in_irq = &(per_cpu_ptr(data->cpu_data, cpu)->in_irq);
+	in_irq = fgraph_in_irq(ent, addr);
+
+	/*
+	 * When testing if we are entering or leaving an IRQ
+	 * we need to know how we got into this function.
+	 * Most irqs are within the irqentry text, but not all
+	 * of them. Those that we detect with the irqentry text
+	 * we stay in the irq until we hit the return address
+	 * from the irqentry text.
+	 * If we flagged being in an interrupt from the hard
+	 * irq flags, that means the interrupt handler was not
+	 * within the irqentry text, and we stay in the interrupt
+	 * until that flag is cleared.
+	 */
+	switch (*cpu_in_irq) {
+	case 0:
+		if (!in_irq)
+			return TRACE_TYPE_UNHANDLED;
+		break;
+	case FGRAPH_IRQ_ADDR:
+		if (in_irq != FGRAPH_IRQ_ADDR)
+			return TRACE_TYPE_UNHANDLED;
+		break;
+	case FGRAPH_IRQ_FLAG:
+		if (in_irq == FGRAPH_IRQ_FLAG)
+			return TRACE_TYPE_UNHANDLED;
+		break;
+	}
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		/* Absolute time */
@@ -735,10 +784,19 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	if (ret != TRACE_TYPE_HANDLED)
 		return ret;
 
-	if (type == TRACE_GRAPH_ENT)
-		ret = trace_seq_puts(s, "==========>");
-	else
+	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+		ret = print_graph_lat_fmt(s, ent);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	if (*cpu_in_irq) {
 		ret = trace_seq_puts(s, "<==========");
+		*cpu_in_irq = 0;
+	} else {
+		ret = trace_seq_puts(s, "==========>");
+		*cpu_in_irq = in_irq;
+	}
 
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -968,7 +1026,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 
 	if (type) {
 		/* Interrupt */
-		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
+		ret = print_graph_irq(iter, ent, addr, type, cpu, ent->pid, flags);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -1047,8 +1105,7 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
 	if (*depth_irq >= 0)
 		return 1;
 
-	if ((addr < (unsigned long)__irqentry_text_start) ||
-	    (addr >= (unsigned long)__irqentry_text_end))
+	if (!fgraph_in_irq(iter->ent, addr))
 		return 0;
 
 	/*
@@ -1226,7 +1283,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
+	ret = print_graph_irq(iter, ent, trace->func, TRACE_GRAPH_RET,
 			      cpu, pid, flags);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
