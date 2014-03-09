Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaCIS2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 14:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaCIS2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:28:34 -0400
Date: Sun, 9 Mar 2014 19:28:25 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 3/7] KVM: x86: Allow the guest to run with dirty debug
 registers
Message-ID: <20140309182825.GA11078@potion.redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
 <1394192571-11056-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394192571-11056-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-07 12:42+0100, Paolo Bonzini:
> When not running in guest-debug mode, the guest controls the debug
> registers and having to take an exit for each DR access is a waste
> of time.  If the guest gets into a state where each context switch
> causes DR to be saved and restored, this can take away as much as 40%
> of the execution time from the guest.
> 
> After this patch, VMX- and SVM-specific code can set a flag in
> switch_db_regs, telling vcpu_enter_guest that on the next exit the debug
> registers might be dirty and need to be reloaded (syncing will be taken
> care of by a new callback in kvm_x86_ops).  This flag can be set on the
> first access to a debug registers, so that multiple accesses to the
> debug registers only cause one vmexit.
> 
> Note that since the guest will be able to read debug registers and
> enable breakpoints in DR7, we need to ensure that they are synchronized
> on entry to the guest---including DR6 that was not synced before.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5ef59d3b6c63..74eb361eaa8f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -339,6 +339,7 @@ struct kvm_pmu {
>  
>  enum {
>  	KVM_DEBUGREG_BP_ENABLED = 1,
> +	KVM_DEBUGREG_WONT_EXIT = 2,
>  };
>  
>  struct kvm_vcpu_arch {
> @@ -707,6 +708,7 @@ struct kvm_x86_ops {
>  	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>  	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
>  	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
> +	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
>  	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
>  	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 252b47e85c69..c48818aa04c0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6033,12 +6033,28 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(vcpu->arch.eff_db[1], 1);
>  		set_debugreg(vcpu->arch.eff_db[2], 2);
>  		set_debugreg(vcpu->arch.eff_db[3], 3);
> +		set_debugreg(vcpu->arch.dr6, 6);
>  	}
>  
>  	trace_kvm_entry(vcpu->vcpu_id);
>  	kvm_x86_ops->run(vcpu);
>  
>  	/*
> +	 * Do this here before restoring debug registers on the host.  And
> +	 * since we do this before handling the vmexit, a DR access vmexit
> +	 * can (a) read the correct value of the debug registers, (b) set
> +	 * KVM_DEBUGREG_WONT_EXIT again.

We re-enable intercepts on the next exit for the sake of simplicity?
(Batched accesses make perfect sense, but it seems we don't have to care
 about DRs at all, without guest-debug.)

> +	 */
> +	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
> +		int i;
> +
> +		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);

Is this possible? (I presumed that we vmexit before handling ioctls.)

> +		kvm_x86_ops->sync_dirty_debug_regs(vcpu);

Sneaky functionality ... it would be nicer to split 'enable DR
intercepts' into a new kvm op.
I think we want to disable them whenever we are not in guest-debug mode
anyway, so it would be a pair.
And we don't have to modify DR intercepts then, which is probably the
main reason why sync_dirty_debug_regs() does two things.

> +		for (i = 0; i < KVM_NR_DB_REGS; i++)
> +			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
> +	}
> +
> +	/*
>  	 * If the guest has used debug registers, at least dr7
>  	 * will be disabled while returning to the host.
>  	 * If we don't have active breakpoints in the host, we don't
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
