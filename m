Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3EWP6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3EWP6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:58:07 -0400
Date: Thu, 23 May 2013 18:57:22 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce
 kvm_mmu_prepare_zap_obsolete_page
Message-ID: <20130523155722.GJ26157@redhat.com>
References: <20130523055725.GA26157@redhat.com>
 <519DB372.3080803@linux.vnet.ibm.com>
 <20130523061818.GC26157@redhat.com>
 <519DB7D3.7030101@linux.vnet.ibm.com>
 <20130523073708.GE26157@redhat.com>
 <519DCA38.30200@linux.vnet.ibm.com>
 <20130523080922.GG26157@redhat.com>
 <519DF9F6.1060902@linux.vnet.ibm.com>
 <20130523123947.GO4725@redhat.com>
 <519E13B6.7060807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519E13B6.7060807@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:03:50PM +0800, Xiao Guangrong wrote:
> On 05/23/2013 08:39 PM, Gleb Natapov wrote:
> > On Thu, May 23, 2013 at 07:13:58PM +0800, Xiao Guangrong wrote:
> >> On 05/23/2013 04:09 PM, Gleb Natapov wrote:
> >>> On Thu, May 23, 2013 at 03:50:16PM +0800, Xiao Guangrong wrote:
> >>>> On 05/23/2013 03:37 PM, Gleb Natapov wrote:
> >>>>> On Thu, May 23, 2013 at 02:31:47PM +0800, Xiao Guangrong wrote:
> >>>>>> On 05/23/2013 02:18 PM, Gleb Natapov wrote:
> >>>>>>> On Thu, May 23, 2013 at 02:13:06PM +0800, Xiao Guangrong wrote:
> >>>>>>>> On 05/23/2013 01:57 PM, Gleb Natapov wrote:
> >>>>>>>>> On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
> >>>>>>>>>> It is only used to zap the obsolete page. Since the obsolete page
> >>>>>>>>>> will not be used, we need not spend time to find its unsync children
> >>>>>>>>>> out. Also, we delete the page from shadow page cache so that the page
> >>>>>>>>>> is completely isolated after call this function.
> >>>>>>>>>>
> >>>>>>>>>> The later patch will use it to collapse tlb flushes
> >>>>>>>>>>
> >>>>>>>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>>>>>>>>> ---
> >>>>>>>>>>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
> >>>>>>>>>>  1 files changed, 41 insertions(+), 5 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>>>>>>>>> index 9b57faa..e676356 100644
> >>>>>>>>>> --- a/arch/x86/kvm/mmu.c
> >>>>>>>>>> +++ b/arch/x86/kvm/mmu.c
> >>>>>>>>>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> >>>>>>>>>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
> >>>>>>>>>>  {
> >>>>>>>>>>  	ASSERT(is_empty_shadow_page(sp->spt));
> >>>>>>>>>> -	hlist_del(&sp->hash_link);
> >>>>>>>>>> +	hlist_del_init(&sp->hash_link);
> >>>>>>>>> Why do you need hlist_del_init() here? Why not move it into
> >>>>>>>>
> >>>>>>>> Since the hlist will be double freed. We will it like this:
> >>>>>>>>
> >>>>>>>> kvm_mmu_prepare_zap_obsolete_page(page, list);
> >>>>>>>> kvm_mmu_commit_zap_page(list);
> >>>>>>>>    kvm_mmu_free_page(page);
> >>>>>>>>
> >>>>>>>> The first place is kvm_mmu_prepare_zap_obsolete_page(page), which have
> >>>>>>>> deleted the hash list.
> >>>>>>>>
> >>>>>>>>> kvm_mmu_prepare_zap_page() like we discussed it here:
> >>>>>>>>> https://patchwork.kernel.org/patch/2580351/ instead of doing
> >>>>>>>>> it differently for obsolete and non obsolete pages?
> >>>>>>>>
> >>>>>>>> It is can break the hash-list walking: we should rescan the
> >>>>>>>> hash list once the page is prepared-ly zapped.
> >>>>>>>>
> >>>>>>>> I mentioned it in the changelog:
> >>>>>>>>
> >>>>>>>>   4): drop the patch which deleted page from hash list at the "prepare"
> >>>>>>>>       time since it can break the walk based on hash list.
> >>>>>>> Can you elaborate on how this can happen?
> >>>>>>
> >>>>>> There is a example:
> >>>>>>
> >>>>>> int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
> >>>>>> {
> >>>>>> 	struct kvm_mmu_page *sp;
> >>>>>> 	LIST_HEAD(invalid_list);
> >>>>>> 	int r;
> >>>>>>
> >>>>>> 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
> >>>>>> 	r = 0;
> >>>>>> 	spin_lock(&kvm->mmu_lock);
> >>>>>> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> >>>>>> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> >>>>>> 			 sp->role.word);
> >>>>>> 		r = 1;
> >>>>>> 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> >>>>>> 	}
> >>>>>> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> >>>>>> 	spin_unlock(&kvm->mmu_lock);
> >>>>>>
> >>>>>> 	return r;
> >>>>>> }
> >>>>>>
> >>>>>> It works fine since kvm_mmu_prepare_zap_page does not touch the hash list.
> >>>>>> If we delete hlist in kvm_mmu_prepare_zap_page(), this kind of codes should
> >>>>>> be changed to:
> >>>>>>
> >>>>>> restart:
> >>>>>> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> >>>>>> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> >>>>>> 			 sp->role.word);
> >>>>>> 		r = 1;
> >>>>>> 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> >>>>>> 			goto restart;
> >>>>>> 	}
> >>>>>> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> >>>>>>
> >>>>> Hmm, yes. So lets leave it as is and always commit invalid_list before
> >>>>
> >>>> So, you mean drop this patch and the patch of
> >>>> KVM: MMU: collapse TLB flushes when zap all pages?
> >>>>
> >>> We still want to add kvm_reload_remote_mmus() to
> >>> kvm_mmu_invalidate_zap_all_pages(). But yes, we disable a nice
> >>> optimization here. So may be skipping obsolete pages while walking
> >>> hashtable is better solution.
> >>
> >> I am willing to use this way instead, but it looks worse than this
> >> patch:
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 9b57faa..810410c 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> >>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
> >>  {
> >>  	ASSERT(is_empty_shadow_page(sp->spt));
> >> -	hlist_del(&sp->hash_link);
> >> +	hlist_del_init(&sp->hash_link);
> > Why not drop this
> > 
> >>  	list_del(&sp->link);
> >>  	free_page((unsigned long)sp->spt);
> >>  	if (!sp->role.direct)
> >> @@ -1648,14 +1648,20 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> >>  static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> >>  				    struct list_head *invalid_list);
> >>
> >> +static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >> +{
> >> +	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> >> +}
> >> +
> >>  #define for_each_gfn_sp(_kvm, _sp, _gfn)				\
> >>  	hlist_for_each_entry(_sp,					\
> >>  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
> >> -		if ((_sp)->gfn != (_gfn)) {} else
> >> +		if ((_sp)->gfn != (_gfn) || is_obsolete_sp(_kvm, _sp)) {} else
> >>
> >>  #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
> >>  	for_each_gfn_sp(_kvm, _sp, _gfn)				\
> >> -		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
> >> +		if ((_sp)->role.direct ||				\
> >> +		      (_sp)->role.invalid || is_obsolete_sp(_kvm, _sp)) {} else
> >>
> >>  /* @sp->gfn should be write-protected at the call site */
> >>  static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >> @@ -1838,11 +1844,6 @@ static void clear_sp_write_flooding_count(u64 *spte)
> >>  	__clear_sp_write_flooding_count(sp);
> >>  }
> >>
> >> -static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >> -{
> >> -	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> >> -}
> >> -
> >>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >>  					     gfn_t gfn,
> >>  					     gva_t gaddr,
> >> @@ -2085,11 +2086,15 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> >>
> >>  	if (sp->unsync)
> >>  		kvm_unlink_unsync_page(kvm, sp);
> >> +
> >>  	if (!sp->root_count) {
> >>  		/* Count self */
> >>  		ret++;
> >>  		list_move(&sp->link, invalid_list);
> >>  		kvm_mod_used_mmu_pages(kvm, -1);
> >> +
> >> +		if (unlikely(is_obsolete_sp(kvm, sp)))
> >> +			hlist_del_init(&sp->hash_link);
> > and this.
> > 
> > Since we check for obsolete while searching hashtable why delete it
> > here?
> 
> In order to zap obsolete pages without tlb flush, we should delete them from
> hash list at the "prepare" time. Here, we only delete the obsolete pages so
> that the hashtable walking functions, like kvm_mmu_unprotect_page(), can work
> properly by skipping obsolete page.
> 
Why we have to delete them from the hash at "prepare" time? I hash walk
ignores them they are as good as deleted, no?

> And, kvm_mmu_prepare_zap_page() is a recursion function:
> kvm_mmu_prepare_zap_page() -> zap_unsync_children -> kvm_mmu_prepare_zap_page().
> It seems it is the only place to do this thing. For example, below code is not
> allowed in kvm_zap_obsolete_pages():
> 
> if (kvm_mmu_prepare_zap_page(sp, list))
> 	hlist_del(sp->hlist);
> 
> Or, i missed your suggestion?
My assumption is that we can leave obsolete shadow pages on hashtable
till commit_zap time.

BTW is it such a good idea to call kvm_mmu_commit_zap_page() once on all
obsolete pages? We basically loop over all of them under the lock
without lock break.

--
			Gleb.
