Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3JJBrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3JJBrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:47:47 -0400
Date: Wed, 9 Oct 2013 22:47:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-ID: <20131010014710.GA2198@amt.cnet>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131008012355.GA3588@amt.cnet>
 <CAD6C3B4-DD55-47EB-9BC0-17867937AE2D@gmail.com>
 <20131009015627.GA4816@amt.cnet>
 <525533DB.1060104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <525533DB.1060104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 06:45:47PM +0800, Xiao Guangrong wrote:
> On 10/09/2013 09:56 AM, Marcelo Tosatti wrote:
> > On Tue, Oct 08, 2013 at 12:02:32PM +0800, Xiao Guangrong wrote:
> >>
> >> Hi Marcelo,
> >>
> >> On Oct 8, 2013, at 9:23 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >>
> >>>>
> >>>> +	if (kvm->arch.rcu_free_shadow_page) {
> >>>> +		kvm_mmu_isolate_pages(invalid_list);
> >>>> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> >>>> +		list_del_init(invalid_list);
> >>>> +		call_rcu(&sp->rcu, free_pages_rcu);
> >>>> +		return;
> >>>> +	}
> >>>
> >>> This is unbounded (there was a similar problem with early fast page fault
> >>> implementations):
> >>>
> >>> From RCU/checklist.txt:
> >>>
> >>> "        An especially important property of the synchronize_rcu()
> >>>        primitive is that it automatically self-limits: if grace periods
> >>>        are delayed for whatever reason, then the synchronize_rcu()
> >>>        primitive will correspondingly delay updates.  In contrast,
> >>>        code using call_rcu() should explicitly limit update rate in
> >>>        cases where grace periods are delayed, as failing to do so can
> >>>        result in excessive realtime latencies or even OOM conditions.
> >>> "
> >>
> >> I understand what you are worrying about… Hmm, can it be avoided by
> >> just using kvm->arch.rcu_free_shadow_page in a small window? - Then
> >> there are slight chance that the page need to be freed by call_rcu.
> > 
> > The point that must be addressed is that you cannot allow an unlimited
> > number of sp's to be freed via call_rcu between two grace periods.
> > 
> > So something like:
> > 
> > - For every 17MB worth of shadow pages.
> > - Guarantee a grace period has passed.
> 
> Hmm, the 'qhimark' in rcu is 10000, that means rcu allows call_rcu
> to pend 10000 times in a grace-period without slowdown. Can we really
> reach this number while rcu_free_shadow_page is set? Anyway, if it can,
> we can use rcu tech-break to avoid it, can't we?

Yes.

> > If you control kvm->arch.rcu_free_shadow_page, you could periodically
> > verify how many MBs worth of shadow pages are in the queue for RCU
> > freeing and force grace period after a certain number.
> 
> I have no idea how to froce grace-period for the cpu which is running
> in rcu-read side. IIUC, only dyntick-idle and offline CPU can be froced,
> see rcu_gp_fqs().

synchronize_rcu.

> >>> Moreover, freeing pages differently depending on some state should 
> >>> be avoided.
> >>>
> >>> Alternatives:
> >>>
> >>> - Disable interrupts at write protect sites.
> >>
> >> The write-protection can be triggered by KVM ioctl that is not in the VCPU
> >> context, if we do this, we also need to send IPI to the KVM thread when do
> >> TLB flush.
> > 
> > Yes. However for the case being measured, simultaneous page freeing by vcpus 
> > should be minimal (therefore not affecting the latency of GET_DIRTY_LOG).
> 
> I agree, but write-protection will cost lots of time, we need to:
> 1) do write-protection under irq disabled, that is not good for device
> Or
> 2) do pieces of works, then enable irq and disable it agian to continue
>    the work. Enabling and disabing irq many times are not cheap for x86.
> 
> no?

Its getting cheaper (see performance optimization guide).

> >> And we can not do much work while interrupt is disabled due to
> >> interrupt latency.
> >>
> >>> - Rate limit the number of pages freed via call_rcu
> >>> per grace period.
> >>
> >> Seems complex. :(
> >>
> >>> - Some better alternative.
> >>
> >> Gleb has a idea that uses RCU_DESTORY to protect the shadow page table
> >> and encodes the page-level into the spte (since we need to check if the spte
> >> is the last-spte. ).  How about this?
> > 
> > Pointer please? Why is DESTROY_SLAB_RCU any safer than call_rcu with
> > regards to limitation? (maybe it is).
> 
> For my experience, freeing shadow page and allocing shadow page are balanced,
> we can check it by (make -j12 on a guest with 4 vcpus and):
> 
> # echo > trace
> [root@eric-desktop tracing]# cat trace > ~/log | sleep 3
> [root@eric-desktop tracing]# cat ~/log | grep new | wc -l
> 10816
> [root@eric-desktop tracing]# cat ~/log | grep prepare | wc -l
> 10656
> [root@eric-desktop tracing]# cat set_event
> kvmmmu:kvm_mmu_get_page
> kvmmmu:kvm_mmu_prepare_zap_page
> 
> alloc VS. free = 10816 : 10656
> 
> So that, mostly all allocing and freeing are done in the slab's
> cache and the slab frees shdadow pages very slowly, there is no rcu issue.

A more detailed test case would be:

- cpu0-vcpu0 releasing pages as fast as possible
- cpu1 executing get_dirty_log

Think of a very large guest.

> >> I planned to do it after this patchset merged, if you like it and if you think
> >> that "using kvm->arch.rcu_free_shadow_page in a small window" can not avoid
> >> the issue, i am happy to do it in the next version. :)
> > 
> > Unfortunately the window can be large (as it depends on the size of the
> > memslot), so it would be best if this problem can be addressed before 
> > merging. What is your idea for reducing rcu_free_shadow_page=1 window?
> > 
> 
> I mean something like:
> 
> for (i =0; i <= page_nr; i++) {
>     rcu_free_shadow_page=1;
>     write_protect(&rmap[i]);
>     rcu_free_shadow_page=0;
> }
> 
> we write-protect less entries per time rather than a memslot.
> 
> BTW, i think rcu_need_break() would be usefull for this case, then the
> rcu_read side do not dealy synchronize_rcu() too much.

Yes, that works, you'd have to synchronize_sched eventually, depending on the
count of pending pages to be freed via RCU (so that rate limiting is
performed).

Or, you could bound the problematic callsites, those that can free a
large number of shadow pages (mmu_shrink, kvm_mmu_change_mmu_pages,
...), and limit there:

if (spin_needbreak(mmu_lock) || (sp_pending_rcu_free > sp_pending_rcu_free_max)) {
		if (sp_pending...)
			synchronize_rcu();
}

And any other code path that can possibly free pages, outside locks of
course (even those that can free 1 page). In a similar fashion as to how
the per-vcpu mmu object slabs are grown.

