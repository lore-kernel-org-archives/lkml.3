Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3FDLf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:35:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60230 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3FDLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:35:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,799,1363132800"; 
   d="scan'208";a="27705125"
Date: Tue, 4 Jun 2013 12:35:20 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 1/5] arm/xen: define xen_remap as ioremap_cached
In-Reply-To: <20130604112834.GA3234@MacBook-Pro.local>
Message-ID: <alpine.DEB.2.02.1306041230080.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com> <1370273624-26976-1-git-send-email-stefano.stabellini@eu.citrix.com> <1370337650.24512.88.camel@zakaz.uk.xensource.com> <20130604112834.GA3234@MacBook-Pro.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Catalin Marinas wrote:
> On Tue, Jun 04, 2013 at 10:20:50AM +0100, Ian Campbell wrote:
> > On Mon, 2013-06-03 at 16:33 +0100, Stefano Stabellini wrote:
> > > Define xen_remap as ioremap_cache (MT_MEMORY and MT_DEVICE_CACHED end up
> > > having the same AttrIndx encoding).
> > 
> > The entries in static struct mem_type mem_types[] look entirely
> > different to me.  What am I missing?
> > 	[MT_DEVICE_CACHED] = {	  /* ioremap_cached */
> > 		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_CACHED,
> > 		.prot_l1	= PMD_TYPE_TABLE,
> > 		.prot_sect	= PROT_SECT_DEVICE | PMD_SECT_WB,
> > 		.domain		= DOMAIN_IO,
> > 	},
> > 	[MT_MEMORY] = {
> > 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY,
> > 		.prot_l1   = PMD_TYPE_TABLE,
> > 		.prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
> > 		.domain    = DOMAIN_KERNEL,
> > 	},
> > 
> > I can see in pgtable-3level.h how L_PTE_MT_DEV_CACHED and
> > L_PTE_MT_WRITEBACK are the same but not where the MT_WRITEBACK comes
> > from for MT_MEMORY. Things are less clear in pgtable-2level.h, where one
> > is 0x3 and the other is 0xb. I can see that the entries are the same in
> > armv6_mt_table but how that would apply to a v7 processor?
> 
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
> 
> Similarly for prot_pte, present, young, dirty are the same.
> 
> Regarding the type, on ARMv7 (with or without LPAE) we use TEX remapping
> and L_PTE_MT_DEVICE has the same index (3-bit TEX[0], C, B for NMRR/PRRR
> or TEX[2:0] for MAIR0/MAIR1 registers) as Normal Cacheable Writeback
> memory (there is no such thing as Device memory with cacheability
> attributes, only Normal Cacheable memory).
> 
> We have XN in addition for MT_DEVICE_CACHED to prevent speculative
> instruction fetches. However, you still get speculative D-cache line
> fills since the memory is Normal Cacheable.
> 
> > Anyhow, even if I'm prepared to believe that MT_MEMORY and
> > MT_DEVICE_CACHED end up being the same thing (which TBH I am) it seems
> > that the level of abstraction involved makes us vulnerable to future
> > changes subtly breaking things for us. What about:
> > 
> >         /* Device shared memory */
> >         #define ioremap_shm(cookie,size)		__arm_ioremap((cookie), (size), MT_MEMORY)
> 
> For my understanding, what is Xen doing with such mapping? I would
> rather make ioremap_cached() use MT_MEMORY on ARMv6/v7 (or make it
> closer to that, I'm not sure about the implications on ARMv5 and earlier
> but for newer architectures I don't see the point in pretending to have
> Cacheable Device memory). That's however for Russell to comment.

Xen guests share these pages with one another and place a lockless ring
buffer on it for bidirectional communication. So the page that is being
ioremapped actually belongs to another guest and it's RAM.
