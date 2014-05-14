Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaENMfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:35:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbaENMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:35:42 -0400
Date: Wed, 14 May 2014 13:35:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>, "bp@suse.de" <bp@suse.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH 6/7] acpi, apei, ghes: Make unmapping functionality
 independent from architecture.
Message-ID: <20140514123542.GG10145@arm.com>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-7-git-send-email-tomasz.nowicki@linaro.org>
 <20140513201118.GF8760@pd.tnic>
 <5373625B.4050401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5373625B.4050401@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:32:27PM +0100, Tomasz Nowicki wrote:
> On 13.05.2014 22:11, Borislav Petkov wrote:
> > On Wed, Apr 09, 2014 at 05:14:34PM +0200, Tomasz Nowicki wrote:
> >> Till now __flush_tlb_one was used for unmapping virtual memory which
> >> is x86 specific function. Replace it with more generic
> >> flush_tlb_kernel_range.
> >>
> >> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >> ---
> >>   drivers/acpi/apei/ghes.c |    4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> >> index aaf8db3..624878b 100644
> >> --- a/drivers/acpi/apei/ghes.c
> >> +++ b/drivers/acpi/apei/ghes.c
> >> @@ -185,7 +185,7 @@ static void ghes_iounmap_nmi(void __iomem *vaddr_ptr)
> >>
> >>   	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_NMI_PAGE(base));
> >>   	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
> >> -	__flush_tlb_one(vaddr);
> >> +	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
> >>   }
> >>
> >>   static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
> >> @@ -195,7 +195,7 @@ static void ghes_iounmap_irq(void __iomem *vaddr_ptr)
> >>
> >>   	BUG_ON(vaddr != (unsigned long)GHES_IOREMAP_IRQ_PAGE(base));
> >>   	unmap_kernel_range_noflush(vaddr, PAGE_SIZE);
> >> -	__flush_tlb_one(vaddr);
> >> +	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
> >
> > flush_tlb_kernel_range() does send an IPI to every core on x86 which is
> > much more expensive than what __flush_tlb_one does.
> >
> > Fairer it would be if you added a __flush_tlb_one() version for arm
> > which does flush_tlb_kernel_range for you.
> >
> 
> Thanks for comment. I am not sure if maintainers will allow me to add 
> sth like __flush_tlb_one() for arm/arm64. Let me ask them directly. 
> Catalin, Russell what do you think?

I don't have the background for this, but if you don't need broadcasting
(if this avoids IPIs on x86, I guess you don't) then why not use
local_flush_tlb_kernel_range instead?

Will
