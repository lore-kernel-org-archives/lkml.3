Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaB1Muy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:50:54 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49110 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaB1Mut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:50:49 -0500
Date: Fri, 28 Feb 2014 12:50:45 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140228125045.GV1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <5379319.g8IPYmY2Zo@wuerfel>
 <20140227200729.GB7773@obsidianresearch.com>
 <11097076.0C13zaKdYD@wuerfel>
MIME-Version: 1.0
In-Reply-To: <11097076.0C13zaKdYD@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 28 Feb 2014 12:50:46.0480 (UTC) FILETIME=[B2F51500:01CF3483]
X-MC-Unique: 114022812504603701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:22:12PM +0000, Arnd Bergmann wrote:
> On Thursday 27 February 2014 13:07:29 Jason Gunthorpe wrote:
> > On Thu, Feb 27, 2014 at 08:48:08PM +0100, Arnd Bergmann wrote:
> > > > It also looks correct for architectures that use the CPU MMIO address
> > > > as the IO address directly (where IO_SPACE_LIMIT would be 4G)
> > > 
> > > Are you aware of any that still do? I thought we had stopped doing
> > > that.
> > 
> > I thought ia64 used to, but it has been a long time since I've touched
> > one...
> 
> They have a different way of doing it now, no idea how it looked in
> the past:
> 
> #define IO_SPACE_LIMIT          0xffffffffffffffffUL
> 
> #define MAX_IO_SPACES_BITS              8
> #define MAX_IO_SPACES                   (1UL << MAX_IO_SPACES_BITS)
> #define IO_SPACE_BITS                   24
> #define IO_SPACE_SIZE                   (1UL << IO_SPACE_BITS)
> 
> #define IO_SPACE_NR(port)               ((port) >> IO_SPACE_BITS)
> #define IO_SPACE_BASE(space)            ((space) << IO_SPACE_BITS)
> #define IO_SPACE_PORT(port)             ((port) & (IO_SPACE_SIZE - 1))
> 
> #define IO_SPACE_SPARSE_ENCODING(p)     ((((p) >> 2) << 12) | ((p) & 0xfff))
> 
> So their port number is a logical token that contains the I/O space number
> and a 16MB offset.
> 
> Apparently sparc64 uses physical memory addressing for I/O space, the
> same way they do for memory space, and they just set IO_SPACE_LIMIT to
> 0xffffffffffffffffUL.
> 
> > > > Architectures that use the virtual IO window technique will always
> > > > require a custom pci_address_to_pio implementation.
> > > 
> > > Hmm, at the moment we only call it from of_address_to_resource(),
> > > which in turn does not get called on PCI devices, and does not
> > > call pci_address_to_pio for 'simple' platform devices. The only
> > > case I can think of where it actually matters is when we have
> > > ISA devices in DT that use an I/O port address in the reg property,
> > > and that case hopefully won't happen on ARM32 or ARM64.
> > 
> > Sure, I ment, after Liviu's patch it will become required since he is
> > cleverly using it to figure out what the io mapping the bridge driver
> > setup before calling the helper.
> 
> Ok. I was arguing more that we should add this dependency.

I've thought about this last night and I think I was trying to be too clever
for my own good. As Jason points out, arm64 needs its own version of
pci_address_to_pio(). I have an idea on how to borrow the powerpc/microblaze
one and make it useful without the need for pci_controller *hose. It would
be generic enough for other platforms that use virtual I/O windows can use,
but I'll start with it being defined for arm64 for discussions in this list.

I'll post v3 shortly.

Best regards,
Liviu

> 
> > > > I think the legacy reasons for having all those layers of translation
> > > > are probably not applicable to ARM64, and it is much simpler without
> > > > the extra translation step....
> > > > 
> > > > Arnd, what do you think?
> > > 
> > > Either I don't like it or I misunderstand you ;-)
> > > 
> > > Most PCI drivers normally don't call ioport_map or pci_iomap, so
> > > we can't just do it there. If you are thinking of calling ioport_map
> > 
> > Okay, that was one of the 'legacy reasons'. Certainly lots of drivers
> > do call pci_iomap, but if you think legacy drivers that don't are
> > important to ARM64 then it makes sense to use the virtual IO window.
> 
> I think all uses of I/O space are legacy, but I don't think that
> drivers doing inb/outb are more obsolete than those doing pci_iomap.
> It's got more to do with the subsystem requirements, e.g. libata
> requires the use of pci_iomap.
> 
> > > for every PCI device that has an I/O BAR and storing the virtual
> > > address in the pci_dev resource, I don't see what that gains us
> > 
> > Mainly we get to drop the fancy dynamic allocation stuff for the fixed
> > virtual window, and it gives the option to have a 1:1 relationship
> > between CPU addresses and PCI BARs.
> 
> I don't think the allocation is much of a problem, as long as we
> can localize it in one function that is shared by everyone.
> The problems I saw were all about explaining to people how it
> works, but they really shouldn't have to know.
> 
> 
> 	Arnd
> 
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

