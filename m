Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaFSRNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:13:31 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40813 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbaFSRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:13:29 -0400
Date: Thu, 19 Jun 2014 13:13:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rob Herring <robherring2@gmail.com>
cc: Laura Abbott <lauraa@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] of: Check for phys_addr_t overflows in
 early_init_dt_add_memory_arch
In-Reply-To: <CAL_JsqJW-mBb7C=ni2YLK-h9kfcAHs6b-uVJ-Zi-+MW0F_x1=Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1406191310330.16842@knanqh.ubzr>
References: <1403154257-14591-1-git-send-email-lauraa@codeaurora.org> <CAL_JsqJW-mBb7C=ni2YLK-h9kfcAHs6b-uVJ-Zi-+MW0F_x1=Q@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Rob Herring wrote:

> On Thu, Jun 19, 2014 at 12:04 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> > The common early_init_dt_add_memory_arch takes the base and size
> > of a memory region as u64 types. The function never checks if
> > the base and size can actually fit in a phys_addr_t which may
> > be smaller than 64-bits. This may result in incorrect memory
> > being passed to memblock_add if the memory falls outside the
> > range of phys_addr_t. Add range checks for the base and size if
> > phys_addr_t is smaller than u64.
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> > ---
> > Geert, can you drop my other patch and give this a test to see if it fixes
> > your bootup problem?
> >
> > ---
> >  drivers/of/fdt.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> > index c4cddf0..f72132c 100644
> > --- a/drivers/of/fdt.c
> > +++ b/drivers/of/fdt.c
> > @@ -880,6 +880,21 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
> >         const u64 phys_offset = __pa(PAGE_OFFSET);
> >         base &= PAGE_MASK;
> >         size &= PAGE_MASK;
> > +
> > +#ifndef CONFIG_ARCH_PHYS_ADDR_T_64BIT
> > +       if (base > ULONG_MAX) {
> 
> How about removing the ifdef and doing something like:
> 
> if ((base >> 32) && (sizeof(phys_addr_t) != sizeof(u64)))

That is what I was about to suggest as well.  Except that I'd use 
sizeof(phys_addr_t) < sizeof(u64) just in case.


Nicolas
