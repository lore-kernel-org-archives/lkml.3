Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935007Ab3E2CPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:15:41 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47678 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934981Ab3E2CPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <51A4FC08.3060906@ti.com>
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
 <20130528130502.GA28971@mudshark.cambridge.arm.com> <51A4B938.7080708@ti.com>
 <20130528140705.GE28971@mudshark.cambridge.arm.com> <51A4FC08.3060906@ti.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 29 May 2013 10:14:58 +0800
Message-ID: <CANutaR-2gTP7ubiEdgjFyzVMc6=4t5GPjLkH8pkup=O882Hb-Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
To: Sricharan R <r.sricharan@ti.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 2:48 AM, Sricharan R <r.sricharan@ti.com> wrote:
>
> On Tuesday 28 May 2013 07:37 PM, Will Deacon wrote:
> > On Tue, May 28, 2013 at 03:03:36PM +0100, Sricharan R wrote:
> >> On Tuesday 28 May 2013 06:35 PM, Will Deacon wrote:
> >>> On Tue, May 28, 2013 at 11:48:20AM +0100, Po-Yu Chuang wrote:
> >>>> This bug was introduced in commit e651eab0.
> >>>> Some v4/v5 platforms failed to boot due to this.
> >>>>
> >>>> Signed-off-by: Po-Yu Chuang <ratbert.chuang@gmail.com>
> >>>> ---
> >>>>  arch/arm/mm/mmu.c |    4 +++-
> >>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> >>>> index e0d8565..19a43f8 100644
> >>>> --- a/arch/arm/mm/mmu.c
> >>>> +++ b/arch/arm/mm/mmu.c
> >>>> @@ -620,6 +620,8 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
> >>>>                    unsigned long end, phys_addr_t phys,
> >>>>                    const struct mem_type *type)
> >>>>  {
> >>>> +  pmd_t *p = pmd;
> >>>> +
> >>>>  #ifndef CONFIG_ARM_LPAE
> >>>>    /*
> >>>>     * In classic MMU format, puds and pmds are folded in to
> >>>> @@ -638,7 +640,7 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
> >>>>            phys += SECTION_SIZE;
> >>>>    } while (pmd++, addr += SECTION_SIZE, addr != end);
> >>>>
> >>>> -  flush_pmd_entry(pmd);
> >>>> +  flush_pmd_entry(p);
> >>> Wait, shouldn't this flush be *inside* the loop anyway? Otherwise we just
> >>> flush the cacheline containing the first pmd. The flushing code could also
> >>> flush to PoU instead of PoC for UP ARMv7, but that's an unrelated optimisation.
> >>    I think in LPAE this loop iterates once and non LPAE twice.
> >>    So both the entries should be contained in same cache line right ?
> > Dunno, are there any guarantees about alignment of the starting pmd? Even
> > so, the function takes the range as parameters, so I don't think we
> > should tailor it to the caller. It may explain why this hasn't come up
> > sooner though.
> >
> > Will
>
>  This function is not exposed outside. And the ranges passed to this is going
> to not more than 2 entries in any case. If we put the flush inside the loop,
> then we will end up doing an extra flush for the same line. Regarding the
> alignment, I think if the pgd base is aligned, then rest should be fine.
> Will have to check this.
>
> Regards,
>  Sricharan
>

Hi ,

Catalin and Sricharan,
Thanks for your explanation.

Will,
I guess nobody noticed this because the MMU of later v7 processors
fetches page table
from D-cache. It even doesn't need to clean pmd to PoU.

Regards,
Po-Yu
