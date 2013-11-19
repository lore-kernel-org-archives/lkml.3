Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3KSAT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:19:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3KSATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:19:55 -0500
Date: Mon, 18 Nov 2013 22:19:38 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/15] KVM: MMU: flush tlb out of mmu lock when
 write-protect the sptes
Message-ID: <20131119001938.GA21435@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131114003609.GA15692@amt.cnet>
 <52845C6C.6060708@linux.vnet.ibm.com>
 <20131114183959.GA27064@amt.cnet>
 <5285C899.6040005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5285C899.6040005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:09:13PM +0800, Xiao Guangrong wrote:
> On 11/15/2013 02:39 AM, Marcelo Tosatti wrote:
> > On Thu, Nov 14, 2013 at 01:15:24PM +0800, Xiao Guangrong wrote:
> >>
> >> Hi Marcelo,
> >>
> >> On 11/14/2013 08:36 AM, Marcelo Tosatti wrote:
> >>
> >>>
> >>> Any code location which reads the writable bit in the spte and assumes if its not
> >>> set, that the translation which the spte refers to is not cached in a
> >>> remote CPU's TLB can become buggy. (*)
> >>>
> >>> It might be the case that now its not an issue, but its so subtle that
> >>> it should be improved.
> >>>
> >>> Can you add a fat comment on top of is_writeable_bit describing this?
> >>> (and explain why is_writable_pte users do not make an assumption
> >>> about (*). 
> >>>
> >>> "Writeable bit of locklessly modifiable sptes might be cleared
> >>> but TLBs not flushed: so whenever reading locklessly modifiable sptes
> >>> you cannot assume TLBs are flushed".
> >>>
> >>> For example this one is unclear:
> >>>
> >>>                 if (!can_unsync && is_writable_pte(*sptep))
> >>>                         goto set_pte;
> >>> And:
> >>>
> >>>         if (!is_writable_pte(spte) &&
> >>>               !(pt_protect && spte_is_locklessly_modifiable(spte)))
> >>>                 return false;
> >>>
> >>> This is safe because get_dirty_log/kvm_mmu_slot_remove_write_access are
> >>> serialized by a single mutex (if there were two mutexes, it would not be
> >>> safe). Can you add an assert to both
> >>> kvm_mmu_slot_remove_write_access/kvm_vm_ioctl_get_dirty_log 
> >>> for (slots_lock) is locked, and explain?
> >>>
> >>> So just improve the comments please, thanks (no need to resend whole
> >>> series).
> >>
> >> Thank you very much for your time to review it and really appreciate
> >> for you detailed the issue so clearly to me.
> >>
> >> I will do it on the top of this patchset or after it is merged
> >> (if it's possiable).
> > 
> > Ok, can you explain why every individual caller of is_writable_pte have
> > no such assumption now? (the one mentioned above is not clear to me for
> > example, should explain all of them).
> 
> Okay.

OK, thanks for checking.

> Generally speak, we 1) needn't care readonly spte too much since it
> can not be locklessly write-protected and 2) if is_writable_pte() is used
> to check mmu-mode's state we can check SPTE_MMU_WRITEABLE instead.
> 
> There are the places is_writable_pte is used:
> 1) in spte_has_volatile_bits():
>  527 static bool spte_has_volatile_bits(u64 spte)
>  528 {
>  529         /*
>  530          * Always atomicly update spte if it can be updated
>  531          * out of mmu-lock, it can ensure dirty bit is not lost,
>  532          * also, it can help us to get a stable is_writable_pte()
>  533          * to ensure tlb flush is not missed.
>  534          */
>  535         if (spte_is_locklessly_modifiable(spte))
>  536                 return true;
>  537
>  538         if (!shadow_accessed_mask)
>  539                 return false;
>  540
>  541         if (!is_shadow_present_pte(spte))
>  542                 return false;
>  543
>  544         if ((spte & shadow_accessed_mask) &&
>  545               (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
>  546                 return false;
>  547
>  548         return true;
>  549 }
> 
> this path is not broken since any spte can be lockless modifiable will do
> lockless update (will always return 'true' in  the line 536).
> 
> 2): in mmu_spte_update()
> 594         /*
>  595          * For the spte updated out of mmu-lock is safe, since
>  596          * we always atomicly update it, see the comments in
>  597          * spte_has_volatile_bits().
>  598          */
>  599         if (spte_is_locklessly_modifiable(old_spte) &&
>  600               !is_writable_pte(new_spte))
>  601                 ret = true;
> 
> The new_spte is a temp value that can not be fetched by lockless
> write-protection and !is_writable_pte() is stable enough (can not be
> locklessly write-protected).
> 
> 3) in spte_write_protect()
> 1368         if (!is_writable_pte(spte) &&
> 1369               !spte_is_locklessly_modifiable(spte))
> 1370                 return false;
> 1371
> 
> It always do write-protection if the spte is lockelss modifiable.
> (This code is the aspect after applying the whole pachset, the code is safe too
> before patch "[PATCH v3 14/15] KVM: MMU: clean up spte_write_protect" since
> the lockless write-protection path is serialized by a single lock.).
> 
> 4) in set_spte()
> 2690                 /*
> 2691                  * Optimization: for pte sync, if spte was writable the hash
> 2692                  * lookup is unnecessary (and expensive). Write protection
> 2693                  * is responsibility of mmu_get_page / kvm_sync_page.
> 2694                  * Same reasoning can be applied to dirty page accounting.
> 2695                  */
> 2696                 if (!can_unsync && is_writable_pte(*sptep))
> 2697                         goto set_pte;
> 
> It is used for a optimization and the worst case is the optimization is disabled
> (walking the shadow pages in the hast table) when the spte has been locklessly
> write-protected. It does not hurt anything since it is a rare event. And the
> optimization can be back if we check SPTE_MMU_WRITEABLE instead.
> 
> 5) fast_page_fault()
> 3110         /*
> 3111          * Check if it is a spurious fault caused by TLB lazily flushed.
> 3112          *
> 3113          * Need not check the access of upper level table entries since
> 3114          * they are always ACC_ALL.
> 3115          */
> 3116          if (is_writable_pte(spte)) {
> 3117                 ret = true;
> 3118                 goto exit;
> 3119         }
> 
> Since kvm_vm_ioctl_get_dirty_log() firstly get-and-clear dirty-bitmap before
> do write-protect, the dirty-bitmap will be properly set again when fast_page_fault
> fix the spte who is write-protected by lockless write-protection.
> 
> 6) in fast_page_fault's tracepoint:
> 244 #define __spte_satisfied(__spte)                                \
> 245         (__entry->retry && is_writable_pte(__entry->__spte))
> It causes the tracepoint reports the wrong result when fast_page_fault
> and tdp_page_fault/lockless-write-protect run concurrently, i guess it's
> okay since it's only used for trace.
> 
> 7) in audit_write_protection():
> 202                 if (is_writable_pte(*sptep))
> 203                         audit_printk(kvm, "shadow page has writable "
> 204                                      "mappings: gfn %llx role %x\n",
> 205                                      sp->gfn, sp->role.word);
> It's okay since lockless-write-protection does not update the readonly sptes.
> 
> > 
> > OK to improve comments later.
> 
> Thank you, Marcelo!
> 
