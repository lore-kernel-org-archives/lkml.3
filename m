Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaBZPGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:06:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2421 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963AbaBZPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:06:06 -0500
Date: Wed, 26 Feb 2014 10:05:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140226100557.5faec8bb@gandalf.local.home>
In-Reply-To: <1641863026.30821.1393424602830.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
	<20140224105454.3e1981ba@gandalf.local.home>
	<1588404356.29584.1393266723043.JavaMail.zimbra@efficios.com>
	<20140224141007.68a9b5b0@gandalf.local.home>
	<1641863026.30821.1393424602830.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 14:23:22 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > 
> > Why? This is not a normal activity to for the user. You seem to have a
> > few specific users, but those are exceptions, and this has nothing to
> > do with normal kernel developer view.
> 
> The very fact that you present "normal kernel developer view" as being
> the norm just tells how much we focus on different user bases. Since
> the user-base you target are mostly kernel developers, it is
> understandable that you dismiss our user base as being small and
> specific.
> 
> There are many more Linux users than kernel developers out there. The
> main difference is that the former category don't usually post on LKML.
>

Yes, there are many more Linux users than kernel developers, but for
those that need to look at tracepoints (the internals of the happenings
of the kernel), of the tracepoint users, there are many more kernel
developers than Linux users. That is key here in this debate!

> > 
> > Tracing a module that's being loaded is far from normal user activity.
> > 
> > Now, for boot up, I could see enabling all tracepoints. For that, we
> > can add a hook to the module load that when a flag is set, we can
> > enable all trace events in the module as it is loaded. That would work
> > for boot up.
> > 
> > If this is such a user activity, please explain to me what scenario
> > that requires tracing a module being loaded that could not easily be
> > accomplished with a module parameter?
> 
> OK. Here is the scenario:
> 
> - We have users deploying tracing on their systems in flight recorder

Yes you have users, but these are a very minority of Linux users.

>   "snapshot" mode (writing into circular memory buffers, without any
>   other type of I/O, except when a snapshot of the buffers is needed).
>   They wish collect data from user-space and kernel-space, including
>   from kernel modules. You can think of it like a detailed crash

And here is the key difference again. They want to know detail
information on the happenings of the kernel. At this point, they cease
from being normal users, and are boarding with kernel developers.


>   tracing for Linux distributions with very low overhead. Which
>   tracepoints are enabled depends on configuration of this flight
>   recorder tracing "session". There may be multiple concurrent tracing
>   sessions enabled in parallel, trying each to pinpoint different kind
>   of issues. Some are controlled by the distro end-user, others are
>   automatically enabled by the distro if the user agrees to provide
>   detailed bug report feedback to the distro.

Again, this is all a very small niche, and not one that we need to bend
over backwards for (ie, not warning about tracepoints not being
enabled).


> - There, an automated analysis wants to hook on specific module
>   tracepoints (e.g. the usb stack) which are loaded only when the
>   devices are physically plugged into the computer.

Again, look at what you are saying. "hook on a specific module". THIS
IS NOT A NORMAL LINUX USER. This is a very small niche, and those that
do such a thing, are more like those that may become or are kernel
developers.

If a company is doing this, then they can afford to do the work arounds
that are required (ie, module parameters), and not change the policy of
the kernel internals.

> 
> It would not be appropriate to change a global state (whether the
> tracepoint is enabled or not for this module) for something specific
> to a subset of the tracing sessions. Moreover, you cannot expect an
> issue-monitoring tool within the distribution to start modifying the
> module parameters across the entire system. Chances are that it will
> conflict with other tools and user-specific configuration if it try
> to do so.

These are your tools that require out of tree modules. Because, there's
no user app that uses the callbacks of tracepoints directly.

I'm sure it wouldn't be hard to have your module do this enabling on
module load, with a module callback.


> > WTF! That's a horrible example. Yes, notifier is the infrastructure
> > code (a header file), but where is there a registered list without
> > callback sites? Look at include/linux/module.h! Do we allow to register
> > module notifiers when modules are not configured in? NO!
> 
> See drivers/acpi/events.c: acpi_notifier_call_chain()
> 
> This notifier chain is defined within events.c, compiled whenever
> ACPI is configured in the kernel (CONFIG_ACPI). All of its callers
> are:
> 
> drivers/acpi/video.c: depends on CONFIG_ACPI_AC
> acpi/ac.c: depends on CONFIG_ACPI_VIDEO
> 
> So yes, there are cases where the notifier block head is there and the
> modules calling into it are not loaded.

WTF? This is completely different. All you are stating is that there's
some dead code here. There's no users of it. Where as, what I'm
bitching about is the fact that we have users and things are not
working because of this crap.


> 
> > 
> > The tracepoint code does much more than registering a notifier. It
> > *enables* the tracepoint.
> 
> Per callsite tracepoint activation is merely an optimization over a
> textbook callback mechanism. We want to skip the empty loop very quickly,
> hence we skip over it with a conditional branch, or static jump (if
> available).

It still enables it, even without jump labels.

> 
> The tracepoints know callsites registered from the core kernel and at
> module load. Tracepoints also register probes for those callsites.
> Whenever a registered probe matches a registered callsite, it is added
> to the list of callbacks for that callsite. If there is at least one
> probe in a callsite callback list, the callsite is enabled.

Right, but because of this hack, nothing will ever get registered to it.

> 
> > I'll reverse your example on you. If you call
> > a notifier that has nothing registered, it does the same work that it
> > would do if something was registered to it. But the loop is empty, it
> > just doesn't call anything.
> 
> A disabled tracepoint is just like an empty loop. The only difference
> is that it is optimized for the common case: empty callback list.

Right. But this isn't what I'm bitching about. We say
"register_this_callback", and NOTHING HAPPENS!!!!

THAT'S THE BUG!

The reason this bug exists, is that something went wrong with the
tracepoint, and it doesn't "exist". But when we go to enable it, we
don't get a warning that it doesn't exist. It just says "OK, we enabled
it". BUT IT DID NOT DO ANYTHING. IT LIED!

> 
> > 
> > The tracepoint code does the work to activate the call site. Here's
> > where your analogy is broken. If I register a handler for a notifier,
> > when the call site is hit, my handler will be called. Well, because of
> > not doing anything different for non existent modules and modules that
> > fail to have their call sites activated, the register returns success
> > in both cases. That means, if I register a probe, it wont be called at
> > the call site. That's a big f'ing bug.
> 
> If the probe and the callsite match, Tracepoints guarantee that the probe
> is added to the module tracepoint callsite. The bug here is that
> tracepoint.c silently ignored certain classes of tainted modules without
> giving any error message to the user. I think your approach of logging
> an error whenever tracepoints decide to disregard force-loaded modules
> is a good approach to at least tell users there is something going
> wrong. Splitting the "unsigned module" case from "force loaded" module
> is going to let users have tracepoints behaving as expected in unsigned
> modules within signed kernels, which I think is the second step in making
> everything right.

The thing is, if people don't see this error, it causes confusion
elsewhere.

-- Steve
