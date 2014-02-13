Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaBMSmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:42:52 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33725 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaBMSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:42:51 -0500
Date: Thu, 13 Feb 2014 19:42:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [RFC - beta][PATCH] tracing: Introduce TRACE_MARKER() no
 argument trace event
Message-ID: <20140213184245.GE14383@localhost.localdomain>
References: <20140207112357.35552998@gandalf.local.home>
 <20140213142640.GD14383@localhost.localdomain>
 <20140213102552.2b292484@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213102552.2b292484@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:25:52AM -0500, Steven Rostedt wrote:
> On Thu, 13 Feb 2014 15:26:42 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > Is this worth doing?
> > 
> > It sounds worth yeah. I've run into this situation multiple times where I had
> 
> Is it?
> 
> > to pass 0 instead of nothing on a tracepoint.
> 
> What tracepoints?

The context tracking ones. Yeah TBH that sole user doesn't justify the feature :)

> 
> The problem I have with a tracepoint that does not pass any information
> what's so ever, is that it can be too tempting to use. Tracepoints do
> not have zero overhead when not used, but a negligible one. Too many
> tracepoints add up, and their foot print can start to be noticed.

Yeah, that maybe overused. I don't know, actually the problem hasn't arised
much.
 
> Point being, why have a tracepoint if you are not recording any data?
> Just do a function trace, or add a kprobe. That's easy enough.

Yeah but it's still easier to use static tracepoints. Especially when you
need to ask somebody to report some traces.

One of the point of static tracepoints is also to propose some key events
to the user. It matters when we do all-events wide tracing for example.

> 
> But that said, see below.
> 
> > 
> > Now about the name, why not TRACE_EVENT_EMPTY?
> 
> Because that's an ugly name ;-)
> 
> Also a bit misleading, because it sounds like the there's no items
> attached or something. It is too close to "list_empty()". My original
> name was TRACE_EVENT_NOARGS(), which could work too.
> 
> Now another possible solution is to just introduce a trace_marker()
> function that you could place anywhere. And then they could show up in
> trace/events/markers/file-func-line/
> 
> We could do something like:
> 
> struct trace_marker {
> 	char *file;
> 	char *func;
> 	int line;
> 	struct static_key key;
> };
> 
> #define trace_marker() __trace_marker(__FILE__,__func__, __LINE__)
> static inline void __trace_marker(const char *file,
> 				const char *func, int line)
> {
> 	static struct trace_marker marker
> 		__attribute__((section("__trace_marker"))) = {
> 		.file = file,
> 		.func = func,
> 		.line = line
> 	};
> 
> 	if (static_key_false(&marker.key))
> 		trace_marker_call(&marker);
> }
> 
> As marker would be a static value, gcc should hard code the first
> parameter to it and make the call. Basically something like:
> 
> 	mov $0x<marker-address>, %rdi
> 	call trace_marker_call
> 
> If we really want to be efficient, we could extend jump labels for each
> arch, and remove the call completely.
> 
> 	asm goto ("1:"
> 		  ".byte NOP\n"
> 		  ".pushsection __trace_marker_struct\n"
> 		  "2:.quad 1b\n"
> 		  ".quad %file\n"
> 		  ".quad %func\n'
> 		  ".word %line\n"
> 		  ".popsection\n"
> 		  ".pushsection __trace_marker_ptrs\n"
> 		  ".quad 2b\n"
> 		  ".popsection\n"
> 		 : : file, func, line);
> 
> [ OK, I didn't follow the true format for asm syntax, but that's
> because I'm just trying to relay an idea, not actually make working
> code ]
> 
> Then the only thing that would be inserted in the code is a nop. We
> could then replace that nop with a call to a trampoline (similar to
> mcount) that can call a C function with the address that it came from
> so that the function could do a look up to find the matching marker to
> trace.
> 
> OK, this is probably a bit too much, but it is feasible. Most likely
> not worth the pain.

Anyway yeah, given the complication and the fact there are very few actual users, lets forget that feature.

Thanks.
