Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaCKReW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:34:22 -0400
Received: from mail.efficios.com ([78.47.125.74]:45655 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbaCKReV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:34:21 -0400
Date: Tue, 11 Mar 2014 17:34:23 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140311114023.02fcf639@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <20140307151202.210588176@goodmis.org> <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com> <y0mr469e9t0.fsf@fche.csb> <20140310225820.0f02025d@gandalf.local.home> <20140311142650.GB13756@redhat.com> <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com> <20140311114023.02fcf639@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: wEAWfpEh0u9qFxdUXYuAZYK4kRKsvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Tuesday, March 11, 2014 11:40:23 AM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Tue, 11 Mar 2014 15:06:22 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > Let's step back and look at the overall picture here, along with the
> > possible solutions that are available so far.
> > 
> > My intent is to let end users specify "I want to trace this specific
> > tracepoint" from the tracer interface as long as the tracepoint probe
> > provider module is loaded (the file with CREATE_TRACE_POINTS defined).
> > For instance, the tracepoint call site can be within a driver loaded by
> > the USB stack when a USB device is plugged in. While tracing is enabled,
> > the user may want to plug in the said USB device to investigate what is
> > the culprit of an issue he would be facing when the the device is plugged
> > in.
> > 
> > There seems to be 2 elegant ways to achieve this while giving feedback to
> > tracers about whether there are active tracepoint callsites or not:
> > 
> > 1) We add a trace_has_callsites_enabled() (or any better name) function to
> >    tracepoint.h, which allows tracers to query whether a given tracepoint
> >    name has any callsites enabled,
> 
> I don't find that one very elegant at all.
> 
> > 2) We change tracepoint_probe_register() so it unregisters the tracepoint
> >    and return -ENODEV if there are no callsites enabled, and deal with
> >    the use-case I explain above with module coming and going within the
> >    tracer. This duplicates part of the tracepoint infrastructure into the
> >    tracer though, which is why I was not so keen on going for this
> >    solution.
> 
> I don't mind the above.
> 
> > 
> > The other solution proposed by Steven (returning -ENODEV without
> > unregistering the tracepoint) does not appear to be an elegant solution,
> > as we discussed earlier in this thread. It kind of weird to have a negative
> > value treated as an OK special case.
> 
> Right, but it was a compromise as you didn't like #2 earlier.
> 
> > 
> > The other solution proposed by Steven in an earlier thread was to tie
> > tracepoints very deeply with module loading infrastructure and add module
> > parameters specifically to specify if tracepoint callsites need to be
> > enabled on module load. This approach unfortunately expect that everyone
> > interacts with module loading, as root, in a system-wide (no multi-session)
> 
> Who can load modules not as root?? That is utterly broken. As once you
> can load a module, YOU ARE ROOT.

udevd runs as root, and listens to events such as USB hotplug, and loads modules
in the back of users. The users don't need to be root for this to happen.

>  
> > fashion and is not suitable for the user-base we are targeting. I seems to
> > be a user experience disaster IMHO.
> 
> For your case only. But it is normal operation for normal uses of Linux.

AFAIK pretty much all distros use udev nowadays. Are you suggesting that all
users using udev and distribution kernels are not "normal uses of Linux" ?

> 
> > 
> > I'm OK as long as we have an elegant way forward. Ideally I would have
> > prefered (1) to eliminate code duplication between tracers and tracepoint
> > infrastructure (we have to reimplement a hash table similar to tracepoints
> > within the tracer with solution (2)), but (2) technically works too.
> 
> Here's what I propose then. We implement 2 for now. You can "duplicate"
> the code into your own work.

Works for me.

> Then we should be able to simplify the
> tracepoint code as it no longer will have the requirement to enable
> tracepoints that do not exist.

What happens for the case where we enable a tracepoint, and then the
only module containing a callsite of that tracepoint is unloaded, and
then reloaded ?

> 
> Also we can remove that tracepoint_probe_unregister_noupdate() as it
> has no in-tree users. Which, you have been lucky that no one noticed
> that yet, as that is a legitimate excuse to remove a function.

LTTng 2.x does not use it at all, so I have no issue with the removal.
I think since this commit it was not required anymore:

commit b75ef8b44b1cb95f5a26484b0e2fe37a63b12b44
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Wed Aug 10 15:18:39 2011 -0400

    Tracepoint: Dissociate from module mutex

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
