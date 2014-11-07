Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKGCoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:44:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10671 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751142AbaKGCoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:44:19 -0500
Date: Thu, 6 Nov 2014 21:44:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paul Bolle <pebolle@tiscali.nl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/trace: Correcting and extending
 tracepoint documentation
Message-ID: <20141106214415.78569cec@gandalf.local.home>
In-Reply-To: <5224C4B7.6090003@citrix.com>
References: <1377421194.2737.118@driftwood>
	<5224C4B7.6090003@citrix.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning out my inbox I find things that are fun to read.

On Mon, 2 Sep 2013 18:02:47 +0100
Zoltan Kiss <zoltan.kiss@citrix.com> wrote:

> Hi,
> 
> I'm not very familiar with the tracing framework, but I will try to 
> comment on your questions.
> 
> On 25/08/13 09:59, Rob Landley wrote:
> > On 08/22/2013 04:49:31 PM, Zoltan Kiss wrote:
> >> +#if !defined(_TRACE_SUBSYS_H) || defined(TRACE_HEADER_MULTI_READ)
> >> +#define _TRACE_SUBSYS_H
> >
> > But this makes no sense to me: why is it needed? (I.E. why must it be
> > block copied into each _user_ of tracepoints?)
> This is to prevent header reinclusion, the second condition makes it 
> possible to include it again from trace/define_trace.h

Right. The TRACE_HEADER_MULTI_READ must be there to allow the multiple
inclusion of the tracepoint header that is used by not only
define_trace.h, but also from include/trace/ftrace.h.

If you look in that file you'll find this:

#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)

where TRACE_INCLUDE(TRACE_INCLUDE_FILE) is defined as your header file
and it will include your data again.

It uses this basic idea:

#define DOGS \
   C(JACK_RUSSELL,	1), \
   C(ITALIAN_GREYHOUND, 2), \
   C(GERMAN_SHEPARD,	3)

#undef C
#define C(a, b)	#a

char *dog_names[] = { DOGS };

#undef C
#define C(a, b) a = b

enum dog_numbers { DOGS };

And so on.

That is, we abuse the C(a,b) macro to redefine what it stands for, and
then use DOGS, which has the C(a,b) redefined and can create strings of
dogs, enums of dogs, and guarantee that they always map correctly.

The ftrace.h file is basically that, and it abuses the various things
within TRACE_EVENT() to create all the code necessary to add a
tracepoint. All one needs to do is follow the example in
samples/trace_events/ and there events will magically appear in
the /sys/kernel/debug/tracing/events directory and they can trace there
data without having to worry at all about how the tracing
infrastructure actually works. That is, they don't need to write code
to make the tracing work. They just need to create a TRACE_EVENT() and
follow the directions.

Considering there's now over a thousand tracepoints in the kernel means
that this method worked rather well.



> 
> >>  #include <linux/tracepoint.h>
> >>
> >> @@ -48,10 +54,16 @@ DECLARE_TRACE(subsys_eventname,
> >>      TP_PROTO(int firstarg, struct task_struct *p),
> >>      TP_ARGS(firstarg, p));
> >>
> >> +#endif /* _TRACE_SUBSYS_H */
> >> +
> >> +/* This part must be outside protection */
> >> +#include <trace/define_trace.h>
> >> +
> >
> > Why? (Both why do you need to #include a header outside a multiple
> > inclusion guard, and why is the additional header needed at all in
> > _every_ subsystem trace header?)
> I see only one inclusion guard here, the one above. define_trace.h 
> should take effect at only one place, where CREATE_TRACE_POINTS is 
> defined, to create the tracepoints exactly once. However I don't see as 
> well why it should be outside protection. Maybe because the intentional 
> header reinclusion in it?

The define_trace.h is protected by:

#ifdef CREATE_TRACE_TRACEPOINTS

which it quickly undefines, to prevent recursion. But define_trace also
defines the TRACE_HEADER_MULTI_READ to let the code enter again.

The reason define_trace.h is outside of protection is because the trace
header may be included in header files which will define the
TRACE_SUBSYS_H. Since the CREATE_TRACE_POINTS is not defined yet, the
define_trace.h wont do anything. But since the TRACE_SUBSYS_H has
already been defined, and the define_trace.h is what would define the
TRACE_HEADER_MULTI_READ, then the define_trace.h would not be
accessible when the CREATE_TRACE_POINTS is defined and the header is
included again.

Make sense?

Also, it looks like that tracepoint.txt file does need some update.

Want to resend this patch?

I should probably write up a tracepoint-design.txt document that
explains the workings of the tracepoints in include/trace.

(I'll just add that to my long list of TODOs :-/ )

-- Steve
