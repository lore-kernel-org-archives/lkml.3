Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3FDN7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:59:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35067 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3FDN7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:59:19 -0400
Date: Tue, 4 Jun 2013 14:58:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/5] arm/xen: define xen_remap as ioremap_cached
Message-ID: <20130604135857.GV18614@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com> <1370273624-26976-1-git-send-email-stefano.stabellini@eu.citrix.com> <1370337650.24512.88.camel@zakaz.uk.xensource.com> <20130604112834.GA3234@MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604112834.GA3234@MacBook-Pro.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 12:28:34PM +0100, Catalin Marinas wrote:
> PROT_PTE_DEVICE and PROT_SECT_DEVICE above don't contain any memory type
> information, just attributes/permission - present, young, dirty and XN:
> 
> #define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_XN
> #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
> 
> The memory type is given by the L_PTE_MT_DEV_CACHED and PMD_SECT_WB
> macros. Let's take prot_sect first as it's simpler. For MT_DEVICE_CACHED
> we have:
> 
> .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_WB
> 
> For MT_MEMORY we have:
> 
> .prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE
> 
> The cache policy is added later to MT_MEMORY which is either WB or WBWA
> (based on SMP, no particular reason as these are just processor hints;
> for some historical reasons we enabled WBWA for ARM11MPCore but we could
> leave it on all the time).

They may be reported to be just hints, but SMP, particularly ARM11MPCore,
the SMP guys at ARM Ltd were very particular about _requiring_ and stating
that it is required that WBWA must be used in the page tables for SMP,
and not WB.  That suggests while the ARM ARM may say that they're hints,
there's slightly more to it when it comes to SMP, and WBWA is a hard
requirement there.

Indeed, that's something we enforce in the kernel because of the statements
from the SMP development group.

> Similarly for prot_pte, present, young, dirty are the same.
> 
> Regarding the type, on ARMv7 (with or without LPAE) we use TEX remapping
> and L_PTE_MT_DEVICE has the same index (3-bit TEX[0], C, B for NMRR/PRRR
> or TEX[2:0] for MAIR0/MAIR1 registers) as Normal Cacheable Writeback
> memory (there is no such thing as Device memory with cacheability
> attributes, only Normal Cacheable memory).

You don't mean L_PTE_MT_DEVICE there. Thankfully, L_PTE_MT_DEVICE doesn't
exist, so it's not that confusing.  What you mean is L_PTE_MT_DEV_CACHED,
which _does_ map to "normal cacheable writeback memory" irrespective of
the mappings which the kernel uses for RAM.

However, that mapping type (which is used for MT_DEVICE_CACHED) should
not be used if you really do want normal memory.  And using MT_* definitions
_not_ in asm/io.h with ioremap() is really... silly.  It's not something
that is intended, nor is it something which I intend to be supportable
into the future on ARM.  That's why the definitions are separate - see
the comments in asm/io.h about "types 4 onwards are undefined for
ioremap" - I'm not sure how more explicit to make that statement.  And
as I _have_ made the statement, if I see people violating it, I won't
care about their code if/when I decide to change the ioremap() behaviour.
