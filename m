Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaHDRj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:39:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62494 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaHDRjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:39:11 -0400
Date: Mon, 4 Aug 2014 10:39:07 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v8 01/11] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
Message-ID: <20140804173907.GU3711@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <1405976886-27807-2-git-send-email-computersforpeace@gmail.com>
 <20140802081924.GW30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802081924.GW30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 09:19:24AM +0100, Russell King wrote:
> Here's some more comments on this.
> 
> On Mon, Jul 21, 2014 at 02:07:56PM -0700, Brian Norris wrote:
> > +static void brcmstb_cpu_die(u32 cpu)
> > +{
> > +	v7_exit_coherency_flush(all);
> 
> This is ultimately what causes my builds to break:
> 
> /tmp/ccSPowmq.s:171: Error: selected processor does not support ARM mode `isb '
> /tmp/ccSPowmq.s:177: Error: selected processor does not support ARM mode `isb '
> /tmp/ccSPowmq.s:178: Error: selected processor does not support ARM mode `dsb '
> make[2]: *** [arch/arm/mach-bcm/platsmp-brcmstb.o] Error 1
> 
> It seems that v7_exit_coherency_flush() can only be used with code which
> is ARMv7 only.

Yes, I noticed this already, and I proposed a solution:

  http://article.gmane.org/gmane.linux.drivers.devicetree/84517

> > +	/* Prevent all interrupts from reaching this CPU. */
> > +	arch_local_irq_disable();
> 
> Why do you think it is necessary to disable interrupts here?  Where
> have they been re-enabled since this bit of generic code:
> 
> void __ref cpu_die(void)
> {
>         unsigned int cpu = smp_processor_id();
> 
>         idle_task_exit();
> 
>         local_irq_disable();
> 
> and why arch_local_irq_disable() at that?  Even if interrupts were
> enabled prior to your call to arch_local_irq_disable(), what do you
> think would be the effect of receiving an interrupt after you've
> exited coherency?

This mistake was already noted. No need for the extra IRQ disable.

(http://article.gmane.org/gmane.linux.drivers.devicetree/84516)

> > +
> > +	/*
> > +	 * Final full barrier to ensure everything before this instruction has
> > +	 * quiesced.
> > +	 */
> > +	isb();
> > +	dsb();
> 
> If the call to arch_local_irq_disable() is removed, and
> v7_exit_coherency_flush() is fixed, then this is not required, because
> v7_exit_coherency_flush() already does this at the very end.

Right. Will drop.

> > +
> > +	per_cpu_sw_state_wr(cpu, 0);
> > +
> > +	/* Sit and wait to die */
> > +	wfi();
> > +
> > +	/* We should never get here... */
> > +	panic("Spurious interrupt on CPU %d received!\n", cpu);
> 
> You really should /not/ be calling panic here, because that uses data
> shared with the CPUs which are still coherent.  This is akin to doing
> DMA into bits of the kernel space without dealing with the cache
> coherency issues.

OK.

> Moreover, if you read the comments on
> v7_exit_coherency_flush() about ldrex/strex, which are two instructions
> spinlocks use, you'll see that ldrex/strex must not be executed, which
> means you can't call any function which uses spinlocks.  That rules
> out printk() et.al.  printascii is fine, but that's only available when
> the low level debug stuff is enabled.

OK, so I'll drop the panic(). printascii doesn't look extremely useful,
but I suppose we could use it for debugging. Seems like a while (1) loop
might be a suitable replacement. If we get this far, we'll likely get
locked up trying to power this CPU off anyway, so it'll be apparent that
there was power-down failure.

Thanks,
Brian
