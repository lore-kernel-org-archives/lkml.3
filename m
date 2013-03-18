Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3CRMqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3CRMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:46:21 -0400
Date: Mon, 18 Mar 2013 14:46:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
Message-ID: <20130318124616.GH4020@redhat.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
 <51433E71.2070107@linux.vnet.ibm.com>
 <20130317150239.GM11223@redhat.com>
 <5146CB92.7060203@linux.vnet.ibm.com>
 <20130318091303.GA1276@redhat.com>
 <514708A9.8040009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514708A9.8040009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:29:29PM +0800, Xiao Guangrong wrote:
> On 03/18/2013 05:13 PM, Gleb Natapov wrote:
> > On Mon, Mar 18, 2013 at 04:08:50PM +0800, Xiao Guangrong wrote:
> >> On 03/17/2013 11:02 PM, Gleb Natapov wrote:
> >>> On Fri, Mar 15, 2013 at 11:29:53PM +0800, Xiao Guangrong wrote:
> >>>> This patch tries to introduce a very simple and scale way to invalid all
> >>>> mmio sptes - it need not walk any shadow pages and hold mmu-lock
> >>>>
> >>>> KVM maintains a global mmio invalid generation-number which is stored in
> >>>> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
> >>>> generation-number into his available bits when it is created
> >>>>
> >>>> When KVM need zap all mmio sptes, it just simply increase the global
> >>>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> >>>> then it walks the shadow page table and get the mmio spte. If the
> >>>> generation-number on the spte does not equal the global generation-number,
> >>>> it will go to the normal #PF handler to update the mmio spte
> >>>>
> >>>> Since 19 bits are used to store generation-number on mmio spte, the
> >>>> generation-number can be round after 33554432 times. It is large enough
> >>>> for nearly all most cases, but making the code be more strong, we zap all
> >>>> shadow pages when the number is round
> >>>>
> >>> Very nice idea, but why drop Takuya patches instead of using
> >>> kvm_mmu_zap_mmio_sptes() when generation number overflows.
> >>
> >> I am not sure whether it is still needed. Requesting to zap all mmio sptes for
> >> more than 500000 times is really really rare, it nearly does not happen.
> >> (By the way, 33554432 is wrong in the changelog, i just copy that for my origin
> >> implantation.) And, after my patch optimizing zapping all shadow pages,
> >> zap-all-sps should not be a problem anymore since it does not take too much lock
> >> time.
> >>
> >> Your idea?
> >>
> > I expect 500000 to become less since I already had plans to store some
> 
> Interesting, just curious, what are the plans? ;)
> 
Currently we uses pio to signal that work is pending to virtio devices. The
requirement is that signaling should be fast and PIO is fast since there
is not need to emulate instruction. PCIE though is not really designed
with PIO in mind, so we will have to use MMIO to do signaling. To avoid
instruction emulation I thought about making guest access these devices using
predefined variety of MOV instruction so that emulation can be skipped.
The idea is to mark mmio spte to know that emulation is not needed.

