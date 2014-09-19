Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbaISTRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:17:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61231 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757474AbaISTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:17:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX197yKo/lSYjC6d+fODhCqF6
Date: Fri, 19 Sep 2014 12:16:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20140919191649.GQ14505@atomide.com>
References: <1411067086-16613-1-git-send-email-nm@ti.com>
 <1411067086-16613-4-git-send-email-nm@ti.com>
 <alpine.DEB.2.10.1409181749170.4206@nanos>
 <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
 <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409191027330.5612@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [140919 10:37]:
> On Fri, 19 Sep 2014, Nishanth Menon wrote:
> > On 08:37-20140919, Thomas Gleixner wrote:
> > > The other omap drivers using this have the same issue ... And of
> > > course they are subtly different.
> > > 
> > > The uart one handles the actual device interrupt, which is violating
> > > the general rule of possible interrupt reentrancy in the pm-runtime
> > > case if the two interrupts are affine to two different cores. Yes,
> > > it's protected by a lock and works by chance ....
> > > 
> > > The mmc one issues a disable_irq_nosync() in the wakeup irq handler
> > > itself.
> > > 
> > > WHY does one driver need that and the other does not? You are not even
> > > able to come up with a common scheme for OMAP. I don't want to see the
> > > mess others are going to create when this stuff becomes more used.
> > > 
> > > Thanks,
> > > 
> > > 	tglx
> > 
> > I think I understand your concern - I request Tony to comment about
> > this. I mean, I can try and hook things like uart in other drivers
> > (like https://patchwork.kernel.org/patch/4759171/ ), but w.r.t overall
> > generic usage guideline wise, I would prefer Tony to comment.
> 
> No, the uart and that i2c thing are just wrong. Assume the following
> 
> device irq affine to cpu0
> wakeup irq affine to cpu1
> 
> CPU 0				CPU 1
> 
> runtime suspend
> 
>  enable_wake(wakeup irq);
> 
> wakeup interrupt is raised	device interrupt is raised
> 
>   dev_handler(device)		dev_handler(device)
> 
> It might work due to locking, but it is nevertheless wrong. Interrupt
> handlers for devices are guaranteed not to be reentrant. And this
> brilliant stuff simply violates that guarantee. So, no. It's wrong
> even if it happens to work by chance.

Hmm yeah that's a good point indeed.

>From hardware point of view the wake-up events behave like interrupts
and could also be used as the only interrupt in some messed up cases.
That avoids all kinds of custom APIs from driver point.

The re-entrancy problem we've most likely had ever since we enabled
the PRCM interrupts, and maybe that's why I did not even consider
that part. I think before that we were calling the driver interrupt
after waking up from the PM code..

Anyways, how about the following to deal with the re-entrancy problem:

1. The wake-up interrupt handler must have a separate interrupt
   handler that just calls tasklet_schedule()

2. The device interrupt handler also just calls tasklet_schedule()

3. The tasklet then does pm_runtime_get, handles the registers, and
   so on.

Or would we still have a re-entrancy problem somewhere else with
that?

Regards,

Tony
