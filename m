Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab3CUW1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:27:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab3CUW1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:27:30 -0400
Date: Thu, 21 Mar 2013 19:21:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
Message-ID: <20130321222151.GA19821@amt.cnet>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:30:20PM +0800, Xiao Guangrong wrote:
> Changlog:
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

Xiao, 

The bulk removal of shadow pages from mmu cache is nerving - it creates
two codepaths to delete a data structure: the usual, single entry one
and the bulk one.

There are two main usecases for kvm_mmu_zap_all(): to invalidate the
current mmu tree (from kvm_set_memory) and to tear down all pages
(VM shutdown).

The first usecase can use your idea of an invalid generation number
on shadow pages. That is, increment the VM generation number, nuke the root
pages and thats it. 

The modifications should be contained to kvm_mmu_get_page() mostly,
correct? (would also have to keep counters to increase SLAB freeing 
ratio, relative to number of outdated shadow pages).

And then have codepaths that nuke shadow pages break from the spinlock,
such as kvm_mmu_slot_remove_write_access does now (spin_needbreak).
That would also solve the current issues without using more memory 
for pte_list_desc and without the delicate "Reset MMU cache" step.

What you think?

> * Idea
> Since all shadow page will be zapped, we can directly zap the mmu-cache
> and rmap so that vcpu will fault on the new mmu-cache, after that, we can
> directly free the memory used by old mmu-cache.
> 
> The root shadow page is little especial since they are currently used by
> vcpus, we can not directly free them. So, we zap the root shadow pages and
> re-add them into the new mmu-cache.
> 
> * TODO
> (1): free root shadow pages by using generation-number
> (2): drop unnecessary @npages from kvm_arch_create_memslot
> 
> * Performance
> The testcase can be found at:
> http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=54896;list=linux
> is used to measure the time of delete / add memslot. At that time, all vcpus
> are waiting, that means, no mmu-lock contention. I believe the result be more
> beautiful if other vcpus and mmu notification need to hold the mmu-lock.
> 
> Guest VCPU:6, Mem:2048M
> 
> before: Run 10 times, Avg time:46078825 ns.
> 
> after: Run 10 times, Avg time:21558774 ns. (+ 113%)
> 
> Xiao Guangrong (7):
>   KVM: MMU: introduce mmu_cache->pte_list_descs
>   KVM: x86: introduce memslot_set_lpage_disallowed
>   KVM: x86: introduce kvm_clear_all_gfn_page_info
>   KVM: MMU: delete shadow page from hash list in
>     kvm_mmu_prepare_zap_page
>   KVM: MMU: split kvm_mmu_prepare_zap_page
>   KVM: MMU: fast zap all shadow pages
>   KVM: MMU: drop unnecessary kvm_reload_remote_mmus after
>     kvm_mmu_zap_all
> 
>  arch/x86/include/asm/kvm_host.h |    7 ++-
>  arch/x86/kvm/mmu.c              |  105 ++++++++++++++++++++++++++++++++++-----
>  arch/x86/kvm/mmu.h              |    1 +
>  arch/x86/kvm/x86.c              |   87 +++++++++++++++++++++++++-------
>  include/linux/kvm_host.h        |    1 +
>  5 files changed, 166 insertions(+), 35 deletions(-)
> 
> -- 
> 1.7.7.6