> > information in mmio spte. Even if all zap-all-sptes becomes faster we
> > still needlessly zap all sptes while we can zap only mmio.
> 
> Okay.
> 
> > 
> >>>
> >>>
> >>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>>> ---
> >>>>  arch/x86/include/asm/kvm_host.h |    2 +
> >>>>  arch/x86/kvm/mmu.c              |   61 +++++++++++++++++++++++++++++++++------
> >>>>  arch/x86/kvm/mmutrace.h         |   17 +++++++++++
> >>>>  arch/x86/kvm/paging_tmpl.h      |    7 +++-
> >>>>  arch/x86/kvm/vmx.c              |    4 ++
> >>>>  arch/x86/kvm/x86.c              |    6 +--
> >>>>  6 files changed, 82 insertions(+), 15 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>> index ef7f4a5..572398e 100644
> >>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>> @@ -529,6 +529,7 @@ struct kvm_arch {
> >>>>  	unsigned int n_requested_mmu_pages;
> >>>>  	unsigned int n_max_mmu_pages;
> >>>>  	unsigned int indirect_shadow_pages;
> >>>> +	unsigned int mmio_invalid_gen;
> >>> Why invalid? Should be mmio_valid_gen or mmio_current_get.
> >>
> >> mmio_invalid_gen is only updated in kvm_mmu_invalidate_mmio_sptes,
> >> so i named it as _invalid_. But mmio_valid_gen is good for me.
> >>
> > It holds currently valid value though, so calling it "invalid" is
> > confusing.
> 
> I agree.
> 
> > 
> >>>
> >>>>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> >>>>  	/*
> >>>>  	 * Hash table of struct kvm_mmu_page.
> >>>> @@ -765,6 +766,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
> >>>>  void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >>>>  				     struct kvm_memory_slot *slot,
> >>>>  				     gfn_t gfn_offset, unsigned long mask);
> >>>> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm);
> >>> Agree with Takuya that kvm_mmu_invalidate_mmio_sptes() is a better name.
> >>
> >> Me too.
> >>
> >>>
> >>>>  void kvm_mmu_zap_all(struct kvm *kvm);
> >>>>  unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
> >>>>  void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
> >>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>>> index 13626f4..7093a92 100644
> >>>> --- a/arch/x86/kvm/mmu.c
> >>>> +++ b/arch/x86/kvm/mmu.c
> >>>> @@ -234,12 +234,13 @@ static unsigned int get_mmio_spte_generation(u64 spte)
> >>>>  static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
> >>>>  			   unsigned access)
> >>>>  {
> >>>> -	u64 mask = generation_mmio_spte_mask(0);
> >>>> +	unsigned int gen = ACCESS_ONCE(kvm->arch.mmio_invalid_gen);
> >>>> +	u64 mask = generation_mmio_spte_mask(gen);
> >>>>
> >>>>  	access &= ACC_WRITE_MASK | ACC_USER_MASK;
> >>>>  	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
> >>>>
> >>>> -	trace_mark_mmio_spte(sptep, gfn, access, 0);
> >>>> +	trace_mark_mmio_spte(sptep, gfn, access, gen);
> >>>>  	mmu_spte_set(sptep, mask);
> >>>>  }
> >>>>
> >>>> @@ -269,6 +270,34 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
> >>>>  	return false;
> >>>>  }
> >>>>
> >>>> +static bool check_mmio_spte(struct kvm *kvm, u64 spte)
> >>>> +{
> >>>> +	return get_mmio_spte_generation(spte) ==
> >>>> +		ACCESS_ONCE(kvm->arch.mmio_invalid_gen);
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * The caller should protect concurrent access on
> >>>> + * kvm->arch.mmio_invalid_gen. Currently, it is used by
> >>>> + * kvm_arch_commit_memory_region and protected by kvm->slots_lock.
> >>>> + */
> >>>> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm)
> >>>> +{
> >>>> +	/* Ensure update memslot has been completed. */
> >>>> +	smp_mb();
> >>> What barrier this one is paired with?
> >>
> >> It is paired with nothing. :)
> >>
> >> I used mb here just for avoid increasing the generation-number before updating
> >> the memslot. But on other sides (storing gen and checking gen), we do not need
> >> to care it - the worse case is that we emulate a memory-accessed instruction.
> >>
> > Are you warring that compiler can reorder instructions and put
> > instruction that increase generation number before updating memslot?
> > If yes then you need to use barrier() here. Or are you warring that
> > update may be seen in different order by another cpu? Then you need to
> > put another barring in the code that access memslot/generation number
> > and cares about the order.
> 
> After more thinking, maybe i missed something. The correct order should be:
> 
> The write side:
> update kvm->memslots
> smp_wmb()
> kvm->mmio_invalid_gen++
> 
> The read side:
> read kvm->mmio_invalid_gen++
> smp_rmb();
> search gfn in memslots (read all memslots)
> 
> Otherwise, mmio spte would cache a newest generation-number and obsolete
> memslot info.
> 
> But we read memslots out of mmu-lock on page fault path, we should pass
> mmio_invalid_gen to the page fault hander. In order to simplify the code,
> let's save the generation-number into kvm_memslots, then they can protected
> by SRCU. How about this?
> 
Make sense and in fact we already have generation number there which is
used for gfn_to_hva_cache. The problem is that gfn_to_hva cache does not
expect generation number to wrap, but with modulo arithmetic we can make
it wrap only for mmio sptes.

--
			Gleb.
