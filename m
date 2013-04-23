Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3DWHdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:33:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab3DWHdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:33:21 -0400
Date: Tue, 23 Apr 2013 10:33:16 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Message-ID: <20130423073315.GD12401@redhat.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130421130346.GE8997@redhat.com>
 <5173F319.2040106@linux.vnet.ibm.com>
 <20130422092117.GM8997@redhat.com>
 <5175D376.6060908@linux.vnet.ibm.com>
 <20130423062816.GC12401@redhat.com>
 <5176363C.10303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5176363C.10303@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:20:28PM +0800, Xiao Guangrong wrote:
> On 04/23/2013 02:28 PM, Gleb Natapov wrote:
> > On Tue, Apr 23, 2013 at 08:19:02AM +0800, Xiao Guangrong wrote:
> >> On 04/22/2013 05:21 PM, Gleb Natapov wrote:
> >>> On Sun, Apr 21, 2013 at 10:09:29PM +0800, Xiao Guangrong wrote:
> >>>> On 04/21/2013 09:03 PM, Gleb Natapov wrote:
> >>>>> On Tue, Apr 16, 2013 at 02:32:38PM +0800, Xiao Guangrong wrote:
> >>>>>> This patchset is based on my previous two patchset:
> >>>>>> [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
> >>>>>> (https://lkml.org/lkml/2013/4/1/2)
> >>>>>>
> >>>>>> [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
> >>>>>> (https://lkml.org/lkml/2013/4/1/134)
> >>>>>>
> >>>>>> Changlog:
> >>>>>> V3:
> >>>>>>   completely redesign the algorithm, please see below.
> >>>>>>
> >>>>> This looks pretty complicated. Is it still needed in order to avoid soft
> >>>>> lockups after "avoid potential soft lockup and unneeded mmu reload" patch?
> >>>>
> >>>> Yes.
> >>>>
> >>>> I discussed this point with Marcelo:
> >>>>
> >>>> ======
> >>>> BTW, to my honest, i do not think spin_needbreak is a good way - it does
> >>>> not fix the hot-lock contention and it just occupies more cpu time to avoid
> >>>> possible soft lock-ups.
> >>>>
> >>>> Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
> >>>> mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
> >>>> create page tables again. zap-all-shadow-page need long time to be finished,
> >>>> the worst case is, it can not completed forever on intensive vcpu and memory
> >>>> usage.
> >>>>
> >>> So what about mixed approach: use generation numbers and reload roots to
> >>> quickly invalidate all shadow pages and then do kvm_mmu_zap_all_invalid().
> >>> kvm_mmu_zap_all_invalid() is a new function that invalidates only shadow
> >>> pages with stale generation number (and uses lock break technique). It
> >>> may traverse active_mmu_pages from tail to head since new shadow pages
> >>> will be added to the head of the list or it may use invalid slot rmap to
> >>> find exactly what should be invalidated.
> >>
> >> I prefer to unmapping the invalid rmap instead of zapping stale shadow pages
> >> in kvm_mmu_zap_all_invalid(), the former is faster.
> >>
> > Not sure what do you mean here. What is "unmapping the invalid rmap"?
> 
> it is like you said below:
> ======
> kvm_mmu_zap_all_invalid(slot) will only zap shadow pages that are
> reachable from the slot's rmap
> ======
> My suggestion is zapping the spte that are linked in the slot's rmap.
> 
OK, so we are on the same page.

> > 
> >> This way may help but not good, after reload mmu with the new generation number,
> >> all of the vcpu will fault in a long time, try to hold mmu-lock is not good even
> >> if use lock break technique.
> > If kvm_mmu_zap_all_invalid(slot) will only zap shadow pages that are
> > reachable from the slot's rmap, as opposite to zapping all invalid
> > shadow pages, it will have much less work to do. The slots that we
> > add/remove during hot plug are usually small. To guaranty reasonable
> > forward progress we can break the lock only after certain amount of
> > shadow pages are invalidated. All other invalid shadow pages will be
> > zapped in make_mmu_pages_available() and zapping will be spread between
> > page faults.
> 
> No interested in hot-remove memory?
> 
I am, good point. Still, I think, that with guarantied forward progress the
slot removal time should be bound to something reasonable. At least we
should have evidence of the contrary before optimizing for it. Hot
memory remove is not instantaneous from guest point of view either,
guest needs to move memory around to make it possible.

> BTW, could you please review my previous patchsets and apply them if its
> looks ok? ;)
> 
I need Marcelo's acks on them too :)

> [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
> (https://lkml.org/lkml/2013/4/1/2)
> 
But you yourself saying that with this patch slot remove may never
complete with high memory usage workload.

> [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
> (https://lkml.org/lkml/2013/4/1/134)
> 
Missed this one. Will review.

--
			Gleb.
