Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaCLSrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:47:20 -0400
Received: from mail.efficios.com ([78.47.125.74]:51428 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaCLSrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:47:17 -0400
Date: Wed, 12 Mar 2014 18:47:15 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <1906756968.1732.1394650035535.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312135059.2d497b58@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <1501695915.977.1394634294978.JavaMail.zimbra@efficios.com> <20140312111100.42ea41c2@gandalf.local.home> <20140312114611.43547df7@gandalf.local.home> <437054772.1403.1394640336308.JavaMail.zimbra@efficios.com> <20140312121813.1e0102aa@gandalf.local.home> <285520930.1511.1394642395537.JavaMail.zimbra@efficios.com> <20140312135059.2d497b58@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: keWLWRxZjo4/qU8LDZAVI+HlV/Od6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>
> Sent: Wednesday, March 12, 2014 1:50:59 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Wed, 12 Mar 2014 16:39:55 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > > Are you telling me it's not possible to delete the entire probe?
> > 
> > The ownership flow is the following:
> > 
> > 1) Tracer creates name, probe, data objects. The probe can be typically
> >    code within a probe provider module, which needs to have a reference
> >    count incremented. The name and data objects can be dynamically
> >    allocated,
> >    or in some special cases part of a probe provider module (again with
> >    refcount incremented).
> > 
> > 2) The tracer registers the tracepoint probe. If registration returns 0,
> >    the tracer should not free those elements until it calls tracepoint
> >    probe unregister for that (name, probe, data) tuple.
> > 
> > 3) Tracer calls tracepoint probe unregister for the (name, probe, data)
> > tuple.
> 
> We can make the registered tracepoint up the mod count to prevent it
> from unloading. But that probably defeats the purpose.

It seems more flexible to me to let this be handled by the tracer rather than
tracepoint.c.

> 
> > 
> > 4) Tracer calls tracepoint_synchronize_unregister() to ensure quiescence
> >    of tracepoint call sites wrt the probe that has just been unregistered.
> 
> Tracepoints should all be disabled when the module is unloaded.

This is only true for the tracepoint call sites located within this module.

> If you
> have a tracepoint callback still being called when the module is
> unloaded then something is seriously wrong. That means the callback
> will go back to the trace_foo() call which is in the module code and
> will no longer exist. Kernel panic is the result.

I agree that the specific call sites within an unloaded module need to be
already quiescent by the time the module is unmapped from memory, no argument
there.

The scenario I'm painting here (ownership of name, probe and data through the
5 steps) is the common "enable tracing, disable tracing" scenario, where the
module is not necessarily unloaded.

> 
> 
> > 
> > 5) Tracer can free/unref the probe provider module.
> 
> I'm a bit confused at what you are doing. As this is totally unrelated
> to anything that happens in the kernel.

The objects "name" and "data" can be dynamically allocated, and need to be
freed at some point. The probe provider module need to have its reference
count released after its probe function is unregistered. However, there
may still be tracepoint call sites in flights (again, this is a normal
enable tracing/disable tracing scenario, no module unload).

I detailed this scenario to answer your question "Are you telling me it's
not possible to delete the entire probe?", thus showing what the ownership
of objects passed to register/unregister is, to shed some light on why
it's currently not possible to unregister a tracepoint probe from
tracepoint.c, because it does not have ownership of those objects.

> 
> > 
> > > 
> > > What I'm proposing is to do what the trace events do. Delete everything
> > > associated to the tracepoints associated to the module.
> > 
> > Is your intent to have a module "going" notifier in tracepoint.c managing
> > ownership of objects it does not own ? If not, I guess I'm not
> > understanding
> > your proposal fully.
> 
> Well, actually that's exactly what the trace_event code does. It
> disables any event of the module that happens to be enabled.
> 
> Look at event_remove() in kernel/trace/trace_events.c
> 
> On module unload, the events are destroyed.

Isn't trace_event.c responsible for dealing with tracepoint probes rather
than call sites ? This is quite different. A tracepoint probe "foo" is only
located within a single module (the one you are unloading here). However,
if you try to unload a module that contains the callsite "foo", you have no
guarantee that no other modules also contain this callsite, and therefore
you cannot destroy the associated name, probe, nor data objects.

> 
> Thus, what your module should do, is exactly what event_remove() does.
> On module unload, you unregister any of the tracepoints that were
> registered. Just like any other module resource. If you request a
> resource on the behalf of a module, it is up to you to free it when the
> module is unloaded.

You seem to try to apply a logic that works in the case of the probes
defined by trace event to tracepoint call sites, but the fact is that
they are very different. Or again perhaps I'm just on the wrong track.

> 
> The tracepoint code will just destroy what it set up when the module
> was loaded. It's up to your module to clean up the allocations that you
> made when the module was loaded on unload. Just like we do for all
> other resources.
> 
> Mathieu, stop thinking that tracepoints are special. They are not.

I'm trying to understand how module going of tracepoint probes and
call sites can be considered the same. What am I missing ?

Thanks,

Mathieu

> 
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
