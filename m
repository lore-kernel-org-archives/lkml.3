Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaI3Pul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:50:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaI3Pui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:50:38 -0400
Date: Tue, 30 Sep 2014 08:50:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Scott Wood <scottwood@freescale.com>
Cc: Jojy Varghese <jojyv@juniper.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "hongtao.jia@freescale.com" <hongtao.jia@freescale.com>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Message-ID: <20140930155029.GA4724@roeck-us.net>
References: <D04F3201.10DEB%jojyv@juniper.net>
 <1412033466.13320.293.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412033466.13320.293.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
> On Mon, 2014-09-29 at 23:03 +0000, Jojy Varghese wrote:
> > 
> > On 9/29/14 12:06 PM, "Guenter Roeck" <linux@roeck-us.net> wrote:
> > 
> > >On Mon, Sep 29, 2014 at 01:36:06PM -0500, Scott Wood wrote:
> > >> On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> > >> > From: Jojy G Varghese <jojyv@juniper.net>
> > >> > 
> > >> > For E500MC and E5500, a machine check exception in pci(e) memory space
> > >> > crashes the kernel.
> > >> > 
> > >> > Testing shows that the MCAR(U) register is zero on a MC exception for
> > >>the
> > >> > E5500 core. At the same time, DEAR register has been found to have the
> > >> > address of the faulty load address during an MC exception for this
> > >>core.
> > >> > 
> > >> > This fix changes the current behavior to fixup the result register
> > >> > and instruction pointers in the case of a load operation on a faulty
> > >> > PCI address.
> > >> > 
> > >> > The changes are:
> > >> > - Added the hook to pci machine check handing to the e500mc machine
> > >>check
> > >> >   exception handler.
> > >> > - For the E5500 core, load faulting address from SPRN_DEAR register.
> > >> >   As mentioned above, this is necessary because the E5500 core does
> > >>not
> > >> >   report the fault address in the MCAR register.
> > >> > 
> > >> > Cc: Scott Wood <scottwood@freescale.com>
> > >> > Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
> > >> > [Guenter Roeck: updated description]
> > >> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> > >> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > >> > ---
> > >> >  arch/powerpc/kernel/traps.c   | 3 ++-
> > >> >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
> > >> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > >> > 
> > >> > diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> > >> > index 0dc43f9..ecb709b 100644
> > >> > --- a/arch/powerpc/kernel/traps.c
> > >> > +++ b/arch/powerpc/kernel/traps.c
> > >> > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
> > >> >  	int recoverable = 1;
> > >> >  
> > >> >  	if (reason & MCSR_LD) {
> > >> > -		recoverable = fsl_rio_mcheck_exception(regs);
> > >> > +		recoverable = fsl_rio_mcheck_exception(regs) ||
> > >> > +			fsl_pci_mcheck_exception(regs);
> > >> >  		if (recoverable == 1)
> > >> >  			goto silent_out;
> > >> >  	}
> > >> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > >>b/arch/powerpc/sysdev/fsl_pci.c
> > >> > index c507767..bdb956b 100644
> > >> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > >> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > >> > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs
> > >>*regs)
> > >> >  #endif
> > >> >  	addr += mfspr(SPRN_MCAR);
> > >> >  
> > >> > +#ifdef CONFIG_E5500_CPU
> > >> > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> > >> > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
> > >> > +#endif
> > >> 
> > >> Kconfig tells you what hardware is supported, not what hardware you're
> > >> actually running on.
> 
> Plus, CONFIG_E5500_CPU may not even be set when running on an e5500, as
> it is used for selecting GCC optimization settings.  You could have
> CONFIG_GENERIC_CPU instead.
> 
> And the subject says "E500MC / E5500", not just "E5500". :-)
> 
> > >Hi Scott,
> > >
> > >Good point. Jojy, guess we'll have to check if the CPU is actually an
> > >E5500.
> > >Can you look into that ?
> > 
> > 
> > "/proc/cpuinfo" shows the cpu as "e5500". Scott, are you suggesting that
> > we use a runtime method of determining the cpu type (cpu_spec's cpu_name
> > for
> > example).  
> 
> Yes, if there's a bug to be worked around, and we don't want to apply
> the workaround unconditionally, you should use PVR to determine whether
> you're running on an affected core.
> 
> > >> Can we rely on DEAR or is this just a side effect of likely having taken
> > >> a TLB miss for the address recently?  Perhaps we should use the
> > >> instruction emulation to determine the effective address instead.
> > >> 
> > >> Guenter, is this patch intended to deal with an erratum or are you
> > >> covering up legitimate errors?
> > >> 
> >
> > >Those are errors related to PCIe hotplug, and are seen with unexpected
> > >PCIe
> > >device removals (triggered, for example, by removing power from a PCIe
> > >adapter).
> > >The behavior we see on E5500 is quite similar to the same behavior on
> > >E500:
> > >If unhandled, the CPU keeps executing the same instruction over and over
> > >again
> > >if there is an error on a PCIe access and thus stalls. I don't know if
> > >this
> > >is considered an erratum or expected behavior, but it is one we have to
> > >address
> > >since we have to be able to handle that condition. 
> 
> The reason I ask is that the handling for e500 was described as an
> erratum workaround.  If it is an erratum it would be nice to know the
> erratum number and the full list of affected chips.
> 
My understanding, which may be wrong, was that this is expected behavior,
at least for E5500. I actually thought I had seen it somewhere in the
specification (response to PCIe errors), but I don't recall where exactly.

At least for my part I am not aware of an erratum.

> > >Ultimately, we'll want
> > >to
> > >implement PCIe error handlers for the affected drivers, but that will be
> > >a next
> > >step.
> 
> For now can we at least print a ratelimited error message?  I don't like
> the idea of silently ignoring these errors.  I suppose it's a separate
> issue from extending the workaround to cover e500mc, though.
> 
I don't really like the idea of printing an error message pretty much each time
when an unexpected hotplug event occurs.

> > According to the spec, we MCAR is supposed to hold the faulty data address
> > but for 5500 core, we found that MCAR is zero.
> 
> Which specific chip and revision did you see this on?  What is the value
> in MCSR?
> 
Jojy can answer that, at least for P5020. We have seen it on P5040 as well,
though, so it is not just limited to one chip/revision.

Guenter

> > You are right that DEAR entry could
> > be a resultOf a TLB miss but that¹s the register we could rely on.
> 
> If it's the result of a previous TLB miss then we can't rely on it.  The
> translation might have been loaded into the TLB before the hotplug
> event, or there might have been an interrupt between loading the
> translation into the TLB and using the translation.
> 
> > What do you mean by "instruction emulation"? 
> 
> mcheck_handle_load()
> 
> > Are you suggesting that we
> > examine the RD, RS 
> > registers for the instruction?
> 
> Yes, if we don't have a simpler reliable source of the address.
> 
> -Scott
> 
> 
