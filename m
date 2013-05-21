Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3EUIp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3EUIpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:45:55 -0400
Date: Tue, 21 May 2013 11:45:51 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
Message-ID: <20130521084551.GX4725@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:36:57AM +0800, Xiao Guangrong wrote:
> > So its better to just 
> > 
> > if (need_resched()) {
> > 	kvm_mmu_complete_zap_page(&list);
> 
> is kvm_mmu_commit_zap_page()?
> 
Also we need to check that someone waits on mmu_lock before entering
here.

> > 	cond_resched_lock(&kvm->mmu_lock);
> > }
> > 
> 
> Isn't it what Gleb said?
> 
It is.

> > If you want to collapse TLB flushes, please do it in a later patch.
> 
> Good to me.
> 
> > 
> >>>> +		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> >>>> +			goto restart;
> >>>> +	}
> >>>> +
> >>>> +	/*
> >>>> +	 * Should flush tlb before free page tables since lockless-walking
> >>>> +	 * may use the pages.
> >>>> +	 */
> >>>> +	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * Fast invalidate all shadow pages.
> >>>> + *
> >>>> + * @zap_obsolete_pages indicates whether all the obsolete pages should
> >>>> + * be zapped. This is required when memslot is being deleted or VM is
> >>>> + * being destroyed, in these cases, we should ensure that KVM MMU does
> >>>> + * not use any resource of the being-deleted slot or all slots after
> >>>> + * calling the function.
> >>>> + *
> >>>> + * @zap_obsolete_pages == false means the caller just wants to flush all
> >>>> + * shadow page tables.
> >>>> + */
> >>>> +void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
> >>>> +{
> >>>> +	spin_lock(&kvm->mmu_lock);
> >>>> +	kvm->arch.mmu_valid_gen++;
> >>>> +
> >>>> +	/*
> >>>> +	 * Notify all vcpus to reload its shadow page table
> >>>> +	 * and flush TLB. Then all vcpus will switch to new
> >>>> +	 * shadow page table with the new mmu_valid_gen.
> >>>
> >>> Only if you zap the roots, which we agreed would be a second step, after
> >>> being understood its necessary.
> >>>
> >> I've lost you here. The patch implement what was agreed upon.
> > 
> > "
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
> 
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
That's the part I do not understand from what Marcelo suggest: why would zap_root
be ever false after this loop?

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

--
			Gleb.
