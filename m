Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaLCBLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:11:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:41947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaLCBLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:11:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,504,1413270000"; 
   d="scan'208";a="617645155"
Date: Wed, 3 Dec 2014 08:50:59 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kvm: x86: revert mask out xsaves
Message-ID: <20141203005059.GA5084@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1417500894-7604-1-git-send-email-wanpeng.li@linux.intel.com>
 <547D7E6D.6090000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D7E6D.6090000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:55:09AM +0100, Paolo Bonzini wrote:
>
>
>On 02/12/2014 07:14, Wanpeng Li wrote:
>> xsaves will be exported to guest in the next patch, so revert the
>> mask out xsaves patch.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  arch/x86/kvm/cpuid.c | 10 +---------
>>  1 file changed, 1 insertion(+), 9 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index a4f5ac4..7af07571 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -320,10 +320,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>  		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
>>  		F(AVX512CD);
>>  
>> -	/* cpuid 0xD.1.eax */
>> -	const u32 kvm_supported_word10_x86_features =
>> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
>
>Every single bit needs to be whitelisted independently of the others, so
>a full revert is not possible.  We need to be careful about post-Skylake
>processors introducing new bits in this cpuid leaf.
>
>Also, you cannot just add F(XSAVES) here; you must only do it if XSAVES
>is actually supported.  This makes sure that nested virtualization will
>_not_ present XSAVES to the guests until specific support is introduced
>for XSAVES and XRSTORS exits (including the XSS exit bitmap).

I will try to enable nested xsaves.

Regards,
Wanpeng Li 

>
>In order to do this, you have to introduce a new member in kvm_x86_ops,
>modeling what was done for MPX.  The second patch can then implement
>this new member.
>
>Thanks,
>
>Paolo
>
>>  	/* all calls to cpuid_count() should be made on the same cpu */
>>  	get_cpu();
>>  
>> @@ -460,8 +456,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>  		entry->eax &= supported;
>>  		entry->edx &= supported >> 32;
>>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> -		if (!supported)
>> -			break;
>>  
>>  		for (idx = 1, i = 1; idx < 64; ++idx) {
>>  			u64 mask = ((u64)1 << idx);
>> @@ -469,9 +463,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>  				goto out;
>>  
>>  			do_cpuid_1_ent(&entry[i], function, idx);
>> -			if (idx == 1)
>> -				entry[i].eax &= kvm_supported_word10_x86_features;
>> -			else if (entry[i].eax == 0 || !(supported & mask))
>> +			if (entry[i].eax == 0 || !(supported & mask))
>>  				continue;
>>  			entry[i].flags |=
>>  			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> 
