Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaISNgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:36:13 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35509 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaISNgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:36:06 -0400
Message-ID: <541C313C.8060402@linux.vnet.ibm.com>
Date: Fri, 19 Sep 2014 21:35:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: Liang Chen <liangchen.linux@gmail.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: x86: directly use kvm_make_request again
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com> <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com> <541BC949.4050602@linux.vnet.ibm.com> <20140919122502.GA29990@potion.brq.redhat.com>
In-Reply-To: <20140919122502.GA29990@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091913-0005-0000-0000-000001164C00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 08:25 PM, Radim Krčmář wrote:

>>>   * Returns 1 to let __vcpu_run() continue the guest execution loop without
>>>   * exiting to the userspace.  Otherwise, the value will be returned to the
>>> @@ -6018,8 +6024,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>>  		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
>>>  			kvm_mmu_sync_roots(vcpu);
>>>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
>>> -			++vcpu->stat.tlb_flush;
>>> -			kvm_x86_ops->tlb_flush(vcpu);
>>> +			kvm_vcpu_flush_tlb(vcpu);
>>
>> NACK!
>>
>> Do not understand why you have to introduce a meaningful name
>> here - it's used just inner a function, which can not help to
>> improve a readability of the code at all.
> 
> I prefer the new hunk
>  - it makes the parent function simpler (not everyone wants to read how
>    we do tlb flushes when looking at vcpu_enter_guest)

Using one line instead of two lines does not simplify parent function much.

>  - the function is properly named

kvm_x86_ops->tlb_flush(vcpu) is also a good hit to tell the reader it is
doing tlb flush. :)

>  - we do a similar thing with kvm_gen_kvmclock_update

I understand this raw-bit-set style is largely used in current kvm code,
however, it does not mean it's a best way do it. It may be turned off
someday as it is be used in more and more places.

Anyway, the meaningful name wrapping raw-bit-set is a right direction
and let's keep this right direction.

> 
>> What i suggested is renaming kvm_mmu_flush_tlb() since it's a
>> API used in multiple files - a good name helps developer to
>> know what it's doing and definitely easier typing.
> 
> I think it is a good idea.
> The proposed name is definitely better than what we have now.
> 
> You can see reasons that led me to prefer raw request below.
> (Preferring something else is no way means that I'm against your idea.)

I understand that, Radim! :)

> 
> ---
> I'm always trying to reach some ideal code in my mind, which makes me
> seemingly oppose good proposals because I see how it could be even
> better ...  and I opt not to do them.
> (Pushing minor refactoring patches upstream is hard!)
> 
> My issues with kvm_mmu_flush_tlb:
> 
>  - 'kvm_flush_remote_tlbs()' calls tlb request directly;
>     our wrapper thus cannot be extended with features, which makes it a
>     poor abstraction

kvm_flush_remote_tlbs does not only set tlb request but also handles memory
order and syncs the tlb state.

I guess you wanted to say kvm_mmu_flush_tlb here, it is a API name and let
it be easily used in other files. It's not worth committing a patch doing
nothing except reverting the meaningful name.

>  - we don't do this for other requests

See above.

>  - direct request isn't absolutely horrible to read and write
>    (I totally agree that it is bad.)
>  - we call one function 'kvm_mmu_flush_tlb()' and the second one
>    'kvm_flush_remote_tlbs()' and I'd need to look why

Yeah, this is why i suggested to rename kvm_mmu_flush_tlb since which clarifies
things better:
- kvm_flush_remote_tlbs: flush tlb in all vcpus
- kvm_vcpu_flush_tlb: only flush tlb on the vcpu specified by @vcpu.

> 
> Which is why just removing it solves more problems for me :)

Thank you for raising this question and letting me know the patch's history. :)



