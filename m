Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3EWHhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:37:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3EWHhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:37:14 -0400
Date: Thu, 23 May 2013 10:37:08 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce
 kvm_mmu_prepare_zap_obsolete_page
Message-ID: <20130523073708.GE26157@redhat.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130523055725.GA26157@redhat.com>
 <519DB372.3080803@linux.vnet.ibm.com>
 <20130523061818.GC26157@redhat.com>
 <519DB7D3.7030101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519DB7D3.7030101@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 02:31:47PM +0800, Xiao Guangrong wrote:
> On 05/23/2013 02:18 PM, Gleb Natapov wrote:
> > On Thu, May 23, 2013 at 02:13:06PM +0800, Xiao Guangrong wrote:
> >> On 05/23/2013 01:57 PM, Gleb Natapov wrote:
> >>> On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
> >>>> It is only used to zap the obsolete page. Since the obsolete page
> >>>> will not be used, we need not spend time to find its unsync children
> >>>> out. Also, we delete the page from shadow page cache so that the page
> >>>> is completely isolated after call this function.
> >>>>
> >>>> The later patch will use it to collapse tlb flushes
> >>>>
> >>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>>> ---
> >>>>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
> >>>>  1 files changed, 41 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>>> index 9b57faa..e676356 100644
> >>>> --- a/arch/x86/kvm/mmu.c
> >>>> +++ b/arch/x86/kvm/mmu.c
> >>>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> >>>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
> >>>>  {
> >>>>  	ASSERT(is_empty_shadow_page(sp->spt));
> >>>> -	hlist_del(&sp->hash_link);
> >>>> +	hlist_del_init(&sp->hash_link);
> >>> Why do you need hlist_del_init() here? Why not move it into
> >>
> >> Since the hlist will be double freed. We will it like this:
> >>
> >> kvm_mmu_prepare_zap_obsolete_page(page, list);
> >> kvm_mmu_commit_zap_page(list);
> >>    kvm_mmu_free_page(page);
> >>
> >> The first place is kvm_mmu_prepare_zap_obsolete_page(page), which have
> >> deleted the hash list.
> >>
> >>> kvm_mmu_prepare_zap_page() like we discussed it here:
> >>> https://patchwork.kernel.org/patch/2580351/ instead of doing
> >>> it differently for obsolete and non obsolete pages?
> >>
> >> It is can break the hash-list walking: we should rescan the
> >> hash list once the page is prepared-ly zapped.
> >>
> >> I mentioned it in the changelog:
> >>
> >>   4): drop the patch which deleted page from hash list at the "prepare"
> >>       time since it can break the walk based on hash list.
> > Can you elaborate on how this can happen?
> 
> There is a example:
> 
> int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
> {
> 	struct kvm_mmu_page *sp;
> 	LIST_HEAD(invalid_list);
> 	int r;
> 
> 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
> 	r = 0;
> 	spin_lock(&kvm->mmu_lock);
> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> 			 sp->role.word);
> 		r = 1;
> 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> 	}
> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> 	spin_unlock(&kvm->mmu_lock);
> 
> 	return r;
> }
> 
> It works fine since kvm_mmu_prepare_zap_page does not touch the hash list.
> If we delete hlist in kvm_mmu_prepare_zap_page(), this kind of codes should
> be changed to:
> 
> restart:
> 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> 			 sp->role.word);
> 		r = 1;
> 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> 			goto restart;
> 	}
> 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> 
Hmm, yes. So lets leave it as is and always commit invalid_list before
releasing lock in kvm_zap_obsolete_pages() or skip obsolete pages while
walking hash table. Former is clearer I think.

--
			Gleb.
