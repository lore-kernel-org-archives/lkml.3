Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaCFKg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:36:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51334 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaCFKg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:36:26 -0500
Date: Thu, 6 Mar 2014 10:36:20 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP	cases.
Message-ID: <20140306103620.GB6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	LAKML <linux-arm-kernel@lists.infradead.org>
References: <1394020150-1875-1-git-send-email-Liviu.Dudau@arm.com>
 <1394020150-1875-2-git-send-email-Liviu.Dudau@arm.com>
 <20140305233135.GZ21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20140305233135.GZ21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 06 Mar 2014 10:36:21.0774 (UTC) FILETIME=[EA7F1AE0:01CF3927]
X-MC-Unique: 114030610362313401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:31:35PM +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 05, 2014 at 11:49:08AM +0000, Liviu Dudau wrote:
> > The inline version of ioport_map() that gets used when !CONFIG_GENERIC_IOMAP
> > is wrong. It returns a mapped (i.e. virtual) address that can start from
> > zero and completely ignores the PCI_IOBASE and IO_SPACE_LIMIT that most
> > architectures that use !CONFIG_GENERIC_MAP define.
> 
> What value does PCI_IOBASE and IO_SPACE_LIMIT have on other architectures
> who make use of asm-generic/io.h ?

Hi Russell,

Sorry for being a bit opaque in the commit message, I probably conflated two
issues into one. The first issue is that ioport_map() is supposed to return
a virtual address for the IO port. I struggle to believe that a virtual address
of zero for IO is valid for most architectures other than x86. My guess is that
most of the architectures that you have listed as including asm-generic/io.h
have no support for PCI whatsoever. The other issue is that *if* you specify an
PCI_IOBASE and don't come up with your own version of ioport_map() then you
get the wrong virtual addresses back.

One way to fix all this is to use PCI_IOBASE inside the generic version and to
define it to a non-zero values for architectures that have memory mapped IO.
That should reduce the number of custom versions of ioport_map() that we currently
have.

The other implied message that I'm getting is that you are suggesting that the
commit message is generalising a bit too much? With that I agree, in light of
your analysis. I can change it to something like:

   The inline version of ioport_map() that gets used for !CONFIG_GENERIC_IOMAP is
   wrong when PCI_IOBASE has a non-zero value. The function is supposed to return
   a virtual address for IO ports and for architectures that memory map the IO
   areas that is giving incorrect results as it ignores PCI_IOBASE. Fix this and
   also limit the port range to the IO_SPACE_LIMIT mask.

> 
> $ git grep asm-generic/io.h arch/
> arch/arc/include/asm/io.h:#include <asm-generic/io.h>
> arch/blackfin/include/asm/io.h:#include <asm-generic/io.h>
> arch/metag/include/asm/io.h:#include <asm-generic/io.h>
> arch/microblaze/include/asm/io.h:/* from asm-generic/io.h */
> arch/openrisc/include/asm/io.h:#include <asm-generic/io.h>
> arch/s390/include/asm/io.h:#include <asm-generic/io.h>
> arch/score/include/asm/io.h:#include <asm-generic/io.h>
> arch/unicore32/include/asm/io.h:#include <asm-generic/io.h>

PCI_IOBASE = PKUNITY_PCILIO_BASE = PKUNITY_PCI_BASE + 0x00030000 = 
    io_p2v(0x80000000) + 0x00030000

All other ones bar arm64 are either happy with PCI_IOBASE being zero (proxy for
"no PCI support") or define their own version of ioport_map().

Best regards,
Liviu

> arch/xtensa/include/asm/io.h:#include <asm-generic/io.h>
> $ arch/arc/include/asm/io.h:#define PCI_IOBASE ((void __iomem *)0)
> arch/arm64/include/asm/io.h:#define PCI_IOBASE          ((void __iomem *)(MODULES_VADDR - SZ_2M))
> arch/arm64/include/asm/io.h:    return readb(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:    return readw(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:    return readl(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:    writeb(b, addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:    writew(b, addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:    writel(b, addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            *buf++ = __raw_readb(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            *buf++ = __raw_readw(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            *buf++ = __raw_readl(addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            __raw_writeb(*buf++, addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            __raw_writew(*buf++, addr + PCI_IOBASE);
> arch/arm64/include/asm/io.h:            __raw_writel(*buf++, addr + PCI_IOBASE);
> arch/unicore32/include/asm/io.h:#define PCI_IOBASE      PKUNITY_PCILIO_BASE
> arch/unicore32/include/asm/io.h:#define PIO_OFFSET              (unsigned int)(PCI_IOBASE)
> 
> 
> -- 
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

