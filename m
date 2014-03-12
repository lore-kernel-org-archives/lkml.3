Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaCLPLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:11:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:14102 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754454AbaCLPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:11:05 -0400
Date: Wed, 12 Mar 2014 11:11:00 -0400
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
Message-ID: <20140312111100.42ea41c2@gandalf.local.home>
In-Reply-To: <1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<y0mr469e9t0.fsf@fche.csb>
	<20140310225820.0f02025d@gandalf.local.home>
	<20140311142650.GB13756@redhat.com>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
	<20140311114023.02fcf639@gandalf.local.home>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
	<20140311151357.077c5a68@gandalf.local.home>
	<1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 14:24:54 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> > Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> > <johannes.berg@intel.com>
> > Sent: Tuesday, March 11, 2014 3:13:57 PM
> > Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> > 
> 
> For those just added in CC, https://lkml.org/lkml/2014/3/11/431 provides the
> missing context. The discussion is about adding module load parameters as ABI
> for end users to enable tracepoints in modules (Steven has proposed the idea
> a couple of times in the past, I am against for the reasons I am exposing
> below). This discussion will likely have deep impact on other changes Steven
> is proposing for tracepoint.c (such as making tracepoint_probe_register()
> return -ENODEV when no tracepoint call site is currently loaded for a given
> tracepoint), so I think the audience should be broadened.

Please tell me one in-tree user that will be impacted?

> 
> > On Tue, 11 Mar 2014 17:34:23 +0000 (UTC)
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >  
> > > > Who can load modules not as root?? That is utterly broken. As once you
> > > > can load a module, YOU ARE ROOT.
> > > 
> > > udevd runs as root, and listens to events such as USB hotplug, and loads
> > > modules
> > > in the back of users. The users don't need to be root for this to happen.
> > 
> > udevd may run as a proxy for users. But it is still a root user.
> > Sysadmins are the ones that set up udevd.
> 
> Uh ? There are tons of distributions that setup udevd for their users, and
> no sysadmin has to interact with it.

And the distribution just magically installs itself onto a computer? No,
a user does, and in doing so, they set up udev. A person installing a
distribution is a sysadmin. Even if it's grandma installing it herself.
She owns the box, no one else is doing anything for her (unless it's
your grandma).

> 
> > If you own your own box, you are technically the sysadmin for it.
> 
> If you use a box owned by your company, running Linux, but enforcing module
> signature, you might be physically allowed to connect USB devices, and let
> udevd load the appropriate modules for the connected devices, but that does
> not mean you have root access at all. But having the ability to trace the
> said computer from a user having "tracing" privileges is very valuable to
> help debugging that machine.

Tracing is a root privilege.

> 
> Even without going that far, if you want tracing to be widely usable to
> pinpoint issues within Linux and/or its applications or libraries, you
> basically have to remove most user interactions from the picture, and let
> automated tools gather tracing data to perform analysis. As soon as you
> require users to fiddle with udev configuration, or pass special parameters
> to modprobe, or if you start coupling the tracing infrastructure with the
> module configuration, you just made tracing unusable for a vast majority of
> Linux distribution users out there.

This seems very specific to a single tracing tool that happens not to
be in the kernel tree.

> 
> I've been trying to make my point that tracing should be first of all
> _usable_ by non-expert Linux end users, but it seems that I'm completely
> failing at getting the message through somehow. And believe me I've spent
> years trying to voice this message. Perhaps I'm not cursing enough, perhaps
> I'm not yelling enough. Rather than arguing, the path I'm currently taking
> is to prove my point by putting the tools needed by my user community in
> their hands.

I don't know why you are complaining. Think of this as your job
security.

> 
> If to you the majority of Linux users means "kernel developers", then
> I can see how our point of views cannot be reconciled easily. From my
> point of view, there are far more users who need those tracing tools that
> are not kernel developers.

No, but the majority of tracing users *are* kernel developers, or those
that are experts in the system.

Why would grandma want to trace the kernel?

> 
> > Modifications to udev require sudo
> > privileges.
> > 
> > Tracepoints should not be something a non-sysadmin can modify or
> > enable. If you want non root users to do so, create a proxy daemon like
> > udevd to do it for them. But the kernel isn't going to allow that
> > directly.
> 
> I never said the kernel should directly expose ABIs accessible by others
> than root. Actually, this is the very reason we have a "lttng-sessiond"
> daemon running as root to control kernel tracing. However, it can be
> controlled by a "lttng" command line tool over unix sockets if the user
> is part of the "tracing" group. Right there, this is the concept of your
> proxy daemon. However, you seem to imply that this proxy daemon should
> somehow fiddle with udevd and/or modprobe configuration to add temporary
> system-wide parameters to how modules are loaded, depending on tracing
> needs. Trying to couple something usually configured initially for a
> large portion of a system's life (and even with tripwire validation that
> /etc does not change over time) with something as transient as tracing
> simply cannot work without causing havoc in the system configuration. So
> no, having a tracing proxy daemon changing configuration of module
> arguments cannot fly.

I actually never said that. I said that you could have a proxy to
enable or disable the tracepoint. I don't know where you're getting
this crap from. Yes, I have suggested in the past that the ideal
approach is to have modprobe handle it, just like it handles other
module changes for one time deals. And yes, tracing a module is a one
time deal. But you seem to be getting in a tizzy thinking that's what I
recommended yesterday.

