Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3BYNeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:34:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59395 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3BYNeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:34:09 -0500
Date: Mon, 25 Feb 2013 13:34:03 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
Message-ID: <20130225133402.GA13045@e102568-lin.cambridge.arm.com>
References: <alpine.LFD.2.02.1302212214020.22263@ionos>
 <5127436E.4040100@ti.com>
 <alpine.LFD.2.02.1302221122290.22263@ionos>
 <20130222103149.GC12140@e102568-lin.cambridge.arm.com>
 <51275058.7010809@ti.com>
 <alpine.LFD.2.02.1302221212500.22263@ionos>
 <20130222144829.GG12140@e102568-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1302221558000.22263@ionos>
 <20130222152639.GH12140@e102568-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1302221946070.22263@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302221946070.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Feb 2013 13:34:06.0373 (UTC) FILETIME=[C8994550:01CE135C]
X-MC-Unique: 113022513340703201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 06:52:14PM +0000, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Lorenzo Pieralisi wrote:
> > On Fri, Feb 22, 2013 at 03:03:02PM +0000, Thomas Gleixner wrote:
> > > On Fri, 22 Feb 2013, Lorenzo Pieralisi wrote:
> > > > On Fri, Feb 22, 2013 at 12:07:30PM +0000, Thomas Gleixner wrote:
> > > > > Now we could make use of that and avoid going deep idle just to come
> > > > > back right away via the IPI. Unfortunately the notification thingy has
> > > > > no return value, but we can fix that.
> > > > > 
> > > > > To confirm that theory, could you please try the hack below and add
> > > > > some instrumentation (trace_printk)?
> > > > 
> > > > Applied, and it looks like that's exactly why the warning triggers, at least
> > > > on the platform I am testing on which is a dual-cluster ARM testchip.
> > > > 
> > > > There is a still time window though where the CPU (the IPI target) can get
> > > > back to idle (tick_broadcast_pending still not set) before the CPU target of
> > > > the broadcast has a chance to run tick_handle_oneshot_broadcast (and set
> > > > tick_broadcast_pending), or am I missing something ?
> > > 
> > > Well, the tick_broadcast_pending bit is uninteresting if the
> > > force_broadcast bit is set. Because if that bit is set we know for
> > > sure, that we got woken with the cpu which gets the broadcast timer
> > > and raced back to idle before the broadcast handler managed to
> > > send the IPI.
> > 
> > Gah, my bad sorry, I mixed things up. I thought
> > 
> > tick_check_broadcast_pending()
> > 
> > was checking against the tick_broadcast_pending mask not
> > 
> > tick_force_broadcast_mask
> 
> Yep, that's a misnomer. I just wanted to make sure that my theory is
> correct. I need to think about the real solution some more.
> 
> We have two alternatives:
> 
> 1) Make the clockevents_notify function have a return value.
> 
> 2) Add something like the hack I gave you with a proper name.
> 
> The latter has the beauty, that we just need to modify the platform
> independent idle code instead of going down to every callsite of the
> clockevents_notify thing.

Thank you.

I am not sure (1) would buy us anything compared to (2) and as you said we
would end up patching all callsites so (2) is preferred.

As I mentioned, we can even just apply your fixes and leave platform specific
code deal with this optimization, at the end of the day idle driver has
just to check pending IRQs/wake-up sources (which would cover all IRQs not
just TIMER IPI) if and when it has to start time consuming operations like
cache cleaning to enter deep idle. If it goes into a shallow C-state so be it.

On x86 I think it is HW/FW that prevents C-state entering if IRQs are pending,
and on ARM it is likely to happen too, so I am just saying you should not
bother if you think the code becomes too hairy to justify this change.

Thank you very much for the fixes and your help,
Lorenzo

