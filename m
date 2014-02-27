Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaB0CVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:21:16 -0500
Received: from mail.efficios.com ([78.47.125.74]:44545 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbaB0CVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:21:15 -0500
Date: Thu, 27 Feb 2014 02:21:16 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <1534483926.31265.1393467676451.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140226203853.09b7d843@gandalf.local.home>
References: <20140226190140.590029589@goodmis.org> <1677033958.31194.1393450578584.JavaMail.zimbra@efficios.com> <20140226203853.09b7d843@gandalf.local.home>
Subject: Re: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint
 code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Request for acks on fixing tracepoint code
Thread-Index: tQtONmwbR9Ii0r/PhwnPYZUnfsp+EQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Peter Zijlstra" <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>
> Sent: Wednesday, February 26, 2014 8:38:53 PM
> Subject: Re: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint code
> 
> On Wed, 26 Feb 2014 21:36:18 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > ----- Original Message -----
> > > From: "Steven Rostedt" <rostedt@goodmis.org>
> > > To: linux-kernel@vger.kernel.org
> > > Cc: "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton"
> > > <akpm@linux-foundation.org>, "Peter Zijlstra"
> > > <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> > > "Mathieu Desnoyers"
> > > <mathieu.desnoyers@efficios.com>
> > > Sent: Wednesday, February 26, 2014 2:01:40 PM
> > > Subject: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint
> > > code
> > > 
> > > [ Request for Acks ]
> > > 
> > > Due to module tainting, we have tracepoints that silently do not work.
> > > That will be solved another way. But the trace event infrastructure
> > > should
> > > not be created for tainted modules. That is, the debugfs files should
> > > not exist for them.
> > > 
> > > By moving the tracepoint module taint test into tracepoint.h, we can
> > > reuse that same test when creating the module tracepoint events.
> > > 
> > > Note, I had to remove the tracepoint.h include from module.h as there
> > > was nothing in module.h that required tracepoint.h, but this broke
> > > a couple of event files (migrate.h and writeback.h) because they did
> > > not include tracepoint.h, and were just lucky that it was included
> > > by module.h.
> > 
> > When designing tracepoint.h, a lot of care went into making sure it did
> > not have needless dependency on other headers, since this header is
> > expected to be included into many other files and headers, thus posing
> > a clear risk of becoming yet another root of an include dependency hell.
> 
> Well, module.h is included in many more.

That is not the question. We don't care about how many times module.h is
included in the kernel, but rather what module.h itself includes and could
include in the future, throughout generic and arch-specific headers. If
someone want to add a tracepoint in a static inline function located within
a header file, they will need to include tracepoint.h. If tracepoint.h
happens to have a circular dependency on this header, there comes include
hell.

Arguing that it's OK to include headers within core instrumentation code
because they are themselves included pretty much everywhere is a paved way
to said include hell IMHO.

> 
> > 
> > While I agree on adding the API you propose, why made it a static inline ?
> > This adds this dependency from tracepoint.h on module.h. Instead, we could
> > just declare a symbol, and implement a tracepoint_module_has_bad_taint()
> > within kernel/tracepoint.c. It should not be a fast path anyway, so I don't
> > see the point it making it a static inline.
> > 
> > I also recommend sticking to the tracepoint_*() API (rather than trace_*).
> 
> Well, as this is now not just for tracepoints, but also used by the
> trace_events, and because the name is already too big (but
> descriptive), I rather not change it.

I just recalled we already have things like "DECLARE_TRACE" and such in
tracepoint.h. I'm OK with trace_module_has_bad_taint() then.

> 
> But as a compromise, I can move it to ftrace_event.h instead.

Since it will be used in tracepoint.c as well, which is a foundation of
ftrace_event, it would be bad coupling to make tracepoint.c include
ftrace_event.h (abstraction inversion). So I still think tracepoint.h
is the right place to put this, only not with the module.h dependency.

But perhaps I'm missing something. Why is it so important to you to make
this a static inline rather than a regular function call ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
