Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaGaOfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:35:40 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38288 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGaOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:35:38 -0400
Date: Thu, 31 Jul 2014 16:35:38 +0200
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
Message-ID: <20140731143538.GI11610@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:55:12PM +0100, Alex Bennée wrote:
> To cleanly restore an SMP VM we need to ensure that the current pause
> state of each vcpu is correctly recorded. Things could get confused if
> the CPU starts running after migration restore completes when it was
> paused before it state was captured.
> 
> I've done this by exposing a register (currently only 1 bit used) via
> the GET/SET_ONE_REG logic to pass the state between KVM and the VM
> controller (e.g. QEMU).
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arch/arm64/include/uapi/asm/kvm.h |  8 +++++
>  arch/arm64/kvm/guest.c            | 61 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index eaf54a3..8990e6e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -148,6 +148,14 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
>  #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
>  
> +/* Power state (PSCI), not real registers */
> +#define KVM_REG_ARM_PSCI		(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM_PSCI_REG(n) \
> +	(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_PSCI | \
> +         (n & ~KVM_REG_ARM_COPROC_MASK))

I don't understand this mask, why isn't this
            (n & 0xffff))

> +#define KVM_REG_ARM_PSCI_STATE          KVM_REG_ARM_PSCI_REG(0)
> +#define NUM_KVM_PSCI_REGS               1
> +

you're missing updates to Documentation/virtual/kvm/api.txt here.

>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 205f0d8..31d6439 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -189,6 +189,54 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  }
>  
>  /**
> + * PSCI State
> + *
> + * These are not real registers as they do not actually exist in the
> + * hardware but represent the current power state of the vCPU

full stop

> + */
> +
> +static bool is_psci_reg(u64 index)
> +{
> +	switch (index) {
> +	case KVM_REG_ARM_PSCI_STATE:
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static int copy_psci_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	if (put_user(KVM_REG_ARM_PSCI_STATE, uindices))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int set_psci_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	void __user *uaddr = (void __user *)(long)reg->addr;
> +	u64 val;
> +	int ret;
> +
> +	ret = copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id));
> +	if (ret != 0)
> +		return ret;
> +
> +        vcpu->arch.pause = (val & 0x1) ? false : true;

tabs

I really need the documentation of the ABI, why is bit[0] == 1 not paused?

If we are not complaining when setting the pause value to false if it
was true before, then we probably also need to wake up the thread in
case this is called from another thread, right?

or perhaps we should just return an error if you're trying to un-pause a
CPU through this interface, hmmmm.

> +	return 0;
> +}
> +
> +static int get_psci_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	void __user *uaddr = (void __user *)(long)reg->addr;
> +	u64 val;
> +
> +        /* currently we only use one bit */

tabs

useless comment, just include docs.

> +	val = vcpu->arch.pause ? 0 : 1;
> +	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id));
> +}
> +
> +
> +/**
>   * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
>   *
>   * This is for all registers.
> @@ -196,7 +244,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  {
>  	return num_core_regs() + kvm_arm_num_sys_reg_descs(vcpu)
> -                + NUM_TIMER_REGS;
> +                + NUM_TIMER_REGS + NUM_KVM_PSCI_REGS;
>  }
>  
>  /**
> @@ -221,6 +269,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  		return ret;
>  	uindices += NUM_TIMER_REGS;
>  
> +        ret = copy_psci_indices(vcpu, uindices);

indentation, please use tabs.

> +	if (ret)
> +		return ret;
> +	uindices += NUM_KVM_PSCI_REGS;
> +
>  	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
>  }
>  
> @@ -237,6 +290,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (is_timer_reg(reg->id))
>  		return get_timer_reg(vcpu, reg);
>  
> +        if (is_psci_reg(reg->id))
> +		return get_psci_reg(vcpu, reg);
> +
>  	return kvm_arm_sys_reg_get_reg(vcpu, reg);
>  }
>  
> @@ -253,6 +309,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (is_timer_reg(reg->id))
>  		return set_timer_reg(vcpu, reg);
>  
> +        if (is_psci_reg(reg->id))
> +		return set_psci_reg(vcpu, reg);
> +
>  	return kvm_arm_sys_reg_set_reg(vcpu, reg);
>  }
>  
> -- 
> 2.0.1
> 

please check for use of tabs versus spaces, checkpatch.pl should
complain.

Can you add the 32-bit counterpart as part of this patch?

Thanks,
-Christoffer
