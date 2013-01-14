Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3ANL35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:29:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46029 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab3ANL34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:29:56 -0500
Date: Mon, 14 Jan 2013 11:29:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast receiver
Message-ID: <20130114112951.GC7990@e106331-lin.cambridge.arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
 <1357742770-15028-2-git-send-email-mark.rutland@arm.com>
 <alpine.LFD.2.02.1301141204421.7475@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301141204421.7475@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Jan 2013 11:29:52.0545 (UTC) FILETIME=[786BE110:01CDF24A]
X-MC-Unique: 113011411295503001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:06:31AM +0000, Thomas Gleixner wrote:
> On Wed, 9 Jan 2013, Mark Rutland wrote:
> > +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> > +extern int tick_receive_broadcast(void);
> > +#else
> > +static inline int tick_receive_broadcast(void)
> > +{
> > +	return 0;
> > +}
> 
> What's the inline function for? If an arch does not have broadcasting
> support it should not have a receive broadcast function call either.

That was how this was originally structured [1], but Santosh suggested this
would break the build for !GENERIC_CLOCKEVENTS_BROADCAST [1]. It means that the
arch-specific receive path (i.e. IPI handler) doesn't have to be #ifdef'd,
which makes it less ugly.

I'm happy to have it the other way, with #ifdef'd IPI handlers.

> 
> > +#endif
> > +
> >  #ifdef CONFIG_GENERIC_CLOCKEVENTS
> >  extern void clockevents_notify(unsigned long reason, void *arg);
> >  #else
> > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> > index f113755..5079bb7 100644
> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -125,6 +125,18 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
> >  	return ret;
> >  }
> >  
> > +int tick_receive_broadcast(void)
> > +{
> > +	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
> > +	struct clock_event_device *evt = td->evtdev;
> > +
> > +	if (!evt)
> > +		return -ENODEV;
> 
> Is anything going to use the return value?

I'd added this after looking at the x86 lapic timers, where interrupts might
remain pending over a kexec, and lapic interrupts come up before timers are
registered. The return value is useful for shutting down the timer in that case
(see x86's local_apic_timer_interrupt).

If you don't agree I'll remove the return value.

> 
> Thanks,
> 
> 	tglx
>

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/138486.html

