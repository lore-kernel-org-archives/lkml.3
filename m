Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBMP0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:26:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48740 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751480AbaBMP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:26:01 -0500
Date: Thu, 13 Feb 2014 10:25:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [RFC - beta][PATCH] tracing: Introduce TRACE_MARKER() no
 argument trace event
Message-ID: <20140213102552.2b292484@gandalf.local.home>
In-Reply-To: <20140213142640.GD14383@localhost.localdomain>
References: <20140207112357.35552998@gandalf.local.home>
	<20140213142640.GD14383@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 15:26:42 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Is this worth doing?
> 
> It sounds worth yeah. I've run into this situation multiple times where I had

Is it?

> to pass 0 instead of nothing on a tracepoint.

What tracepoints?

The problem I have with a tracepoint that does not pass any information
what's so ever, is that it can be too tempting to use. Tracepoints do
not have zero overhead when not used, but a negligible one. Too many
tracepoints add up, and their foot print can start to be noticed.

Point being, why have a tracepoint if you are not recording any data?
Just do a function trace, or add a kprobe. That's easy enough.

But that said, see below.

> 
> Now about the name, why not TRACE_EVENT_EMPTY?

Because that's an ugly name ;-)

Also a bit misleading, because it sounds like the there's no items
attached or something. It is too close to "list_empty()". My original
name was TRACE_EVENT_NOARGS(), which could work too.

Now another possible solution is to just introduce a trace_marker()
function that you could place anywhere. And then they could show up in
trace/events/markers/file-func-line/

We could do something like:

struct trace_marker {
	char *file;
	char *func;
	int line;
	struct static_key key;
};

#define trace_marker() __trace_marker(__FILE__,__func__, __LINE__)
static inline void __trace_marker(const char *file,
				const char *func, int line)
{
	static struct trace_marker marker
		__attribute__((section("__trace_marker"))) = {
		.file = file,
		.func = func,
		.line = line
	};

	if (static_key_false(&marker.key))
		trace_marker_call(&marker);
}

As marker would be a static value, gcc should hard code the first
parameter to it and make the call. Basically something like:

	mov $0x<marker-address>, %rdi
	call trace_marker_call

If we really want to be efficient, we could extend jump labels for each
arch, and remove the call completely.

	asm goto ("1:"
		  ".byte NOP\n"
		  ".pushsection __trace_marker_struct\n"
		  "2:.quad 1b\n"
		  ".quad %file\n"
		  ".quad %func\n'
		  ".word %line\n"
		  ".popsection\n"
		  ".pushsection __trace_marker_ptrs\n"
		  ".quad 2b\n"
		  ".popsection\n"
		 : : file, func, line);

[ OK, I didn't follow the true format for asm syntax, but that's
because I'm just trying to relay an idea, not actually make working
code ]

Then the only thing that would be inserted in the code is a nop. We
could then replace that nop with a call to a trampoline (similar to
mcount) that can call a C function with the address that it came from
so that the function could do a look up to find the matching marker to
trace.

OK, this is probably a bit too much, but it is feasible. Most likely
not worth the pain.

-- Steve

