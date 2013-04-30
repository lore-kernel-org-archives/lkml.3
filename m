Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3D3ATH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:19:07 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:52593 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab3D3ATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:19:04 -0400
Date: Tue, 30 Apr 2013 02:19:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: systemtap broken by removal of register_timer_hook
Message-ID: <20130430001858.GF1760@somewhere>
References: <20130403075017.GA2534@suse.de>
 <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com>
 <y0mvc83u79f.fsf@fche.csb>
 <CAFTL4hxx_GHoa4uguSAtY0A=cC43qJPKvpqaoguS-WAjFj+HSw@mail.gmail.com>
 <20130403144428.GA15432@redhat.com>
 <CAFTL4hy+U-dLPwGR8BcZt=C8Tug-jvh+24epadfte7Ci2cDU5Q@mail.gmail.com>
 <20130419144655.GD8308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419144655.GD8308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:46:55AM -0400, Frank Ch. Eigler wrote:
> Hi, Frederic -
> 
> 
> > > How about this?
> > >
> > > Author: Frank Ch. Eigler <fche@redhat.com>
> > > Date:   Wed Apr 3 10:35:21 2013 -0400
> > >
> > >     profiling: add profile_tick tracepoint
> > > [...]
> 
> > It would be better not to tie this to CONFIG_PROFILING.
> > A tracepoint in update_process_times() instead would be great but it's
> > sometimes called several times in a tick from some archs.
> > Probably we need something like:
> > 
> > static inline tick_trace(struct pt_regs *regs)
> > {
> >     trace_timer_tick(regs);
> >     profile_tick(CPU_PROFILING);
> > }
> 
> I looked into this, but found no natural place to define such an
> inline function from which to call into a tracepoint, without having
> to #include the <event/FOO.h> file many times.

You could include it from linux/profile.h or linux/tick.h and
define profile_tick to "{ trace_tick(); __profile_tick()}" .

But in a second thought, using a tracepoint in a general purpose header
resulted in bad circular headers dependency in the past, we had bitter
experiences with trace_softirq_raise for example.

> Nor does it seem
> appropriate to do the identical #define CREATE_TRACE_POINTSw part from
> all the different arch/.../*.c files that may call into that inline.
>
> If you'd like to stick to this idea, please advise further where you
> think the tracepoint definition & declarations should go.
> 
> In the alternative, here is v2 of the patch, just changing the
> tracepoint-printing argument as suggested by jistone.

But your tracepoint still depends on CONFIG_PROFILING and I would
really like to avoid that.

How about creating trace_tick() in include/trace/events/timer.h
and call it from tick_periodic() and tick_sched_handle().

This only leaves the archs that don't support generic clockevents
behind. This should be no big deal, they can integrate this tracepoint
later if they need to.

Thanks.
