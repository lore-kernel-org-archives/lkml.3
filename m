Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3EVBme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3EVBmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:42:32 -0400
Date: Tue, 21 May 2013 22:41:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
Message-ID: <20130522014151.GB8583@amt.cnet>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130520194624.GA21392@amt.cnet>
 <20130520201545.GC14287@redhat.com>
 <20130520204047.GA23364@amt.cnet>
 <519AEBD9.9040909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519AEBD9.9040909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:36:57AM +0800, Xiao Guangrong wrote:
> On 05/21/2013 04:40 AM, Marcelo Tosatti wrote:
> > On Mon, May 20, 2013 at 11:15:45PM +0300, Gleb Natapov wrote:
> >> On Mon, May 20, 2013 at 04:46:24PM -0300, Marcelo Tosatti wrote:
> >>> On Fri, May 17, 2013 at 05:12:58AM +0800, Xiao Guangrong wrote:
> >>>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
> >>>> walk and zap all shadow pages one by one, also it need to zap all guest
> >>>> page's rmap and all shadow page's parent spte list. Particularly, things
> >>>> become worse if guest uses more memory or vcpus. It is not good for
> >>>> scalability
> >>>>
> >>>> In this patch, we introduce a faster way to invalidate all shadow pages.
> >>>> KVM maintains a global mmu invalid generation-number which is stored in
> >>>> kvm->arch.mmu_valid_gen and every shadow page stores the current global
> >>>> generation-number into sp->mmu_valid_gen when it is created
> >>>>
> >>>> When KVM need zap all shadow pages sptes, it just simply increase the
> >>>> global generation-number then reload root shadow pages on all vcpus.
> >>>> Vcpu will create a new shadow page table according to current kvm's
> >>>> generation-number. It ensures the old pages are not used any more.
> >>>> Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
> >>>> are zapped by using lock-break technique
> >>>>
> >>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>>> ---
> >>>>  arch/x86/include/asm/kvm_host.h |    2 +
> >>>>  arch/x86/kvm/mmu.c              |  103 +++++++++++++++++++++++++++++++++++++++
> >>>>  arch/x86/kvm/mmu.h              |    1 +
> >>>>  3 files changed, 106 insertions(+), 0 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>> index 3741c65..bff7d46 100644
> >>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>> @@ -222,6 +222,7 @@ struct kvm_mmu_page {
> >>>>  	int root_count;          /* Currently serving as active root */
> >>>>  	unsigned int unsync_children;
> >>>>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
> >>>> +	unsigned long mmu_valid_gen;
> >>>>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
> >>>>  
> >>>>  #ifdef CONFIG_X86_32
> >>>> @@ -529,6 +530,7 @@ struct kvm_arch {
> >>>>  	unsigned int n_requested_mmu_pages;
> >>>>  	unsigned int n_max_mmu_pages;
> >>>>  	unsigned int indirect_shadow_pages;
> >>>> +	unsigned long mmu_valid_gen;
> >>>>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> >>>>  	/*
> >>>>  	 * Hash table of struct kvm_mmu_page.
> >>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>>> index 682ecb4..891ad2c 100644
> >>>> --- a/arch/x86/kvm/mmu.c
> >>>> +++ b/arch/x86/kvm/mmu.c
> >>>> @@ -1839,6 +1839,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
> >>>>  	__clear_sp_write_flooding_count(sp);
> >>>>  }
> >>>>  
> >>>> +static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >>>> +{
> >>>> +	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> >>>> +}
> >>>> +
> >>>>  static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >>>>  					     gfn_t gfn,
> >>>>  					     gva_t gaddr,
> >>>> @@ -1865,6 +1870,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >>>>  		role.quadrant = quadrant;
> >>>>  	}
> >>>>  	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
> >>>> +		if (is_obsolete_sp(vcpu->kvm, sp))
> >>>> +			continue;
> >>>> +
> >>>
> >>> Whats the purpose of not using pages which are considered "obsolete" ?
> >>>
> >> The same as not using page that is invalid, to not reuse stale
> >> information. The page may contain ptes that point to invalid slot.
> > 
> > Any pages with stale information will be zapped by kvm_mmu_zap_all().
> > When that happens, page faults will take place which will automatically 
> > use the new generation number.
> 
> kvm_mmu_zap_all() uses lock-break technique to zap pages, before it zaps
> all obsolete pages other vcpus can require mmu-lock and call kvm_mmu_get_page()
> to install new page. In this case, obsolete page still live in hast-table and
> can be found by kvm_mmu_get_page().

There is an assumption in that modification that its worthwhile to
"prefault" pages as soon as kvm_mmu_zap_all() is detected. So its a
heuristic. 

Please move it to a separate patch, as an optimization.

(*) marker

> > spin_lock(mmu_lock)
> > shadow page = lookup page on hash list
> > if (shadow page is not found)
> > 	proceed assuming the page has been properly deleted (*)
> > spin_unlock(mmu_lock)
> > 
> > At (*) we assume it has been 1) deleted and 2) TLB flushed.
> > 
> > So its better to just 
> > 
> > if (need_resched()) {
> > 	kvm_mmu_complete_zap_page(&list);
> 
> is kvm_mmu_commit_zap_page()?

Yeah.

> 
> > 	cond_resched_lock(&kvm->mmu_lock);
> > }
> > 
> 
> Isn't it what Gleb said?
> 
> > If you want to collapse TLB flushes, please do it in a later patch.
> 
> Good to me.

OK thanks.

> > + /*
> > +  * Notify all vcpus to reload its shadow page table
> > +  * and flush TLB. Then all vcpus will switch to new
> > +  * shadow page table with the new mmu_valid_gen.
> > "
> > 
> > What was suggested was... go to phrase which starts with "The only purpose
> > of the generation number should be to".
> > 
> > The comment quoted here does not match that description.
> 
> So, is this your want?

This 

"
* Notify all vcpus to reload its shadow page table
* and flush TLB. Then all vcpus will switch to new
* shadow page table with the new mmu_valid_gen.
"

Should be in a later patch, where prefault behaviour (see the first
comment) is introduced, see the "(*) marker" comment.

Note sure about the below (perhaps separately i can understand).

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2c512e8..2fd4c04 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4275,10 +4275,19 @@ restart:
>   */
>  void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
>  {
> +       bool zap_root = fase;
> +       struct kvm_mmu_page *sp;
> +
>         spin_lock(&kvm->mmu_lock);
>         trace_kvm_mmu_invalidate_all_pages(kvm, zap_obsolete_pages);
>         kvm->arch.mmu_valid_gen++;
> 
> +       list_for_each_entry(sp, kvm->arch.active_mmu_pages, link)
> +               if (sp->root_count && !sp->role.invalid) {
> +                       zap_root = true;
> +                       break;
> +               }
> +
>         /*
>          * Notify all vcpus to reload its shadow page table
>          * and flush TLB. Then all vcpus will switch to new
> @@ -4288,7 +4297,8 @@ void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
>          * mmu-lock, otherwise, vcpu would purge shadow page
>          * but miss tlb flush.
>          */
> -       kvm_reload_remote_mmus(kvm);
> +       if (zap_root)
> +               kvm_reload_remote_mmus(kvm);
> 
>         if (zap_obsolete_pages)
>                 kvm_zap_obsolete_pages(kvm);
> 
> > 
> >>>> +	 *
> >>>> +	 * Note: we should do this under the protection of
> >>>> +	 * mmu-lock, otherwise, vcpu would purge shadow page
> >>>> +	 * but miss tlb flush.
> >>>> +	 */
> >>>> +	kvm_reload_remote_mmus(kvm);
> >>>> +
> >>>> +	if (zap_obsolete_pages)
> >>>> +		kvm_zap_obsolete_pages(kvm);
> >>>
> >>> Please don't condition behaviour on parameters like this, its confusing. 
> >>> Can probably just use
> >>>
> >>> spin_lock(&kvm->mmu_lock);
> >>> kvm->arch.mmu_valid_gen++;
> >>> kvm_reload_remote_mmus(kvm);
> >>> spin_unlock(&kvm->mmu_lock);
> >>>
> >>> Directly when needed.
> >>
> >> Please, no. Better have one place where mmu_valid_gen is
> >> handled. If parameter is confusing better have two functions:
> >> kvm_mmu_invalidate_all_pages() and kvm_mmu_invalidate_zap_all_pages(),
> >> but to minimize code duplication they will call the same function with
> >> a parameter anyway, so I am not sure this is a win.
> > 
> > OK.
> 
> Will introduce these two functions.
> 
> Thank you all. ;)
> 
