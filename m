Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3CVLKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:10:54 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51796 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3CVLKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:10:53 -0400
Message-ID: <514C3C34.4080906@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 19:10:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130321222151.GA19821@amt.cnet> <514BBDC5.6090104@linux.vnet.ibm.com> <20130322105436.GC7543@amt.cnet>
In-Reply-To: <20130322105436.GC7543@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032211-5140-0000-0000-000002EE1448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 06:54 PM, Marcelo Tosatti wrote:

>>
>>>
>>> And then have codepaths that nuke shadow pages break from the spinlock,
>>
>> I think this is not needed any more. We can let mmu_notify use the generation
>> number to invalid all shadow pages, then we only need to free them after
>> all vcpus down and mmu_notify unregistered - at this point, no lock contention,
>> we can directly free them.
>>
>>> such as kvm_mmu_slot_remove_write_access does now (spin_needbreak).
>>
>> BTW, to my honest, i do not think spin_needbreak is a good way - it does
>> not fix the hot-lock contention and it just occupies more cpu time to avoid
>> possible soft lock-ups.
>>
>> Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
>> mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
>> create page tables again. zap-all-shadow-page need long time to be finished,
>> the worst case is, it can not completed forever on intensive vcpu and memory
>> usage.
> 
> Yes, but the suggestion is to use spin_needbreak on the VM shutdown
> cases, where there is no detailed concern about performance. Such as
> mmu_notifier_release, kvm_destroy_vm, etc. In those cases what matters
> most is that host remains unaffected (and that it finishes in a
> reasonable time).

Okay. I agree with you, will give a try.

> 
>> I still think the right way to fix this kind of thing is optimization for
>> mmu-lock.
> 
> And then for the cases where performance matters just increase a
> VM global generetion number, zap the roots and then on kvm_mmu_get_page:
> 
> kvm_mmu_get_page() {
> 	sp = lookup_hash(gfn)
> 	if (sp->role = role) {
> 		if (sp->mmu_gen_number != kvm->arch.mmu_gen_number) {
> 			kvm_mmu_commit_zap_page(sp); (no need for TLB flushes as its unreachable)
> 			kvm_mmu_init_page(sp);
> 			proceed as if the page was just allocated
> 		}
> 	}
> }
> 
> It makes the kvm_mmu_zap_all path even faster than you have now.
> I suppose this was your idea correct with the generation number correct?

Wow, great minds think alike, this is exactly what i am doing. ;)


