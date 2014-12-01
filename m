Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaLALyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:54:21 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41894 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaLALyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:54:18 -0500
Date: Mon, 1 Dec 2014 11:54:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Allow interrupt level to be set for PPIs.
Message-ID: <20141201115400.GD3836@n2100.arm.linux.org.uk>
References: <1417197340-27298-1-git-send-email-Liviu.Dudau@arm.com>
 <20141201104145.GY3836@n2100.arm.linux.org.uk>
 <20141201104612.GM828@e106497-lin.cambridge.arm.com>
 <20141201110358.GA3836@n2100.arm.linux.org.uk>
 <547C4ECD.20802@arm.com>
 <20141201112302.GC3836@n2100.arm.linux.org.uk>
 <547C5179.5020505@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C5179.5020505@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:31:05AM +0000, Marc Zyngier wrote:
> On 01/12/14 11:23, Russell King - ARM Linux wrote:
> > On Mon, Dec 01, 2014 at 11:19:41AM +0000, Marc Zyngier wrote:
> >> Hi Russell,
> >>
> >> On 01/12/14 11:03, Russell King - ARM Linux wrote:
> >>> If all you want to do is to bypass the following check, what's wrong
> >>> with actually doing that:
> >>>
> >>> -	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
> >>> +	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
> >>> +	    type != IRQ_TYPE_EDGE_RISING)
> >>> 		return -EINVAL;
> >>>
> >>
> >> I think that will require some additional changes to gic_configure_irq
> >> (in irq-gic-common.c).
> > 
> > I don't think so - gic_configure_irq() will treat it as a no-op as far
> > as trying to configure the IRQ settings.
> 
> I agree. But that's following ARM's tradition of making PPIs
> non-configurable. I seem to remember that there is at least one
> occurrence of a GIC with configurable PPIs (Qualcomm, IIRC).
> 
> With this use case in mind, Liviu's patch allows an active-low interrupt
> to be correctly configured as level, for example.

Liviu's patch is nothing more than a hack.  It changes (eg) the active
low level to be an active high level with the explicitly stated reason to
bypass a test, and then hopes that the remaining functions do the right
thing.

It would be better to explicitly bypass the test, and then explicitly
handle other cases in gic_configure_irq().

It would be even better to make the code reflect reality right the way
through.  If PPIs are non-configurable, then we should return -EINVAL if
trying to set them to a setting which is not supported.  For example,
pass through all states to gic_configure_irq(), and have gic_configure_irq()
return whether the state is valid.

Then, gic_configure_irq() can read back the register after trying to set
the appropriate value, and see whether it was taken.  If the bits remain
unchanged, then it can decide that the requested mode is not supported,
and return -EINVAL.

In any case, let's not hack the code in the way that Liviu is trying to
do.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
