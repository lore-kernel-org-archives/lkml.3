Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaCGBsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:48:22 -0500
Received: from dliviu.plus.com ([80.229.23.120]:40806 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaCGBsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:48:07 -0500
Date: Fri, 7 Mar 2014 01:44:52 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/3] Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
Message-ID: <20140307014452.GI13582@bart.dudau.co.uk>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	LAKML <linux-arm-kernel@lists.infradead.org>
References: <1394020150-1875-1-git-send-email-Liviu.Dudau@arm.com>
 <1394020150-1875-2-git-send-email-Liviu.Dudau@arm.com>
 <20140305233135.GZ21483@n2100.arm.linux.org.uk>
 <201403070137.38621.arnd@arndb.de>
 <20140307010950.GE21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307010950.GE21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Mar  7 01:48:04 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 531925543191942457687
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:09:50AM +0000, Russell King - ARM Linux wrote:
> On Fri, Mar 07, 2014 at 01:37:38AM +0100, Arnd Bergmann wrote:
> > On Thursday 06 March 2014, Russell King - ARM Linux wrote:
> > > On Wed, Mar 05, 2014 at 11:49:08AM +0000, Liviu Dudau wrote:
> > > > The inline version of ioport_map() that gets used when !CONFIG_GENERIC_IOMAP
> > > > is wrong. It returns a mapped (i.e. virtual) address that can start from
> > > > zero and completely ignores the PCI_IOBASE and IO_SPACE_LIMIT that most
> > > > architectures that use !CONFIG_GENERIC_MAP define.
> > > 
> > > What value does PCI_IOBASE and IO_SPACE_LIMIT have on other architectures
> > > who make use of asm-generic/io.h ?
> > > 
> > > $ git grep asm-generic/io.h arch/
> > > arch/arc/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > PCI support hasn't been upstreamed.
> > 
> > > arch/blackfin/include/asm/io.h:#include <asm-generic/io.h>
> > > arch/metag/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > No PCI support
> > 
> > > arch/microblaze/include/asm/io.h:/* from asm-generic/io.h */
> > 
> > PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.
> 
> Seems to define _IO_BASE not PCI_IOBASE.
> 
> > > arch/openrisc/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > No PCI support
> > 
> > > arch/s390/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > s390 supports PCI but no I/O space
> > 
> > > arch/score/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > No PCI support
> > 
> > > arch/unicore32/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > unicore32 is broken currently, the patch fixes it.
> > 
> > > arch/xtensa/include/asm/io.h:#include <asm-generic/io.h>
> > 
> > PCI_IOBASE=0, IO_SPACE_LIMIT=0xffffffff, so no change.
> 
> Doesn't appear to define PCI_IOBASE.
> 
> Maybe there's other patches required for these?
> 
> > For most of these, I assume we actually want to remove support
> > for inb/outb as they don't support I/O space accesses. The other
> > ones look correct to me.
> 
> Right, so:
> 
> #ifdef CONFIG_HAS_IOPORT
> #ifndef CONFIG_GENERIC_IOMAP
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
>         return (void __iomem *) port;
> }
> 
> changing that to include PCI_IOBASE in there will result in a build
> failure if the C compiler sees that.  In other words, when HAS_IOPORT=y
> and GENERIC_IOMAP=n.
> 
> HAS_IOPORT is set when HAS_IOMEM is also set and NO_IOPORT unset.
> 
> It looks to me like blackfin doesn't set NO_IOPORT nor NO_IOMEM, so
> this would have HAS_IOPORT set, and from what I can see doesn't set
> GENERIC_IOMAP.  So, this change probably breaks blackfin.
> 
> I haven't looked deeply at the others.

Maybe I'm missing something obvious, but line 118 in include/asm-generic/io.h has:

#ifndef PCI_IOBASE
#define PCI_IOBASE ((void __iomem *)0)
#endif

That doesn't seem to be guarded by any other #ifdef (other than the overall
__ASM_GENERIC_IO_H), so PCI_IOBASE is defined regardless of CONFIG_HAS_IOPORT and 
CONFIG_GENERIC_IOMAP values.

Best regards,
Liviu

> 
> -- 
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

