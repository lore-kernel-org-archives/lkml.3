Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaCJWBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:01:37 -0400
Received: from dliviu.plus.com ([80.229.23.120]:58425 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaCJWBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:01:35 -0400
Date: Mon, 10 Mar 2014 21:56:00 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140310215600.GA14968@bart.dudau.co.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Bjorn Helgaas <bhelgaas@google.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
 <2115856.ZTdgp5fkma@wuerfel>
 <20140310163343.GY6457@e106497-lin.cambridge.arm.com>
 <1469359.kil5iaOqdU@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1469359.kil5iaOqdU@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Mar 10 22:01:33 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 531e363d3198865457261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 07:59:59PM +0100, Arnd Bergmann wrote:
> On Monday 10 March 2014 16:33:44 Liviu Dudau wrote:
> > On Mon, Mar 10, 2014 at 03:21:01PM +0000, Arnd Bergmann wrote:
> > > On Monday 10 March 2014 14:44:14 Liviu Dudau wrote:
> > > > I will try to improve the error handling in the next patchset version.
> > > > However I am still confused about the earlier discussion on
> > > > pci_register_io_range(). Your suggestion initially was to return an
> > > > error in the default weak implementation, but in your last email you
> > > > are talking about returning 'port'.
> > > 
> > > You can do either one: 'port' should be positive or zero, while the
> > > error would always be negative. We do the same thing in many interfaces
> > > in the kernel.
> > > 
> > > > My idea when I've introduced the
> > > > helper function was that it would return an error if it fails to
> > > > register the IO range and zero otherwise. I agree that we can treat
> > > > the default 'do nothing with the IO range' case as an error, with
> > > > the caveat that will force architectures that use this code to
> > > > provide their own implementation of pci_register_io_range() in order
> > > > to avoid failure, even for the cases where the architecture has a 1:1
> > > > mapping between IO and CPU addresses.
> > > 
> > > Which architectures are you thinking of? The only one I know that
> > > does this is ia64, and we won't ever have to support this helper
> > > on that architecture.
> > 
> > I was thinking about architectures that have IO_SPACE_LIMIT >= 0xffffffff.
> > While not an absolute indicator, with the default pci_address_to_pio()
> > that means that they can use the CPU MMIO address as IO address directly.
> 
> Not really, that would only work if they also have instructions to do
> raw accesses to physical memory addresses rather than virtual memory
> pointers that most architectures do.
> 
> > $ git grep IO_SPACE_LIMIT | grep -i ffffffff
> > arch/arm/include/asm/io.h:#define IO_SPACE_LIMIT ((resource_size_t)0xffffffff)
> > arch/arm/mach-at91/include/mach/io.h:#define IO_SPACE_LIMIT		0xFFFFFFFF
> > arch/arm/mach-omap1/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
> > arch/arm/mach-pxa/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
> > arch/arm/mach-s3c24xx/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
> 
> These use a special trick where an __iomem pointer is the same as
> the port number. This works most of the time, but breaks anything
> that assumes that port numbers are low, such as /dev/port or
> broken devices. Moreover, it means your code won't work because
> it depends on passing the virtual start address of the PIO mapping
> window as io_offset.
> 
> > arch/avr32/include/asm/io.h:#define IO_SPACE_LIMIT	0xffffffff
> > arch/frv/include/asm/io.h:#define IO_SPACE_LIMIT	0xffffffff
> 
> They have no MMU, and the code relies on the port number to match
> both the virtual and the physical address. You could be right about
> these, but I would guess that the code also needs some other
> changes if we want to make it work on nommu kernels. It also depends
> on whether the I/O bus address is the same as the CPU address, or
> if it starts at bus address 0.
> 
> > arch/ia64/include/asm/io.h:#define IO_SPACE_LIMIT		0xffffffffffffffffUL
> 
> Here, the definition is special, the token is just used to encode
> a space number and an offset within the I/O space.
> 
> > arch/m32r/include/asm/io.h:#define IO_SPACE_LIMIT  0xFFFFFFFF
> 
> no PCI here.
> 
> > arch/m68k/include/asm/io_no.h:#define IO_SPACE_LIMIT 0xffffffff
> 
> This looks like a mistake, it should be smaller
> 
> > arch/microblaze/include/asm/io.h:#define IO_SPACE_LIMIT (0xFFFFFFFF)
> 
> I suspect it doesn't actually work. microblaze copied large parts
> of this from PowerPC, but the parts that differ apparently get
> it wrong for the I/O space. 
> 
> > arch/mn10300/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff
> 
> Same category as frv. We should ask David Howells whether he
> thinks I/O space actually works on these.
> 
> > arch/sh/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff
> 
> I think this should just be 0xffff.
> 
> > arch/sparc/include/asm/io_32.h:#define IO_SPACE_LIMIT 0xffffffff
> > arch/sparc/include/asm/io_64.h:#define IO_SPACE_LIMIT 0xffffffffffffffffUL
> 
> Sparc actually accesses the physical addresses, so in theory
> it could always work. In the 64-bit case it would however have
> to check that the port number is smaller than 0xffffffff, otherwise
> you couldn't set the BAR. This means you still need a custom
> function.
> 
> > arch/tile/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff
> 
> tile seems to support only ioport_map() but not inb/outb, if I'm
> reading this right.
> 
> > > I did not ask to treat 'do nothing with the IO range' as an error,
> > > what I meant is that we should treat 'architecture cannot translate
> > > from I/O space to memory space but DT lists a translation anyway'
> > > as an error. On x86, you should never see an entry for the I/O space
> > > in "ranges", so we will not call this function unless there is a
> > > bug in DT.
> > 
> > Ok, it's just that there is no "architecture cannot translate from I/O
> > space to memory space" indicator anywhere and I don't want to make x86
> > a special case.
> 
> Right.
> 
> > So, my proposal is this: default weak implementation of pci_register_io_range()
> > returns an error (meaning I have no idea how to translate IO addresses
> > to memory space) and anyone that wants this function to return success will
> > have to provide their implementation.
> 
> Another idea: make this conditional on the definition of PCI_IOBASE: If this
> is defined, we can use the arm64 version that uses this number. Otherwise
> we fall back to returning an error, which means that either on the
> architecture we shouldn't be calling that function, or we need a custom
> implementation.

PCI_IOBASE is always defined. See the discussion with Russell on this subject.

include/asm-generic/io.h has at line 118:

#ifndef PCI_IOBASE
#define PCI_IOBASE ((void __iomem *) 0)
#endif

I will go with my idea tomorrow. arm64 overwrite the implementation anyway, I
find it cleaner rather than having to do #ifdefs and/or ifs.

Best regards,
Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

