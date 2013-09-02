Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3IBQ0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3IBQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:26:50 -0400
Date: Mon, 2 Sep 2013 19:26:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
Message-ID: <20130902162638.GH10142@redhat.com>
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
 <5224584F.6010409@linux.vnet.ibm.com>
 <20130902092518.GN22899@redhat.com>
 <522461C7.8090701@linux.vnet.ibm.com>
 <20130902100747.GQ22899@redhat.com>
 <5224B517.3000602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224B517.3000602@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 05:56:07PM +0200, Paolo Bonzini wrote:
> Il 02/09/2013 12:07, Gleb Natapov ha scritto:
> > On Mon, Sep 02, 2013 at 06:00:39PM +0800, Xiao Guangrong wrote:
> >> On 09/02/2013 05:25 PM, Gleb Natapov wrote:
> >>> On Mon, Sep 02, 2013 at 05:20:15PM +0800, Xiao Guangrong wrote:
> >>>> On 08/30/2013 08:41 PM, Paolo Bonzini wrote:
> >>>>> Page tables in a read-only memory slot will currently cause a triple
> >>>>> fault because the page walker uses gfn_to_hva and it fails on such a slot.
> >>>>>
> >>>>> OVMF uses such a page table; however, real hardware seems to be fine with
> >>>>> that as long as the accessed/dirty bits are set.  Save whether the slot
> >>>>> is readonly, and later check it when updating the accessed and dirty bits.
> >>>>
> >>>> Paolo, do you know why OVMF is using readonly memory like this?
> >>>>
> >>> Just a guess, but perhaps they want to move to paging mode as early as
> >>> possible even before memory controller is fully initialized.
> >>>
> >>>> AFAIK, The fault trigged by this kind of access can hardly be fixed by
> >>>> userspace since the fault is trigged by pagetable walking not by the current
> >>>> instruction. Do you have any idea to let uerspace emulate it properly?
> >>> Not sure what userspace you mean here, but there shouldn't be a fault in the
> >>
> >> I just wonder how to fix this kind of fault. The current patch returns -EACCES
> >> but that will crash the guest. I think we'd better let userspace to fix this
> >> error (let userspace set the D/A bit.)
> >>
> > Ugh, this is not good. Missed that. Don't know what real HW will do
> > here, but the easy thing for us to do would be to just return success.
> 
> Real hardware would just do a memory write.  What happens depends on
> what is on the bus, i.e. on what the ROM is used for.
> 
> QEMU uses read-only slots for two things: actual read-only memory where
> writes go to the bitbucket, and "ROMD" memory where writes are treated
> as MMIO.
> 
> So, in the first case we would ignore the write.  In the second we would
> do an MMIO exit to userspace.  But ignoring the write isn't always
> correct, and doing an MMIO exit is complicated, so I would just kill the
> guest.
> 
> EPT will probably write to the read-only slots without thinking much
> about it.
> 
> My patch injects a page fault, which is very likely to escalate to a
> triple fault.  This is probably never what you want---on the other hand,
> I wasn't sure what level of accuracy we want in this case, given that
> EPT does it wrong too.
> 
Just ignoring write into RO slot is OK. We do not handle page tables in
MMIO memory, so handling page tables in ROMD memory shouldn't be a
priority either. 

--
			Gleb.
