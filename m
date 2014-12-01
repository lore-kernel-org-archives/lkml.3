Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaLALdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:33:33 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:59179
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaLALdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:33:31 -0500
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-5-git-send-email-alex.bennee@linaro.org> <20141129162115.GF23653@cbox>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de,
        pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] KVM: arm64: guest debug, add SW break point support
In-reply-to: <20141129162115.GF23653@cbox>
Date: Mon, 01 Dec 2014 11:33:30 +0000
Message-ID: <87sigz1u5x.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Tue, Nov 25, 2014 at 04:10:02PM +0000, Alex Bennée wrote:
>> This adds support for SW breakpoints inserted by userspace.
>> 
>> First we need to trap all BKPT exceptions in the hypervisor (ELS). This
>> in controlled through the MDCR_EL2 register. I've added a new field to
>
> this is ?
>
>> the vcpu structure to hold this value. There should be scope to
>> rationlise this with the VCPU_DEBUG_FLAGS/KVM_ARM64_DEBUG_DIRTY_SHIFT
>> manipulation in later patches.
>
> I don't understand what you mean with rationalising something in later
> patches.

I was pointing to potential future improvements. I'm wary of touching
the lazy register syncing code in this patch set as it greatly increases
the scope of testing. However I guess I'll have to bite the bullet and
merge it in a sensible way.

>
>> 
>> Once the exception arrives we triggers an exit from the main hypervisor
>> loop to the hypervisor controller. The kvm_debug_exit_arch carries the
>
> hypervisor controller is userspace?

Yeah sorry that one sneaked through.

>
>> address of the exception. If the controller doesn't know of breakpoint
>
> the breakint ?
>
>> then we have a guest inserted breakpoint and the hypervisor needs to
>> start again and deliver the exception to guest.
>
> to the guest
>
>> 
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> 
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 2c6386e..9383359 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2592,7 +2592,7 @@ when running. Common control bits are:
>>  The top 16 bits of the control field are architecture specific control
>>  flags which can include the following:
>>  
>> -  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86]
>> +  - KVM_GUESTDBG_USE_SW_BP:     using software breakpoints [x86, arm64]
>>    - KVM_GUESTDBG_USE_HW_BP:     using hardware breakpoints [x86, s390]
>>    - KVM_GUESTDBG_INJECT_DB:     inject DB type exception [x86]
>>    - KVM_GUESTDBG_INJECT_BP:     inject BP type exception [x86]
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index a0ff410..48d26bb 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -303,6 +303,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>  					struct kvm_guest_debug *dbg)
>>  {
>> +	/* Route debug traps to el2? */
>> +	bool route_el2 = false;
>> +
>>  	/* If it's not enabled clear all flags */
>>  	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
>>  		vcpu->guest_debug = 0;
>> @@ -320,8 +323,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>  
>>  	/* Software Break Points */
>>  	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
>> -		kvm_info("SW BP support requested, not yet implemented\n");
>> -		return -EINVAL;
>> +		kvm_info("SW BP support requested\n");
>> +		route_el2 = true;
>>  	}
>>  
>>  	/* Hardware assisted Break and Watch points */
>> @@ -330,6 +333,20 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>  		return -EINVAL;
>>  	}
>>  
>> +	/* If we are going to handle any debug exceptions we need to
>
> wings on the comments
>
>> +	 * set MDCE_EL2.TDE to ensure they are routed to the
>> +	 * hypervisor. If userspace determines the exception was
>> +	 * actually internal to the guest it needs to handle
>> +	 * re-injecting the exception.
>> +	 */
>> +	if (route_el2) {
>> +		kvm_info("routing debug exceptions");
>> +		vcpu->arch.mdcr_el2 = MDCR_EL2_TDE;
>> +	} else {
>> +		kvm_info("not routing debug exceptions");
>> +		vcpu->arch.mdcr_el2 = 0;
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2012c4b..38b0f07 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -98,6 +98,7 @@ struct kvm_vcpu_arch {
>>  
>>  	/* HYP configuration */
>>  	u64 hcr_el2;
>> +	u32 mdcr_el2;
>>  
>>  	/* Exception Information */
>>  	struct kvm_vcpu_fault_info fault;
>> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
>> index 9a9fce0..8da1043 100644
>> --- a/arch/arm64/kernel/asm-offsets.c
>> +++ b/arch/arm64/kernel/asm-offsets.c
>> @@ -122,6 +122,7 @@ int main(void)
>>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2));
>>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
>>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>> +  DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 34b8bd0..28dc92b 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -71,6 +71,26 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  	return 1;
>>  }
>>  
>> +/**
>> + * kvm_handle_bkpt - handle a break-point instruction
>> + *
>> + * @vcpu:	the vcpu pointer
>> + *
>> + * By definition if we arrive here it's because we are routing
>> + * all SW breakpoints to the hyper-visor as some may be a result of
>
> s/hyper-visor/hypervisor/
>
> this sentence is weird. I think what you want is a full stop after
> hypervisor and then a new sentence: Userspace may decide that this
> particular breakpoint should be routed to the guest (if the breakpoint
> does not come form userspace but by someone debugging a process inside
> the guest), and in that case inject a software breakpoint instruction by
> <insert the method here>.
>
>
>
>> + * guest debugging. If user-space decides this particular break-point
>> + * isn't for the host to handle it can re-feed the exception to the
>> + * guest.
>> + */
>> +static int kvm_handle_bkpt(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +	run->exit_reason = KVM_EXIT_DEBUG;
>> +	run->debug.arch.exit_type = KVM_DEBUG_EXIT_SW_BKPT;
>> +	run->debug.arch.address = *vcpu_pc(vcpu);
>> +	kvm_info("exiting from %llx\n", run->debug.arch.address);
>> +	return 0;
>> +}
>> +
>>  static exit_handle_fn arm_exit_handlers[] = {
>>  	[ESR_EL2_EC_WFI]	= kvm_handle_wfx,
>>  	[ESR_EL2_EC_CP15_32]	= kvm_handle_cp15_32,
>> @@ -85,6 +105,8 @@ static exit_handle_fn arm_exit_handlers[] = {
>>  	[ESR_EL2_EC_SYS64]	= kvm_handle_sys_reg,
>>  	[ESR_EL2_EC_IABT]	= kvm_handle_guest_abort,
>>  	[ESR_EL2_EC_DABT]	= kvm_handle_guest_abort,
>> +	[ESR_EL2_EC_BKPT32]	= kvm_handle_bkpt,
>> +	[ESR_EL2_EC_BRK64]	= kvm_handle_bkpt,
>>  };
>>  
>>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index b72aa9f..3c733ea 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -772,6 +772,10 @@
>>  	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
>>  	orr	x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
>>  
>> +	// Any other bits (currently TDE)
>> +	ldr	x3, [x0, #VCPU_MDCR_EL2]
>> +	orr	x2, x2, x3
>> +
>>  	// Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
>>  	// if not dirty.
>>  	ldr	x3, [x0, #VCPU_DEBUG_FLAGS]
>> -- 
>> 2.1.3
>> 
>
> It may be simpler to just load/restore the MDCR_EL2 and do all
> bit-manipulations for a specific VCPU in C-code instead of this.
>
> -Christoffer

-- 
Alex Bennée
