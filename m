Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3H2ID1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:03:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46397 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191Ab3H2IDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:03:24 -0400
Date: Thu, 29 Aug 2013 10:03:20 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-ID: <20130829100320.0b86e1f9@skate>
In-Reply-To: <20130828123352.b9beff5237dfde2571a5779e@linux-foundation.org>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<20130827133709.64b4743950b911d6dfe7fab8@linux-foundation.org>
	<20130828102422.GA2348@localhost>
	<20130828123352.b9beff5237dfde2571a5779e@linux-foundation.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Morton,

On Wed, 28 Aug 2013 12:33:52 -0700, Andrew Morton wrote:

> > > It only works if both subsystems agree to use atomic_io_modify().  And
> > > if they're both capable of doing that, they are both capable of
> > > implementing an agreed-upon internal locking scheme, so why bother?
> > > 
> > 
> > One of the scenarios where this could be helpful and an agreed-upon
> > lock seemed difficult to design is this: a watchdog driver that shares
> > some control register with *two* different clocksource drivers.
> > 
> > So, one first solution is to have a function in the two clocksource
> > drivers (with matching prototype) and have the watchdog access
> > the register through it.
> > 
> > However, because of multiplatform builds, both these clocksource drivers
> > could be built at the same time. Therefore we would have a symbol
> > collision, doubly-defined, in each driver.
> > 
> > How would that work? What other internal locking scheme could we
> > implement?
> 
> I guess the locking would need to be in a standalone module which the
> various driver modules would then depend upon.  I'm not really
> advocating doing this - I'm just making noise.

I think the idea of this "atomic MMIO modify" function was precisely to
solve the situations where one or two "misc" registers need to be
accessed by various unrelated drivers, and having a separate standalone
module to control those one or two "misc" registers would be a bit too
annoying.

This is a situation that we have fairly often at least in some ARM
SoCs: the registers of the various IP blocks are generally nicely
organized in "regions", where all the registers for each UART are
grouped together, for each I2C controller, each SPI controller and so
on. But there are always a bunch of misc, system control registers that
do not really belong to any particular IP block, but some of the device
drivers sometimes need to set/clear a bit in such registers. Of course,
when those "system control" registers control a clock, or pin muxing,
or something well-known, we have existing frameworks in the kernel to
support that. But there is always this bizarre "system control"
feature, that does not fit into an existing kernel framework, and for
which writing an entirely separate driver is really overkill.

The case highlighted by the patches 3/4 and 4/4 of Ezequiel are I
believe a good example. While each timer and the watchdog each have
their own "region" of registers to be controlled, there is also one
single global register to enable/disable the different timers and
watchdog (with one bit per timer or watchdog). So this register needs
to be accessed by both the timer (clocksource) and watchdog drivers,
even though they are otherwise completely unrelated. Writing a separate
driver just to control this register, that is accessed infrequently
(i.e only when the kernel boots essentially), would require a lot of
code for no real benefit.

Does that clarify the intended usage?

Thanks for your feedback,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
