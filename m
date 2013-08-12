Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3HLOKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:10:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab3HLOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:10:38 -0400
Date: Mon, 12 Aug 2013 16:10:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCHv2] ftrace: Add initialization check in trace_printk for *puts
 paths
Message-ID: <20130812141028.GB1032@krava.brq.redhat.com>
References: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
 <20130812090758.2c0018a6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812090758.2c0018a6@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:07:58AM -0400, Steven Rostedt wrote:

SNIP

> >  static bool allocate_snapshot;
> >  
> > +#define TRACE_PRINTK_DENIED \
> 
> 
> s/TRACE_PRINTK_DENIED/TRACE_PRINTK_DISABLED/
> 
> -- Steve
> 
> > +	unlikely(tracing_selftest_running || tracing_disabled)
> > +
> >  static int __init set_cmdline_ftrace(char *str)
> >  {
> >  	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> > 

v2 attached, thanks
jirka


---
Adding initialization check in trace_printk for *puts
paths, plus unifying the check for all related cases.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 496f94d..cef7e55 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -126,6 +126,9 @@ static char *default_bootup_tracer;
 
 static bool allocate_snapshot;
 
+#define TRACE_PRINTK_DISABLED \
+	unlikely(tracing_selftest_running || tracing_disabled)
+
 static int __init set_cmdline_ftrace(char *str)
 {
 	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
@@ -435,6 +438,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	unsigned long irq_flags;
 	int alloc;
 
+	if (TRACE_PRINTK_DISABLED)
+		return 0;
+
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	local_save_flags(irq_flags);
@@ -475,6 +481,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
 
+	if (TRACE_PRINTK_DISABLED)
+		return 0;
+
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
@@ -1757,7 +1766,7 @@ void trace_dump_stack(int skip)
 {
 	unsigned long flags;
 
-	if (tracing_disabled || tracing_selftest_running)
+	if (TRACE_PRINTK_DISABLED)
 		return;
 
 	local_save_flags(flags);
@@ -1976,7 +1985,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	char *tbuffer;
 	int len = 0, size, pc;
 
-	if (unlikely(tracing_selftest_running || tracing_disabled))
+	if (TRACE_PRINTK_DISABLED)
 		return 0;
 
 	/* Don't pollute graph traces with trace_vprintk internals */
@@ -2032,7 +2041,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 	unsigned long flags;
 	char *tbuffer;
 
-	if (tracing_disabled || tracing_selftest_running)
+	if (TRACE_PRINTK_DISABLED)
 		return 0;
 
 	/* Don't pollute graph traces with trace_vprintk internals */
-- 
1.7.11.7

