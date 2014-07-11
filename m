Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaGKMTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:19:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30845 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752461AbaGKMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:19:50 -0400
Date: Fri, 11 Jul 2014 13:19:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Message-ID: <20140711121923.GE11473@arm.com>
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
 <1404918699-17284-3-git-send-email-thierry.reding@gmail.com>
 <20140710110034.GI16137@arm.com>
 <201407101514.16530.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201407101514.16530.arnd@arndb.de>
Thread-Topic: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 02:14:16PM +0100, Arnd Bergmann wrote:
> On Thursday 10 July 2014, Catalin Marinas wrote:
> > > @@ -235,8 +155,7 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
> > >  #define ioremap_wc(addr, size)               __ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
> > >  #define iounmap                              __iounmap
> > >  
> > > -#define ARCH_HAS_IOREMAP_WC
> > > -#include <asm-generic/iomap.h>
> > > +#include <asm-generic/io.h>
> > 
> > We don't currently have PCIe support in mainline for arm64 but what I
> > had in mind with the generic iomap is that functions like ioread32_rep
> > first check whether the address is an IO address or a memory one and
> > calls the insl or mmio_insl accordingly. With your generic
> > implementation, this check disappears.
> > 
> > The question is whether this functionality would still be needed.
> 
> I think it's much better not to have that check on architectures that have a memory
> mapped I/O space like arm64. The main advantage is that ioread32() is just a trivial
> alias for readl(). The only reason for needing generic_iomap is architectures that
> do something very different for I/O ports.

ioread32() is indeed an alias for readl on arm64 but if the address it
gets as argument looks like an I/O port, it adds PCI_IOBASE (via the inl
macro). This would no longer happen with Thierry's patches.

So I guess that for this patch to work, we also need ioport_map() to
return an address from the PCI_IOBASE range. Should we merge this now as
well:

http://linux-arm.org/git?p=linux-ld.git;a=commitdiff;h=3423064d8e42a38164a8436bcdf7434cf9cd2192

-- 
Catalin
