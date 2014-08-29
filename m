Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaH2Qwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:52:46 -0400
Received: from goliath.siemens.de ([192.35.17.28]:49308 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaH2Qwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:52:45 -0400
Message-ID: <5400AFBF.90408@siemens.com>
Date: Fri, 29 Aug 2014 18:52:15 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86: #GP when attempts to write reserved
 bits of Variable Range MTRRs
References: <1408439080-57721-1-git-send-email-wanpeng.li@linux.intel.com> <1408439080-57721-3-git-send-email-wanpeng.li@linux.intel.com> <5400AEBA.2080405@redhat.com>
In-Reply-To: <5400AEBA.2080405@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-29 18:47, Paolo Bonzini wrote:
> Il 19/08/2014 11:04, Wanpeng Li ha scritto:
>> Section 11.11.2.3 of the SDM mentions "All other bits in the IA32_MTRR_PHYSBASEn 
>> and IA32_MTRR_PHYSMASKn registers are reserved; the processor generates a 
>> general-protection exception(#GP) if software attempts to write to them". This 
>> patch do it in kvm.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> This breaks if the guest maxphyaddr is higher than the host's (which 
> sometimes happens depending on your hardware and how QEMU is 
> configured).
> 
> You need to use cpuid_maxphyaddr, like this
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a375dfc42f6a..916e89515210 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1726,7 +1726,7 @@ static bool valid_mtrr_type(unsigned t)
>  static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
>  	int i;
> -	u64 mask = 0;
> +	u64 mask;
>  
>  	if (!msr_mtrr_valid(msr))
>  		return false;
> @@ -1750,8 +1750,7 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  	/* variable MTRRs */
>  	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
>  
> -	for (i = 63; i > boot_cpu_data.x86_phys_bits; i--)
> -		mask |= (1ULL << i);
> +	mask = (~0ULL) << cpuid_maxphyaddr(vcpu);
>  	if ((msr & 1) == 0) {
>  		/* MTRR base */
>  		if (!valid_mtrr_type(data & 0xff))
> 
> 
> Jan, can you see if this patch fixes the SeaBIOS triple fault you reported?

Yep, it does.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
