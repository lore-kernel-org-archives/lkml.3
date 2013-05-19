Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3ESKtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 06:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3ESKtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 06:49:14 -0400
Date: Sun, 19 May 2013 13:49:10 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/7] KVM: MMU: fast zap all shadow pages
Message-ID: <20130519104910.GF4725@redhat.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:12:55AM +0800, Xiao Guangrong wrote:
> The benchmark and the result can be found at:
> http://www.spinics.net/lists/kvm/msg91391.html
> 
I asked a couple of questions on some patches, but overall this looks
good to me. Marcelo can you look at this too?

> Changlog:
> V6:
>   1): reversely walk active_list to skip the new created pages based
>       on the comments from Gleb and Paolo.
> 
>   2): completely replace kvm_mmu_zap_all by kvm_mmu_invalidate_all_pages
>       based on Gleb's comments.
> 
>   3): improve the parameters of kvm_mmu_invalidate_all_pages based on
>       Gleb's comments.
>  
>   4): rename kvm_mmu_invalidate_memslot_pages to kvm_mmu_invalidate_all_pages
>   5): rename zap_invalid_pages to kvm_zap_obsolete_pages
> 
> V5:
>   1): rename is_valid_sp to is_obsolete_sp
>   2): use lock-break technique to zap all old pages instead of only pages
>       linked on invalid slot's rmap suggested by Marcelo.
>   3): trace invalid pages and kvm_mmu_invalidate_memslot_pages()
>   4): rename kvm_mmu_invalid_memslot_pages to kvm_mmu_invalidate_memslot_pages
>       according to Takuya's comments.
> 
> V4:
>   1): drop unmapping invalid rmap out of mmu-lock and use lock-break technique
>       instead. Thanks to Gleb's comments.
> 
>   2): needn't handle invalid-gen pages specially due to page table always
>       switched by KVM_REQ_MMU_RELOAD. Thanks to Marcelo's comments.
> 
> V3:
>   completely redesign the algorithm, please see below.
> 
> V2:
>   - do not reset n_requested_mmu_pages and n_max_mmu_pages
>   - batch free root shadow pages to reduce vcpu notification and mmu-lock
>     contention
>   - remove the first patch that introduce kvm->arch.mmu_cache since we only
>     'memset zero' on hashtable rather than all mmu cache members in this
>     version
>   - remove unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all
> 
> * Issue
> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
> walk and zap all shadow pages one by one, also it need to zap all guest
> page's rmap and all shadow page's parent spte list. Particularly, things
> become worse if guest uses more memory or vcpus. It is not good for
> scalability.
> 
> * Idea
> KVM maintains a global mmu invalid generation-number which is stored in
> kvm->arch.mmu_valid_gen and every shadow page stores the current global
> generation-number into sp->mmu_valid_gen when it is created.
> 
> When KVM need zap all shadow pages sptes, it just simply increase the
> global generation-number then reload root shadow pages on all vcpus.
> Vcpu will create a new shadow page table according to current kvm's
> generation-number. It ensures the old pages are not used any more.
> 
> Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
> are zapped by using lock-break technique.
> 
> Xiao Guangrong (7):
>   KVM: MMU: drop unnecessary kvm_reload_remote_mmus
>   KVM: MMU: delete shadow page from hash list in
>     kvm_mmu_prepare_zap_page
>   KVM: MMU: fast invalidate all pages
>   KVM: MMU: zap pages in batch
>   KVM: x86: use the fast way to invalidate all pages
>   KVM: MMU: show mmu_valid_gen in shadow page related tracepoints
>   KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages
> 
>  arch/x86/include/asm/kvm_host.h |    2 +
>  arch/x86/kvm/mmu.c              |  115 +++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu.h              |    1 +
>  arch/x86/kvm/mmutrace.h         |   45 ++++++++++++----
>  arch/x86/kvm/x86.c              |   11 ++---
>  5 files changed, 151 insertions(+), 23 deletions(-)
> 
> -- 
> 1.7.7.6

--
			Gleb.
