Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3LFRA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:00:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3LFRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:00:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc C <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Fri, 6 Dec 2013 18:00:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com> <201312031601.04997.arnd@arndb.de> <52A1717D.7000001@gmail.com>
In-Reply-To: <52A1717D.7000001@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312061800.42563.arnd@arndb.de>
X-Provags-ID: V02:K0:PraTg/CQhlRnbvI+EhjcTPWLi6SuXodtgTGUeeja5RH
 wivXN2QA5TGl6CoyXUq8JBFN+GzqCSOEfSKVbQx780vG+zBhZy
 Rc5dpT5y6sQ2jfuQIRwVzXHHJiveWRM81sNKZLwhIPgQ/HemBL
 hCwZLn9l9wowhpQXQI1DMyFV0VUMYctu16sMcn5ZLXBwSln7qD
 0BXp1xdlbnyq+evD6MxbvzaUR2d3Qc34cU54LMeBrM4NllVkYc
 dBUXUw+2qjKQnGR9LYmqzjnkmEYeOc7OwL4TcOFkB/LMttKpu9
 QFtSmLc09oZ0RhCFZ2cTJUJ1rLV8uj/cR79WY2VcpEBGtqQIMo
 WW6wJx7V1V9VX0+beiTk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Marc C wrote:

> > This seems like stuff that should go into the device drivers for the
> > respective hardware blocks, not into platform code.
> 
> Understood. I'm not sure if you recall this [1] conversation, but short
> of having a big array of registers offsets per chip ID (which will
> probably grow to 10 or more), leveraging the DT to let the bootloader
> tell the kernel these randomly-located registers are proved to be very
> lightweight.

Right, but I didn't expect the code to look at these registers to be
outside of a device-driver context.
 
> Seems like there's one thing I could possibly factor out into a separate
> driver... the registers that assert a chip reset (sw-master-reset-reg).
> Maybe I could register a reset-controller driver specifically for this
> purpose?

I have not followed the latest developments regarding system-reset and
where that is supposed to be handled, but I'm sure it's in some driver,
probably drivers/power or drivers/reset.

> > We try hard to avoid having register available this early and outside
> > of device drivers. Can you try to make at least some (if not all) of
> > these more regular, and provide specific comments in the code why this
> > is not possible for the others?
> 
> Just to be sure, you're asking to reduce our dependence on touching
> these machine-specific registers?

Not touching them at all would be preferred (e.g. if the boot loader
could set them up to the correct per-board setting), but of course that
doesn't work for run-time settings or system-reset.

The most important part of my comment above is to have as little as
possible done "early", i.e. before init_machine(). Beyond that, the
preferred way to do any kind of register access from a device driver
with an abstract platform-independent interface. We have added a number
of new subsystems in the past few years (clk, irqchip, pinctrl, reset,
clocksource, regmap, syscon, ...) along these lines, to the extent where
most new platforms can now have an empty machine descriptor (if they
can use the standard psci_smp_ops, I mentioned already that we need
some more work to get non-standard smp_ops merged with cpuidle).

Chances are that a lot of the registers you are trying to map here
already have a subsystem that they can fit in as a device driver,
or that they do something generic enough that we should add another
subsystem to abstract them. If you need help figuring out which
subsystem they should use, we should take a closer look at the actual
register descriptions together. Is there a manual that is publically
available?

	Arnd
