Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaLBNRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:17:14 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47803 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaLBNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:17:11 -0500
Date: Tue, 2 Dec 2014 14:17:53 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de,
        pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Message-ID: <20141202131753.GC545@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <20141130102137.GH23653@cbox>
 <87r3wj1te1.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r3wj1te1.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:50:14AM +0000, Alex Bennée wrote:
> 
> Christoffer Dall <christoffer.dall@linaro.org> writes:
> 
> > On Tue, Nov 25, 2014 at 04:10:03PM +0000, Alex Bennée wrote:
> >> This adds support for single-stepping the guest. As userspace can and
> >> will manipulate guest registers before restarting any tweaking of the
> >> registers has to occur just before control is passed back to the guest.
> >> Furthermore while guest debugging is in effect we need to squash the
> >> ability of the guest to single-step itself as we have no easy way of
> >> re-entering the guest after the exception has been delivered to the
> >> hypervisor.
> >
> > Admittedly this is a corner case, but wouldn't the only really nasty bit
> > of this be to emulate the guest debug exception?
> 
> Well yes - currently this is all squashed by ignoring the guest's wishes
> while we are debugging (save for SW breakpoints).
> 
> >
> >> 
> >> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> 
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index 48d26bb..a76daae 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -38,6 +38,7 @@
> >>  #include <asm/tlbflush.h>
> >>  #include <asm/cacheflush.h>
> >>  #include <asm/virt.h>
> >> +#include <asm/debug-monitors.h>
> >>  #include <asm/kvm_arm.h>
> >>  #include <asm/kvm_asm.h>
> >>  #include <asm/kvm_mmu.h>
> >> @@ -300,6 +301,17 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >>  	kvm_arm_set_running_vcpu(NULL);
> >>  }
> >>  
> >> +/**
> >> + * kvm_arch_vcpu_ioctl_set_guest_debug - Setup guest debugging
> >> + * @kvm:	pointer to the KVM struct
> >> + * @kvm_guest_debug: the ioctl data buffer
> >> + *
> >> + * This sets up the VM for guest debugging. Care has to be taken when
> >> + * manipulating guest registers as these will be set/cleared by the
> >> + * hyper-visor controller, typically before each kvm_run event. As a
> >
> > hypervisor
> >
> >> + * result modification of the guest registers needs to take place
> >> + * after they have been restored in the hyp.S trampoline code.
> >
> > I don't understand this??
> 
> We can't use GET/SET one reg to manipulate the registers we want as
> these are the guest visible versions and subject to modification by
> userspace. This is why the debugging code makes it's changes after the
> guest state has been restored.
> 

eh, once you're in the KVM_RUN ioctl, user space can't fiddle your VCPU
regs because you're holding the vcpu mutex, so doing stuff in some
callout from kvm_arch_vcpu_ioctl_run() seems every bid as valid for this
case as doing it in EL2.  In fact, the only reason why we're doing
anything in EL2 is when you're accessing state only accessible in EL2,
when you need to write the whole thing in assembly (like the context
switch of GP registers) etc.

If it doesn't have huge performance costs, we should use C-code in EL1
to the furthest extent possible.

> >
> >> + */
> >>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >>  					struct kvm_guest_debug *dbg)
> >>  {
> >> @@ -317,8 +329,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >>  
> >>  	/* Single Step */
> >>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> >> -		kvm_info("SS requested, not yet implemented\n");
> >> -		return -EINVAL;
> >> +		kvm_info("SS requested\n");
> >> +		route_el2 = true;
> >>  	}
> >>  
> >>  	/* Software Break Points */
> >> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> >> index 8da1043..78e5ae1 100644
> >> --- a/arch/arm64/kernel/asm-offsets.c
> >> +++ b/arch/arm64/kernel/asm-offsets.c
> >> @@ -121,6 +121,7 @@ int main(void)
> >>    DEFINE(VCPU_FAR_EL2,		offsetof(struct kvm_vcpu, arch.fault.far_el2));
> >>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2));
> >>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
> >> +  DEFINE(GUEST_DEBUG,		offsetof(struct kvm_vcpu, guest_debug));
> >>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> >>    DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
> >>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
> >> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> >> index 28dc92b..6def054 100644
> >> --- a/arch/arm64/kvm/handle_exit.c
> >> +++ b/arch/arm64/kvm/handle_exit.c
> >> @@ -91,6 +91,25 @@ static int kvm_handle_bkpt(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>  	return 0;
> >>  }
> >>  
> >> +/**
> >> + * kvm_handle_ss - handle single step exceptions
> >> + *
> >> + * @vcpu:	the vcpu pointer
> >> + *
> >> + * See: ARM ARM D2.12 for the details. While the host is routing debug
> >> + * exceptions to it's handlers we have to suppress the ability of the
> >
> > its handlers
> >
> >> + * guest to trigger exceptions.
> >
> > not really sure why this comment is here?  Does it really help anyone
> > reading this specific function or does it just confuse people more?
> >
> >> + */
> >> +static int kvm_handle_ss(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >> +{
> >> +	WARN_ON(!(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP));
> >
> > is this something that can actually happen or should it be a BUG_ON() -
> > which may even go away once you're doing hacking on this?
> 
> It shouldn't happen. I was treating more like an assert, failure of
> which would indicate something has gone wrong somewhere although
> generally not worth bringing the kernel down for.
> 

huh, I guess that's fair enough, but somewhat unconventional for kernel
code.  Typically I read WARN_ON (I could be wrong here) as something
that may happen under extreme circumstances (debugging turned on, crazy
low-memory situations etc.), but not as something that catches a bug.

I've seen the argument before that if something that sholdn't ever
happen in the kernel, indeed does happen in the kernel, then that is a
bug, and then you should panic().

So I do feel that this is either a kvm_info()/kvm_err() situation or a
BUG_ON() situation, or nothing at all.

> >
> >> +
> >> +	run->exit_reason = KVM_EXIT_DEBUG;
> >> +	run->debug.arch.exit_type = KVM_DEBUG_EXIT_SINGLE_STEP;
> >> +	run->debug.arch.address = *vcpu_pc(vcpu);
> >> +	return 0;
> >> +}
> >> +
> >>  static exit_handle_fn arm_exit_handlers[] = {
> >>  	[ESR_EL2_EC_WFI]	= kvm_handle_wfx,
> >>  	[ESR_EL2_EC_CP15_32]	= kvm_handle_cp15_32,
> >> @@ -105,6 +124,7 @@ static exit_handle_fn arm_exit_handlers[] = {
> >>  	[ESR_EL2_EC_SYS64]	= kvm_handle_sys_reg,
> >>  	[ESR_EL2_EC_IABT]	= kvm_handle_guest_abort,
> >>  	[ESR_EL2_EC_DABT]	= kvm_handle_guest_abort,
> >> +	[ESR_EL2_EC_SOFTSTP]    = kvm_handle_ss,
> >>  	[ESR_EL2_EC_BKPT32]	= kvm_handle_bkpt,
> >>  	[ESR_EL2_EC_BRK64]	= kvm_handle_bkpt,
> >>  };
> >> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> index 3c733ea..c0bc218 100644
> >> --- a/arch/arm64/kvm/hyp.S
> >> +++ b/arch/arm64/kvm/hyp.S
> >> @@ -16,6 +16,7 @@
> >>   */
> >>  
> >>  #include <linux/linkage.h>
> >> +#include <linux/kvm.h>
> >>  
> >>  #include <asm/assembler.h>
> >>  #include <asm/memory.h>
> >> @@ -168,6 +169,31 @@
> >>  	// x19-x29, lr, sp*, elr*, spsr*
> >>  	restore_common_regs
> >>  
> >> +	// After restoring the guest registers but before we return to the guest
> >> +	// we may want to make some final tweaks to support guest debugging.
> >
> > "we may want" sounds like we're not sure what we'll be doing here.  We
> > probably want to write something like "If the guest is being debugged we
> > need to set blah blah blah".
> >
> >> +	ldr	x3, [x0, #GUEST_DEBUG]
> >> +	tbz	x3, #KVM_GUESTDBG_ENABLE_SHIFT, 2f	// No guest debug
> >> +
> >> +	// x0 - preserved as VCPU ptr
> >> +	// x1 - spsr
> >> +	// x2 - mdscr
> >
> > not sure we need this comment
> >
> >> +	mrs	x1, spsr_el2
> >> +	mrs 	x2, mdscr_el1
> >> +
> >> +	// See ARM ARM D2.12.3 The software step state machine
> >> +	// If we are doing Single Step - set MDSCR_EL1.SS and PSTATE.SS
> >> +	orr	x1, x1, #DBG_SPSR_SS
> >> +	orr	x2, x2, #DBG_MDSCR_SS
> >> +	tbnz	x3, #KVM_GUESTDBG_SINGLESTEP_SHIFT, 1f
> >> +	// If we are not doing Single Step we want to prevent the guest doing so
> >> +	// as otherwise we will have to deal with the re-routed exceptions as we
> >> +	// are doing other guest debug related things
> >> +	eor	x1, x1, #DBG_SPSR_SS
> >> +	eor	x2, x2, #DBG_MDSCR_SS
> >
> > this really confuses me: so you're setting the SS bits in both
> > registers, and then if we're not single-stepping the guest, you clear
> > both bits again?
> >
> > Wouldn't it be much simper to mask off the bits with a 'bic' and then
> > setting the bits when needed?
> 
> Is there a non-vector BIC #imm? I was being frugal with register usage
> at this point. The orr/eor steps where just to avoid having too many
> branch cases.
> 

there are "bic x3, x3, #1" and such in this very file, so I would guess,
yes.

> > Alternatively, we could manage all these registers from C code and just
> > save/restore them off the VCPU struct.
> 
> Yes but this has to be done as we run into the hyp.S code after all
> guest registers are confirmed as the changes are on-top of whatever the
> guest view is (for the _el1 regs).
> 
> Where would you suggest that goes?
> 

As a call-out from the arch-specific KVM_RUN ioctl, call
kvm_setup_guest_debug() or something like that, just like we do to check
if our vmid is valid and to setup the vgic state and so on.  Does that
work?

-Christoffer
