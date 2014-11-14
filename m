Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965682AbaKNSWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:22:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33253 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964931AbaKNSWO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:22:14 -0500
Date: Fri, 14 Nov 2014 13:21:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 02/23 v4] tracing: Add trace_seq_has_overflowed()
 and trace_handle_return()
Message-ID: <20141114132156.7af0e086@gandalf.local.home>
In-Reply-To: <20141114112522.GA2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011410.365183157@goodmis.org>
	<20141114112522.GA2988@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 12:25:23 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> > @@ -193,7 +184,6 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
> >  	struct trace_seq *s = &iter->seq;
> >  	struct trace_seq *p = &iter->tmp_seq;
> >  	struct trace_entry *entry;
> > -	int ret;
> >  
> >  	event = container_of(trace_event, struct ftrace_event_call, event);
> >  	entry = iter->ent;
> > @@ -204,8 +194,9 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
> >  	}
> >  
> >  	trace_seq_init(p);
> > -	ret = trace_seq_printf(s, "%s: ", ftrace_event_name(event));
> > -	if (!ret)
> > +	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
> > +
> > +	if (trace_seq_has_overflowed(s))
> >  		return TRACE_TYPE_PARTIAL_LINE;
> >  
> >  	return 0;
> 
> This looks like a bug in the original code. It returns 0 in each case
> because TRACE_TYPE_PARTIAL_LINE == 0. I guess that the last three
> lines should get replaced by
> 
> 	return trace_handle_return(s);
> 
> as it is done in the other functions.

Here's the fix for this:

-- Steve

>From 5986fa1aee34cbfe2513d7a20d2590fb2a1fc1f2 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 14 Nov 2014 11:42:06 -0500
Subject: [PATCH] tracing: Fix return value of ftrace_raw_output_prep()

If the trace_seq of ftrace_raw_output_prep() is full this function
returns TRACE_TYPE_PARTIAL_LINE, otherwise it returns zero.

The problem is that TRACE_TYPE_PARTIAL_LINE happens to be zero!

The thing is, the caller of ftrace_raw_output_prep() expects a
success to be zero. Change that to expect it to be
TRACE_TYPE_HANDLED.

Link: http://lkml.kernel.org/r/20141114112522.GA2988@dhcp128.suse.cz

Reminded-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      | 2 +-
 kernel/trace/trace_output.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f13471b5d27a..139b5067345b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -277,7 +277,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))iter->ent;				\
 									\
 	ret = ftrace_raw_output_prep(iter, trace_event);		\
-	if (ret)							\
+	if (ret != TRACE_TYPE_HANDLED)					\
 		return ret;						\
 									\
 	trace_seq_printf(s, print);					\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 163c11b6b8ff..723818bc83b4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -196,10 +196,7 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	trace_seq_init(p);
 	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
 
-	if (trace_seq_has_overflowed(s))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return 0;
+	return trace_handle_return(s);
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
-- 
1.8.1.4

