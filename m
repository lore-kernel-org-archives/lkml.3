Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaIBRsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:48:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41133 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbaIBRsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:48:04 -0400
Message-ID: <540602CE.8090503@gmail.com>
Date: Tue, 02 Sep 2014 20:47:58 +0300
From: Avi Kivity <avi.kivity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 2/4] KVM: nSVM: propagate the NPF EXITINFO to the guest
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-3-git-send-email-pbonzini@redhat.com> <20140902163344.GB16722@suse.de> <5405F44E.7090803@redhat.com>
In-Reply-To: <5405F44E.7090803@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/02/2014 07:46 PM, Paolo Bonzini wrote:
> */
>>>   		if (unlikely(real_gfn == UNMAPPED_GVA))
>>>   			goto error;
>>> @@ -1974,10 +1974,28 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>>>   {
>>>   	struct vcpu_svm *svm = to_svm(vcpu);
>>>   
>>> -	svm->vmcb->control.exit_code = SVM_EXIT_NPF;
>>> -	svm->vmcb->control.exit_code_hi = 0;
>>> -	svm->vmcb->control.exit_info_1 = fault->error_code;
>>> -	svm->vmcb->control.exit_info_2 = fault->address;
>>> +	/*
>>> +	 * We can keep the value that the processor stored in the VMCB,
>>> +	 * but make up something sensible if we hit the WARN.
>>> +	 */
>>> +	if (WARN_ON(svm->vmcb->control.exit_code != SVM_EXIT_NPF)) {
>>> +		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
>>> +		svm->vmcb->control.exit_code_hi = 0;
>>> +		svm->vmcb->control.exit_info_1 = (1ULL << 32);
>>> +		svm->vmcb->control.exit_info_2 = fault->address;
>>> +	}
>> Its been a while since I looked into this, but is an injected NPF exit
>> always the result of a real NPF exit?
> I think so, but that's why I CCed you. :)

It could always be the result of emulation into which L0 was tricked.  I 
don't think it's a safe assumption.

>> How about an io-port emulated on
>> L1 but passed through to L2 by the nested hypervisor. On emulation of
>> INS or OUTS, KVM would need to read/write to an L2 address space,
> It would need to read/write to *L1* (that's where the VMCB's IOIO map
> lies), which could result into a regular page fault injected into L1.
>
> Paolo
>
>> maybe
>> causing NPF faults to be injected. In this case an IOIO exit would cause
>> an injected NPF exit for L1.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

