Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab3HHRit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:38:49 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61627 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965827Ab3HHRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:38:47 -0400
Message-ID: <5203D785.30506@redhat.com>
Date: Thu, 08 Aug 2013 19:38:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [RFC PATCH 00/12] KVM: MMU: locklessly wirte-protect
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <5200F720.7070608@linux.vnet.ibm.com>
In-Reply-To: <5200F720.7070608@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/08/2013 15:16, Xiao Guangrong ha scritto:
> Hi Gleb, Paolo, Marcelo, Takuya,
> 
> Any comments or further comments? :)

It's not the easiest patch to review.  I've looked at it (beyond the
small comments I have already posted), but it will take some time to
digest it...

By the way, both I and Gleb will be on vacation next week.  I will read
email, but I will not be able to apply patches or do pull requests.

Paolo

> On 07/30/2013 09:01 PM, Xiao Guangrong wrote:
>> Background
>> ==========
>> Currently, when mark memslot dirty logged or get dirty page, we need to
>> write-protect large guest memory, it is the heavy work, especially, we need to
>> hold mmu-lock which is also required by vcpu to fix its page table fault and
>> mmu-notifier when host page is being changed. In the extreme cpu / memory used
>> guest, it becomes a scalability issue.
>>
>> This patchset introduces a way to locklessly write-protect guest memory.
>>
>> Idea
>> ==========
>> There are the challenges we meet and the ideas to resolve them.
>>
>> 1) How to locklessly walk rmap?
>> The first idea we got to prevent "desc" being freed when we are walking the
>> rmap is using RCU. But when vcpu runs on shadow page mode or nested mmu mode,
>> it updates the rmap really frequently.
>>
>> So we uses SLAB_DESTROY_BY_RCU to manage "desc" instead, it allows the object
>> to be reused more quickly. We also store a "nulls" in the last "desc"
>> (desc->more) which can help us to detect whether the "desc" is moved to anther
>> rmap then we can re-walk the rmap if that happened. I learned this idea from
>> nulls-list.
>>
>> Another issue is, when a spte is deleted from the "desc", another spte in the
>> last "desc" will be moved to this position to replace the deleted one. If the
>> deleted one has been accessed and we do not access the replaced one, the
>> replaced one is missed when we do lockless walk.
>> To fix this case, we do not backward move the spte, instead, we forward move
>> the entry: when a spte is deleted, we move the entry in the first desc to that
>> position.
>>
>> 2) How to locklessly access shadow page table?
>> It is easy if the handler is in the vcpu context, in that case we can use
>> walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
>> disable interrupt to stop shadow page be freed. But we are on the ioctl context
>> and the paths we are optimizing for have heavy workload, disabling interrupt is
>> not good for the system performance.
>>
>> We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then use
>> call_rcu() to free the shadow page if that indicator is set. Set/Clear the
>> indicator are protected by slot-lock, so it need not be atomic and does not
>> hurt the performance and the scalability.
>>
>> 3) How to locklessly write-protect guest memory?
>> Currently, there are two behaviors when we write-protect guest memory, one is
>> clearing the Writable bit on spte and the another one is dropping spte when it
>> points to large page. The former is easy we only need to atomicly clear a bit
>> but the latter is hard since we need to remove the spte from rmap. so we unify
>> these two behaviors that only make the spte readonly. Making large spte
>> readonly instead of nonpresent is also good for reducing jitter.
>>
>> And we need to pay more attention on the order of making spte writable, adding
>> spte into rmap and setting the corresponding bit on dirty bitmap since
>> kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the dirty bitmap,
>> we should ensure the writable spte can be found in rmap before the dirty bitmap
>> is visible. Otherwise, we cleared the dirty bitmap and failed to write-protect
>> the page.
>>
>> Performance result
>> ====================
>> Host: CPU: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz x 12
>> Mem: 36G
>>
>> The benchmark i used and will be attached:
>> a) kernbench
>> b) migrate-perf
>>    it emulates guest migration
>> c) mmtest
>>    it repeatedly writes the memory and measures the time and is used to
>>    generate memory access in the guest which is being migrated
>> d) Qemu monitor command to implement guest live migration
>>    the script can be found in migrate-perf.
>>   
>>
>> 1) First, we use kernbench to benchmark the performance with non-write-protection
>>   case to detect the possible regression:
>>
>>   EPT enabled:  Base: 84.05      After the patch: 83.53
>>   EPT disabled: Base: 142.57     After the patch: 141.70
>>
>>   No regression and the optimization may come from lazily drop large spte.
>>
>> 2) Benchmark the performance of get dirty page
>>    (./migrate-perf -c 12 -m 3000 -t 20)
>>
>>    Base: Run 20 times, Avg time:24813809 ns.
>>    After the patch: Run 20 times, Avg time:8371577 ns.
>>    
>>    It improves +196%
>>   
>> 3) There is the result of Live Migration:
>>    3.1) Less vcpus, less memory and less dirty page generated
>>         (
>>           Guest config: MEM_SIZE=7G        VCPU_NUM=6
>>           The workload in migrated guest:
>>           ssh -f $CLIENT "cd ~; rm -f result; nohup /home/eric/mmtest/mmtest -m 3000 -c 30 -t 60 > result &"
>>         )
>>
>>                Live Migration time (ms)   Benchmark (ns)
>> ----------------------------------------+-------------+---------+
>> EPT    | Baseline |     21638           |  266601028            |
>>        + -------------------------------+-------------+---------+
>>        |   After  |     21110    +2.5%  |  264966696    +0.6%   |
>> ----------------------------------------+-------------+---------+
>> Shadow | Baseline |     22542           |  271969284  |         |
>>        +----------+---------------------+-------------+---------+
>>        |  After   |     21641    +4.1%  |  270485511    +0.5%   |
>> -------+----------+---------------------------------------------+
>>
>>    3.2) More vcpus, more memory and less dirty page generated
>>        (
>>          Guest config: MEM_SIZE=25G VCPU_NUM=12
>>          The workload in migrated guest:
>>          ssh -f $CLIENT "cd ~; rm -f result; nohup /home/eric/mmtest/mmtest -m 15000 -c 30 -t 30 > result &"
>>        )
>>
>>                Live Migration time (ms)   Benchmark (ns)
>> ----------------------------------------+-------------+---------+
>> EPT    | Baseline |     72773           |  1278228350           |
>>        + -------------------------------+-------------+---------+
>>        |   After  |     70516     +3.2% |  1266581587   +0.9%   |
>> ----------------------------------------+-------------+---------+
>> Shadow | Baseline |     74198           |  1323180090 |         |
>>        +----------+---------------------+-------------+---------+
>>        |  After   |     64948   +14.2%  |  1299283302   +1.8%  |
>> -------+----------+---------------------------------------------+
>>
>>    3.3) Less vcpus, more memory and huge dirty page generated
>>         ( 
>>           Guest config: MEM_SIZE=25G VCPU_NUM=6
>>           The workload in migrated guest:
>>           ssh -f $CLIENT "cd ~; rm -f result; nohup /home/eric/mmtest/mmtest -m 15000 -c 30 -t 200 > result &"
>>         )
>>
>>                Live Migration time (ms)   Benchmark (ns)
>> ----------------------------------------+-------------+---------+
>> EPT    | Baseline |     267473          |  1224657502           |
>>        + -------------------------------+-------------+---------+
>>        |   After  |     267374   +0.03% |  1221520513   +0.6%   |
>> ----------------------------------------+-------------+---------+
>> Shadow | Baseline |     369999          |  1712004428 |         |
>>        +----------+---------------------+-------------+---------+
>>        |  After   |     335737   +10.2% |  1556065063   +10.2%  |
>> -------+----------+---------------------------------------------+
>>
>>    For the case of 3.3), EPT gets small benefit, the reason is only the first
>>    time guest writes memory need take mmu-lock to mark spte from nonpresent to
>>    present. Other writes cost lots of time to trigger the page fault due to
>>    write-protection which are fixed by fast page fault which need not take
>>    mmu-lock.
>>
>> Xiao Guangrong (12):
>>   KVM: MMU: remove unused parameter
>>   KVM: MMU: properly check last spte in fast_page_fault()
>>   KVM: MMU: lazily drop large spte
>>   KVM: MMU: log dirty page after marking spte writable
>>   KVM: MMU: add spte into rmap before logging dirty page
>>   KVM: MMU: flush tlb if the spte can be locklessly modified
>>   KVM: MMU: redesign the algorithm of pte_list
>>   KVM: MMU: introduce nulls desc
>>   KVM: MMU: introduce pte-list lockless walker
>>   KVM: MMU: allow locklessly access shadow page table out of vcpu thread
>>   KVM: MMU: locklessly write-protect the page
>>   KVM: MMU: clean up spte_write_protect
>>
>>  arch/x86/include/asm/kvm_host.h |  10 +-
>>  arch/x86/kvm/mmu.c              | 442 ++++++++++++++++++++++++++++------------
>>  arch/x86/kvm/mmu.h              |  28 +++
>>  arch/x86/kvm/x86.c              |  19 +-
>>  4 files changed, 356 insertions(+), 143 deletions(-)
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

