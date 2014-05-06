Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaEFUxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:53:44 -0400
Received: from mail.efficios.com ([78.47.125.74]:37558 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbaEFUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:53:42 -0400
Date: Tue, 6 May 2014 20:53:41 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <799562553.12242.1399409621298.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140506154845.43c7b0ad@gandalf.local.home>
References: <20140506094407.507b6435@gandalf.local.home> <1033323713.12184.1399404932965.JavaMail.zimbra@efficios.com> <20140506154845.43c7b0ad@gandalf.local.home>
Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Add trace_<tracepoint>_enabled() function
Thread-Index: +ULLZQaAbpirMaAMSI4hHD1La85rEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Javi Merino"
> <javi.merino@arm.com>, "David Howells" <dhowells@redhat.com>, "Ingo Molnar" <mingo@kernel.org>
> Sent: Tuesday, May 6, 2014 3:48:45 PM
> Subject: Re: [RFA][PATCH] tracing: Add trace_<tracepoint>_enabled() function
> 
> On Tue, 6 May 2014 19:35:32 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > I'm OK with the intend, however there seems to be two means to achieve
> > this, and I'm not sure the proposed solution is safe.
> 
> I do plan on adding more documentation to this to stress that this
> should be done like this. But hey, we're kernel developers, we should
> be responsible enough to not require the hand holding.

I like your optimism. ;-)

> Perhaps change checkpatch to make sure that any use of
> trace_tracepoint_enabled() encompasses the tracepoint.
> 
> Then again, if arg is initialized to something that the tracepoint can
> handle, that would work too.

True.

> 
> > 
> > As you point out just above, the trace_mytracepoint_enabled() construct
> > can easily lead to incorrect code if users are not very careful on how
> > they use the condition vs the tracepoint itself.
> > 
> > I understand that the reason why we cannot simply put the call
> > to "process_tp_arg()" within the parameters passed to trace_mytracepoint()
> > is because trace_mytracepoint() is a static inline, and that the
> > side-effects of the arguments it receives need to be evaluated whether
> > the tracepoint is enabled or not.
> > 
> > To overcome this issue, I have used a layer of macro on top of the
> > trace_*() call in lttng-ust, giving something similar to this:
> > 
> > #define tracepoint(name, ...)                                      \
> >         do {                                                       \
> >                 if (static_key_false(&__tracepoint_##name.key)     \
> >                         trace_##name(__VA_ARGS__);                 \
> >         } while (0)
> > 
> > and the static inline trace_##name declared by __DECLARE_TRACE
> > simply contains __DO_TRACE(&__tracepoint_##name,
> >                                 TP_PROTO(data_proto),
> >                                 TP_ARGS(data_args),
> >                                 TP_CONDITION(cond),,);
> > 
> > This allow calling a tracepoint with:
> > 
> >    tracepoint(mytracepoint, process_tp_arg());
> > 
> > making sure that process_tp_arg() will only be evaluated if
> > the tracepoint is enabled. It also ensures that it's impossible
> > to create a C construct that will open a race window where a
> > tracepoint could be called with an unpopulated parameter, such as:
> > 
> >    if (trace_mytracepoint_enabled())
> >  	arg = process_tp_arg();
> >    trace_mytracepoint(arg);
> > 
> > Thoughts ?
> > 
> 
> The first time I thought about using this was with David's code, which
> does this:
> 
> 	if (static_key_false(&i2c_trace_msg)) {
> 		int i;
> 		for (i = 0; i < ret; i++)
> 			if (msgs[i].flags & I2C_M_RD)
> 				trace_i2c_reply(adap, &msgs[i], i);
> 		trace_i2c_result(adap, i, ret);
> 	}
> 
> That would look rather silly in a tracepoint.

Which goes with a mandatory silly question: how do you intend mapping
the single key to two different tracepoints ?

Thanks,

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
