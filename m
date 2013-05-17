Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3ERAqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 20:46:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33679 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3ERAqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 20:46:01 -0400
Date: Fri, 17 May 2013 16:55:53 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: versatile: Make able to use UART ports for KGDB
 FIQ debugger
Message-ID: <20130517235553.GA6137@teo>
References: <1368144651-11250-1-git-send-email-john.stultz@linaro.org>
 <1368144651-11250-4-git-send-email-john.stultz@linaro.org>
 <20130510161710.45b18866@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510161710.45b18866@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for the review, Thomas!

On Fri, May 10, 2013 at 04:17:10PM +0200, Thomas Petazzoni wrote:
[...]
> > +{
> > +	return readl(kgdb_irq_base + VIC_FIQ_STATUS) & (1 << kgdb_irq);
> > +}
> > +
> > +static int __init kgdb_fiq_init(void)
> > +{
> > +	kgdb_irq_base = __io_address(VERSATILE_VIC_BASE);
> > +	kgdb_irq += INT_UARTINT0;
> > +	WARN_ON(kgdb_irq > INT_UARTINT2);
> > +
> > +	return kgdb_register_fiq(kgdb_fiq_select, kgdb_is_fiq_rised);
> > +}
> > +console_initcall(kgdb_fiq_init);
> 
> Also, this code that uses hardcoded addresses and IRQ numbers doesn't
> seem to play really well with the DT. I was considering toying around
> with this thing on the mach-mvebu platform, but don't have those
> hardcoded addresses and IRQs, and the register offsets of the IRQ
> controller driver are not exposed in an header file. Shouldn't IRQ
> controller driver be exposing a the fiq_select() functionality instead?
> Like a new flag for irq_chip->irq_set_type(), or a completely new hook
> irq_chip->irq_set_mode() or something like that?

FIQs are very specific to the platform, and I doubt that anyone will be
happy in exposing this kind of knowledge to the generic subsystem.

Moreover, Russell King once said that we should better detach IRQ stuff
from FIQs altogether. Thing is, FIQs are not going through the generic IRQ
code flow, so there is actually very little point in managing them thru
the generic IRQ subsystem.

What seems more plausible is making a "FIQ subsystem", and register each
IRQ controller that can redirect its sources to FIQ with that new
subsystem. But the "subsystem" isn't there, and even doing some cleanups
in this core stuff takes forever to review/make decision. :) Plus, writing
it for this small thing seems like a bit of overhead.

And if you take a closer look at this patch, it actually does not use IRQ
numbers with the IRQ subsystem. Instead, it bypasses the whole thing and
writes to the VIC registers directly.

So, for your case (if you want to use FIQ debugger on your board), I would
suggest doing the same. At least until we figure out how to do these ten
lines of board-specific code better (ideas/hints are welcome! :)

Thanks!

Anton
