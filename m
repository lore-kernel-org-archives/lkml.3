Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3EPMVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:21:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34841 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3EPMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:03 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 0/8] KVM: MMU: fast zap all shadow pages
Date: Thu, 16 May 2013 20:17:45 +0800
Message-Id: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-0260-0000-0000-00000302C3CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bechmark result:
I have tested this patchset and the previous version that only zaps the
pages linked on invalid slot's rmap. The benchmark is written by myself
which has been attached, it writes large memory when do pci rom read.

Host: Intel(R) Xeon(R) CPU X5690  @ 3.47GHz + 36G Memory
Guest: 12 VCPU + 32G Memory

Current code:           This patchset         Previous Version 
2405434959 ns           2323016424 ns         2368810003 ns

The interesting thing is, the previous version is slower than this patch,
i guess the reason is that the former keeps lots of invalid pages in mmu
which cause shadow page to be reclaimed due to used-pages > request-pages
or host memory shrink.

Changlog:
V5:
  1): rename is_valid_sp to is_obsolete_sp
  2): use lock-break technique to zap all old pages instead of only pages
      linked on invalid slot's rmap suggested by Marcelo.
  3): trace invalid pages and kvm_mmu_invalidate_memslot_pages() 
  4): rename kvm_mmu_invalid_memslot_pages to kvm_mmu_invalidate_memslot_pages
      according to Takuya's comments. 

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

Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
are zapped by using lock-break technique.

Xiao Guangrong (8):
  KVM: MMU: drop unnecessary kvm_reload_remote_mmus
  KVM: MMU: delete shadow page from hash list in
    kvm_mmu_prepare_zap_page
  KVM: MMU: fast invalidate all pages
  KVM: x86: use the fast way to invalidate all pages
  KVM: MMU: make kvm_mmu_zap_all preemptable
  KVM: MMU: show mmu_valid_gen in shadow page related tracepoints
  KVM: MMU: add tracepoint for kvm_mmu_invalidate_memslot_pages
  KVM: MMU: zap pages in batch

 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |  124 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.h              |    2 +
 arch/x86/kvm/mmutrace.h         |   45 +++++++++++---
 arch/x86/kvm/x86.c              |    9 +--
 5 files changed, 163 insertions(+), 19 deletions(-)

-- 
1.7.7.6

