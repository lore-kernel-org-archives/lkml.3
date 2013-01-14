Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3ANPgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:36:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60033 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3ANPgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:36:17 -0500
Date: Mon, 14 Jan 2013 15:36:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast receiver
Message-ID: <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
 <1357742770-15028-2-git-send-email-mark.rutland@arm.com>
 <alpine.LFD.2.02.1301141204421.7475@ionos>
 <20130114112951.GC7990@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1301141247020.7475@ionos>
 <20130114121247.GD7990@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1301141318460.7475@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301141318460.7475@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Jan 2013 15:36:12.0840 (UTC) FILETIME=[E229EA80:01CDF26C]
X-MC-Unique: 113011415361516701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 02:17:26PM +0000, Thomas Gleixner wrote:
> On Mon, 14 Jan 2013, Mark Rutland wrote:
> > On Mon, Jan 14, 2013 at 11:50:55AM +0000, Thomas Gleixner wrote:
> > > On Mon, 14 Jan 2013, Mark Rutland wrote:
> > > 
> > > > On Mon, Jan 14, 2013 at 11:06:31AM +0000, Thomas Gleixner wrote:
> > > > > On Wed, 9 Jan 2013, Mark Rutland wrote:
> > > > > > +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> > > > > > +extern int tick_receive_broadcast(void);
> > > > > > +#else
> > > > > > +static inline int tick_receive_broadcast(void)
> > > > > > +{
> > > > > > +	return 0;
> > > > > > +}
> > > > > 
> > > > > What's the inline function for? If an arch does not have broadcasting
> > > > > support it should not have a receive broadcast function call either.
> > > > 
> > > > That was how this was originally structured [1], but Santosh suggested this
> > > > would break the build for !GENERIC_CLOCKEVENTS_BROADCAST [1]. It means that the
> > > > arch-specific receive path (i.e. IPI handler) doesn't have to be #ifdef'd,
> > > > which makes it less ugly.
> > > 
> > > Hmm. If you want to keep the IPI around unconditionally the inline
> > > makes some sense, though the question is whether keeping an unused IPI
> > > around makes sense in the first place. I'd rather see a warning that
> > > an unexpected IPI happened than a silent inline function being called.
> > 
> > How about I add a warning (e.g. "Impossible timer broadcast received.") and
> > return -EOPNOTSUPP when !GENERIC_CLOCKEVENTS_BROADCAST?
> 
> You still need to do something with the return value in the arch IPI
> code, right?

Good point. Having the stub when !CONFIG_GENERIC_CLOCKEVENTS_BROADCAST is
clearly problematic.

I'll go with your original suggestion, removing the tick_receive_broadcast stub
for !CONFIG_GENERIC_CLOCKEVENTS_BROADCAST and I'll #idef the IPI_TIMER handler.
That way it'll fall down to the standard warning for an unexpected/unknown IPI
for arch/arm at least.

> > > > > Is anything going to use the return value?
> > > > 
> > > > I'd added this after looking at the x86 lapic timers, where interrupts might
> > > > remain pending over a kexec, and lapic interrupts come up before timers are
> > > > registered. The return value is useful for shutting down the timer in that case
> > > > (see x86's local_apic_timer_interrupt).
> > > 
> > > Right, though then you need to check for evt->event_handler as well.
> > 
> > I thought this previously also [1], but I couldn't find any path such that a
> > tick_cpu_device would have an evtdev without an event_handler. We always set the
> > handler before setting evtdev, and alway wipe evtdev before wiping the handler.
> > 
> > Have I missed something?
> 
> That's an x86 specific issue. Though we could try and make that
> functionality completely generic.

Just to check: is the evt->event_handler check necessary?

> Thanks,
> 
> 	tglx
> 

Thanks,
Mark.

