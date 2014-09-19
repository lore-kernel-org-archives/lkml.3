Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaISRhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:37:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:60389 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaISRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:37:04 -0400
Date: Fri, 19 Sep 2014 10:36:54 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nishanth Menon <nm@ti.com>
cc: Tony Lindgren <tony@atomide.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
In-Reply-To: <20140919161927.GA28613@kahuna>
Message-ID: <alpine.DEB.2.10.1409191027330.5612@nanos>
References: <1411067086-16613-1-git-send-email-nm@ti.com> <1411067086-16613-4-git-send-email-nm@ti.com> <alpine.DEB.2.10.1409181749170.4206@nanos> <20140919030333.GA6088@kahuna> <alpine.DEB.2.10.1409190710320.5612@nanos> <20140919161927.GA28613@kahuna>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Nishanth Menon wrote:
> On 08:37-20140919, Thomas Gleixner wrote:
> > The other omap drivers using this have the same issue ... And of
> > course they are subtly different.
> > 
> > The uart one handles the actual device interrupt, which is violating
> > the general rule of possible interrupt reentrancy in the pm-runtime
> > case if the two interrupts are affine to two different cores. Yes,
> > it's protected by a lock and works by chance ....
> > 
> > The mmc one issues a disable_irq_nosync() in the wakeup irq handler
> > itself.
> > 
> > WHY does one driver need that and the other does not? You are not even
> > able to come up with a common scheme for OMAP. I don't want to see the
> > mess others are going to create when this stuff becomes more used.
> > 
> > Thanks,
> > 
> > 	tglx
> 
> I think I understand your concern - I request Tony to comment about
> this. I mean, I can try and hook things like uart in other drivers
> (like https://patchwork.kernel.org/patch/4759171/ ), but w.r.t overall
> generic usage guideline wise, I would prefer Tony to comment.

No, the uart and that i2c thing are just wrong. Assume the following

device irq affine to cpu0
wakeup irq affine to cpu1

CPU 0				CPU 1

runtime suspend

 enable_wake(wakeup irq);

wakeup interrupt is raised	device interrupt is raised

  dev_handler(device)		dev_handler(device)

It might work due to locking, but it is nevertheless wrong. Interrupt
handlers for devices are guaranteed not to be reentrant. And this
brilliant stuff simply violates that guarantee. So, no. It's wrong
even if it happens to work by chance.

Thanks,

	tglx
