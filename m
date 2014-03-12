Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaCLRvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:51:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:12648 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640AbaCLRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:51:03 -0400
Date: Wed, 12 Mar 2014 13:50:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140312135059.2d497b58@gandalf.local.home>
In-Reply-To: <285520930.1511.1394642395537.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
	<20140311151357.077c5a68@gandalf.local.home>
	<1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
	<20140312111100.42ea41c2@gandalf.local.home>
	<20140312114611.43547df7@gandalf.local.home>
	<437054772.1403.1394640336308.JavaMail.zimbra@efficios.com>
	<20140312121813.1e0102aa@gandalf.local.home>
	<285520930.1511.1394642395537.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 16:39:55 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> > Are you telling me it's not possible to delete the entire probe?
> 
> The ownership flow is the following:
> 
> 1) Tracer creates name, probe, data objects. The probe can be typically
>    code within a probe provider module, which needs to have a reference
>    count incremented. The name and data objects can be dynamically allocated,
>    or in some special cases part of a probe provider module (again with
>    refcount incremented).
> 
> 2) The tracer registers the tracepoint probe. If registration returns 0,
>    the tracer should not free those elements until it calls tracepoint
>    probe unregister for that (name, probe, data) tuple.
> 
> 3) Tracer calls tracepoint probe unregister for the (name, probe, data) tuple.

We can make the registered tracepoint up the mod count to prevent it
from unloading. But that probably defeats the purpose.

> 
> 4) Tracer calls tracepoint_synchronize_unregister() to ensure quiescence
>    of tracepoint call sites wrt the probe that has just been unregistered.

Tracepoints should all be disabled when the module is unloaded. If you
have a tracepoint callback still being called when the module is
unloaded then something is seriously wrong. That means the callback
will go back to the trace_foo() call which is in the module code and
will no longer exist. Kernel panic is the result.


> 
> 5) Tracer can free/unref the probe provider module.

I'm a bit confused at what you are doing. As this is totally unrelated
to anything that happens in the kernel.

> 
> > 
> > What I'm proposing is to do what the trace events do. Delete everything
> > associated to the tracepoints associated to the module.
> 
> Is your intent to have a module "going" notifier in tracepoint.c managing
> ownership of objects it does not own ? If not, I guess I'm not understanding
> your proposal fully.

Well, actually that's exactly what the trace_event code does. It
disables any event of the module that happens to be enabled.

Look at event_remove() in kernel/trace/trace_events.c

On module unload, the events are destroyed.

Thus, what your module should do, is exactly what event_remove() does.
On module unload, you unregister any of the tracepoints that were
registered. Just like any other module resource. If you request a
resource on the behalf of a module, it is up to you to free it when the
module is unloaded.

The tracepoint code will just destroy what it set up when the module
was loaded. It's up to your module to clean up the allocations that you
made when the module was loaded on unload. Just like we do for all
other resources.

Mathieu, stop thinking that tracepoints are special. They are not.


-- Steve
