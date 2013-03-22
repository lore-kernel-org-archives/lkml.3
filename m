Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3CVK4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:56:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab3CVK4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:56:45 -0400
Date: Fri, 22 Mar 2013 07:54:36 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
Message-ID: <20130322105436.GC7543@amt.cnet>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130321222151.GA19821@amt.cnet>
 <514BBDC5.6090104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514BBDC5.6090104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:11:17AM +0800, Xiao Guangrong wrote:
> On 03/22/2013 06:21 AM, Marcelo Tosatti wrote:
> > On Wed, Mar 20, 2013 at 04:30:20PM +0800, Xiao Guangrong wrote:
> >> Changlog:
> >> V2:
> >>   - do not reset n_requested_mmu_pages and n_max_mmu_pages
> >>   - batch free root shadow pages to reduce vcpu notification and mmu-lock
> >>     contention
> >>   - remove the first patch that introduce kvm->arch.mmu_cache since we only
> >>     'memset zero' on hashtable rather than all mmu cache members in this
> >>     version
> >>   - remove unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all
> >>
> >> * Issue
> >> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
> >> walk and zap all shadow pages one by one, also it need to zap all guest
> >> page's rmap and all shadow page's parent spte list. Particularly, things
> >> become worse if guest uses more memory or vcpus. It is not good for
> >> scalability.
> > 
> > Xiao, 
> > 
> > The bulk removal of shadow pages from mmu cache is nerving - it creates
> > two codepaths to delete a data structure: the usual, single entry one
> > and the bulk one.
> > 
> > There are two main usecases for kvm_mmu_zap_all(): to invalidate the
> > current mmu tree (from kvm_set_memory) and to tear down all pages
> > (VM shutdown).
> > 
> > The first usecase can use your idea of an invalid generation number
> > on shadow pages. That is, increment the VM generation number, nuke the root
> > pages and thats it. 
> > 
> > The modifications should be contained to kvm_mmu_get_page() mostly,
> > correct? (would also have to keep counters to increase SLAB freeing 
> > ratio, relative to number of outdated shadow pages).
> 
> Yes.
> 
> > 
> > And then have codepaths that nuke shadow pages break from the spinlock,
> 
> I think this is not needed any more. We can let mmu_notify use the generation
> number to invalid all shadow pages, then we only need to free them after
> all vcpus down and mmu_notify unregistered - at this point, no lock contention,
> we can directly free them.
> 
> > such as kvm_mmu_slot_remove_write_access does now (spin_needbreak).
> 
> BTW, to my honest, i do not think spin_needbreak is a good way - it does
> not fix the hot-lock contention and it just occupies more cpu time to avoid
> possible soft lock-ups.
>
> Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
> mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
> create page tables again. zap-all-shadow-page need long time to be finished,
> the worst case is, it can not completed forever on intensive vcpu and memory
> usage.

Yes, but the suggestion is to use spin_needbreak on the VM shutdown
cases, where there is no detailed concern about performance. Such as
mmu_notifier_release, kvm_destroy_vm, etc. In those cases what matters
most is that host remains unaffected (and that it finishes in a
reasonable time).

> I still think the right way to fix this kind of thing is optimization for
> mmu-lock.

And then for the cases where performance matters just increase a
VM global generetion number, zap the roots and then on kvm_mmu_get_page:

kvm_mmu_get_page() {
	sp = lookup_hash(gfn)
	if (sp->role = role) {
		if (sp->mmu_gen_number != kvm->arch.mmu_gen_number) {
			kvm_mmu_commit_zap_page(sp); (no need for TLB flushes as its unreachable)
			kvm_mmu_init_page(sp);
			proceed as if the page was just allocated
		}
	}
}

It makes the kvm_mmu_zap_all path even faster than you have now.
I suppose this was your idea correct with the generation number correct?

