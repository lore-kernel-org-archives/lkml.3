Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaCKPGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:06:20 -0400
Received: from mail.efficios.com ([78.47.125.74]:45143 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaCKPGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:06:19 -0400
Date: Tue, 11 Mar 2014 15:06:22 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140311142650.GB13756@redhat.com>
References: <20140307150920.881849073@goodmis.org> <20140307151202.210588176@goodmis.org> <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com> <y0mr469e9t0.fsf@fche.csb> <20140310225820.0f02025d@gandalf.local.home> <20140311142650.GB13756@redhat.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: aRMRwzlyz/H6g5zj3XyoqBfujA6GNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Frank Ch. Eigler" <fche@redhat.com>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, "Ingo Molnar"
> <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Johannes Berg" <johannes.berg@intel.com>
> Sent: Tuesday, March 11, 2014 10:26:50 AM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> Hi, Steven -
> 
> > > So it is a deferred-activation kind of call, with no way of knowing
> > > when or if the tracepoints will start coming in.  Why is that
> > > supported at all, considering that clients could monitor modules
> > > coming & going via the module_notifier chain, and update registration
> > > at that time?
> > 
> > That's my argument.
> 
> Was there an answer?

Let's step back and look at the overall picture here, along with the
possible solutions that are available so far.

My intent is to let end users specify "I want to trace this specific
tracepoint" from the tracer interface as long as the tracepoint probe
provider module is loaded (the file with CREATE_TRACE_POINTS defined).
For instance, the tracepoint call site can be within a driver loaded by
the USB stack when a USB device is plugged in. While tracing is enabled,
the user may want to plug in the said USB device to investigate what is
the culprit of an issue he would be facing when the the device is plugged
in.

There seems to be 2 elegant ways to achieve this while giving feedback to
tracers about whether there are active tracepoint callsites or not:

1) We add a trace_has_callsites_enabled() (or any better name) function to
   tracepoint.h, which allows tracers to query whether a given tracepoint
   name has any callsites enabled,
2) We change tracepoint_probe_register() so it unregisters the tracepoint
   and return -ENODEV if there are no callsites enabled, and deal with
   the use-case I explain above with module coming and going within the
   tracer. This duplicates part of the tracepoint infrastructure into the
   tracer though, which is why I was not so keen on going for this
   solution.

The other solution proposed by Steven (returning -ENODEV without
unregistering the tracepoint) does not appear to be an elegant solution,
as we discussed earlier in this thread. It kind of weird to have a negative
value treated as an OK special case.

The other solution proposed by Steven in an earlier thread was to tie
tracepoints very deeply with module loading infrastructure and add module
parameters specifically to specify if tracepoint callsites need to be
enabled on module load. This approach unfortunately expect that everyone
interacts with module loading, as root, in a system-wide (no multi-session)
fashion and is not suitable for the user-base we are targeting. I seems to
be a user experience disaster IMHO.

I'm OK as long as we have an elegant way forward. Ideally I would have
prefered (1) to eliminate code duplication between tracers and tracepoint
infrastructure (we have to reimplement a hash table similar to tracepoints
within the tracer with solution (2)), but (2) technically works too.

Thanks,

Mathieu

> 
> 
> > > >> +	entry = get_tracepoint(name);
> > > >> +	/* Make sure the entry was enabled */
> > > >> +	if (!entry || !entry->enabled)
> > > >> +		ret = -ENODEV;
> > > 
> > > For what it's worth, I agree with Mathieu that this sort of successful
> > > failure result code is a problem for tracking what needs cleanup and
> > > what doesn't.  (In systemtap's case, if this change gets merged, we'll
> > > have to treat -ENODEV as if it were 0.)
> > 
> > Does systemtap enable tracepoints before they are created? That is, do
> > you allow enabling of a tracepoint in a module that is not loaded yet?
> 
> We have no formal opinion on whether or not this makes sense.  If the
> kernel permits it, fine.
> 
> > If not, than you want this as an error.
> 
> But it's not exactly an error!  It's a success of sorts, and means
> that later on we have to unregister the callback, just as if it were
> successful.
> 
> 
> - FChE
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
