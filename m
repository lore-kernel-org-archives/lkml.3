Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3EFRqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:46:06 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44195 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3EFRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:46:03 -0400
Message-ID: <5187EC50.4030308@linux.vnet.ibm.com>
Date: Tue, 07 May 2013 01:45:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503010534.GA5467@amt.cnet> <51835087.8090605@linux.vnet.ibm.com> <20130503155302.GB3362@amt.cnet> <5183EAFA.4050500@linux.vnet.ibm.com> <20130504005201.GA11823@amt.cnet> <518725DF.5090503@linux.vnet.ibm.com> <20130506123625.GB12349@redhat.com> <5187ABB3.7020403@linux.vnet.ibm.com> <20130506172455.GB18963@redhat.com>
In-Reply-To: <20130506172455.GB18963@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050617-5816-0000-0000-000007D9B46B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:24 AM, Gleb Natapov wrote:
> On Mon, May 06, 2013 at 09:10:11PM +0800, Xiao Guangrong wrote:
>> On 05/06/2013 08:36 PM, Gleb Natapov wrote:
>>
>>>>> Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
>>>>> spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
>>>>> releases mmu_lock and reacquires it again, only shadow pages 
>>>>> from the generation with which kvm_mmu_zap_all started are zapped (this
>>>>> guarantees forward progress and eventual termination).
>>>>>
>>>>> kvm_mmu_zap_generation()
>>>>> 	spin_lock(mmu_lock)
>>>>> 	int generation = kvm->arch.mmu_generation;
>>>>>
>>>>> 	for_each_shadow_page(sp) {
>>>>> 		if (sp->generation == kvm->arch.mmu_generation)
>>>>> 			zap_page(sp)
>>>>> 		if (spin_needbreak(mmu_lock)) {
>>>>> 			kvm->arch.mmu_generation++;
>>>>> 			cond_resched_lock(mmu_lock);
>>>>> 		}
>>>>> 	}
>>>>>
>>>>> kvm_mmu_zap_all()
>>>>> 	spin_lock(mmu_lock)
>>>>> 	for_each_shadow_page(sp) {
>>>>> 		if (spin_needbreak(mmu_lock)) {
>>>>> 			cond_resched_lock(mmu_lock);
>>>>> 		}
>>>>> 	}
>>>>>
>>>>> Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
>>>>> Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
>>>>>
>>>>> This addresses the main problem: excessively long hold times 
>>>>> of kvm_mmu_zap_all with very large guests.
>>>>>
>>>>> Do you see any problem with this logic? This was what i was thinking 
>>>>> we agreed.
>>>>
>>>> No. I understand it and it can work.
>>>>
>>>> Actually, it is similar with Gleb's idea that "zapping stale shadow pages
>>>> (and uses lock break technique)", after some discussion, we thought "only zap
>>>> shadow pages that are reachable from the slot's rmap" is better, that is this
>>>> patchset does.
>>>> (https://lkml.org/lkml/2013/4/23/73)
>>>>
>>> But this is not what the patch is doing. Close, but not the same :)
>>
>> Okay. :)
>>
>>> Instead of zapping shadow pages reachable from slot's rmap the patch
>>> does kvm_unmap_rmapp() which drop all spte without zapping shadow pages.
>>> That is why you need special code to re-init lpage_info. What I proposed
>>> was to call zap_page() on all shadow pages reachable from rmap. This
>>> will take care of lpage_info counters. Does this make sense?
>>
>> Unfortunately, no! We still need to care lpage_info. lpage_info is used
>> to count the number of guest page tables in the memslot.
>>
>> For example, there is a memslot:
>> memslot[0].based_gfn = 0, memslot[0].npages = 100,
>>
>> and there is a shadow page:
>> sp->role.direct =0, sp->role.level = 4, sp->gfn = 10.
>>
>> this sp is counted in the memslot[0] but it can not be found by walking
>> memslot[0]->rmap since there is no last mapping in this shadow page.
>>
> Right, so what about walking mmu_page_hash for each gfn belonging to the
> slot that is in process to be removed to find those?

That will cost lots of time. The size of hashtable is 1 << 10. If the
memslot has 4M memory, it will walk all the entries, the cost is the same
as walking active_list (maybe litter more). And a memslot has 4M memory is
the normal case i think.

Another point is that lpage_info stops mmu to use large page. If we
do not reset lpage_info, mmu is using 4K page until the invalid-sp is
zapped.


