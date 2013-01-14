Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3ANLu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:50:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:58599 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3ANLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:50:57 -0500
Date: Mon, 14 Jan 2013 12:50:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast
 receiver
In-Reply-To: <20130114112951.GC7990@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.02.1301141247020.7475@ionos>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com> <1357742770-15028-2-git-send-email-mark.rutland@arm.com> <alpine.LFD.2.02.1301141204421.7475@ionos> <20130114112951.GC7990@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Mark Rutland wrote:

> On Mon, Jan 14, 2013 at 11:06:31AM +0000, Thomas Gleixner wrote:
> > On Wed, 9 Jan 2013, Mark Rutland wrote:
> > > +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> > > +extern int tick_receive_broadcast(void);
> > > +#else
> > > +static inline int tick_receive_broadcast(void)
> > > +{
> > > +	return 0;
> > > +}
> > 
> > What's the inline function for? If an arch does not have broadcasting
> > support it should not have a receive broadcast function call either.
> 
> That was how this was originally structured [1], but Santosh suggested this
> would break the build for !GENERIC_CLOCKEVENTS_BROADCAST [1]. It means that the
> arch-specific receive path (i.e. IPI handler) doesn't have to be #ifdef'd,
> which makes it less ugly.

Hmm. If you want to keep the IPI around unconditionally the inline
makes some sense, though the question is whether keeping an unused IPI
around makes sense in the first place. I'd rather see a warning that
an unexpected IPI happened than a silent inline function being called.

> > Is anything going to use the return value?
> 
> I'd added this after looking at the x86 lapic timers, where interrupts might
> remain pending over a kexec, and lapic interrupts come up before timers are
> registered. The return value is useful for shutting down the timer in that case
> (see x86's local_apic_timer_interrupt).

Right, though then you need to check for evt->event_handler as well.

Thanks,

	tglx
