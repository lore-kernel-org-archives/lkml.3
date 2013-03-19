Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3CSQlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:41:52 -0400
Received: from goliath.siemens.de ([192.35.17.28]:29676 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3CSQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:41:51 -0400
Message-ID: <51489549.10308@siemens.com>
Date: Tue, 19 Mar 2013 17:41:45 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: correctly initialize the CS base on reset
References: <1363707026-19351-1-git-send-email-pbonzini@redhat.com> <20130319154319.GF19292@redhat.com>
In-Reply-To: <20130319154319.GF19292@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-19 16:43, Gleb Natapov wrote:
> On Tue, Mar 19, 2013 at 04:30:26PM +0100, Paolo Bonzini wrote:
>> The CS base was initialized to 0 on VMX (wrong, but usually overridden
>> by userspace before starting) or 0xf0000 on SVM.  The correct value is
>> 0xffff0000, and VMX is able to emulate it now, so use it.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Gleb Natapov <gleb@redhat.com>

Just for the history (as I was wondering where this came from): CS base
used to be set to 0xf0000 on VMX as well, but that was changed by
b246dd5d to only affect guests when unrestricted mode is missing. That
change actually left the base uninitialized.

Jan

> 
>> ---
>>  arch/x86/kvm/svm.c | 8 +-------
>>  arch/x86/kvm/vmx.c | 1 +
>>  2 files changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 7219a40..7a46c1f 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1131,17 +1131,11 @@ static void init_vmcb(struct vcpu_svm *svm)
>>  	init_seg(&save->gs);
>>  
>>  	save->cs.selector = 0xf000;
>> +	save->cs.base = 0xffff0000;
>>  	/* Executable/Readable Code Segment */
>>  	save->cs.attrib = SVM_SELECTOR_READ_MASK | SVM_SELECTOR_P_MASK |
>>  		SVM_SELECTOR_S_MASK | SVM_SELECTOR_CODE_MASK;
>>  	save->cs.limit = 0xffff;
>> -	/*
>> -	 * cs.base should really be 0xffff0000, but vmx can't handle that, so
>> -	 * be consistent with it.
>> -	 *
>> -	 * Replace when we have real mode working for vmx.
>> -	 */
>> -	save->cs.base = 0xf0000;
>>  
>>  	save->gdtr.limit = 0xffff;
>>  	save->idtr.limit = 0xffff;
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 4a0bafe..c75c25d 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -4133,6 +4133,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>>  
>>  	seg_setup(VCPU_SREG_CS);
>>  	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
>> +	vmcs_write32(GUEST_CS_BASE, 0xffff0000);
>>  
>>  	seg_setup(VCPU_SREG_DS);
>>  	seg_setup(VCPU_SREG_ES);
>> -- 
>> 1.8.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> 			Gleb.
> 
-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux

