Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3GEKVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:21:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:44236 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3GEKVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:21:08 -0400
Date: Fri, 5 Jul 2013 12:21:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Subject: Re: [PATCH v5] ARM: clocksource: add support for MOXA ART SoCs
In-Reply-To: <CACmBeS03Xfo7DyyYUbpBaO8TeR3g8BTPzcoOzQayk40k1soFzA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1307051213080.11637@ionos.tec.linutronix.de>
References: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com> <1372940383-5957-1-git-send-email-jonas.jensen@gmail.com> <alpine.DEB.2.02.1307042211420.11637@ionos.tec.linutronix.de>
 <CACmBeS03Xfo7DyyYUbpBaO8TeR3g8BTPzcoOzQayk40k1soFzA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Jonas Jensen wrote:

> On 4 July 2013 23:42, Thomas Gleixner <tglx@linutronix.de> wrote:
> > You just modify bits on the "cache" variable. though you are not
> > caching it. As it seems to work it looks like this register simply can
> > be written with constants.
> 
> I agree, the global "cache" variable wasn't very good. The only good thing, that
> it eliminated all TIMER_CR reads in moxart_clkevt_next_event.

Well, you can use a global cache variable. But that wants to be
implemented as a real cache, i.e. it always contains the current state
of the register.

   cache = 0;

   cache |= T2_ENABLE;
   write(cache, CR);
   ....
 
> Yes it could be written with constants, and it wouldn't be so bad, because in
> this case so few need to be set. If more constants were set from init
> the benefit
> would be more clear.
>
> >> +     timereg_cache = readl(base + TIMER_CR) | TIMEREG_CR_2_ENABLE;
> >
> > Why are you reading that back? You know excactly which of the timers
> > you are using and none of those should be enabled before you reach
> > that code. If it one of them is enabled by the boot loader you better
> > disable it in this init function.
> 
> Removed. All timers except TIMER2 should be disabled in init.
> 
> > Now if you disable all of those timers and just use a known set, then
> > you can do without a pseudo cache variable and just write constants
> > into the control register, right ?
> 
> Yes, please take a look at v6.

You are still reading from the control register.

What's wrong with:

#define T1_ENABLE	(TIMEREG_CR_2_ENABLE | TIMEREG_CR_1_ENABLE)
#define T1_DISABLE	(TIMEREG_CR_2_ENABLE)

Because you need to preserve the CR2 enable bit so your clocksource
does not get switched off.

Then the set_mode/next_event functions simply do:

     write(T1_DISABLE)
     write(data)
     write(T1_ENABLE)

Hmm?

Thanks,

	tglx
