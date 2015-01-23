Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbbAWBgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:36:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbbAWBgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:36:40 -0500
Message-ID: <54C1A596.2000600@redhat.com>
Date: Thu, 22 Jan 2015 19:36:22 -0600
From: Wei Huang <wei@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Christoffer Dall <cdall@cs.columbia.edu>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64 tree
References: <20150122160704.5ad5aeb9@canb.auug.org.au> <87r3unfb9x.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87r3unfb9x.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 02:51 AM, Marc Zyngier wrote:
> On Thu, Jan 22 2015 at  5:07:04 am GMT, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> Hi Stephen,
> 
>> Today's linux-next merge of the kvm-arm tree got a conflict in
>> arch/arm64/include/asm/kvm_arm.h between commit 6e53031ed840 ("arm64:
>> kvm: remove ESR_EL2_* macros") from the arm64 tree and commit
>> 0d97f8848104 ("arm/arm64: KVM: add tracing support for arm64 exit
>> handler") from the kvm-arm tree.
>>
>> I fixed it up (see below, but this probably requires more work) and can
>> carry the fix as necessary (no action is required).
> 
> Thanks for dealing with this. I think the following patch should be
> applied on top of your resolution, making the new macro part of the
> asm/esr.h file.
> 
> Mark, Wei: does it match your expectations?
Looks good to me. Thanks for handling this issue.

-Wei

> 
> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 6216709..92bbae3 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -96,6 +96,7 @@
>  #define ESR_ELx_COND_SHIFT	(20)
>  #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
> +#define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
>  
>  #ifndef __ASSEMBLY__
>  #include <asm/types.h>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 53fbc1e..94674eb 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -192,6 +192,4 @@
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  
> -#define ESR_EL2_HVC_IMM_MASK	((1UL << 16) - 1)
> -
>  #endif /* __ARM64_KVM_ARM_H__ */
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index b861ff6..bbc17cd 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -133,7 +133,7 @@ static inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
>  
>  static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
>  {
> -	return kvm_vcpu_get_hsr(vcpu) & ESR_EL2_HVC_IMM_MASK;
> +	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_xVC_IMM_MASK;
>  }
>  
>  static inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
> 
