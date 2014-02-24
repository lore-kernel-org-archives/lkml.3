Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBXLbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:31:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:56575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaBXLbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:31:32 -0500
Date: Mon, 24 Feb 2014 12:31:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
cc: Chao Xie <xiechao.mail@gmail.com>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 09/26] arm: mmp: Remove pointless fiddling with irq
 internals
In-Reply-To: <CAN1soZy_TfzNigfn4y6kF2qe4K+AQsagd-1KWYrz1VEavMO4bA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402241227400.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212737.214342433@linutronix.de> <20140223231755.GA27579@pengutronix.de> <CADApbeiyGoSAF9n5-+Ys1H4VDgN+d727E6ARWFGj4EixqeP79w@mail.gmail.com>
 <CAN1soZy_TfzNigfn4y6kF2qe4K+AQsagd-1KWYrz1VEavMO4bA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-798059020-1393241501=:21251"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-798059020-1393241501=:21251
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 24 Feb 2014, Haojian Zhuang wrote:

> On Mon, Feb 24, 2014 at 2:07 PM, Chao Xie <xiechao.mail@gmail.com> wrote:
> > On Mon, Feb 24, 2014 at 7:17 AM, Uwe Kleine-König
> > <u.kleine-koenig@pengutronix.de> wrote:
> >> Hi Thomas,
> >>
> >> On Sun, Feb 23, 2014 at 09:40:13PM -0000, Thomas Gleixner wrote:
> >>> The pm-mmp2 and pm-pxa910 power management related irq_set_wake
> >>> callbacks fiddle pointlessly with the irq actions for no reason except
> >>> for lack of understanding how the wakeup mechanism works.
> >>>
> >>> On supsend the core disables all interrupts lazily, i.e. it does not
> >>> mask them at the irq controller level. So any interrupt which is
> >>> firing during supsend will mark the corresponding interrupt line as
> >> s/supsend/suspend/ twice
> >>> pending. Just before the core powers down it checks whether there are
> >>> interrupts pending from interrupt lines which are marked as wakeup
> >>> sources and if so it aborts the resume and resends the interrupts.
> >> It's the suspend that is aborted, not the resume.
> >>
> >> Other than that your change looks fine.
> >>
> > For pxa910 and MMP2, wake up source only wake up the AP subsystem.
> > The AP subsystem includes the APMU(AP Power Mangament Unit) and cores.
> > Now the core is still powered down. APMU will check the interrupt
> > lines, and find
> > that there are interrupt pending, it will power on the cores.
> > So if the irq is disabled, even wake up source can wake up AP subsystem, but the
> > core is still powered down. It will not be powered up by APMU.
> >
> 
> Yes, suspend/resume can't work if the above code is removed.
> 
> Interrupt source (logic AND with interrupt mask register) is connected
> to MPMU as
> wakeup source. If the interrupt is disabled, there's no wakeup source event.
> 
> And APMU is waken up by MPMU.
> 
> So please don't remove the above code. We must keep these interrupt lines active
> to wake up the whole system.

They are kept active at the interrupt controller level. You just
refuse to understand how the internals of the interrupt subsystem
work.

And even if you would need this flag, then fiddling with the irq desc
internals is a big NONO. There is a proper way to hand that in.

Thanks,

	tglx


--8323329-798059020-1393241501=:21251--
