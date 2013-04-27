Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3D0DNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 23:13:33 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47556 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3D0DNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 23:13:31 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 0/6] KVM: MMU: fast zap all shadow pages
Date: Sat, 27 Apr 2013 11:13:16 +0800
Message-Id: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042703-2674-0000-0000-000008C0CD69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on current 'queue' branch on kvm tree.

Changlog:

V4:
  1): drop unmapping invalid rmap out of mmu-lock and use lock-break technique
      instead. Thanks to Gleb's comments.

  2): needn't handle invalid-gen pages specially due to page table always
      switched by KVM_REQ_MMU_RELOAD. Thanks to Marcelo's comments.

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
will be freed.

For the lpage-info, we clear all lpage count when do zap-all-pages, then
all invalid shadow pages are not counted in lpage-info, after that lpage-info
on the invalid memslot can be safely freed. This is also good for the
performance - it allows guest to use hugepage as far as possible.

For the rmap, we use lock-break technique to zap all sptes linked on the
invalid rmap, it is not very effective but good for the first step.

* TODO
Unmapping invalid rmap out of mmu-lock with a clear way.

Xiao Guangrong (6):
  KVM: MMU: drop unnecessary kvm_reload_remote_mmus
  KVM: x86: introduce memslot_set_lpage_disallowed
  KVM: MMU: introduce kvm_clear_all_lpage_info
  KVM: MMU: fast invalid all shadow pages
  KVM: x86: use the fast way to invalid all pages
  KVM: MMU: make kvm_mmu_zap_all preemptable

 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   88 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.h              |    2 +
 arch/x86/kvm/x86.c              |   87 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/x86.h              |    2 +
 5 files changed, 155 insertions(+), 26 deletions(-)

-- 
1.7.7.6

