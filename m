Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaBZOX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:23:28 -0500
Received: from mail.efficios.com ([78.47.125.74]:41801 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaBZOX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:23:26 -0500
Date: Wed, 26 Feb 2014 14:23:22 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <1641863026.30821.1393424602830.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140224141007.68a9b5b0@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140213102817.4bfd5eac@gandalf.local.home> <2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com> <20140213154507.4040fb06@gandalf.local.home> <1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com> <20140224105454.3e1981ba@gandalf.local.home> <1588404356.29584.1393266723043.JavaMail.zimbra@efficios.com> <20140224141007.68a9b5b0@gandalf.local.home>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: T/pdZ2ZKOwmIdnYQ+EyWSePgQ4gUhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Ingo Molnar" <mingo@kernel.org>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas
> Gleixner" <tglx@linutronix.de>, "Rusty Russell" <rusty@rustcorp.com.au>, "David Howells" <dhowells@redhat.com>,
> "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Monday, February 24, 2014 2:10:07 PM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> On Mon, 24 Feb 2014 18:32:03 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > > 
> > > The real answer to this is to enabled the tracepoints on module load,
> > > with a module parameter. We've talked about this before, and I also
> > > think there's some patches out there that do this. (I remember creating
> > > something myself). I'll have to go dig them out and we can work to get
> > > them in 3.15.
> > 
> > For the records, I still think that requiring users of tracing to add
> > module parameters specifying what tracing they need enabled is expecting
> > them to interact at the wrong interface level. This might be convenient
> > for kernel developers, but not for other types of kernel tracing end
> > users. From a user experience perspective, I think your "real answer"
> > is the wrong answer.
> 
> 
> Why? This is not a normal activity to for the user. You seem to have a
> few specific users, but those are exceptions, and this has nothing to
> do with normal kernel developer view.

The very fact that you present "normal kernel developer view" as being
the norm just tells how much we focus on different user bases. Since
the user-base you target are mostly kernel developers, it is
understandable that you dismiss our user base as being small and
specific.

There are many more Linux users than kernel developers out there. The
main difference is that the former category don't usually post on LKML.

> 
> Tracing a module that's being loaded is far from normal user activity.
> 
> Now, for boot up, I could see enabling all tracepoints. For that, we
> can add a hook to the module load that when a flag is set, we can
> enable all trace events in the module as it is loaded. That would work
> for boot up.
> 
> If this is such a user activity, please explain to me what scenario
> that requires tracing a module being loaded that could not easily be
> accomplished with a module parameter?

OK. Here is the scenario:

- We have users deploying tracing on their systems in flight recorder
  "snapshot" mode (writing into circular memory buffers, without any
  other type of I/O, except when a snapshot of the buffers is needed).
  They wish collect data from user-space and kernel-space, including
  from kernel modules. You can think of it like a detailed crash
  tracing for Linux distributions with very low overhead. Which
  tracepoints are enabled depends on configuration of this flight
  recorder tracing "session". There may be multiple concurrent tracing
  sessions enabled in parallel, trying each to pinpoint different kind
  of issues. Some are controlled by the distro end-user, others are
  automatically enabled by the distro if the user agrees to provide
  detailed bug report feedback to the distro.
- There, an automated analysis wants to hook on specific module
  tracepoints (e.g. the usb stack) which are loaded only when the
  devices are physically plugged into the computer.

It would not be appropriate to change a global state (whether the
tracepoint is enabled or not for this module) for something specific
to a subset of the tracing sessions. Moreover, you cannot expect an
issue-monitoring tool within the distribution to start modifying the
module parameters across the entire system. Chances are that it will
conflict with other tools and user-specific configuration if it try
to do so.

