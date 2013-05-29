Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965913Ab3E2Mk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:40:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536Ab3E2MkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:40:25 -0400
Date: Wed, 29 May 2013 09:25:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] KVM: MMU: introduce
 kvm_mmu_prepare_zap_obsolete_page
Message-ID: <20130529122552.GB5931@amt.cnet>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130528001302.GA1359@amt.cnet>
 <51A4C47A.7090405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A4C47A.7090405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:51:38PM +0800, Xiao Guangrong wrote:
> On 05/28/2013 08:13 AM, Marcelo Tosatti wrote:
> > On Thu, May 23, 2013 at 03:55:58AM +0800, Xiao Guangrong wrote:
> >> It is only used to zap the obsolete page. Since the obsolete page
> >> will not be used, we need not spend time to find its unsync children
> >> out. Also, we delete the page from shadow page cache so that the page
> >> is completely isolated after call this function.
> >>
> >> The later patch will use it to collapse tlb flushes
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
> >>  1 files changed, 41 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 9b57faa..e676356 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> >>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
> >>  {
> >>  	ASSERT(is_empty_shadow_page(sp->spt));
> >> -	hlist_del(&sp->hash_link);
> >> +	hlist_del_init(&sp->hash_link);
> >>  	list_del(&sp->link);
> >>  	free_page((unsigned long)sp->spt);
> >>  	if (!sp->role.direct)
> >> @@ -2069,14 +2069,19 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
> >>  	return zapped;
> >>  }
> >>  
> >> -static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> >> -				    struct list_head *invalid_list)
> >> +static int
> >> +__kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> >> +			   bool zap_unsync_children,
> >> +			   struct list_head *invalid_list)
> >>  {
> >> -	int ret;
> >> +	int ret = 0;
> >>  
> >>  	trace_kvm_mmu_prepare_zap_page(sp);
> >>  	++kvm->stat.mmu_shadow_zapped;
> >> -	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
> >> +
> >> +	if (likely(zap_unsync_children))
> >> +		ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
> >> +
> > 
> > Why is this an important case to be optimized?
> > 
> > 1) shadow is the uncommon, obsolete case.
> > 2) mmu_zap_unsync_children has
> > 
> >         if (parent->role.level == PT_PAGE_TABLE_LEVEL)
> >                 return 0;
> > 
> > So the large majority of pages are already optimized.
> 
> Hmm, if we zap the high level page (e.g level = 4), it should walk its
> children and its children's children. It is high overload.
> (IMHO, trivial optimization is still necessary, especially, the change
> is really slight.)
> 
> And, there is another point me mentioned in the changelog:
> "Also, we delete the page from shadow page cache so that the page
> is completely isolated after call this function."
> Skipping zapping unsync-children can ensure that only one page is
> zapped so that we can use "hlist_del_init(&sp->hash_link)" to completely
> remove the page from mmu-cache.
> 
> Now, Gleb and i got a agreement that skipping obsolete page when
> walking hash list is a better way.
> 
> BTW, zapping unsync-children is unnecessary, is it?

It is necessary that if an unsync page exists, that 
invlpg emulation is able to reach it, or that at kvm_mmu_get_page 
time they are synchronized.

You transfer the synchronization work to pagefault time, which directly
affects guest performance, while it could have been done by the host
(this was the reason for zapping unsync children).

