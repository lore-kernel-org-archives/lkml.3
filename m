Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3F0KTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3F0KTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:19:36 -0400
Date: Thu, 27 Jun 2013 13:19:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 4/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130627101931.GF18508@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1370595088-3315-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130627082900.GD18508@redhat.com>
 <20130627090110.GE18508@redhat.com>
 <20130627091424.GA10758@redhat.com>
 <20130627092152.GB10758@redhat.com>
 <51CC0AD0.3080003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC0AD0.3080003@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 05:50:08PM +0800, Xiao Guangrong wrote:
> On 06/27/2013 05:21 PM, Gleb Natapov wrote:
> > On Thu, Jun 27, 2013 at 12:14:24PM +0300, Gleb Natapov wrote:
> >> On Thu, Jun 27, 2013 at 12:01:10PM +0300, Gleb Natapov wrote:
> >>> On Thu, Jun 27, 2013 at 11:29:00AM +0300, Gleb Natapov wrote:
> >>>> On Fri, Jun 07, 2013 at 04:51:26PM +0800, Xiao Guangrong wrote:
> >>>>> This patch tries to introduce a very simple and scale way to invalidate
> >>>>> all mmio sptes - it need not walk any shadow pages and hold mmu-lock
> >>>>>
> >>>>> KVM maintains a global mmio valid generation-number which is stored in
> >>>>> kvm->memslots.generation and every mmio spte stores the current global
> >>>>> generation-number into his available bits when it is created
> >>>>>
> >>>>> When KVM need zap all mmio sptes, it just simply increase the global
> >>>>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> >>>>> then it walks the shadow page table and get the mmio spte. If the
> >>>>> generation-number on the spte does not equal the global generation-number,
> >>>>> it will go to the normal #PF handler to update the mmio spte
> >>>>>
> >>>>> Since 19 bits are used to store generation-number on mmio spte, we zap all
> >>>>> mmio sptes when the number is round
> >>>>>
> >>>> So this commit makes Fedora 9 32 bit reboot during boot, Fedora 9 64
> >>>> fails too, but I haven't checked what happens exactly.
> >>>>
> >>> Something wrong with gfn calculation during mmio:
> >>>
> >>> qemu-system-x86-17003 [000]  3962.625103: handle_mmio_page_fault: addr:c00ba6c0 gfn 100000000ba access a92
> >>> qemu-system-x86-17003 [000]  3962.774862: handle_mmio_page_fault: addr:ffffb170 gfn 100000fee00 access a92
> >>>
> >> Hmm, so I wounder why get_mmio_spte_gfn() does not clear gen bits.
> >>
> > Hmm, something like patch below fixes it. Will test more.
> > 
> > 
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 1fd2c05..aec9c05 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -260,7 +260,8 @@ static bool is_mmio_spte(u64 spte)
> > 
> >  static gfn_t get_mmio_spte_gfn(u64 spte)
> >  {
> > -	return (spte & ~shadow_mmio_mask) >> PAGE_SHIFT;
> > +	u64 mask = generation_mmio_spte_mask(MMIO_MAX_GEN) | shadow_mmio_mask;
> > +	return (spte & ~mask) >> PAGE_SHIFT;
> >  }
> 
> Looks nice.
> 
The question is if get_mmio_spte_access() need the same treatment?

--
			Gleb.
