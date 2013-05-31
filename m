Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3EaAgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:36:45 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36040 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3EaAgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:40 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 00/11] KVM: MMU: fast zap all shadow pages
Date: Fri, 31 May 2013 08:36:19 +0800
Message-Id: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-5490-0000-0000-0000038EDB97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb, Paolo, Marcelo,

I have putted the potential controversial patches to the latter that are
patch 8 ~ 10, patch 11 depends on patch 9. Other patches are fully reviewed,
I think its are ready for being merged. If not luck enough, further discussion
is needed, could you please apply that patches first? :)

Thank you in advance!

Some points are raised during discussion but missed in this version:
1) Gleb's idea that skip obsolete pages in the hast list walker

   Unfortunately, it is not safe. There has a window between updating
   valid-gen and reloading mmu, in that window, the obsolete page can
   be used by vcpu, but the guest page table fail to be write-protected
   (since the obsolete page is skipped in mmu_need_write_protect()).

   Instead, we can only skip the zapped-obsolete page
   (is_obsolete_sp(sp) && sp->role.invalid)), the current code has already
   skip them but put the comment around the hash list walker to warn the
   further development.

2) Marcelo's comment that obsolete pages can cause the number of shadow page
   greater than the n_max_mmu_pages

   I am not sure this is really a problem, it only exists in the really tiny
   window and the page-reclaim path are able to handle the obsolete pages.
   Furthermore, we can properly reduce n_max_mmu_pages to make that window
   more tiny.

   Anyway, like commit 5d21881432 shows that "the mmu counters are for
   beancounting purposes only", maybe that window is allowed.

Changlog:
V8:
  1): add some comments to explain FIFO around active_mmu_list address
      Marcelo's comments.

  2): the page-reclaim path may fail to free zapped-obsolete pages pointed
      out by Marcelo, the patchset fixes it by listing all zapped obsolete
      pages on a global list, always free page from that list first.

  3): address Marcelo's suggestion to move the "zap pages in batch" patch
      to the latter.

  4): drop the previous patch which introduced
      kvm_mmu_prepare_zap_obsolete_page(), instead, we put the comments
      around hash list walker to warn the user that the zapped-obsolete
      page still live on hash list.

  5): add the note into the changelog of "zap pages in batch" patch to explain
      the batch number is the speculative value based on Takuya's comments.

V7:
  1): separate some optimization into two patches which do not reuse
      the obsolete pages and collapse tlb flushes, suggested by Marcelo.

  2): make the patch based on Gleb's diff change which reduce
      KVM_REQ_MMU_RELOAD when root page is being zapped.

  3): remove calling kvm_mmu_zap_page when patching hypercall, investigated
      by Gleb.

  4): drop the patch which deleted page from hash list at the "prepare"
      time since it can break the walk based on hash list.

  5): rename kvm_mmu_invalidate_all_pages to kvm_mmu_invalidate_zap_all_pages.

  6): introduce kvm_mmu_prepare_zap_obsolete_page which is used to zap obsolete
      page to collapse tlb flushes.

V6:
  1): reversely walk active_list to skip the new created pages based
      on the comments from Gleb and Paolo.

  2): completely replace kvm_mmu_zap_all by kvm_mmu_invalidate_all_pages
      based on Gleb's comments.

  3): improve the parameters of kvm_mmu_invalidate_all_pages based on
      Gleb's comments.
 
  4): rename kvm_mmu_invalidate_memslot_pages to kvm_mmu_invalidate_all_pages
  5): rename zap_invalid_pages to kvm_zap_obsolete_pages

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

Gleb Natapov (1):
  KVM: MMU: reduce KVM_REQ_MMU_RELOAD when root page is zapped

Xiao Guangrong (10):
  KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall
  KVM: MMU: drop unnecessary kvm_reload_remote_mmus
  KVM: MMU: fast invalidate all pages
  KVM: x86: use the fast way to invalidate all pages
  KVM: MMU: show mmu_valid_gen in shadow page related tracepoints
  KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages
  KVM: MMU: do not reuse the obsolete page
  KVM: MMU: zap pages in batch
  KVM: MMU: collapse TLB flushes when zap all pages
  KVM: MMU: reclaim the zapped-obsolete page first

 arch/x86/include/asm/kvm_host.h |    4 +
 arch/x86/kvm/mmu.c              |  128 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/mmutrace.h         |   42 ++++++++++---
 arch/x86/kvm/x86.c              |   17 +----
 5 files changed, 161 insertions(+), 31 deletions(-)

-- 
1.7.7.6

