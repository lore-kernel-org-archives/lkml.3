Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3EGOeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:34:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab3EGOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:34:30 -0400
Date: Tue, 7 May 2013 11:33:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130507143329.GB6408@amt.cnet>
References: <5183EAFA.4050500@linux.vnet.ibm.com>
 <20130504005201.GA11823@amt.cnet>
 <518725DF.5090503@linux.vnet.ibm.com>
 <20130506123625.GB12349@redhat.com>
 <5187ABB3.7020403@linux.vnet.ibm.com>
 <20130506172455.GB18963@redhat.com>
 <5187EC50.4030308@linux.vnet.ibm.com>
 <20130507085848.GI12349@redhat.com>
 <5188CC4F.3070306@linux.vnet.ibm.com>
 <20130507100051.GK12349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507100051.GK12349@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:00:51PM +0300, Gleb Natapov wrote:
> On Tue, May 07, 2013 at 05:41:35PM +0800, Xiao Guangrong wrote:
> > On 05/07/2013 04:58 PM, Gleb Natapov wrote:
> > > On Tue, May 07, 2013 at 01:45:52AM +0800, Xiao Guangrong wrote:
> > >> On 05/07/2013 01:24 AM, Gleb Natapov wrote:
> > >>> On Mon, May 06, 2013 at 09:10:11PM +0800, Xiao Guangrong wrote:
> > >>>> On 05/06/2013 08:36 PM, Gleb Natapov wrote:
> > >>>>
> > >>>>>>> Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
> > >>>>>>> spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
> > >>>>>>> releases mmu_lock and reacquires it again, only shadow pages 
> > >>>>>>> from the generation with which kvm_mmu_zap_all started are zapped (this
> > >>>>>>> guarantees forward progress and eventual termination).
> > >>>>>>>
> > >>>>>>> kvm_mmu_zap_generation()
> > >>>>>>> 	spin_lock(mmu_lock)
> > >>>>>>> 	int generation = kvm->arch.mmu_generation;
> > >>>>>>>
> > >>>>>>> 	for_each_shadow_page(sp) {
> > >>>>>>> 		if (sp->generation == kvm->arch.mmu_generation)
> > >>>>>>> 			zap_page(sp)
> > >>>>>>> 		if (spin_needbreak(mmu_lock)) {
> > >>>>>>> 			kvm->arch.mmu_generation++;
> > >>>>>>> 			cond_resched_lock(mmu_lock);
> > >>>>>>> 		}
> > >>>>>>> 	}
> > >>>>>>>
> > >>>>>>> kvm_mmu_zap_all()
> > >>>>>>> 	spin_lock(mmu_lock)
> > >>>>>>> 	for_each_shadow_page(sp) {
> > >>>>>>> 		if (spin_needbreak(mmu_lock)) {
> > >>>>>>> 			cond_resched_lock(mmu_lock);
> > >>>>>>> 		}
> > >>>>>>> 	}
> > >>>>>>>
> > >>>>>>> Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
> > >>>>>>> Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
> > >>>>>>>
> > >>>>>>> This addresses the main problem: excessively long hold times 
> > >>>>>>> of kvm_mmu_zap_all with very large guests.
> > >>>>>>>
> > >>>>>>> Do you see any problem with this logic? This was what i was thinking 
> > >>>>>>> we agreed.
> > >>>>>>
> > >>>>>> No. I understand it and it can work.
> > >>>>>>
> > >>>>>> Actually, it is similar with Gleb's idea that "zapping stale shadow pages
> > >>>>>> (and uses lock break technique)", after some discussion, we thought "only zap
> > >>>>>> shadow pages that are reachable from the slot's rmap" is better, that is this
> > >>>>>> patchset does.
> > >>>>>> (https://lkml.org/lkml/2013/4/23/73)
> > >>>>>>
> > >>>>> But this is not what the patch is doing. Close, but not the same :)
> > >>>>
> > >>>> Okay. :)
> > >>>>
> > >>>>> Instead of zapping shadow pages reachable from slot's rmap the patch
> > >>>>> does kvm_unmap_rmapp() which drop all spte without zapping shadow pages.
> > >>>>> That is why you need special code to re-init lpage_info. What I proposed
> > >>>>> was to call zap_page() on all shadow pages reachable from rmap. This
> > >>>>> will take care of lpage_info counters. Does this make sense?
> > >>>>
> > >>>> Unfortunately, no! We still need to care lpage_info. lpage_info is used
> > >>>> to count the number of guest page tables in the memslot.
> > >>>>
> > >>>> For example, there is a memslot:
> > >>>> memslot[0].based_gfn = 0, memslot[0].npages = 100,
> > >>>>
> > >>>> and there is a shadow page:
> > >>>> sp->role.direct =0, sp->role.level = 4, sp->gfn = 10.
> > >>>>
> > >>>> this sp is counted in the memslot[0] but it can not be found by walking
> > >>>> memslot[0]->rmap since there is no last mapping in this shadow page.
> > >>>>
> > >>> Right, so what about walking mmu_page_hash for each gfn belonging to the
> > >>> slot that is in process to be removed to find those?
> > >>
> > >> That will cost lots of time. The size of hashtable is 1 << 10. If the
> > >> memslot has 4M memory, it will walk all the entries, the cost is the same
> > >> as walking active_list (maybe litter more). And a memslot has 4M memory is
> > >> the normal case i think.
> > >>
> > > Memslots will be much bigger with memory hotplug. Lock break should be
> > > used while walking mmu_page_hash obviously, but still iterating over
> > > entire memslot gfn space to find a few gfn that may be there is
> > > suboptimal. We can keep a list of them in the memslot itself.
> > 
> > It sounds good to me.
> > 
> > BTW, this approach looks more complex and use more memory (new list_head
> > added into every shadow page) used, why you dislike clearing lpage_info? ;)
> > 
> Looks a little bit hackish, but now that I see we do not have easy way
> to find all shadow pages counted in lpage_info I am not entirely against
> it. If you convince Marcelo that clearing lpage_info like that is a good
> idea I may reconsider. I think, regardless of tracking lpage_info,
> having a way to find all shadow pages that reference a memslot is a good
> thing though.
> 
> > > 
> > >> Another point is that lpage_info stops mmu to use large page. If we
> > >> do not reset lpage_info, mmu is using 4K page until the invalid-sp is
> > >> zapped.
> > >>
> > > I do not think this is a big issue. If lpage_info prevented the use of
> > > large pages for some memory ranges before we zapped entire shadow pages
> > > it was probably for a reason, so new shadow page will prevent large
> > > pages from been created for the same memory ranges.
> > 
> > Still worried, but I will try it if Marcelo does not have objects.
> > Thanks a lot for your valuable suggestion, Gleb!
> > 
> > Now, i am trying my best to catch Marcelo's idea of "zapping root
> > pages", but......
> > 
> Yes, I am missing what Marcelo means there too. We cannot free memslot
> until we unmap its rmap one way or the other.

I do not understand what are you optimizing for, given the four possible
cases we discussed at

https://lkml.org/lkml/2013/4/18/280

That is, why a simple for_each_all_shadow_page(zap_page) is not sufficient.

