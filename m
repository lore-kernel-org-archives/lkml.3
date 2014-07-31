Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaGaQiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:38:10 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:63065 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaGaQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:38:08 -0400
Date: Thu, 31 Jul 2014 18:38:05 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
Message-ID: <20140731163805.GK11610@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <20140731143538.GI11610@cbox>
 <87mwbpimgz.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mwbpimgz.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 04:14:51PM +0100, Alex Bennée wrote:
> 
> Christoffer Dall writes:
> 
> > On Wed, Jul 09, 2014 at 02:55:12PM +0100, Alex Bennée wrote:
> >> To cleanly restore an SMP VM we need to ensure that the current pause
> >> state of each vcpu is correctly recorded. Things could get confused if
> >> the CPU starts running after migration restore completes when it was
> >> paused before it state was captured.
> >> 
> <snip>
> >> +/* Power state (PSCI), not real registers */
> >> +#define KVM_REG_ARM_PSCI		(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> >> +#define KVM_REG_ARM_PSCI_REG(n) \
> >> +	(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_PSCI | \
> >> +         (n & ~KVM_REG_ARM_COPROC_MASK))
> >
> > I don't understand this mask, why isn't this
> >             (n & 0xffff))
> 
> I was trying to use the existing masks, but of course if anyone changes
> that it would be an ABI change so probably not worth it.
> 

the KVM_REG_ARM_COPROC_MASK is part of the uapi IIRC, so that's not the
issue, but that mask doesn't cover all the upper bits, so it feels weird
to use that to me.

> >
> >> +#define KVM_REG_ARM_PSCI_STATE          KVM_REG_ARM_PSCI_REG(0)
> >> +#define NUM_KVM_PSCI_REGS               1
> >> +
> >
> > you're missing updates to Documentation/virtual/kvm/api.txt here.
> 
> Will add.
> 
> >>  /* Device Control API: ARM VGIC */
> >>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> >>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> >> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> index 205f0d8..31d6439 100644
> >> --- a/arch/arm64/kvm/guest.c
> >> +++ b/arch/arm64/kvm/guest.c
> >> @@ -189,6 +189,54 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >>  }
> >>  
> >>  /**
> >> + * PSCI State
> >> + *
> >> + * These are not real registers as they do not actually exist in the
> >> + * hardware but represent the current power state of the vCPU
> >
> > full stop
> >
> >> + */
> >> +
> >> +static bool is_psci_reg(u64 index)
> >> +{
> >> +	switch (index) {
> >> +	case KVM_REG_ARM_PSCI_STATE:
> >> +		return true;
> >> +	}
> >> +	return false;
> >> +}
> >> +
> >> +static int copy_psci_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >> +{
> >> +	if (put_user(KVM_REG_ARM_PSCI_STATE, uindices))
> >> +		return -EFAULT;
> >> +	return 0;
> >> +}
> >> +
> >> +static int set_psci_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >> +{
> >> +	void __user *uaddr = (void __user *)(long)reg->addr;
> >> +	u64 val;
> >> +	int ret;
> >> +
> >> +	ret = copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id));
> >> +	if (ret != 0)
> >> +		return ret;
> >> +
> >> +        vcpu->arch.pause = (val & 0x1) ? false : true;
> >
> > tabs
> 
> Hmmm, apparently the GNU Emacs "linux" style doesn't actually enforce
> that. Who knew? I'll beat the editor into submission.
> 
> > I really need the documentation of the ABI, why is bit[0] == 1 not
> > paused?
> 
> I figured 1 == running, but I can switch it round if you want to to map
> directly to the .pause flag.
> 

don't care very deeply, just want something to describe it clearly.

> > If we are not complaining when setting the pause value to false if it
> > was true before, then we probably also need to wake up the thread in
> > case this is called from another thread, right?
> >
> > or perhaps we should just return an error if you're trying to un-pause a
> > CPU through this interface, hmmmm.
> 
> Wouldn't it be an error to mess with any register when the system is not
> in a quiescent state? I was assuming that the wake state is dealt with
> when the run loop finally restarts. 
> 

The ABI doesn't really define it as an error (the ABI doesn't enforce
anything right now) so the question is, does it ever make sense to clear
the pause flag through this ioctl?  If not, I think we should just err
on the side of caution and specify in the docs that this is not
supported and return an error.


> <snip>
> >
> > please check for use of tabs versus spaces, checkpatch.pl should
> > complain.
> >
> > Can you add the 32-bit counterpart as part of this patch?
> 
> Same patch? Sure.

really up to you if you want to split it up into two patches, but I
think it's small enough that you can just create one patch.

Thanks,
-Christoffer
