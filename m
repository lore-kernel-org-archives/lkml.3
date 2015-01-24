Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbbAXQPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:15:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:40696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbAXQPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:15:51 -0500
Date: Sat, 24 Jan 2015 17:15:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
In-Reply-To: <97acd41d4ec349de80a2c1f30ec18efa@BL2FFO11FD007.protection.gbl>
Message-ID: <alpine.DEB.2.11.1501241254010.5526@nanos>
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com> <1025ebd0a9984037bf15adf3ae4889d9@BN1BFFO11FD013.protection.gbl> <99d5bcca1d6541a49ff8a9f41f9b18af@BL2FFO11FD039.protection.gbl> <12360948.gSvRbI0dui@vostro.rjw.lan>
 <20150112154347.GA23297@red-moon> <2313f65696c04c48867a3e8ce65ceb0b@BL2FFO11FD015.protection.gbl> <20150112161453.GA25281@red-moon> <97acd41d4ec349de80a2c1f30ec18efa@BL2FFO11FD007.protection.gbl>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-704767873-1422102053=:5526"
Content-ID: <alpine.DEB.2.11.1501241322300.5526@nanos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-704767873-1422102053=:5526
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.11.1501241322301.5526@nanos>

On Fri, 23 Jan 2015, Sören Brinkmann wrote:
> On Mon, 2015-01-12 at 04:14PM +0000, Lorenzo Pieralisi wrote:
> > I thought that a shutdown clock event device explicitly disables IRQ
> > assertion, that's why I am inquiring, I do not understand how this
> > can happen - how can you have a pending timer IRQ at step 3 above.
> 
> It does I guess, but the shutdown of the IRQ happens after disabling
> IRQs. During that window the IRQ can become pening without anybody
> handling it. Shutting the timer down usually just ensures that no new
> interrupts are signaled but it apparently doesn't check whether any are
> still pending (which isn't necessary in almost all cases since the ISR
> would take care of it).

Well, the issue is that lots of platforms are just not affected by
this because they either power off or simply do not propagate
interrupts which are not explicitely marked as wakeup sources.

After thinking more about it, we really should try to handle it at the
core code, especially because the freezer folks who try to shutdown
the tick completely run into similar issues.

But, I don't think that just moving the suspend() call before
disabling interrupts is sufficient. I rather think it's outright
dangerous.

suspend_ce()
   local_irq_disable();

---> Interrupt becomes pending

   shutdown(ce);
   local_irq_enable();

---> Interrupt fires

There are implementations which actually switch of clocks and such at
shutdown. So depending on the code in the actual interrupt handler (not the
clockevent->handler, though that might have issues as well) we might
touch a disfunctional device with possibly fatal consequences.

Right now this cannot happen as the invocation of the interrupt
handler is guaranteed to happen _after_ the device has been
resumed. Just because it does not explode in your implementation does
not mean its safe to inflict on everyone.

So if we try to handle this issue at the core level, then we really
must deal with the interrupt itself.

Timer interrupts are always marked IRQF_NO_SUSPEND, because we still
need them until syscore_suspend(). So in case we really shut down the
clockevent device via tick_suspend() then we must disable the
interrupt there as well and reenable it in tick_resume().

But that's not really possible at the core level today. Timer
interrupts are delivered by various mechanisms:

      - plain interrupts
      - percpu interrupts
      - per cpu direct vectors
      - more complex stuff

and we have no idea which type we are dealing with. So the only option
would be to have a callback and let the suspend code do:

   if (cedev->disable_irq)
      cedev->disable_irq(cddev);

and the reverse operation for resume. So we can provide default
implementations for the callbacks:

   void ce_[dis|en]able_irq(...)
   void ce_[dis|en]able_percpu_irq(...)

which would rely on cedev->irq. Those two would cover most of the
implementations. The ones with special requirements can implement
their own.

Now at the irq level, we'd need a new function for the device irqs:

    disable_and_mask_irq_nosync(irq)

which makes sure that the line is masked at the hardware level. That's
necessary because the lazy interrupt disable is not sufficient. The
percpu irqs are already masking at the hardware level.

One might argue that we could handle this in set_mode() as well, but
we are thinking about going away from that multiplex call. Aside of
that, ensuring the symmetry of disable/enable invocations would be
problematic with the existing set_mode() implementations and usage.

Thanks,

	tglx


--8323329-704767873-1422102053=:5526--
