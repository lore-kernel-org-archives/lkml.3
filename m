Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCLOYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:24:55 -0400
Received: from mail.efficios.com ([78.47.125.74]:50262 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbaCLOYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:24:52 -0400
Date: Wed, 12 Mar 2014 14:24:54 +0000 (UTC)
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
Message-ID: <1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140311151357.077c5a68@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <y0mr469e9t0.fsf@fche.csb> <20140310225820.0f02025d@gandalf.local.home> <20140311142650.GB13756@redhat.com> <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com> <20140311114023.02fcf639@gandalf.local.home> <1752080128.130.1394559263621.JavaMail.zimbra@efficios.com> <20140311151357.077c5a68@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: 6d11sOO8EYbIrb8FuOhBlPRO8hkx+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Tuesday, March 11, 2014 3:13:57 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 

For those just added in CC, https://lkml.org/lkml/2014/3/11/431 provides the
missing context. The discussion is about adding module load parameters as ABI
for end users to enable tracepoints in modules (Steven has proposed the idea
a couple of times in the past, I am against for the reasons I am exposing
below). This discussion will likely have deep impact on other changes Steven
is proposing for tracepoint.c (such as making tracepoint_probe_register()
return -ENODEV when no tracepoint call site is currently loaded for a given
tracepoint), so I think the audience should be broadened.

> On Tue, 11 Mar 2014 17:34:23 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>  
> > > Who can load modules not as root?? That is utterly broken. As once you
> > > can load a module, YOU ARE ROOT.
> > 
> > udevd runs as root, and listens to events such as USB hotplug, and loads
> > modules
> > in the back of users. The users don't need to be root for this to happen.
> 
> udevd may run as a proxy for users. But it is still a root user.
> Sysadmins are the ones that set up udevd.

Uh ? There are tons of distributions that setup udevd for their users, and
no sysadmin has to interact with it.

> If you own your own box, you are technically the sysadmin for it.

If you use a box owned by your company, running Linux, but enforcing module
signature, you might be physically allowed to connect USB devices, and let
udevd load the appropriate modules for the connected devices, but that does
not mean you have root access at all. But having the ability to trace the
said computer from a user having "tracing" privileges is very valuable to
help debugging that machine.

Even without going that far, if you want tracing to be widely usable to
pinpoint issues within Linux and/or its applications or libraries, you
basically have to remove most user interactions from the picture, and let
automated tools gather tracing data to perform analysis. As soon as you
require users to fiddle with udev configuration, or pass special parameters
to modprobe, or if you start coupling the tracing infrastructure with the
module configuration, you just made tracing unusable for a vast majority of
Linux distribution users out there.

I've been trying to make my point that tracing should be first of all
_usable_ by non-expert Linux end users, but it seems that I'm completely
failing at getting the message through somehow. And believe me I've spent
years trying to voice this message. Perhaps I'm not cursing enough, perhaps
I'm not yelling enough. Rather than arguing, the path I'm currently taking
is to prove my point by putting the tools needed by my user community in
their hands.

If to you the majority of Linux users means "kernel developers", then
I can see how our point of views cannot be reconciled easily. From my
point of view, there are far more users who need those tracing tools that
are not kernel developers.

> Modifications to udev require sudo
> privileges.
> 
> Tracepoints should not be something a non-sysadmin can modify or
> enable. If you want non root users to do so, create a proxy daemon like
> udevd to do it for them. But the kernel isn't going to allow that
> directly.

I never said the kernel should directly expose ABIs accessible by others
than root. Actually, this is the very reason we have a "lttng-sessiond"
daemon running as root to control kernel tracing. However, it can be
controlled by a "lttng" command line tool over unix sockets if the user
is part of the "tracing" group. Right there, this is the concept of your
proxy daemon. However, you seem to imply that this proxy daemon should
somehow fiddle with udevd and/or modprobe configuration to add temporary
system-wide parameters to how modules are loaded, depending on tracing
needs. Trying to couple something usually configured initially for a
large portion of a system's life (and even with tripwire validation that
/etc does not change over time) with something as transient as tracing
simply cannot work without causing havoc in the system configuration. So
no, having a tracing proxy daemon changing configuration of module
arguments cannot fly.

