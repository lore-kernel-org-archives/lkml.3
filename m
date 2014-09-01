Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaIAAU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:20:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:59231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbaIAAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:20:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379557371"
Date: Mon, 1 Sep 2014 08:22:08 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: x86: #GP when attempts to write reserved
 bits of Variable Range MTRRs
Message-ID: <20140901002208.GA11180@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408439080-57721-1-git-send-email-wanpeng.li@linux.intel.com>
 <1408439080-57721-3-git-send-email-wanpeng.li@linux.intel.com>
 <5400AEBA.2080405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5400AEBA.2080405@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 06:47:54PM +0200, Paolo Bonzini wrote:
>Il 19/08/2014 11:04, Wanpeng Li ha scritto:
>> Section 11.11.2.3 of the SDM mentions "All other bits in the IA32_MTRR_PHYSBASEn 
>> and IA32_MTRR_PHYSMASKn registers are reserved; the processor generates a 
>> general-protection exception(#GP) if software attempts to write to them". This 
>> patch do it in kvm.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>
>This breaks if the guest maxphyaddr is higher than the host's (which 
>sometimes happens depending on your hardware and how QEMU is 
>configured).
>
>You need to use cpuid_maxphyaddr, like this
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index a375dfc42f6a..916e89515210 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1726,7 +1726,7 @@ static bool valid_mtrr_type(unsigned t)
> static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> {
> 	int i;
>-	u64 mask = 0;
>+	u64 mask;
> 
> 	if (!msr_mtrr_valid(msr))
> 		return false;
>@@ -1750,8 +1750,7 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> 	/* variable MTRRs */
> 	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
> 
>-	for (i = 63; i > boot_cpu_data.x86_phys_bits; i--)
>-		mask |= (1ULL << i);
>+	mask = (~0ULL) << cpuid_maxphyaddr(vcpu);
> 	if ((msr & 1) == 0) {
> 		/* MTRR base */
> 		if (!valid_mtrr_type(data & 0xff))
>
>

Got it, thanks Paolo and Jan. 

Regards,
Wanpeng Li 

>Jan, can you see if this patch fixes the SeaBIOS triple fault you reported?
>
>Paolo
>
>> ---
>>  arch/x86/kvm/x86.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fb3ea7a..b85da5f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1726,6 +1726,7 @@ static bool valid_mtrr_type(unsigned t)
>>  static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>>  {
>>  	int i;
>> +	u64 mask = 0;
>>  
>>  	if (!msr_mtrr_valid(msr))
>>  		return false;
>> @@ -1749,10 +1750,21 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>>  	/* variable MTRRs */
>>  	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
>>  
>> -	if ((msr & 1) == 0)
>> +	for (i = 63; i > boot_cpu_data.x86_phys_bits; i--)
>> +		mask |= (1ULL << i);
>> +	if ((msr & 1) == 0) {
>>  		/* MTRR base */
>> -		return valid_mtrr_type(data & 0xff);
>> -	/* MTRR mask */
>> +		if (!valid_mtrr_type(data & 0xff))
>> +			return false;
>> +		 mask |= 0xf00;
>> +	} else
>> +		/* MTRR mask */
>> +		mask |= 0x7ff;
>> +	if (data & mask) {
>> +		kvm_inject_gp(vcpu, 0);
>> +		return false;
>> +	}
>> +
>>  	return true;
>>  }
>>  
>> 
