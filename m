Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaH1WoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:44:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:43148 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1WoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:44:20 -0400
Date: Fri, 29 Aug 2014 00:44:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH 0/5 v3] irq / PM: Suspend-to-idle wakeup interrupts
In-Reply-To: <5320472.coYotHR1d0@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408282355350.23342@nanos>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Rafael J. Wysocki wrote:
> To me, all of this is relatively straightforward and the handling of
> IRQF_NO_SUSPEND for shared interrupts, which is a separate problem, can be
> addressed on top of it later (make no mistake, I still think that it should be
> addressed).

Why? Just because there is enough idiotic code using it?

Let's look at the usage sites:

sound/soc/codecs/twl6040.c

  Introduced in commit 8d61f4901f83461e1f04df7743777e9db5f541aa

    ASoC: twl6040: Convert PLUGINT to no-suspend irq
    
    Convert headset PLUGINT interrupt to NO_SUSPEND type in order to
    allow handling of insertion/removal events while device is
    suspended.

  So why does this need to be a NO_SUSPEND type interrupt? Just because
  the flag is sexy? What's wrong with using the wake mechanism?

drivers/xen/events/events_base.c

  A genuine usecase which makes sense and is not shared

drivers/watchdog/intel-mid_wdt.c

  MUHAHAHAHAHAHA

  static irqreturn_t mid_wdt_irq(int irq, void *dev_id)
  {
      panic("Kernel Watchdog");
      /* This code should not be reached */
      return IRQ_HANDLED;
  }

  So why does this need to be NO_SUSPEND? Because we forgot to trigger
  the watchdog during suspend? Brilliant!

drivers/usb/phy/phy-ab8500-usb.c

  Of course no explanation WHY this uses NO_SUSPEND plus SHARED and
  there is no fcking reason to do so.

So really, I'm too lazy to walk through that mess further. I bet NONE
of the usage sites except those for which this has been introduced in
the first place has a real good reason to do so.

Unless someone comes up with a use case where a shared NO_SUSPEND
handler is absolutely required, there is nothing which needs to be
addressed. You've proven yourself, that the wake mechanism is
sufficient to solve the problem which led to this discussion.

So we rather go and fix the ABUSE instead of making it legitimate by
fugly workarounds in the core code.

The same applies to the IRQF_RESUME_EARLY flag.

Just look at:

  commit 8b41669ceba0c2d4c09d69ccb9a3458953dae784

    mfd: twl4030: Fix chained irq handling on resume from suspend
    
    The irqs are enabled one-by-one in pm core resume_noirq phase.
    This leads to situation where the twl4030 primary interrupt
    handler (PIH) is enabled before the chained secondary handlers
    (SIH). As the PIH cannot clear the pending interrupt, and
    SIHs have not been enabled yet, a flood of interrupts hangs
    the device.
    
    Fixed the issue by setting the SIH irqs with IRQF_EARLY_RESUME
    flags, so they get enabled before the PIH.

So we solve an ordering problem which has a completely different root
cause by slapping random flags on it which paper over the issue?

The solution to the problem is completely wrong and of course the
"fix" is only applied to the one instance which might be affected by
that issue, i.e. the one which caused the patch submitter trouble.

Now I don't blame the author, I blame the maintainer who happily
applied that "fix".

That's unfortunately a very common pattern in the kernel which will
cause serious maintainability issues in the long run, but of course
that's just the opinion of a grumpy old greybeard.

The sad thing is that neither the author nor the maintainer who
applied it is going to be around and responsive when the shit hits the
fan. That commit is a perfect example for this.

Thanks,

	tglx
