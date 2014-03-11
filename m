Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaCKPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:40:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:44849 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbaCKPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:40:26 -0400
Date: Tue, 11 Mar 2014 11:40:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140311114023.02fcf639@gandalf.local.home>
In-Reply-To: <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
	<y0mr469e9t0.fsf@fche.csb>
	<20140310225820.0f02025d@gandalf.local.home>
	<20140311142650.GB13756@redhat.com>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 15:06:22 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> Let's step back and look at the overall picture here, along with the
> possible solutions that are available so far.
> 
> My intent is to let end users specify "I want to trace this specific
> tracepoint" from the tracer interface as long as the tracepoint probe
> provider module is loaded (the file with CREATE_TRACE_POINTS defined).
> For instance, the tracepoint call site can be within a driver loaded by
> the USB stack when a USB device is plugged in. While tracing is enabled,
> the user may want to plug in the said USB device to investigate what is
> the culprit of an issue he would be facing when the the device is plugged
> in.
> 
> There seems to be 2 elegant ways to achieve this while giving feedback to
> tracers about whether there are active tracepoint callsites or not:
> 
> 1) We add a trace_has_callsites_enabled() (or any better name) function to
>    tracepoint.h, which allows tracers to query whether a given tracepoint
>    name has any callsites enabled,

I don't find that one very elegant at all.

> 2) We change tracepoint_probe_register() so it unregisters the tracepoint
>    and return -ENODEV if there are no callsites enabled, and deal with
>    the use-case I explain above with module coming and going within the
>    tracer. This duplicates part of the tracepoint infrastructure into the
>    tracer though, which is why I was not so keen on going for this
>    solution.

I don't mind the above.

> 
> The other solution proposed by Steven (returning -ENODEV without
> unregistering the tracepoint) does not appear to be an elegant solution,
> as we discussed earlier in this thread. It kind of weird to have a negative
> value treated as an OK special case.

Right, but it was a compromise as you didn't like #2 earlier.

> 
> The other solution proposed by Steven in an earlier thread was to tie
> tracepoints very deeply with module loading infrastructure and add module
> parameters specifically to specify if tracepoint callsites need to be
> enabled on module load. This approach unfortunately expect that everyone
> interacts with module loading, as root, in a system-wide (no multi-session)

Who can load modules not as root?? That is utterly broken. As once you
can load a module, YOU ARE ROOT.
 
> fashion and is not suitable for the user-base we are targeting. I seems to
> be a user experience disaster IMHO.

For your case only. But it is normal operation for normal uses of Linux.

> 
> I'm OK as long as we have an elegant way forward. Ideally I would have
> prefered (1) to eliminate code duplication between tracers and tracepoint
> infrastructure (we have to reimplement a hash table similar to tracepoints
> within the tracer with solution (2)), but (2) technically works too.

Here's what I propose then. We implement 2 for now. You can "duplicate"
the code into your own work. Then we should be able to simplify the
tracepoint code as it no longer will have the requirement to enable
tracepoints that do not exist.

Also we can remove that tracepoint_probe_unregister_noupdate() as it
has no in-tree users. Which, you have been lucky that no one noticed
that yet, as that is a legitimate excuse to remove a function.

-- Steve