> 
> > 
> > >  
> > > > fashion and is not suitable for the user-base we are targeting. I seems
> > > > to
> > > > be a user experience disaster IMHO.
> > > 
> > > For your case only. But it is normal operation for normal uses of Linux.
> > 
> > AFAIK pretty much all distros use udev nowadays. Are you suggesting that
> > all
> > users using udev and distribution kernels are not "normal uses of Linux" ?
> 
> udev is root, and is modified by root users. A normal user can not just
> interact with udev. And sticking in a usb stick into a computer counts
> as a sysadmin operation, even if the person doesn't official have the
> title.

So if I understand your line of thought, you imply that anyone who can
plug a USB stick of any kind (memory stick, USB wifi card, etc) into a
computer should automatically have root access ? Is it just me, or it
makes no sense ?

> 
> > 
> > > 
> > > > 
> > > > I'm OK as long as we have an elegant way forward. Ideally I would have
> > > > prefered (1) to eliminate code duplication between tracers and
> > > > tracepoint
> > > > infrastructure (we have to reimplement a hash table similar to
> > > > tracepoints
> > > > within the tracer with solution (2)), but (2) technically works too.
> > > 
> > > Here's what I propose then. We implement 2 for now. You can "duplicate"
> > > the code into your own work.
> > 
> > Works for me.
> > 
> > > Then we should be able to simplify the
> > > tracepoint code as it no longer will have the requirement to enable
> > > tracepoints that do not exist.
> > 
> > What happens for the case where we enable a tracepoint, and then the
> > only module containing a callsite of that tracepoint is unloaded, and
> > then reloaded ?
> 
> When a module is unloaded, it usually loses state. Is there any state
> that is maintained for a module being unloaded and reloaded again?
> Besides tracepoints? If not, then the module should lose its state for
> tracepoints as well.

What you're missing here is that the same tracepoint can appear within
more than one module.

I think there is a core, fundamental difference between the ways we see
tracing. You seem to see tracing as being solely part of the modules
that contain the caller tracing code. From my perspective, tracing fits
much better in the "aspect oriented programming" paradigm, since it spreads
the same "crosscutting concerns" across multiple modules. So yes, in AOP,
it makes perfect sense that tracing activation state goes beyond the
lifetime of a single loaded module: it spawns across core kernel, and zero,
one, or more loaded modules, independently of whether they are unloaded and
reloaded again.


So going back on the changes you proposed to the tracepoint infrastructure:

A) Making tracepoint_probe_register() unregister the probe and fail when
   there is no tracepoint call site present for a probe at that time:

With this approach, if the probe is registered when the module containing
the call site is loaded, and then that module is unloaded, it will leave
the probe in a registered state, leaving the tracer lying to the user,
letting them think there are currently callsites for this tracepoint when
there are none.

B) Making tracepoint_probe_register() just return an error (-ENOEDV), but
   leaving the probe registered.

I think we have already agreed that this compromise solution is a weird API
choice, since an error condition must be treated as a success by the caller.
Moreover, it has the same issue as (A) above: if the module is unloaded
after probe registration, the tracer is lying to the user, making them
think there is a call site loaded when there are none.

C) Adding module load arguments to specify which tracepoint should be
   enabled.

Please refer to my response above in this email to understand why I object.

Back to your original requirement: you want to let the tracer communicate
to end users whether a specific tracepoint has call sites or not. I'm
currently preparing a patch implementing a "tracepoint_callsite_count()"
API that will allow this, and it won't lie to the tracer like solutions
(A) and (B) above. Whenever the tracer queries the state, it will get the
current information about the number of enabled call sites, not some stale
data based on a prior registration error.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
