Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3EGOng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:43:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab3EGOnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:43:35 -0400
Date: Tue, 7 May 2013 11:42:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130507144211.GC6408@amt.cnet>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130503010534.GA5467@amt.cnet>
 <51835087.8090605@linux.vnet.ibm.com>
 <20130503155302.GB3362@amt.cnet>
 <5183EAFA.4050500@linux.vnet.ibm.com>
 <20130504005201.GA11823@amt.cnet>
 <518725DF.5090503@linux.vnet.ibm.com>
 <20130506195022.GA5706@amt.cnet>
 <5188778F.9030804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5188778F.9030804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 11:39:59AM +0800, Xiao Guangrong wrote:
> >>> Step 1) Fix kvm_mmu_zap_all's behaviour: introduce lockbreak via
> >>> spin_needbreak. Use generation numbers so that in case kvm_mmu_zap_all 
> >>> releases mmu_lock and reacquires it again, only shadow pages 
> >>> from the generation with which kvm_mmu_zap_all started are zapped (this
> >>> guarantees forward progress and eventual termination).
> >>>
> >>> kvm_mmu_zap_generation()
> >>> 	spin_lock(mmu_lock)
> >>> 	int generation = kvm->arch.mmu_generation;
> >>>
> >>> 	for_each_shadow_page(sp) {
> >>> 		if (sp->generation == kvm->arch.mmu_generation)
> >>> 			zap_page(sp)
> >>> 		if (spin_needbreak(mmu_lock)) {
> >>> 			kvm->arch.mmu_generation++;
> >>> 			cond_resched_lock(mmu_lock);
> >>> 		}
> >>> 	}
> >>>
> >>> kvm_mmu_zap_all()
> >>> 	spin_lock(mmu_lock)
> >>> 	for_each_shadow_page(sp) {
> >>> 		if (spin_needbreak(mmu_lock)) {
> >>> 			cond_resched_lock(mmu_lock);
> >>> 		}
> >>> 	}
> >>>
> >>> Use kvm_mmu_zap_generation for kvm_arch_flush_shadow_memslot.
> >>> Use kvm_mmu_zap_all for kvm_mmu_notifier_release,kvm_destroy_vm.
> >>>
> >>> This addresses the main problem: excessively long hold times 
> >>> of kvm_mmu_zap_all with very large guests.
> >>>
> >>> Do you see any problem with this logic? This was what i was thinking 
> >>> we agreed.
> >>
> >> No. I understand it and it can work.
> >>
> >> Actually, it is similar with Gleb's idea that "zapping stale shadow pages
> >> (and uses lock break technique)", after some discussion, we thought "only zap
> >> shadow pages that are reachable from the slot's rmap" is better, that is this
> >> patchset does.
> >> (https://lkml.org/lkml/2013/4/23/73)
> >>
> >>>
> >>> Step 2) Show that the optimization to zap only the roots is worthwhile
> >>> via benchmarking, and implement it.
> >>
> >> This is what i am confused. I can not understand how "zap only the roots"
> >> works. You mean these change?
> >>
> >> kvm_mmu_zap_generation()
> >>  	spin_lock(mmu_lock)
> >>  	int generation = kvm->arch.mmu_generation;
> >>
> >>  	for_each_shadow_page(sp) {
> >> 		/* Change here. */
> >> => 		if ((sp->generation == kvm->arch.mmu_generation) &&
> >> =>		      sp->root_count)
> >>  			zap_page(sp)
> >>
> >>  		if (spin_needbreak(mmu_lock)) {
> >>  			kvm->arch.mmu_generation++;
> >>  			cond_resched_lock(mmu_lock);
> >>  		}
> >>  	}
> >>
> >> If we do this, there will have shadow pages that are linked to invalid memslot's
> >> rmap. How do we handle these pages and the mmu-notify issue?

No, this is a full kvm_mmu_zap_page().

In step 2, after demonstrating and understanding kvm_mmu_zap_page()'s inefficiency (which
we are not certain about, given the four use cases of slot
deletion/move/create), use something smarter than plain
kvm_mmu_zap_page.

> >> Thanks!
> > 
> > By "zap only roots" i mean zapping roots plus generation number on
> > shadow pages. But this as a second step, after it has been demonstrated
> > its worthwhile.
> 
> Marcelo,
> 
> Sorry for my stupidity, still do not understand. Could you please show me the
> pseudocode and answer my questions above?

Hopefully its clear now?

