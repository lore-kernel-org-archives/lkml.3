Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3DPGdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:33:07 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58069 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3DPGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:33:05 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Date: Tue, 16 Apr 2013 14:32:38 +0800
Message-Id: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-5816-0000-0000-000007917230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on my previous two patchset:
[PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
(https://lkml.org/lkml/2013/4/1/2)

[PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
(https://lkml.org/lkml/2013/4/1/134)

Changlog:
V3:
  completely redesign the algorithm, please see below.

V2:
  - do not reset n_requested_mmu_pages and n_max_mmu_pages
  - batch free root shadow pages to reduce vcpu notification and mmu-lock
    contention
  - remove the first patch that introduce kvm->arch.mmu_cache since we only
    'memset zero' on hashtable rather than all mmu cache members in this
    version
  - remove unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all

* Issue
The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
walk and zap all shadow pages one by one, also it need to zap all guest
page's rmap and all shadow page's parent spte list. Particularly, things
become worse if guest uses more memory or vcpus. It is not good for
scalability.

* Idea
KVM maintains a global mmu invalid generation-number which is stored in
kvm->arch.mmu_valid_gen and every shadow page stores the current global
generation-number into sp->mmu_valid_gen when it is created.

When KVM need zap all shadow pages sptes, it just simply increase the
global generation-number then reload root shadow pages on all vcpus.
Vcpu will create a new shadow page table according to current kvm's
generation-number. It ensures the old pages are not used any more.

The invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
are keeped in mmu-cache until page allocator reclaims page.

* Challenges
Some page invalidation is requested when memslot is moved or deleted
and kvm is being destroy who call zap_all_pages to delete all sp using
their rmap and lpage-info, after call zap_all_pages, the rmap and lpage-info
will be freed. So, we should implement a fast way to delete sp from the rmap
and lpage-info.

For the lpage-info, we clear all lpage count when do zap-all-pages, then
all invalid shadow pages are not counted in lpage-info, after that lpage-info
on the invalid memslot can be safely freed. This is also good for the
performance - it allows guest to use hugepage as far as possible.

For the rmap, we introduce a way to unmap rmap out of mmu-lock.
In order to do that, we should resolve these problems:
1) do not corrupt the rmap
2) keep pte-list-descs available
3) keep shadow page available

Resolve 1):
we make the invalid rmap be remove-only that means we only delete and
clear spte from the rmap, no new sptes can be added to it.
This is reasonable since kvm can not do address translation on invalid rmap
(gfn_to_pfn is failed on invalid memslot) and all sptes on invalid rmap can
not be reused (they belong to invalid shadow page).

Resolve 2):
We use the placeholder (PTE_LIST_SPTE_SKIP) to indicate spte has been deleted
from the rmap instead of freeing pte-list-descs and moving sptes. Then, the
pte-list-desc entry are available when concurrently unmap the rmap.
The pte-list-descs are freed when the memslot is not visible to all vcpus.

Resolve 3):
we protect the lifecycle of sp by this algorithm:

unmap-rmap-out-of-mmu-lock():
for-each-rmap-in-slot:
      preempt_disable
      kvm->arch.being_unmapped_rmap = rmapp

      clear spte and reset rmap entry

      kvm->arch.being_unmapped_rmap = NULL
      preempt_enable

Other patch like zap-sp and mmu-notify which are protected
by mmu-lock:

      clear spte and reset rmap entry
retry:
      if (kvm->arch.being_unmapped_rmap == rmap)
                goto retry
(the wait is very rare and clear one rmap is very fast, it
is not bad even if wait is needed)

Then, we can sure the spte is always available when we concurrently unmap the
rmap


* TODO
Use a better algorithm to free pte-list-desc, for example, we can link them
together by desc->more.

* Performance
We observably reduce the contention of mmu-lock and make the invalidation
be preemptable.

Xiao Guangrong (15):
  KVM: x86: clean up and optimize for kvm_arch_free_memslot
  KVM: fold kvm_arch_create_memslot into kvm_arch_prepare_memory_region
  KVM: x86: do not reuse rmap when memslot is moved
  KVM: MMU: abstract memslot rmap related operations
  KVM: MMU: allow per-rmap operations
  KVM: MMU: allow concurrently clearing spte on remove-only pte-list
  KVM: MMU: introduce invalid rmap handlers
  KVM: MMU: allow unmap invalid rmap out of mmu-lock
  KVM: MMU: introduce free_meslot_rmap_desc_nolock
  KVM: x86: introduce memslot_set_lpage_disallowed
  KVM: MMU: introduce kvm_clear_all_lpage_info
  KVM: MMU: fast invalid all shadow pages
  KVM: x86: use the fast way to invalid all pages
  KVM: move srcu_read_lock/srcu_read_unlock to arch-specified code
  KVM: MMU: replace kvm_zap_all with kvm_mmu_invalid_all_pages

 arch/arm/kvm/arm.c              |    5 -
 arch/ia64/kvm/kvm-ia64.c        |    5 -
 arch/powerpc/kvm/powerpc.c      |    8 +-
 arch/s390/kvm/kvm-s390.c        |    5 -
 arch/x86/include/asm/kvm_host.h |    7 +-
 arch/x86/kvm/mmu.c              |  493 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu.h              |   21 ++
 arch/x86/kvm/mmu_audit.c        |   10 +-
 arch/x86/kvm/x86.c              |  122 +++++++---
 arch/x86/kvm/x86.h              |    2 +
 include/linux/kvm_host.h        |    1 -
 virt/kvm/kvm_main.c             |   11 +-
 12 files changed, 576 insertions(+), 114 deletions(-)

-- 
1.7.7.6