> 
> > 
> > > 
> > > > 
> > > > Another way to do this, without requiring changes to the existing
> > > > tracepoint_probe_register() API, is to simply add e.g. (better function
> > > > names welcome):
> > > > 
> > > > int tracepoint_has_callsites(const char *name)
> > > > {
> > > >     struct tracepoint_entry *entry;
> > > >     int ret = 0;
> > > > 
> > > >     mutex_lock(&tracepoints_mutex);
> > > >     entry = get_tracepoint(name);
> > > >     if (entry && entry->refcount) {
> > > >         ret = 1;
> > > >     }
> > > >     mutex_unlock(&tracepoints_mutex);
> > > >     return ret;
> > > > }
> > > 
> > > No, I'm not about to change the interface for something that is broken.
> > > tracepoint_probe_register() should fail if it does not register a
> > > tracepoint. It should not store it off for later. I'm not aware of any
> > > other "register" function in the kernel that does such a thing. Is
> > > there one that you know of?
> > 
> > see include/linux/notifier.h
> > 
> > You can register notifier callbacks without having any notifier call sites.
> > This is exactly what tracepoint.c is currently doing. The change you
> > propose
> > is the equivalent of refusing to register a notifier callback if there is
> > no call site for that notifier.
> 
> WTF! That's a horrible example. Yes, notifier is the infrastructure
> code (a header file), but where is there a registered list without
> callback sites? Look at include/linux/module.h! Do we allow to register
> module notifiers when modules are not configured in? NO!

See drivers/acpi/events.c: acpi_notifier_call_chain()

This notifier chain is defined within events.c, compiled whenever
ACPI is configured in the kernel (CONFIG_ACPI). All of its callers
are:

drivers/acpi/video.c: depends on CONFIG_ACPI_AC
acpi/ac.c: depends on CONFIG_ACPI_VIDEO

So yes, there are cases where the notifier block head is there and the
modules calling into it are not loaded.

> 
> The tracepoint code does much more than registering a notifier. It
> *enables* the tracepoint.

Per callsite tracepoint activation is merely an optimization over a
textbook callback mechanism. We want to skip the empty loop very quickly,
hence we skip over it with a conditional branch, or static jump (if
available).

The tracepoints know callsites registered from the core kernel and at
module load. Tracepoints also register probes for those callsites.
Whenever a registered probe matches a registered callsite, it is added
to the list of callbacks for that callsite. If there is at least one
probe in a callsite callback list, the callsite is enabled.

> I'll reverse your example on you. If you call
> a notifier that has nothing registered, it does the same work that it
> would do if something was registered to it. But the loop is empty, it
> just doesn't call anything.

A disabled tracepoint is just like an empty loop. The only difference
is that it is optimized for the common case: empty callback list.

> 
> The tracepoint code does the work to activate the call site. Here's
> where your analogy is broken. If I register a handler for a notifier,
> when the call site is hit, my handler will be called. Well, because of
> not doing anything different for non existent modules and modules that
> fail to have their call sites activated, the register returns success
> in both cases. That means, if I register a probe, it wont be called at
> the call site. That's a big f'ing bug.

If the probe and the callsite match, Tracepoints guarantee that the probe
is added to the module tracepoint callsite. The bug here is that
tracepoint.c silently ignored certain classes of tainted modules without
giving any error message to the user. I think your approach of logging
an error whenever tracepoints decide to disregard force-loaded modules
is a good approach to at least tell users there is something going
wrong. Splitting the "unsigned module" case from "force loaded" module
is going to let users have tracepoints behaving as expected in unsigned
modules within signed kernels, which I think is the second step in making
everything right.

Thanks,

Mathieu

> 
> 
> > 
> > > 
> > > > 
> > > > So tools which care about providing feedback to their users about the
> > > > fact that tracepoint callsites are not there can call this new
> > > > function.
> > > > The advantage is that it would not change the return values of the
> > > > existing
> > > > API. Also, it would be weird to have tracepoint_probe_register() return
> > > > an error value but leave the tracepoint in a registered state. Moving
> > > > this
> > > > into a separate query function seems more consistent IMHO.
> > > 
> > > Again, the existing API is not a user interface. It is free to change,
> > > and this change wont break any existing in-tree uses. In fact, the fact
> > > that you had this stupid way of doing it, *broke* the in-tree users!
> > > That is, no error messages were ever displayed when the probe was not
> > > registered. This is why I consider this a broken design.
> > > 
> > > If you want LTTng to enable tracepoints before loading, then have your
> > > module save off these these tracepoints and register a handler to
> > > be called when a module is loaded and enable them yourself.
> > 
> > That's a possible option.
> > 
> > > 
> > > For now, I'm going to push this in, and also mark it for stable.
> > 
> > I still disagree with this change.
> 
> Of course you do ;-)
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
