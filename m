Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaIBQqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaIBQqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:46:18 -0400
Message-ID: <5405F44E.7090803@redhat.com>
Date: Tue, 02 Sep 2014 18:46:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joerg Roedel <jroedel@suse.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 2/4] KVM: nSVM: propagate the NPF EXITINFO to the guest
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-3-git-send-email-pbonzini@redhat.com> <20140902163344.GB16722@suse.de>
In-Reply-To: <20140902163344.GB16722@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:33, Joerg Roedel ha scritto:
> Ah, here you add emulation of these bits.
> 
> On Tue, Sep 02, 2014 at 05:13:48PM +0200, Paolo Bonzini wrote:
>> This is similar to what the EPT code does with the exit qualification.
>> This allows the guest to see a valid value for bits 33:32.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/paging_tmpl.h |  6 ++++++
>>  arch/x86/kvm/svm.c         | 26 ++++++++++++++++++++++----
>>  2 files changed, 28 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index 410776528265..99d4c4e836a0 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -322,8 +322,14 @@ retry_walk:
>>  
>>  		real_gfn = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
>>  					      PFERR_USER_MASK|PFERR_WRITE_MASK);
>> +
>> +		/*
>> +		 * Can this happen (except if the guest is playing TOCTTOU games)?
>> +		 * We should have gotten a nested page fault on table_gfn instead.
>> +		 */
> 
> Comment is true, but doesn't make the check below obsolete, no?

No, it doesn't.  I'll rewrite it as

	/*
	 * This cannot happen unless the guest is playing TOCTTOU games,
	 * because we would have gotten a nested page fault on table_gfn
	 * instead.  If this happens, the exit qualification / exit info
	 * field will incorrectly have "guest page access" as the
	 * nested page fault's cause, instead of "guest page structure
	 * access".
	 */

>>  		if (unlikely(real_gfn == UNMAPPED_GVA))
>>  			goto error;
>> @@ -1974,10 +1974,28 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  
>> -	svm->vmcb->control.exit_code = SVM_EXIT_NPF;
>> -	svm->vmcb->control.exit_code_hi = 0;
>> -	svm->vmcb->control.exit_info_1 = fault->error_code;
>> -	svm->vmcb->control.exit_info_2 = fault->address;
>> +	/*
>> +	 * We can keep the value that the processor stored in the VMCB,
>> +	 * but make up something sensible if we hit the WARN.
>> +	 */
>> +	if (WARN_ON(svm->vmcb->control.exit_code != SVM_EXIT_NPF)) {
>> +		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
>> +		svm->vmcb->control.exit_code_hi = 0;
>> +		svm->vmcb->control.exit_info_1 = (1ULL << 32);
>> +		svm->vmcb->control.exit_info_2 = fault->address;
>> +	}
> 
> Its been a while since I looked into this, but is an injected NPF exit
> always the result of a real NPF exit?

I think so, but that's why I CCed you. :)

> How about an io-port emulated on
> L1 but passed through to L2 by the nested hypervisor. On emulation of
> INS or OUTS, KVM would need to read/write to an L2 address space,

It would need to read/write to *L1* (that's where the VMCB's IOIO map
lies), which could result into a regular page fault injected into L1.

Paolo

> maybe
> causing NPF faults to be injected. In this case an IOIO exit would cause
> an injected NPF exit for L1.

