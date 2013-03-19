Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3CSO5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab3CSO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:57:36 -0400
Date: Tue, 19 Mar 2013 11:40:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: fast zap all shadow pages
Message-ID: <20130319144043.GA8767@amt.cnet>
References: <514006AC.2020904@linux.vnet.ibm.com>
 <514007A0.1040400@linux.vnet.ibm.com>
 <20130318204601.GA16208@amt.cnet>
 <5147D63B.4000400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5147D63B.4000400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:06:35AM +0800, Xiao Guangrong wrote:
> On 03/19/2013 04:46 AM, Marcelo Tosatti wrote:
> > On Wed, Mar 13, 2013 at 12:59:12PM +0800, Xiao Guangrong wrote:
> >> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
> >> walk and zap all shadow pages one by one, also it need to zap all guest
> >> page's rmap and all shadow page's parent spte list. Particularly, things
> >> become worse if guest uses more memory or vcpus. It is not good for
> >> scalability.
> >>
> >> Since all shadow page will be zapped, we can directly zap the mmu-cache
> >> and rmap so that vcpu will fault on the new mmu-cache, after that, we can
> >> directly free the memory used by old mmu-cache.
> >>
> >> The root shadow page is little especial since they are currently used by
> >> vcpus, we can not directly free them. So, we zap the root shadow pages and
> >> re-add them into the new mmu-cache.
> >>
> >> After this patch, kvm_mmu_zap_all can be faster 113% than before
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++-----
> >>  1 files changed, 56 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index e326099..536d9ce 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -4186,18 +4186,68 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
> >>
> >>  void kvm_mmu_zap_all(struct kvm *kvm)
> >>  {
> >> -	struct kvm_mmu_page *sp, *node;
> >> +	LIST_HEAD(root_mmu_pages);
> >>  	LIST_HEAD(invalid_list);
> >> +	struct list_head pte_list_descs;
> >> +	struct kvm_mmu_cache *cache = &kvm->arch.mmu_cache;
> >> +	struct kvm_mmu_page *sp, *node;
> >> +	struct pte_list_desc *desc, *ndesc;
> >> +	int root_sp = 0;
> >>
> >>  	spin_lock(&kvm->mmu_lock);
> >> +
> >>  restart:
> >> -	list_for_each_entry_safe(sp, node,
> >> -	      &kvm->arch.mmu_cache.active_mmu_pages, link)
> >> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> >> -			goto restart;
> >> +	/*
> >> +	 * The root shadow pages are being used on vcpus that can not
> >> +	 * directly removed, we filter them out and re-add them to the
> >> +	 * new mmu cache.
> >> +	 */
> >> +	list_for_each_entry_safe(sp, node, &cache->active_mmu_pages, link)
> >> +		if (sp->root_count) {
> >> +			int ret;
> >> +
> >> +			root_sp++;
> >> +			ret = kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> >> +			list_move(&sp->link, &root_mmu_pages);
> >> +			if (ret)
> >> +				goto restart;
> >> +		}
> >> +
> >> +	list_splice(&cache->active_mmu_pages, &invalid_list);
> >> +	list_replace(&cache->pte_list_descs, &pte_list_descs);
> >> +
> >> +	/*
> >> +	 * Reset the mmu cache so that later vcpu will fault on the new
> >> +	 * mmu cache.
> >> +	 */
> >> +	memset(cache, 0, sizeof(*cache));
> >> +	kvm_mmu_init(kvm);
> > 
> > Xiao,
> > 
> > I suppose zeroing of kvm_mmu_cache can be avoided, if the links are
> > removed at prepare_zap_page. So perhaps
> 
> The purpose of zeroing of kvm_mmu_cache is resetting the hashtable and
> some count numbers.
> [.n_request_mmu_pages and .n_max_mmu_pages should not be changed, i will
> fix this].
> 
> > 
> > - spin_lock(mmu_lock)
> > - for each page
> > 	- zero sp->spt[], remove page from linked lists
> 
> sizeof(mmu_cache) is:
> (1 << 10) * sizeof (hlist_head) + 4 * sizeof(unsigned int) = 2^13 + 16
> and it is constant. In your way, for every sp, we need to zap:
> 512 entries + a hash-node = 2^12 + 8
> especially the workload depends on the size of guest memory.
> Why you think this way is better?

Its not of course. 

> > - flush remote TLB (batched)
> > - spin_unlock(mmu_lock)
> > - free data (which is safe because freeing has its own serialization)
> 
> We should free the root sp in mmu-lock like my patch.
> 
> > - spin_lock(mmu_lock)
> > - account for the pages freed
> > - spin_unlock(mmu_lock)
> 
> The count numbers are still inconsistent if other thread hold mmu-lock between
> zero shadow page and recount.
> 
> Marcelo, i really confused what is the benefit in this way but i might
> completely misunderstand it.

I misunderstood the benefit of your idea (now i got it: zap root
and flush TLB guarantees vcpus will refault). What i'd like to avoid is

memset(cache, 0, sizeof(*cache));
kvm_mmu_init(kvm);

I'd prefer normal operations on those data structures (in mmu_cache).
And also the page accounting is a problem.

Perhaps you can use a generation number to consider whether shadow pages
are valid? So: 

find_sp(gfn_t gfn)
lookup hash
if sp->generation_number != mmu->current_generation_number
	initialize page as if it were just allocated (but keep it in the hash list)

And on kvm_mmu_zap_all()
spin_lock(mmu_lock)
for each page
if page->root_count
	zero sp->spt[]

flush TLB
mmu->current_generation_number++
spin_unlock(mmu_lock)

Then have kvm_mmu_free_all() that actually frees all data.

Hum, not sure if thats any better than your current patchset.
Well, maybe resend patchset with bug fixes / improvements and 
we go from there.


