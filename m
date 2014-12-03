Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaLCIEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:04:37 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62821 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaLCIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:04:35 -0500
Message-ID: <547EC40E.5010506@redhat.com>
Date: Wed, 03 Dec 2014 09:04:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH] KVM: cpuid: mask more bits in leaf 0xd and subleaves
References: <1417525770-16485-1-git-send-email-pbonzini@redhat.com> <20141202230536.GA12980@potion.redhat.com>
In-Reply-To: <20141202230536.GA12980@potion.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/12/2014 00:05, Radim Krčmář wrote:
> 2014-12-02 14:09+0100, Paolo Bonzini:
>> - EAX=0Dh, ECX=1: output registers EBX/ECX/EDX are reserved.
> 
> (As good as reserved without XSAVES/IA32_XSS.)
> 
>> - EAX=0Dh, ECX>1: output register ECX is zero for all the CPUID leaves
>> we support, because variable "supported" comes from XCR0 and not XSS.
>> However, only bits above 0 are reserved.  Output register EDX is reserved.
> 
> (Yes.  Well, EDX is 0 when the sub-leaf is invalid.)
> 
>> Source: Intel Architecture Instruction Set Extensions Programming
>> Reference, ref. number 319433-022
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> --
>>  arch/x86/kvm/cpuid.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 0d919bc33b02..b1366743a728 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -470,10 +470,17 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>  				goto out;
>>  
>>  			do_cpuid_1_ent(&entry[i], function, idx);
>> -			if (idx == 1)
>> +			if (idx == 1) {
>>  				entry[i].eax &= kvm_supported_word10_x86_features;
>> -			else if (entry[i].eax == 0 || !(supported & mask))
>> -				continue;
>> +				entry[i].ebx = 0;
>> +				entry[i].ecx = 0;
>> +			} else {
>> +				if (entry[i].eax == 0 || !(supported & mask))
>> +					continue;
>> +				WARN_ON_ONCE(entry[i].ecx & 1);
>> +				entry[i].ecx &= 1;
> 
>  ECX  Bit 0 is set if the sub-leaf index, n, maps to a valid bit in the
>       IA32_XSS MSR and bit 0 is clear if n maps to a valid bit in XCR0.
> 
> ECX should be set to 0 instead, we definitely don't map to a valid bit
> in IA32_XSS now.

Well, there is a WARN just above. :)  But I can change it to zero instead.

> (Having only one part of cpuid ready for it is weird ...)
> 
>> +			}
>> +			entry[i].edx = 0;
>>  			entry[i].flags |=
>>  			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> 
> (Unrelated, I have yet to understand how this flag translates
>  * If ECX contains an invalid sub-leaf index, EAX/EBX/ECX/EDX return 0.)

If the index is invalid, entry[i].eax is zero and we do not return
anything at all.

Paolo

>>  			++*nent;
> 
> Forcing a change of the XSAVES implementation is a likely purpose of
> this patch and it is correct after changing the ecx handling, so then,
> 
> Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
> 
