Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161570AbaKNSOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:14:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:53551 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161175AbaKNSOm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:14:42 -0500
Date: Fri, 14 Nov 2014 13:14:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 10/23 v4] tracing/uprobes: Do not use return values
 of trace_seq_printf()
Message-ID: <20141114131429.52b9345b@gandalf.local.home>
In-Reply-To: <20141114103733.03ffc40b@gandalf.local.home>
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.693008134@goodmis.org>
	<54662133.4060405@hitachi.com>
	<20141114103733.03ffc40b@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 10:37:33 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 15 Nov 2014 00:35:15 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>  
> > >  	for (i = 0; i < tu->tp.nr_args; i++) {
> > >  		struct probe_arg *parg = &tu->tp.args[i];
> > >  
> > > -		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
> > > -			goto partial;
> > > +		parg->type->print(s, parg->name, data + parg->offset, entry);
> > 
> > In 7/23 you've left loop canceling path, why don't you do same thing here?
> 
> While rebasing this series on my latest code, this patch conflicted. I
> notice the difference too (just two minutes ago!).
> 
> I agree, it should break out still.
> 
> Srikar, can I still have your Reviewed-by if I do that?
> 

Here's the new patch:

-- Steve

>From cd883b4c2d5d68ec598d6c6a3b5dce4dd99a4cc1 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 12 Nov 2014 17:26:57 -0500
Subject: [PATCH] tracing/uprobes: Do not use return values of
 trace_seq_printf()

The functions trace_seq_printf() and friends will soon no longer have
return values. Using trace_seq_has_overflowed() and trace_handle_return()
should be used instead.

Link: http://lkml.kernel.org/r/20141114011411.693008134@goodmis.org

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index e35327c787f7..fd76f8e108ef 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -852,16 +852,14 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	tu = container_of(event, struct trace_uprobe, tp.call.event);
 
 	if (is_ret_probe(tu)) {
-		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[1], entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[1], entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		if (!trace_seq_printf(s, "%s: (0x%lx)",
-					ftrace_event_name(&tu->tp.call),
-					entry->vaddr[0]))
-			goto partial;
+		trace_seq_printf(s, "%s: (0x%lx)",
+				 ftrace_event_name(&tu->tp.call),
+				 entry->vaddr[0]);
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
@@ -869,14 +867,13 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 		struct probe_arg *parg = &tu->tp.args[i];
 
 		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
-			goto partial;
+			goto out;
 	}
 
-	if (trace_seq_putc(s, '\n'))
-		return TRACE_TYPE_HANDLED;
+	trace_seq_putc(s, '\n');
 
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
+ out:
+	return trace_handle_return(s);
 }
 
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
-- 
1.8.1.4

