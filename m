Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3EFUNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab3EFUNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:13:07 -0400
Date: Mon, 6 May 2013 16:50:22 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130506195022.GA5706@amt.cnet>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130503010534.GA5467@amt.cnet>
 <51835087.8090605@linux.vnet.ibm.com>
 <20130503155302.GB3362@amt.cnet>
 <5183EAFA.4050500@linux.vnet.ibm.com>
 <20130504005201.GA11823@amt.cnet>
 <518725DF.5090503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518725DF.5090503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:39:11AM +0800, Xiao Guangrong wrote:
> On 05/04/2013 08:52 AM, Marcelo Tosatti wrote:
> > On Sat, May 04, 2013 at 12:51:06AM +0800, Xiao Guangrong wrote:
> >> On 05/03/2013 11:53 PM, Marcelo Tosatti wrote:
> >>> On Fri, May 03, 2013 at 01:52:07PM +0800, Xiao Guangrong wrote:
> >>>> On 05/03/2013 09:05 AM, Marcelo Tosatti wrote:
> >>>>
> >>>>>> +
> >>>>>> +/*
> >>>>>> + * Fast invalid all shadow pages belong to @slot.
> >>>>>> + *
> >>>>>> + * @slot != NULL means the invalidation is caused the memslot specified
> >>>>>> + * by @slot is being deleted, in this case, we should ensure that rmap
> >>>>>> + * and lpage-info of the @slot can not be used after calling the function.
> >>>>>> + *
> >>>>>> + * @slot == NULL means the invalidation due to other reasons, we need
> >>>>>> + * not care rmap and lpage-info since they are still valid after calling
> >>>>>> + * the function.
> >>>>>> + */
> >>>>>> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> >>>>>> +				   struct kvm_memory_slot *slot)
> >>>>>> +{
> >>>>>> +	spin_lock(&kvm->mmu_lock);
> >>>>>> +	kvm->arch.mmu_valid_gen++;
> >>>>>> +
> >>>>>> +	/*
> >>>>>> +	 * All shadow paes are invalid, reset the large page info,
> >>>>>> +	 * then we can safely desotry the memslot, it is also good
> >>>>>> +	 * for large page used.
> >>>>>> +	 */
> >>>>>> +	kvm_clear_all_lpage_info(kvm);
> >>>>>
> >>>>> Xiao,
> >>>>>
> >>>>> I understood it was agreed that simple mmu_lock lockbreak while
> >>>>> avoiding zapping of newly instantiated pages upon a
> >>>>>
> >>>>> 	if(spin_needbreak)
> >>>>> 		cond_resched_lock()
> >>>>>
> >>>>> cycle was enough as a first step? And then later introduce root zapping
> >>>>> along with measurements.
> >>>>>
> >>>>> https://lkml.org/lkml/2013/4/22/544
> >>>>
> >>>> Yes, it is.
> >>>>
> >>>> See the changelog in 0/0:
> >>>>
> >>>> " we use lock-break technique to zap all sptes linked on the
> >>>> invalid rmap, it is not very effective but good for the first step."
> >>>>
> >>>> Thanks!
> >>>
> >>> Sure, but what is up with zeroing kvm_clear_all_lpage_info(kvm) and
> >>> zapping the root? Only lock-break technique along with generation number 
> >>> was what was agreed.
> >>
> >> Marcelo,
> >>
> >> Please Wait... I am completely confused. :(
> >>
> >> Let's clarify "zeroing kvm_clear_all_lpage_info(kvm) and zapping the root" first.
> >> Are these changes you wanted?
> >>
> >> void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> >> 				   struct kvm_memory_slot *slot)
> >> {
> >> 	spin_lock(&kvm->mmu_lock);
> >> 	kvm->arch.mmu_valid_gen++;
> >>
> >> 	/* Zero all root pages.*/
> >> restart:
> >> 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> >> 		if (!sp->root_count)
> >> 			continue;
> >>
> >> 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> >> 			goto restart;
> >> 	}
> >>
> >> 	/*
> >> 	 * All shadow paes are invalid, reset the large page info,
> >> 	 * then we can safely desotry the memslot, it is also good
> >> 	 * for large page used.
> >> 	 */
> >> 	kvm_clear_all_lpage_info(kvm);
> >>
> >> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> >> 	spin_unlock(&kvm->mmu_lock);
> >> }
> >>
> >> static void rmap_remove(struct kvm *kvm, u64 *spte)
> >> {
> >> 	struct kvm_mmu_page *sp;
> >> 	gfn_t gfn;
> >> 	unsigned long *rmapp;
> >>
> >> 	sp = page_header(__pa(spte));
> >> +
> >> +       /* Let invalid sp do not access its rmap. */
> >> +	if (!sp_is_valid(sp))
> >> +		return;
> >> +
> >> 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
> >> 	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
> >> 	pte_list_remove(spte, rmapp);
> >> }
> >>
> >> If yes, there is the reason why we can not do this that i mentioned before:
> >>
> >> after call kvm_mmu_invalid_memslot_pages(), the memslot->rmap will be destroyed.
> >> Later, if host reclaim page, the mmu-notify handlers, ->invalidate_page and
> >> ->invalidate_range_start, can not find any spte using the host page, then
> >> Accessed/Dirty for host page is missing tracked.
> >> (missing call kvm_set_pfn_accessed and kvm_set_pfn_dirty properly.)
> >>
> >> What's your idea?
> > 
> > 
> > Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
> > spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
> > releases mmu_lock and reacquires it again, only shadow pages 
> > from the generation with which kvm_mmu_zap_all started are zapped (this
> > guarantees forward progress and eventual termination).
> > 
> > kvm_mmu_zap_generation()
> > 	spin_lock(mmu_lock)
> > 	int generation = kvm->arch.mmu_generation;
> > 
> > 	for_each_shadow_page(sp) {
> > 		if (sp->generation == kvm->arch.mmu_generation)
> > 			zap_page(sp)
> > 		if (spin_needbreak(mmu_lock)) {
> > 			kvm->arch.mmu_generation++;
> > 			cond_resched_lock(mmu_lock);
> > 		}
> > 	}
> > 
> > kvm_mmu_zap_all()
> > 	spin_lock(mmu_lock)
> > 	for_each_shadow_page(sp) {
> > 		if (spin_needbreak(mmu_lock)) {
> > 			cond_resched_lock(mmu_lock);
> > 		}
> > 	}
> > 
> > Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
> > Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
> > 
> > This addresses the main problem: excessively long hold times 
> > of kvm_mmu_zap_all with very large guests.
> > 
> > Do you see any problem with this logic? This was what i was thinking 
> > we agreed.
> 
> No. I understand it and it can work.
> 
> Actually, it is similar with Gleb's idea that "zapping stale shadow pages
> (and uses lock break technique)", after some discussion, we thought "only zap
> shadow pages that are reachable from the slot's rmap" is better, that is this
> patchset does.
> (https://lkml.org/lkml/2013/4/23/73)
> 
> > 
> > Step 2) Show that the optimization to zap only the roots is worthwhile
> > via benchmarking, and implement it.
> 
> This is what i am confused. I can not understand how "zap only the roots"
> works. You mean these change?
> 
> kvm_mmu_zap_generation()
>  	spin_lock(mmu_lock)
>  	int generation = kvm->arch.mmu_generation;
> 
>  	for_each_shadow_page(sp) {
> 		/* Change here. */
> => 		if ((sp->generation == kvm->arch.mmu_generation) &&
> =>		      sp->root_count)
>  			zap_page(sp)
> 
>  		if (spin_needbreak(mmu_lock)) {
>  			kvm->arch.mmu_generation++;
>  			cond_resched_lock(mmu_lock);
>  		}
>  	}
> 
> If we do this, there will have shadow pages that are linked to invalid memslot's
> rmap. How do we handle these pages and the mmu-notify issue?
> 
> Thanks!

By "zap only roots" i mean zapping roots plus generation number on
shadow pages. But this as a second step, after it has been demonstrated
its worthwhile.

