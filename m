Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3KCM3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3KCM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:29:09 -0500
Date: Sun, 3 Nov 2013 14:29:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: locklessly write-protect
Message-ID: <20131103122904.GA3963@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo can you review it please?

On Wed, Oct 23, 2013 at 09:29:18PM +0800, Xiao Guangrong wrote:
> Changelog v3:
> - the changes from Gleb's review:
>   1) drop the patch which fixed the count of spte number in rmap since it
>      can not be easily fixed and it has gone after applying this patchset
> 
> - ideas from Gleb and discussion with Marcelo is also very appreciated:
>   2) change the way to locklessly access shadow page - use SLAB_DESTROY_BY_RCU
>      to protect shadow page instead of conditionally using call_rcu()
>   3) improve is_last_spte() that checks last spte by only using some bits on
>      the spte, then it is safely used when we locklessly write-protect the
>      shadow page table
> 
> Changelog v2:
> 
> - the changes from Gleb's review:
>   1) fix calculating the number of spte in the pte_list_add()
>   2) set iter->desc to NULL if meet a nulls desc to cleanup the code of
>      rmap_get_next()
>   3) fix hlist corruption due to accessing sp->hlish out of mmu-lock
>   4) use rcu functions to access the rcu protected pointer
>   5) spte will be missed in lockless walker if the spte is moved in a desc
>      (remove a spte from the rmap using only one desc). Fix it by bottom-up
>      walking the desc
> 
> - the changes from Paolo's review
>   1) make the order and memory barriers between update spte / add spte into
>      rmap and dirty-log more clear
>   
> - the changes from Marcelo's review:
>   1) let fast page fault only fix the spts on the last level (level = 1)
>   2) improve some changelogs and comments
> 
> - the changes from Takuya's review:
>   move the patch "flush tlb if the spte can be locklessly modified" forward
>   to make it's more easily merged
> 
> Thank all of you very much for your time and patience on this patchset!
>   
> Since we use rcu_assign_pointer() to update the points in desc even if dirty
> log is disabled, i have measured the performance:
> Host: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz * 12 + 36G memory
> 
> - migrate-perf (benchmark the time of get-dirty-log)
>   before: Run 10 times, Avg time:9009483 ns.
>   after: Run 10 times, Avg time:4807343 ns.
> 
> - kerbench
>   Guest: 12 VCPUs + 8G memory
>   before:
> EPT is enabled:
> # cat 09-05-origin-ept | grep real       
> real 85.58
> real 83.47
> real 82.95
> 
> EPT is disabled:
> # cat 09-05-origin-shadow | grep real
> real 138.77
> real 138.99
> real 139.55
> 
>   after:
> EPT is enabled:
> # cat 09-05-lockless-ept | grep real
> real 83.40
> real 82.81
> real 83.39
> 
> EPT is disabled:
> # cat 09-05-lockless-shadow | grep real
> real 138.91
> real 139.71
> real 138.94
> 
> No performance regression!
> 
> 
> 
> Background
> ==========
> Currently, when mark memslot dirty logged or get dirty page, we need to
> write-protect large guest memory, it is the heavy work, especially, we need to
> hold mmu-lock which is also required by vcpu to fix its page table fault and
> mmu-notifier when host page is being changed. In the extreme cpu / memory used
> guest, it becomes a scalability issue.
> 
> This patchset introduces a way to locklessly write-protect guest memory.
> 
> Idea
> ==========
> There are the challenges we meet and the ideas to resolve them.
> 
> 1) How to locklessly walk rmap?
> The first idea we got to prevent "desc" being freed when we are walking the
> rmap is using RCU. But when vcpu runs on shadow page mode or nested mmu mode,
> it updates the rmap really frequently.
> 
> So we uses SLAB_DESTROY_BY_RCU to manage "desc" instead, it allows the object
> to be reused more quickly. We also store a "nulls" in the last "desc"
> (desc->more) which can help us to detect whether the "desc" is moved to anther
> rmap then we can re-walk the rmap if that happened. I learned this idea from
> nulls-list.
> 
> Another issue is, when a spte is deleted from the "desc", another spte in the
> last "desc" will be moved to this position to replace the deleted one. If the
> deleted one has been accessed and we do not access the replaced one, the
> replaced one is missed when we do lockless walk.
> To fix this case, we do not backward move the spte, instead, we forward move
> the entry: when a spte is deleted, we move the entry in the first desc to that
> position.
> 
> 2) How to locklessly access shadow page table?
> It is easy if the handler is in the vcpu context, in that case we can use
> walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
> disable interrupt to stop shadow page be freed. But we are on the ioctl context
> and the paths we are optimizing for have heavy workload, disabling interrupt is
> not good for the system performance.
> 
> We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then use
> call_rcu() to free the shadow page if that indicator is set. Set/Clear the
> indicator are protected by slot-lock, so it need not be atomic and does not
> hurt the performance and the scalability.
> 
> 3) How to locklessly write-protect guest memory?
> Currently, there are two behaviors when we write-protect guest memory, one is
> clearing the Writable bit on spte and the another one is dropping spte when it
> points to large page. The former is easy we only need to atomicly clear a bit
> but the latter is hard since we need to remove the spte from rmap. so we unify
> these two behaviors that only make the spte readonly. Making large spte
> readonly instead of nonpresent is also good for reducing jitter.
> 
> And we need to pay more attention on the order of making spte writable, adding
> spte into rmap and setting the corresponding bit on dirty bitmap since
> kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the dirty bitmap,
> we should ensure the writable spte can be found in rmap before the dirty bitmap
> is visible. Otherwise, we cleared the dirty bitmap and failed to write-protect
> the page.
> 
> Performance result
> ====================
> The performance result and the benchmark can be found at:
>   http://permalink.gmane.org/gmane.linux.kernel/1534876
> 
> Xiao Guangrong (15):
>   KVM: MMU: properly check last spte in fast_page_fault()
>   KVM: MMU: lazily drop large spte
>   KVM: MMU: flush tlb if the spte can be locklessly modified
>   KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
>   KVM: MMU: update spte and add it into rmap before dirty log
>   KVM: MMU: redesign the algorithm of pte_list
>   KVM: MMU: introduce nulls desc
>   KVM: MMU: introduce pte-list lockless walker
>   KVM: MMU: initialize the pointers in pte_list_desc properly
>   KVM: MMU: allocate shadow pages from slab
>   KVM: MMU: locklessly access shadow page under rcu protection
>   KVM: MMU: check last spte with unawareness of mapping level
>   KVM: MMU: locklessly write-protect the page
>   KVM: MMU: clean up spte_write_protect
>   KVM: MMU: use rcu functions to access the pointer
> 
>  arch/x86/include/asm/kvm_host.h |   7 +-
>  arch/x86/kvm/mmu.c              | 586 ++++++++++++++++++++++++++++++----------
>  arch/x86/kvm/mmu.h              |   6 +
>  arch/x86/kvm/mmu_audit.c        |   6 +-
>  arch/x86/kvm/paging_tmpl.h      |   6 +-
>  arch/x86/kvm/x86.c              |  34 ++-
>  6 files changed, 475 insertions(+), 170 deletions(-)
> 
> -- 
> 1.8.1.4

--
			Gleb.
