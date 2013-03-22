Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3CVLrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3CVLrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:47:19 -0400
Date: Fri, 22 Mar 2013 13:47:15 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
Message-ID: <20130322114715.GW9382@redhat.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130321222151.GA19821@amt.cnet>
 <514BBDC5.6090104@linux.vnet.ibm.com>
 <20130322105436.GC7543@amt.cnet>
 <514C3C34.4080906@linux.vnet.ibm.com>
 <20130322112811.GV9382@redhat.com>
 <514C42EC.6000303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514C42EC.6000303@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 07:39:24PM +0800, Xiao Guangrong wrote:
> On 03/22/2013 07:28 PM, Gleb Natapov wrote:
> > On Fri, Mar 22, 2013 at 07:10:44PM +0800, Xiao Guangrong wrote:
> >> On 03/22/2013 06:54 PM, Marcelo Tosatti wrote:
> >>
> >>>>
> >>>>>
> >>>>> And then have codepaths that nuke shadow pages break from the spinlock,
> >>>>
> >>>> I think this is not needed any more. We can let mmu_notify use the generation
> >>>> number to invalid all shadow pages, then we only need to free them after
> >>>> all vcpus down and mmu_notify unregistered - at this point, no lock contention,
> >>>> we can directly free them.
> >>>>
> >>>>> such as kvm_mmu_slot_remove_write_access does now (spin_needbreak).
> >>>>
> >>>> BTW, to my honest, i do not think spin_needbreak is a good way - it does
> >>>> not fix the hot-lock contention and it just occupies more cpu time to avoid
> >>>> possible soft lock-ups.
> >>>>
> >>>> Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
> >>>> mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
> >>>> create page tables again. zap-all-shadow-page need long time to be finished,
> >>>> the worst case is, it can not completed forever on intensive vcpu and memory
> >>>> usage.
> >>>
> >>> Yes, but the suggestion is to use spin_needbreak on the VM shutdown
> >>> cases, where there is no detailed concern about performance. Such as
> >>> mmu_notifier_release, kvm_destroy_vm, etc. In those cases what matters
> >>> most is that host remains unaffected (and that it finishes in a
> >>> reasonable time).
> >>
> >> Okay. I agree with you, will give a try.
> >>
> >>>
> >>>> I still think the right way to fix this kind of thing is optimization for
> >>>> mmu-lock.
> >>>
> >>> And then for the cases where performance matters just increase a
> >>> VM global generetion number, zap the roots and then on kvm_mmu_get_page:
> >>>
> >>> kvm_mmu_get_page() {
> >>> 	sp = lookup_hash(gfn)
> >>> 	if (sp->role = role) {
> >>> 		if (sp->mmu_gen_number != kvm->arch.mmu_gen_number) {
> >>> 			kvm_mmu_commit_zap_page(sp); (no need for TLB flushes as its unreachable)
> >>> 			kvm_mmu_init_page(sp);
> >>> 			proceed as if the page was just allocated
> >>> 		}
> >>> 	}
> >>> }
> >>>
> >>> It makes the kvm_mmu_zap_all path even faster than you have now.
> >>> I suppose this was your idea correct with the generation number correct?
> >>
> >> Wow, great minds think alike, this is exactly what i am doing. ;)
> >>
> > Not that I disagree with above code, but why not make mmu_gen_number to be
> > part of a role and remove old pages in kvm_mmu_free_some_pages() whenever
> > limit is reached like we looks to be doing with role.invalid pages now.
> 
> These pages can be reused after purge its entries and delete it from parents
> list, it can reduce the pressure of memory allocator. Also, we can move it to
> the head of active_list so that the pages with invalid_gen can be reclaimed first.
> 
You mean tail of the active_list, since kvm_mmu_free_some_pages()
removes pages from tail? Since pages with new mmu_gen_number will be put
at the head of the list it is natural that tail will contain pages with
outdated generation numbers without need to explicitly move them.

--
			Gleb.
