Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3BVOsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:48:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34171 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab3BVOsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:48:36 -0500
Date: Fri, 22 Feb 2013 14:48:30 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
Message-ID: <20130222144829.GG12140@e102568-lin.cambridge.arm.com>
References: <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com>
 <alpine.LFD.2.02.1302211436300.22263@ionos>
 <51263975.20906@ti.com>
 <alpine.LFD.2.02.1302212214020.22263@ionos>
 <5127436E.4040100@ti.com>
 <alpine.LFD.2.02.1302221122290.22263@ionos>
 <20130222103149.GC12140@e102568-lin.cambridge.arm.com>
 <51275058.7010809@ti.com>
 <alpine.LFD.2.02.1302221212500.22263@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302221212500.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Feb 2013 14:48:30.0738 (UTC) FILETIME=[AE540F20:01CE110B]
X-MC-Unique: 113022214483302101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 12:07:30PM +0000, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
> 
> > On Friday 22 February 2013 04:01 PM, Lorenzo Pieralisi wrote:
> > > On Fri, Feb 22, 2013 at 10:24:00AM +0000, Thomas Gleixner wrote:
> > > > On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
> > > > > BTW, Lorenzo off-list mentioned to me about warning in boot-up
> > > > > which I missed while testing your patch. It will take bit more
> > > > > time for me to look into it and hence thought of reporting it.
> > > > > 
> > > > > [    2.186126] ------------[ cut here ]------------
> > > > > [    2.190979] WARNING: at kernel/time/tick-broadcast.c:501
> > > > > tick_broadcast_oneshot_control+0x1c0/0x21c()
> > > > 
> > > > Which one is that? tick_broadcast_pending or tick_force_broadcast_mask ?
> > > 
> > > It is the tick_force_broadcast_mask and I think that's because on all
> > > systems we are testing, the broadcast timer IRQ is a thundering herd,
> > > all CPUs get out of idle at once and try to get out of broadcast mode
> > > at more or less the same time.
> > > 
> > So the issue comes ups only when the idle state used where CPU wakeup
> > more or less at same time as Lorenzo mentioned. I have two platforms
> > where I could test the patch and see the issue only with one platform.
> > 
> > Yesterday I didn't notice the warning because it wasn't seen on that
> > platform :-) OMAP4 idle entry and exit in deep state is staggered
> > between CPUs and hence the warning isn't seen. On OMAP5 though,
> > there is an additional C-state where idle entry/exit for CPU
> > isn't staggered and I see the issue in that case.
> > 
> > Actually the broad-cast code doesn't expect such a behavior
> > from CPUs since only the broad-cast affine CPU should wake
> > up and rest of the CPU should be woken up by the broad-cast
> > IPIs.
> 
> That's what I feared. We might have the same issue on x86, depending
> on the cpu model.
> 
> But thinking more about it. It's actually not a real problem, just
> pointless burning of cpu cycles.
> 
> So on the CPU which gets woken along with the target CPU of the
> broadcast the following happens:
> 
>   deep_idle()
> 			<-- spurious wakeup
>   broadcast_exit()
>     set forced bit
>   
>   enable interrupts
>     
> 			<-- Nothing happens
> 
>   disable interrupts
> 
>   broadcast_enter()
> 			<-- Here we observe the forced bit is set
>   deep_idle()
> 
> Now after that the target CPU of the broadcast runs the broadcast
> handler and finds the other CPU in both the broadcast and the forced
> mask, sends the IPI and stuff gets back to normal.
> 
> So it's not actually harmful, just more evidence for the theory, that
> hardware designers have access to very special drug supplies.
> 
> Now we could make use of that and avoid going deep idle just to come
> back right away via the IPI. Unfortunately the notification thingy has
> no return value, but we can fix that.
> 
> To confirm that theory, could you please try the hack below and add
> some instrumentation (trace_printk)?

Applied, and it looks like that's exactly why the warning triggers, at least
on the platform I am testing on which is a dual-cluster ARM testchip.

There is a still time window though where the CPU (the IPI target) can get
back to idle (tick_broadcast_pending still not set) before the CPU target of
the broadcast has a chance to run tick_handle_oneshot_broadcast (and set
tick_broadcast_pending), or am I missing something ?
It is a corner case, granted. Best thing would be to check pending IRQs in the
idle driver back-end (or have always-on local timers :-)).

Thanks,
Lorenzo

