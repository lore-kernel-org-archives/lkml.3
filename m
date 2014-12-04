Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaLDNm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:42:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44722 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaLDNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:42:27 -0500
Message-ID: <548064B9.4080300@arm.com>
Date: Thu, 04 Dec 2014 13:42:17 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: Thomas Gleixner <tglx@linutronix.de>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops
 conditional
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-4-git-send-email-stefan@agner.ch> <5174649.NxPq80uDz8@wuerfel> <alpine.DEB.2.11.1412031303000.16275@nanos> <8eccedc781df2636a132dae449cbe774@agner.ch> <547F5EBD.6040705@arm.com> <a62b856866915f6939da79bdbcdabb39@agner.ch>
In-Reply-To: <a62b856866915f6939da79bdbcdabb39@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 13:35, Stefan Agner wrote:
> On 2014-12-03 20:04, Marc Zyngier wrote:
> <snip>
>>> What do you mean by the shared state in the drawing above? Currently, I
>>> check whether a interrupt is already used by the other core by reading
>>> the register (do this configuration register reflect the "shared state"
>>> in your drawing?).
>>
>> I think that is basically it. It should only be the register that
>> decides on the actual routing. BTW, how do you arbitrate between
>> concurrent accesses to this register? Or is only the A5 allowed to
>> change it?
>  
> No arbitration so far... The whole Vybrid on M4 stuff is quite a hack
> right now. For instance also the concurrent access to the clock
> registers is not handled. Currently, I start the M4 from a booted A5
> Linux. To avoid half of the clocks get turned of by the M4 clock driver,
> I need to specify clk_ignore_unused. Beside that, peripherals have to be
> enabled/disabled in a non conflicting manor in the device trees...
> 
> For the interrupt router in MSCM, it would be nice if the access could
> be done an atomic way, which would avoid the use of a lock mechanism.
> But I guess this is not possible, since peripherals only support
> standard ldr/str...?
> 
> There is the SEMA4 module which provides hardware semaphores. I'm aware
> of the hardware spinlock drivers (drivers/hwspinlock/), I started to
> implement such a driver for Vybrid. But so far a grep through the kernel
> does not show one usage of that framework... I guess we could add dt
> support for that, so we can assign the locks to individual drivers.
> 
> I also plan to have a deeper look into remoteproc/rpmsg, not sure if
> locking of shared peripherals is part (or planned to be part) of that
> framework.
> 
> For the clock stuff, the problem is more complex: I guess the would need
> some kind of master/slave definition, where we disallow the change of
> the shared clocks for the slave.
> 
> If you are aware of patches/solutions, I'm happy to hear it...

I don't have a real solution for this, but I'd be tempted to generate
the M4 DT based on the HW the A5 is not using, and only describe that.

Clearly not ideal, but it gives you the control you need (don't describe
the HW you don't want to see touched)...

	M.
-- 
Jazz is not dead. It just smells funny...
