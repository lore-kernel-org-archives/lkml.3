Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaI2TGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:06:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38829 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbaI2TGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:06:48 -0400
Date: Mon, 29 Sep 2014 12:06:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jojy G Varghese <jojyv@juniper.net>,
        Guenter Roeck <groeck@juniper.net>, hongtao.jia@freescale.com
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Message-ID: <20140929190643.GA20189@roeck-us.net>
References: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
 <1412015766.13320.253.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412015766.13320.253.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:36:06PM -0500, Scott Wood wrote:
> On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> > From: Jojy G Varghese <jojyv@juniper.net>
> > 
> > For E500MC and E5500, a machine check exception in pci(e) memory space
> > crashes the kernel.
> > 
> > Testing shows that the MCAR(U) register is zero on a MC exception for the
> > E5500 core. At the same time, DEAR register has been found to have the
> > address of the faulty load address during an MC exception for this core.
> > 
> > This fix changes the current behavior to fixup the result register
> > and instruction pointers in the case of a load operation on a faulty
> > PCI address.
> > 
> > The changes are:
> > - Added the hook to pci machine check handing to the e500mc machine check
> >   exception handler.
> > - For the E5500 core, load faulting address from SPRN_DEAR register.
> >   As mentioned above, this is necessary because the E5500 core does not
> >   report the fault address in the MCAR register.
> > 
> > Cc: Scott Wood <scottwood@freescale.com>
> > Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
> > [Guenter Roeck: updated description]
> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  arch/powerpc/kernel/traps.c   | 3 ++-
> >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> > index 0dc43f9..ecb709b 100644
> > --- a/arch/powerpc/kernel/traps.c
> > +++ b/arch/powerpc/kernel/traps.c
> > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
> >  	int recoverable = 1;
> >  
> >  	if (reason & MCSR_LD) {
> > -		recoverable = fsl_rio_mcheck_exception(regs);
> > +		recoverable = fsl_rio_mcheck_exception(regs) ||
> > +			fsl_pci_mcheck_exception(regs);
> >  		if (recoverable == 1)
> >  			goto silent_out;
> >  	}
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> > index c507767..bdb956b 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs *regs)
> >  #endif
> >  	addr += mfspr(SPRN_MCAR);
> >  
> > +#ifdef CONFIG_E5500_CPU
> > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
> > +#endif
> 
> Kconfig tells you what hardware is supported, not what hardware you're
> actually running on.
> 
Hi Scott,

Good point. Jojy, guess we'll have to check if the CPU is actually an E5500.
Can you look into that ?

> Jia Hongtao, do you know anything about this issue?  Is there an
> erratum?  What chips are affected by the the erratum covered by
> <http://patchwork.ozlabs.org/patch/240239/>?
> 
We already have and use the above patch(es) in our kernel. It works fine
for E500 (P2020), but does not address E5500 (P5020/P5040).

> Can we rely on DEAR or is this just a side effect of likely having taken
> a TLB miss for the address recently?  Perhaps we should use the
> instruction emulation to determine the effective address instead.
> 
> Guenter, is this patch intended to deal with an erratum or are you
> covering up legitimate errors?
> 
Those are errors related to PCIe hotplug, and are seen with unexpected PCIe
device removals (triggered, for example, by removing power from a PCIe adapter).
The behavior we see on E5500 is quite similar to the same behavior on E500:
If unhandled, the CPU keeps executing the same instruction over and over again
if there is an error on a PCIe access and thus stalls. I don't know if this
is considered an erratum or expected behavior, but it is one we have to address
since we have to be able to handle that condition. Ultimately, we'll want to
implement PCIe error handlers for the affected drivers, but that will be a next
step.

Please let me know if you have a better solution to address this problem.

Thanks,
Guenter
