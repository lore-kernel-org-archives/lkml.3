Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBXL1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:27:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:56538 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:27:22 -0500
Date: Mon, 24 Feb 2014 12:27:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chao Xie <xiechao.mail@gmail.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 09/26] arm: mmp: Remove pointless fiddling with irq
 internals
In-Reply-To: <CADApbeiyGoSAF9n5-+Ys1H4VDgN+d727E6ARWFGj4EixqeP79w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402241207010.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212737.214342433@linutronix.de> <20140223231755.GA27579@pengutronix.de> <CADApbeiyGoSAF9n5-+Ys1H4VDgN+d727E6ARWFGj4EixqeP79w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-794881041-1393241246=:21251"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-794881041-1393241246=:21251
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 24 Feb 2014, Chao Xie wrote:

> On Mon, Feb 24, 2014 at 7:17 AM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > Hi Thomas,
> >
> > On Sun, Feb 23, 2014 at 09:40:13PM -0000, Thomas Gleixner wrote:
> >> The pm-mmp2 and pm-pxa910 power management related irq_set_wake
> >> callbacks fiddle pointlessly with the irq actions for no reason except
> >> for lack of understanding how the wakeup mechanism works.
> >>
> >> On supsend the core disables all interrupts lazily, i.e. it does not
> >> mask them at the irq controller level. So any interrupt which is
> >> firing during supsend will mark the corresponding interrupt line as
> > s/supsend/suspend/ twice
> >> pending. Just before the core powers down it checks whether there are
> >> interrupts pending from interrupt lines which are marked as wakeup
> >> sources and if so it aborts the resume and resends the interrupts.
> > It's the suspend that is aborted, not the resume.
> >
> > Other than that your change looks fine.
> >
> For pxa910 and MMP2, wake up source only wake up the AP subsystem.
> The AP subsystem includes the APMU(AP Power Mangament Unit) and cores.
> Now the core is still powered down. APMU will check the interrupt
> lines, and find
> that there are interrupt pending, it will power on the cores.
> So if the irq is disabled, even wake up source can wake up AP subsystem, but the
> core is still powered down. It will not be powered up by APMU.

The interrupt is NOT disabled at the interrupt chip level. The core does:

suspend_device_irqs() {
  __disable_irq() {
    if (!desc->depth++)
      irq_disable(desc) {
        irq_state_set_disabled(desc);
        if (desc->irq_data.chip->irq_disable) {
          desc->irq_data.chip->irq_disable(&desc->irq_data);
          irq_state_set_masked(desc);
        }

Your chip does not have a chip->irq_disable() callback installed, so
the interrupt is not masked at the controller level. So APMU sees the
interrupt enabled.

APMU does not care about the irq_desc->depth counter and the irq_data
IRQD_DISABLED state bit.

So this hackery is completely pointless.

Thanks,

	tglx

--8323329-794881041-1393241246=:21251--