> 
> > 
> > > 
> > > >  
> > > > > fashion and is not suitable for the user-base we are targeting. I seems
> > > > > to
> > > > > be a user experience disaster IMHO.
> > > > 
> > > > For your case only. But it is normal operation for normal uses of Linux.
> > > 
> > > AFAIK pretty much all distros use udev nowadays. Are you suggesting that
> > > all
> > > users using udev and distribution kernels are not "normal uses of Linux" ?
> > 
> > udev is root, and is modified by root users. A normal user can not just
> > interact with udev. And sticking in a usb stick into a computer counts
> > as a sysadmin operation, even if the person doesn't official have the
> > title.
> 
> So if I understand your line of thought, you imply that anyone who can
> plug a USB stick of any kind (memory stick, USB wifi card, etc) into a
> computer should automatically have root access ? Is it just me, or it
> makes no sense ?

I wouldn't want people to have access to any box I own to be able to
just stick any usb device into the computer. Look at all the USB drivers
we have. You think they are all perfect. I'm sure it wouldn't be too
hard to find a bad USB device driver and make your own dongle to stick
in, that can root the box.

> 
> > 
> > > 
> > > > 
> > > > > 
> > > > > I'm OK as long as we have an elegant way forward. Ideally I would have
> > > > > prefered (1) to eliminate code duplication between tracers and
> > > > > tracepoint
> > > > > infrastructure (we have to reimplement a hash table similar to
> > > > > tracepoints
> > > > > within the tracer with solution (2)), but (2) technically works too.
> > > > 
> > > > Here's what I propose then. We implement 2 for now. You can "duplicate"
> > > > the code into your own work.
> > > 
> > > Works for me.
> > > 
> > > > Then we should be able to simplify the
> > > > tracepoint code as it no longer will have the requirement to enable
> > > > tracepoints that do not exist.
> > > 
> > > What happens for the case where we enable a tracepoint, and then the
> > > only module containing a callsite of that tracepoint is unloaded, and
> > > then reloaded ?
> > 
> > When a module is unloaded, it usually loses state. Is there any state
> > that is maintained for a module being unloaded and reloaded again?
> > Besides tracepoints? If not, then the module should lose its state for
> > tracepoints as well.
> 
> What you're missing here is that the same tracepoint can appear within
> more than one module.

So?

> 
> I think there is a core, fundamental difference between the ways we see
> tracing. You seem to see tracing as being solely part of the modules
> that contain the caller tracing code. From my perspective, tracing fits
> much better in the "aspect oriented programming" paradigm, since it spreads
> the same "crosscutting concerns" across multiple modules. So yes, in AOP,
> it makes perfect sense that tracing activation state goes beyond the
> lifetime of a single loaded module: it spawns across core kernel, and zero,
> one, or more loaded modules, independently of whether they are unloaded and
> reloaded again.

Have your LTTNg module dictate that policy.

> 
> 
> So going back on the changes you proposed to the tracepoint infrastructure:
> 
> A) Making tracepoint_probe_register() unregister the probe and fail when
>    there is no tracepoint call site present for a probe at that time:
> 
> With this approach, if the probe is registered when the module containing
> the call site is loaded, and then that module is unloaded, it will leave
> the probe in a registered state, leaving the tracer lying to the user,
> letting them think there are currently callsites for this tracepoint when
> there are none.

Hmm, currently the probe lies to the user when the tracepoint doesn't
exist. We enable it and nothing happens. This BROKE IN TREE USERS!!!!

I suggest that we remove the probe when the module is unloaded. No
lying. Either a tracepoint exists when you enable it, or it doesn't.


> 
> B) Making tracepoint_probe_register() just return an error (-ENOEDV), but
>    leaving the probe registered.
> 
> I think we have already agreed that this compromise solution is a weird API
> choice, since an error condition must be treated as a success by the caller.
> Moreover, it has the same issue as (A) above: if the module is unloaded
> after probe registration, the tracer is lying to the user, making them
> think there is a call site loaded when there are none.

But isn't that what we do today?

> 
> C) Adding module load arguments to specify which tracepoint should be
>    enabled.
> 
> Please refer to my response above in this email to understand why I object.

I didn't suggest this in this thread. I only pointed out that is the
most sane situation. But I've been trying to work with you, and you
don't seem to see that.

> 
> Back to your original requirement: you want to let the tracer communicate
> to end users whether a specific tracepoint has call sites or not. I'm
> currently preparing a patch implementing a "tracepoint_callsite_count()"
> API that will allow this, and it won't lie to the tracer like solutions
> (A) and (B) above. Whenever the tracer queries the state, it will get the
> current information about the number of enabled call sites, not some stale
> data based on a prior registration error.

No, I don't want to know if this call site exists or not. This stupid
"tracepoint_probe_register()" that activates a tracepoint by name. But
if that tracepoint doesn't exist, it just returns normally as if
everything is fine and dandy. WTF!

Look Mathieu, I've been trying to be nice here. This crap has broken
in tree kernel users, and this magical "enable a non-existent
tracepoint, so when one is created, it will be enabled" is only used by
LTTng! NOBODY ELSE USES IT. This means that I can strip this usage out
of the kernel, as there are no uses of it in the kernel.

What you don't seem to realize, is that your methods broke the stuff
that is in the kernel, and you don't seem to give a shit about that.

The solution I like the most that I believe will work for both of us,
is to to move this magic "enable tracepoint in the future" to your
LTTng module. Have your module register a module load and unload handler
to be able to see the tracepoints that exist in the module, and you can
enable them then. When a module is unloaded, your module can do the
accounting to record that, and the state of its tracepoints. 

Looks like we can have it both ways. A way that works well for the
kernel, and a way that works well for you. But your module will need to
do the heavy work for what you want.

To me, a tracepoint should only be enabled when it exists. If it is
enabled in module when the module is unloaded, then it should be
removed after the module has left. If the module is loaded again, it is
up to the user (or your module) to enable that tracepoint again.

-- Steve

