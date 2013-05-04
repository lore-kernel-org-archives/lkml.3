Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3EDA5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762800Ab3EDA5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:57:14 -0400
Date: Fri, 3 May 2013 21:56:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130504005655.GA19194@amt.cnet>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130503010534.GA5467@amt.cnet>
 <51835087.8090605@linux.vnet.ibm.com>
 <20130503155302.GB3362@amt.cnet>
 <5183EAFA.4050500@linux.vnet.ibm.com>
 <20130504005201.GA11823@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504005201.GA11823@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 09:52:01PM -0300, Marcelo Tosatti wrote:
> On Sat, May 04, 2013 at 12:51:06AM +0800, Xiao Guangrong wrote:
> > On 05/03/2013 11:53 PM, Marcelo Tosatti wrote:
> > > On Fri, May 03, 2013 at 01:52:07PM +0800, Xiao Guangrong wrote:
> > >> On 05/03/2013 09:05 AM, Marcelo Tosatti wrote:
> > >>
> > >>>> +
> > >>>> +/*
> > >>>> + * Fast invalid all shadow pages belong to @slot.
> > >>>> + *
> > >>>> + * @slot != NULL means the invalidation is caused the memslot specified
> > >>>> + * by @slot is being deleted, in this case, we should ensure that rmap
> > >>>> + * and lpage-info of the @slot can not be used after calling the function.
> > >>>> + *
> > >>>> + * @slot == NULL means the invalidation due to other reasons, we need
> > >>>> + * not care rmap and lpage-info since they are still valid after calling
> > >>>> + * the function.
> > >>>> + */
> > >>>> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> > >>>> +				   struct kvm_memory_slot *slot)
> > >>>> +{
> > >>>> +	spin_lock(&kvm->mmu_lock);
> > >>>> +	kvm->arch.mmu_valid_gen++;
> > >>>> +
> > >>>> +	/*
> > >>>> +	 * All shadow paes are invalid, reset the large page info,
> > >>>> +	 * then we can safely desotry the memslot, it is also good
> > >>>> +	 * for large page used.
> > >>>> +	 */
> > >>>> +	kvm_clear_all_lpage_info(kvm);
> > >>>
> > >>> Xiao,
> > >>>
> > >>> I understood it was agreed that simple mmu_lock lockbreak while
> > >>> avoiding zapping of newly instantiated pages upon a
> > >>>
> > >>> 	if(spin_needbreak)
> > >>> 		cond_resched_lock()
> > >>>
> > >>> cycle was enough as a first step? And then later introduce root zapping
> > >>> along with measurements.
> > >>>
> > >>> https://lkml.org/lkml/2013/4/22/544
> > >>
> > >> Yes, it is.
> > >>
> > >> See the changelog in 0/0:
> > >>
> > >> " we use lock-break technique to zap all sptes linked on the
> > >> invalid rmap, it is not very effective but good for the first step."
> > >>
> > >> Thanks!
> > > 
> > > Sure, but what is up with zeroing kvm_clear_all_lpage_info(kvm) and
> > > zapping the root? Only lock-break technique along with generation number 
> > > was what was agreed.
> > 
> > Marcelo,
> > 
> > Please Wait... I am completely confused. :(
> > 
> > Let's clarify "zeroing kvm_clear_all_lpage_info(kvm) and zapping the root" first.
> > Are these changes you wanted?
> > 
> > void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> > 				   struct kvm_memory_slot *slot)
> > {
> > 	spin_lock(&kvm->mmu_lock);
> > 	kvm->arch.mmu_valid_gen++;
> > 
> > 	/* Zero all root pages.*/
> > restart:
> > 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> > 		if (!sp->root_count)
> > 			continue;
> > 
> > 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> > 			goto restart;
> > 	}
> > 
> > 	/*
> > 	 * All shadow paes are invalid, reset the large page info,
> > 	 * then we can safely desotry the memslot, it is also good
> > 	 * for large page used.
> > 	 */
> > 	kvm_clear_all_lpage_info(kvm);
> > 
> > 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> > 	spin_unlock(&kvm->mmu_lock);
> > }
> > 
> > static void rmap_remove(struct kvm *kvm, u64 *spte)
> > {
> > 	struct kvm_mmu_page *sp;
> > 	gfn_t gfn;
> > 	unsigned long *rmapp;
> > 
> > 	sp = page_header(__pa(spte));
> > +
> > +       /* Let invalid sp do not access its rmap. */
> > +	if (!sp_is_valid(sp))
> > +		return;
> > +
> > 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
> > 	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
> > 	pte_list_remove(spte, rmapp);
> > }
> > 
> > If yes, there is the reason why we can not do this that i mentioned before:
> > 
> > after call kvm_mmu_invalid_memslot_pages(), the memslot->rmap will be destroyed.
> > Later, if host reclaim page, the mmu-notify handlers, ->invalidate_page and
> > ->invalidate_range_start, can not find any spte using the host page, then
> > Accessed/Dirty for host page is missing tracked.
> > (missing call kvm_set_pfn_accessed and kvm_set_pfn_dirty properly.)
> > 
> > What's your idea?
> 
> 
> Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
> spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
> releases mmu_lock and reacquires it again, only shadow pages 
> from the generation with which kvm_mmu_zap_all started are zapped (this
> guarantees forward progress and eventual termination).
> 
> kvm_mmu_zap_generation()
> 	spin_lock(mmu_lock)
> 	int generation = kvm->arch.mmu_generation;
> 
> 	for_each_shadow_page(sp) {
> 		if (sp->generation == kvm->arch.mmu_generation)
> 			zap_page(sp)
> 		if (spin_needbreak(mmu_lock)) {
> 			kvm->arch.mmu_generation++;
> 			cond_resched_lock(mmu_lock);
> 		}
> 	}
> 
> kvm_mmu_zap_all()
> 	spin_lock(mmu_lock)
> 	for_each_shadow_page(sp) {
> 		if (spin_needbreak(mmu_lock)) {
> 			cond_resched_lock(mmu_lock);
> 		}
> 	}
> 
> Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
> Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
> 
> This addresses the main problem: excessively long hold times 
> of kvm_mmu_zap_all with very large guests.
> 
> Do you see any problem with this logic? This was what i was thinking 
> we agreed.
> 
> Step 2) Show that the optimization to zap only the roots is worthwhile
> via benchmarking, and implement it.
> 
> What do you say?

One concern you had earlier was:

"BTW, to my honest, i do not think spin_needbreak is a good way - it
does not fix the hot-lock contention and it just occupies more cpu time
to avoid possible soft lock-ups.

Especially, zap-all-shadow-pages can let other vcpus fault and vcpus
contest mmu-lock, then zap-all-shadow-pages release mmu-lock and wait,
other vcpus create page tables again. zap-all-shadow-page need long
time to be finished, the worst case is, it can not completed forever on
intensive vcpu and memory usage."

But with generation numbers you can guarantee termination (as long as
new pages are added to one side of the active_mmu_pages list while
kvm_mmu_zap_all begins walking from the other).

