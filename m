Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3EVNSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:18:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3EVNR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:17:59 -0400
Date: Wed, 22 May 2013 16:17:20 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
Message-ID: <20130522131720.GO14287@redhat.com>
References: <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130520194624.GA21392@amt.cnet>
 <20130520201545.GC14287@redhat.com>
 <20130520204047.GA23364@amt.cnet>
 <20130521083902.GW4725@redhat.com>
 <20130522013330.GA8583@amt.cnet>
 <20130522063413.GL14287@redhat.com>
 <519C85CC.6040103@linux.vnet.ibm.com>
 <20130522085410.GM14287@redhat.com>
 <519C92B6.1020405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C92B6.1020405@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 05:41:10PM +0800, Xiao Guangrong wrote:
> On 05/22/2013 04:54 PM, Gleb Natapov wrote:
> > On Wed, May 22, 2013 at 04:46:04PM +0800, Xiao Guangrong wrote:
> >> On 05/22/2013 02:34 PM, Gleb Natapov wrote:
> >>> On Tue, May 21, 2013 at 10:33:30PM -0300, Marcelo Tosatti wrote:
> >>>> On Tue, May 21, 2013 at 11:39:03AM +0300, Gleb Natapov wrote:
> >>>>>> Any pages with stale information will be zapped by kvm_mmu_zap_all().
> >>>>>> When that happens, page faults will take place which will automatically 
> >>>>>> use the new generation number.
> >>>>>>
> >>>>>> So still not clear why is this necessary.
> >>>>>>
> >>>>> This is not, strictly speaking, necessary, but it is the sane thing to do.
> >>>>> You cannot update page's generation number to prevent it from been
> >>>>> destroyed since after kvm_mmu_zap_all() completes stale ptes in the
> >>>>> shadow page may point to now deleted memslot. So why build shadow page
> >>>>> table with a page that is in a process of been destroyed?
> >>>>
> >>>> OK, can this be introduced separately, in a later patch, with separate
> >>>> justification, then?
> >>>>
> >>>> Xiao please have the first patches of the patchset focus on the problem
> >>>> at hand: fix long mmu_lock hold times.
> >>>>
> >>>>> Not sure what you mean again. We flush TLB once before entering this function.
> >>>>> kvm_reload_remote_mmus() does this for us, no?
> >>>>
> >>>> kvm_reload_remote_mmus() is used as an optimization, its separate from the
> >>>> problem solution.
> >>>>
> >>>>>>
> >>>>>> What was suggested was... go to phrase which starts with "The only purpose
> >>>>>> of the generation number should be to".
> >>>>>>
> >>>>>> The comment quoted here does not match that description.
> >>>>>>
> >>>>> The comment describes what code does and in this it is correct.
> >>>>>
> >>>>> You propose to not reload roots right away and do it only when root sp
> >>>>> is encountered, right? So my question is what's the point? There are,
> >>>>> obviously, root sps with invalid generation number at this point, so
> >>>>> reload will happen regardless in kvm_mmu_prepare_zap_page(). So why not
> >>>>> do it here right away and avoid it in kvm_mmu_prepare_zap_page() for
> >>>>> invalid and obsolete sps as I proposed in one of my email?
> >>>>
> >>>> Sure. But Xiao please introduce that TLB collapsing optimization as a
> >>>> later patch, so we can reason about it in a more organized fashion.
> >>>
> >>> So, if I understand correctly, you are asking to move is_obsolete_sp()
> >>> check from kvm_mmu_get_page() and kvm_reload_remote_mmus() from
> >>> kvm_mmu_invalidate_all_pages() to a separate patch. Fine by me, but if
> >>> we drop kvm_reload_remote_mmus() from kvm_mmu_invalidate_all_pages() the
> >>> call to kvm_mmu_invalidate_all_pages() in emulator_fix_hypercall() will
> >>> become nop. But I question the need to zap all shadow pages tables there
> >>> in the first place, why kvm_flush_remote_tlbs() is not enough?
> >>
> >> I do not know too... I even do no know why kvm_flush_remote_tlbs
> >> is needed. :(
> > We changed the content of an executable page, we need to flush instruction
> > cache of all vcpus to not use stale data, so my suggestion to call
> 
> I thought the reason is about icache too but icache is automatically
> flushed on x86, we only need to invalidate the prefetched instructions by
> executing a serializing operation.
> 
> See the SDM in the chapter of
> "8.1.3 Handling Self- and Cross-Modifying Code"
> 
Right, so we do cross-modifying code here and we need to make sure no
vcpu is running in a guest mode while this happens, but
kvm_mmu_zap_all() does not provide this guaranty since vcpus will
continue running after reloading roots!
 
> > kvm_flush_remote_tlbs() is obviously incorrect since this flushes tlb,
> > not instruction cache, but why kvm_reload_remote_mmus() would flush
> > instruction cache?
> 
> kvm_reload_remote_mmus do not have any help i think.
> 
> I find that this change is introduced by commit: 7aa81cc0
> and I have added Anthony in the CC.
> 
> I also find some discussions related to calling
> kvm_reload_remote_mmus():
> 
> >
> > But if the instruction is architecture dependent, and you run on the
> > wrong architecture, now you have to patch many locations at fault time,
> > introducing some nasty runtime code / data cache overlap performance
> > problems.  Granted, they go away eventually.
> >
> 
> We're addressing that by blowing away the shadow cache and holding the
> big kvm lock to ensure SMP safety.  Not a great thing to do from a
> performance perspective but the whole point of patching is that the cost
> is amortized.
> 
> (http://kerneltrap.org/mailarchive/linux-kernel/2007/9/14/260288)
> 
> But i can not understand...
Back then kvm->lock protected memslot access so code like:

mutex_lock(&vcpu->kvm->lock);
kvm_mmu_zap_all(vcpu->kvm);
mutex_unlock(&vcpu->kvm->lock);

which is what 7aa81cc0 does was enough to guaranty that no vcpu will
run while code is patched. This is no longer the case and
mutex_lock(&vcpu->kvm->lock); is gone from that code path long time ago,
so now kvm_mmu_zap_all() there is useless and the code is incorrect.

Lets drop kvm_mmu_zap_all() there (in separate patch) and fix the
patching properly later.

--
			Gleb.
