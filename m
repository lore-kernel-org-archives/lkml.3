Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3FLRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:21:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43946 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab3FLRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:21:49 -0400
Date: Wed, 12 Jun 2013 10:21:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ARM: mmu: Add debug_ll_io_init() mappings to early
 mappings
Message-ID: <20130612172146.GB10823@codeaurora.org>
References: <1371000607-1787-1-git-send-email-sboyd@codeaurora.org>
 <CAL_JsqLJ7ZD9-VR+vgOZZ_q-RD6FCDvKPSNSCjAADxy94SU1Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLJ7ZD9-VR+vgOZZ_q-RD6FCDvKPSNSCjAADxy94SU1Xg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Rob Herring wrote:
> On Tue, Jun 11, 2013 at 8:30 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> > index e0d8565..04fe160 100644
> > --- a/arch/arm/mm/mmu.c
> > +++ b/arch/arm/mm/mmu.c
> > @@ -938,8 +938,12 @@ static void __init pci_reserve_io(void)
> >  #ifdef CONFIG_DEBUG_LL
> >  void __init debug_ll_io_init(void)
> >  {
> > +       struct vm_struct *vm;
> > +       struct static_vm *svm;
> >         struct map_desc map;
> >
> > +       svm = early_alloc_aligned(sizeof(*svm), __alignof__(*svm));
> > +
> >         debug_ll_addr(&map.pfn, &map.virtual);
> >         if (!map.pfn || !map.virtual)
> >                 return;
> > @@ -948,6 +952,15 @@ void __init debug_ll_io_init(void)
> >         map.length = PAGE_SIZE;
> >         map.type = MT_DEVICE;
> >         create_mapping(&map);
> > +
> > +       vm = &svm->vm;
> > +       vm->addr = (void *)map.virtual;
> > +       vm->size = map.length;
> > +       vm->phys_addr = __pfn_to_phys(map.pfn);
> > +       vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
> > +       vm->flags |= VM_ARM_MTYPE(map.type);
> > +       vm->caller = debug_ll_io_init;
> > +       add_static_vm_early(svm);
> 
> Can you use vm_reserve_area_early here or perhaps just call
> iotable_init instead of create_mapping directly? I don't recall if
> there was some reason I didn't do that.
> 

I had iotable_init() before but I thought it was better to have
the ->caller argument say debug_ll_io_init() instead of
iotable_init(). Shall I extract out the similar code?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
