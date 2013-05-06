Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3EFNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:10:26 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43442 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3EFNKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:10:22 -0400
Message-ID: <5187ABB3.7020403@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 21:10:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503010534.GA5467@amt.cnet> <51835087.8090605@linux.vnet.ibm.com> <20130503155302.GB3362@amt.cnet> <5183EAFA.4050500@linux.vnet.ibm.com> <20130504005201.GA11823@amt.cnet> <518725DF.5090503@linux.vnet.ibm.com> <20130506123625.GB12349@redhat.com>
In-Reply-To: <20130506123625.GB12349@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050613-5564-0000-0000-000007CA66D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 08:36 PM, Gleb Natapov wrote:

>>> Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
>>> spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
>>> releases mmu_lock and reacquires it again, only shadow pages 
>>> from the generation with which kvm_mmu_zap_all started are zapped (this
>>> guarantees forward progress and eventual termination).
>>>
>>> kvm_mmu_zap_generation()
>>> 	spin_lock(mmu_lock)
>>> 	int generation = kvm->arch.mmu_generation;
>>>
>>> 	for_each_shadow_page(sp) {
>>> 		if (sp->generation == kvm->arch.mmu_generation)
>>> 			zap_page(sp)
>>> 		if (spin_needbreak(mmu_lock)) {
>>> 			kvm->arch.mmu_generation++;
>>> 			cond_resched_lock(mmu_lock);
>>> 		}
>>> 	}
>>>
>>> kvm_mmu_zap_all()
>>> 	spin_lock(mmu_lock)
>>> 	for_each_shadow_page(sp) {
>>> 		if (spin_needbreak(mmu_lock)) {
>>> 			cond_resched_lock(mmu_lock);
>>> 		}
>>> 	}
>>>
>>> Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
>>> Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
>>>
>>> This addresses the main problem: excessively long hold times 
>>> of kvm_mmu_zap_all with very large guests.
>>>
>>> Do you see any problem with this logic? This was what i was thinking 
>>> we agreed.
>>
>> No. I understand it and it can work.
>>
>> Actually, it is similar with Gleb's idea that "zapping stale shadow pages
>> (and uses lock break technique)", after some discussion, we thought "only zap
>> shadow pages that are reachable from the slot's rmap" is better, that is this
>> patchset does.
>> (https://lkml.org/lkml/2013/4/23/73)
>>
> But this is not what the patch is doing. Close, but not the same :)

Okay. :)

> Instead of zapping shadow pages reachable from slot's rmap the patch
> does kvm_unmap_rmapp() which drop all spte without zapping shadow pages.
> That is why you need special code to re-init lpage_info. What I proposed
> was to call zap_page() on all shadow pages reachable from rmap. This
> will take care of lpage_info counters. Does this make sense?

Unfortunately, no! We still need to care lpage_info. lpage_info is used
to count the number of guest page tables in the memslot.

For example, there is a memslot:
memslot[0].based_gfn = 0, memslot[0].npages = 100,

and there is a shadow page:
sp->role.direct =0, sp->role.level = 4, sp->gfn = 10.

this sp is counted in the memslot[0] but it can not be found by walking
memslot[0]->rmap since there is no last mapping in this shadow page.


