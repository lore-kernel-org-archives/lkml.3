Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaKRDEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:04:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:18535 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751524AbaKRDEv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:04:51 -0500
Date: Mon, 17 Nov 2014 22:04:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 11/23 v4] tracing: Do not use return values of
 trace_seq_printf() in syscall tracing
Message-ID: <20141117220449.253128cc@gandalf.local.home>
In-Reply-To: <20141117214411.73a12be4@gandalf.local.home>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.842421346@goodmis.org>
	<87ioids587.fsf@sejong.aot.lge.com>
	<20141117214411.73a12be4@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 21:44:11 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 18 Nov 2014 09:49:12 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 

> > > -	ret = trace_seq_printf(s, "%s(", entry->name);
> > > -	if (!ret)
> > > -		return TRACE_TYPE_PARTIAL_LINE;
> > > +	trace_seq_printf(s, "%s(", entry->name);
> > >  
> > >  	for (i = 0; i < entry->nb_args; i++) {
> > 
> > 		if (trace_seq_has_overflowed())
> > 			goto end;
> > ?
> 
> Yeah, I guess I can do that.
> 

Here's the update:

-- Steve

>From 17845179b46f3e8b849d06a9a0069fd0a085e666 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 12 Nov 2014 17:41:33 -0500
Subject: [PATCH] tracing: Do not use return values of trace_seq_printf() in
 syscall tracing

The functions trace_seq_printf() and friends will not be returning values
soon and will be void functions. To know if they succeeded or not, the
functions trace_seq_has_overflowed() and trace_handle_return() should be
used instead.

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c | 47 +++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4dc8b79c5f75..a72f3d8d813e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -114,7 +114,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_enter *trace;
 	struct syscall_metadata *entry;
-	int i, ret, syscall;
+	int i, syscall;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -128,35 +128,28 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 		goto end;
 	}
 
-	ret = trace_seq_printf(s, "%s(", entry->name);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "%s(", entry->name);
 
 	for (i = 0; i < entry->nb_args; i++) {
+
+		if (trace_seq_has_overflowed(s))
+			goto end;
+
 		/* parameter types */
-		if (trace_flags & TRACE_ITER_VERBOSE) {
-			ret = trace_seq_printf(s, "%s ", entry->types[i]);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+		if (trace_flags & TRACE_ITER_VERBOSE)
+			trace_seq_printf(s, "%s ", entry->types[i]);
+
 		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
-				       trace->args[i],
-				       i == entry->nb_args - 1 ? "" : ", ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		trace_seq_printf(s, "%s: %lx%s", entry->args[i],
+				 trace->args[i],
+				 i == entry->nb_args - 1 ? "" : ", ");
 	}
 
-	ret = trace_seq_putc(s, ')');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
+	trace_seq_putc(s, ')');
 end:
-	ret =  trace_seq_putc(s, '\n');
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_putc(s, '\n');
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t
@@ -168,7 +161,6 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	struct syscall_trace_exit *trace;
 	int syscall;
 	struct syscall_metadata *entry;
-	int ret;
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
@@ -176,7 +168,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 
 	if (!entry) {
 		trace_seq_putc(s, '\n');
-		return TRACE_TYPE_HANDLED;
+		goto out;
 	}
 
 	if (entry->exit_event->event.type != ent->type) {
@@ -184,12 +176,11 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 		return TRACE_TYPE_UNHANDLED;
 	}
 
-	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
+	trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
 				trace->ret);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
 
-	return TRACE_TYPE_HANDLED;
+ out:
+	return trace_handle_return(s);
 }
 
 extern char *__bad_type_size(void);
-- 
1.8.1.4


