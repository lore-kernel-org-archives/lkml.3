Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaCLPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:10:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:42697 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaCLPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:10:32 -0400
Date: Wed, 12 Mar 2014 16:10:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irq: Consider a negative return value of irq_startup()
 as an error
In-Reply-To: <CACRpkdb=51_D6kxWcmSSRdr3kROXiwJbRzQDS-1VxEJpBjVyUA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403121555140.18573@ionos.tec.linutronix.de>
References: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com> <alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de> <CACRpkdZ6D1XfDBdJEcR8G2HWkNcZSfz08Yvx8f0s+CqTUmybkg@mail.gmail.com> <alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de>
 <CACRpkdb=51_D6kxWcmSSRdr3kROXiwJbRzQDS-1VxEJpBjVyUA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Linus Walleij wrote:
> On Sat, Mar 8, 2014 at 10:15 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 7 Mar 2014, Linus Walleij wrote:
> >> I'll see what Jean-Jacques comes up with and take it from there unless
> >> he's interested in taking it all the way.
> >
> > Thought more about it while trying to come up with a persuasive
> > argument for the other Linus to take the irq_startup change that late
> > in the cycle:
> >
> > Using startup is the wrong point in __setup_irq() because we call
> > chip->irq_set_type() before we call chip->irq_startup(). And we want
> > this to be in that order to avoid spurious interrupts.
> >
> > Proper solution below. That leaves the startup/unmask logic untouched
> > and provides separate callbacks for this kind of requirements. That
> > makes it also simpler to have common functions for all gpios as you
> > don't have to do the mask/unmask dance in startup/shutdown. So you can
> > simply create gpio_irq_request/release_resources() and let the drivers
> > add those to their callbacks.
> >
> > If you agree, I put that into a separate branch based on an upstream
> > -rc so you can pull it into your gpiolib stuff and work from there.
> 
> Yeah I really like the looks of this!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> We need to think about whether the gpiolib changes are serious
> enough to be pushed this late in the -rc cycle though.
> 
> The thing is that the flagging of GPIO lines as IRQs was to fix
> up the ages-old mess of sequential semantic dependencies between
> different unrelated gpiolib and irqchip calls, and these bugs have
> been around since the first irqchip was implemented in
> drivers/gpio I think :-(
> 
> But if you prefer, I'll surely do it.

Nah. We can just do that for 3.15. If people have the urge to backport
it, it's simple enough to do so.

I pushed out the patch to a separate branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip irq/for-gpio

and merged that branch back into irq/core.

So you can just pull irq/for-gpio into the gpio work and base the gpio
related changes on top of that. Just mention it in the pull request to
the other Linus that it contains an irq/core change which avoids merge
dependencies.

Thanks,

	tglx

