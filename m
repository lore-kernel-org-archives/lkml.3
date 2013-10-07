Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3JGOFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:05:03 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50962 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753704Ab3JGOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:04:59 -0400
Date: Mon, 7 Oct 2013 15:03:49 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131007140343.GA12030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 03:51:31PM -0400, Nicolas Pitre wrote:
> On Wed, 2 Oct 2013, Dave Martin wrote:
> 
> > On Tue, Oct 01, 2013 at 08:17:04PM +0400, Vyacheslav Tyrtov wrote:
> > > +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
> > > +{
> > > +     int ret;
> > > +     local_irq_disable();
> > 
> > Should there be a local_fiq_disable() here also?
> 
> No.  In fact this is paired with
> 
> > > +     arch_spin_lock(&exynos_lock);
> 
> to create the equivalent of a arch_spin_lock_irq().  And the reason is:
> 
> /*
>  * We can't use regular spinlocks. In the switcher case, it is possible
>  * for an outbound CPU to call power_down() after its inbound counterpart
>  * is already live using the same logical CPU number which trips lockdep
>  * debugging.
>  */
> 
> Otherwise we simply would have used spin_lock_irq().

Duh, of course.  Looks like I suffered temporary brain failure there.

> No FIQs are supposed to ever race with this code.

There is an anomaly though: FIQ and external abort don't seem to get
explicitly masked anywhere, either on the suspend or powerdown paths.
Sometimes either or both remains unmasked (I tried some trace in the
TC2 MCPM backend to confirm this.)

Looks like a possible omission in the arch/arm/ suspend and shutdown
code, rather than a problem specific to MCPM.

Shouldn't be an issue for this series, though.

Cheers
---Dave
