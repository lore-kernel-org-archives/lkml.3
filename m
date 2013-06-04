Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3FDOWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:22:48 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50105 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab3FDOWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:22:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,799,1363132800"; 
   d="scan'208";a="29128806"
Date: Tue, 4 Jun 2013 15:14:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/5] arm/xen: define xen_remap as ioremap_cached
In-Reply-To: <20130604135857.GV18614@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1306041509530.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com> <1370273624-26976-1-git-send-email-stefano.stabellini@eu.citrix.com> <1370337650.24512.88.camel@zakaz.uk.xensource.com> <20130604112834.GA3234@MacBook-Pro.local>
 <20130604135857.GV18614@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Russell King - ARM Linux wrote:
> On Tue, Jun 04, 2013 at 12:28:34PM +0100, Catalin Marinas wrote:
> > PROT_PTE_DEVICE and PROT_SECT_DEVICE above don't contain any memory type
> > information, just attributes/permission - present, young, dirty and XN:
> > 
> > #define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_XN
> > #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
> > 
> > The memory type is given by the L_PTE_MT_DEV_CACHED and PMD_SECT_WB
> > macros. Let's take prot_sect first as it's simpler. For MT_DEVICE_CACHED
> > we have:
> > 
> > .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_WB
> > 
> > For MT_MEMORY we have:
> > 
> > .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE
> > 
> > The cache policy is added later to MT_MEMORY which is either WB or WBWA
> > (based on SMP, no particular reason as these are just processor hints;
> > for some historical reasons we enabled WBWA for ARM11MPCore but we could
> > leave it on all the time).
> 
> They may be reported to be just hints, but SMP, particularly ARM11MPCore,
> the SMP guys at ARM Ltd were very particular about _requiring_ and stating
> that it is required that WBWA must be used in the page tables for SMP,
> and not WB.  That suggests while the ARM ARM may say that they're hints,
> there's slightly more to it when it comes to SMP, and WBWA is a hard
> requirement there.
> 
> Indeed, that's something we enforce in the kernel because of the statements
> from the SMP development group.
> 
> > Similarly for prot_pte, present, young, dirty are the same.
> > 
> > Regarding the type, on ARMv7 (with or without LPAE) we use TEX remapping
> > and L_PTE_MT_DEVICE has the same index (3-bit TEX[0], C, B for NMRR/PRRR
> > or TEX[2:0] for MAIR0/MAIR1 registers) as Normal Cacheable Writeback
> > memory (there is no such thing as Device memory with cacheability
> > attributes, only Normal Cacheable memory).
> 
> You don't mean L_PTE_MT_DEVICE there. Thankfully, L_PTE_MT_DEVICE doesn't
> exist, so it's not that confusing.  What you mean is L_PTE_MT_DEV_CACHED,
> which _does_ map to "normal cacheable writeback memory" irrespective of
> the mappings which the kernel uses for RAM.
> 
> However, that mapping type (which is used for MT_DEVICE_CACHED) should
> not be used if you really do want normal memory.  And using MT_* definitions
> _not_ in asm/io.h with ioremap() is really... silly.  It's not something
> that is intended, nor is it something which I intend to be supportable
> into the future on ARM.  That's why the definitions are separate - see
> the comments in asm/io.h about "types 4 onwards are undefined for
> ioremap" - I'm not sure how more explicit to make that statement.  And
> as I _have_ made the statement, if I see people violating it, I won't
> care about their code if/when I decide to change the ioremap() behaviour.

Fair enough. In that case what do you suggest we should do? 
Given that ioremap_cached is already taken for "device cacheable memory", maybe we
could introduce ioremap_memory for "normal memory" on ARM and ARM64:

#define ioremap_memory(cookie,size) __arm_ioremap((cookie), (size), MT_MEMORY)

that would require us moving the MT_MEMORY definition to
arch/arm/include/asm/io.h though.

I am open to any suggestions.
