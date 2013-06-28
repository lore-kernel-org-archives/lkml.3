Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3F1V12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:27:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:48423 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3F1V11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:27:27 -0400
Date: Fri, 28 Jun 2013 23:27:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
In-Reply-To: <20130628210853.GB2756@lukather>
Message-ID: <alpine.DEB.2.02.1306282322480.4013@ionos.tec.linutronix.de>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com> <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com> <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de> <20130628210853.GB2756@lukather>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Maxime Ripard wrote:
> On Fri, Jun 28, 2013 at 10:13:08PM +0200, Thomas Gleixner wrote:
> > On Fri, 28 Jun 2013, Maxime Ripard wrote:
> > > @@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode mode,
> > >  static int sun4i_clkevt_next_event(unsigned long evt,
> > >  				   struct clock_event_device *unused)
> > >  {
> > > -	u32 u = readl(timer_base + TIMER_CTL_REG(0));
> > > -	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
> > > -	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
> > > +	u32 val = readl(timer_base + TIMER_CTL_REG(0));
> > > +	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
> > > +	udelay(1);
> > 
> > That udelay() is more than suspicious. Is there really no other way to
> > deal with that hardware?
> > 
> > If no, you really need to put a proper explanation for that into the code.
> 
> The datasheet states that you have to wait for two ticks of the timer
> clock source (in that case, 24MHz, which makes it around 80-85ns) before
> you can actually enable it back.
> 
> I didn't came up with a better solution.

80-85ns is definitely way less than 1us.

Why not reading the counter register and wait for 2 or 3 cycles to
elapse instead of wasting a full microsecond evertime ?

Thanks,

	tglx
