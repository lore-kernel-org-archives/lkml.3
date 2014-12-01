Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaLAKis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:38:48 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41699 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaLAKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:38:46 -0500
Date: Mon, 1 Dec 2014 10:38:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Sander <tim@krieglstein.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
Message-ID: <20141201103832.GX3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <13373554.4deCsZOMXS@dabox>
 <20141128100828.GQ3836@n2100.arm.linux.org.uk>
 <1633306.naE1qIcAOt@dabox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1633306.naE1qIcAOt@dabox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:32:00AM +0100, Tim Sander wrote:
> Hi Russel, Daniel
> 
> Am Freitag, 28. November 2014, 10:08:28 schrieb Russell King - ARM Linux:
> > The two things are mutually exclusive.  You can either have FIQ being used
> > for debug purposes, where we decode the FIQ reason and call some function
> > (which means that we will only service one FIQ at a time) or you can use
> > it in exclusive mode (provided by fiq.c) where your handler has sole usage
> > of the vector, and benefits from fast and immediate servicing of the event.
>
> As far as i am aware, die CONFIG_FIQ symbol is not pulled by all ARM 
> platforms. Since there are ARM platforms which don't use this symbol but the 
> hardware is fully capable of handling FIQ requests i would expect, that adding
> CONFIG_FIQ to a plattform, that this platform honors the set_fiq_handler 
> functionality. 

That whole paragraph doesn't make much sense to me.

Look, in my mind it is very simple.  If you are using CONFIG_FIQ on a
SMP platform, your life will be very difficult.  The FIQ code enabled
by that symbol is not designed to be used on SMP systems, *period*.

If you decide to enable CONFIG_FIQ, and you use that code on a SMP
platform, I'm going to say right now so it's totally clear: if you
encounter a problem, I don't want to know about it.  The code is not
designed for use on that situation.

Therefore, as far as I'm concerned, the two facilities are mututally
exclusive.

I had thought about whether the IPI FIQ should be disabled when a
replacement FIQ handler is installed, I deem it not to be a use case
that the mainline kernel needs to be concerned about.

> Yes, but if the FIQ handler is also used for IPI, set_fiq_handler gets IPI 
> interrupts (with the patch starting this thread)? So i think that the patch 
> needs to look like:
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry 
> handle_fiq_as_nmi(struct pt_regs *regs)
> +#ifndef CONFIG_FIQ
>  #ifdef CONFIG_ARM_GIC
>         gic_handle_fiq_ipi();
>  #endif
> +#endif

No.  With a single zImage kernel, you could very well have SMP and FIQ
both enabled, but have a non-SMP platform using FIQ, but also support
SMP platforms as well.  Your change prevents that happening.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
