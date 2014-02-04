Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaBDP5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:57:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:57:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Tue, 4 Feb 2014 16:56:58 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <4524393.8AzpATULMB@wuerfel> <20140204120801.GB27975@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140204120801.GB27975@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402041656.59165.arnd@arndb.de>
X-Provags-ID: V02:K0:MbP4ZjWJT1/5JGpi4i4R+67bPfxFMGpz4W3wknoRDf9
 lOCWbGku3lUHM1Ue2DDkuYdb51xfGWBbeVG1Kqhswmex2qVOoh
 J5DYLeVWphiLdj3Vxw1N9eLuzrFRklw9DQec9nHpEHAV3Warja
 l0iyi2I3wW+xWOp43Iu2fPka4SuxDINTtk6K5KAy0YNmHtCm8L
 V48kNKqvx+FD7pmxdsSYGu2IWeq47HAejNHKEDT/Lzwc2/2l/I
 8iPk9OESiHg5xTF9yprh/BNU+zrX+1FHuugiIHJdFbQt1veUrC
 W6vl95gRfmkYDQiIZpXsJgXVbCUnFvu1pE7N6mQCNjFYw7YF11
 c1QbIpIQ7lGbkOcysru85KDYVcp6QpJAASsbuekV3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014, Liviu Dudau wrote:
> On Tue, Feb 04, 2014 at 10:09:44AM +0000, Arnd Bergmann wrote:
> > On Monday 03 February 2014 22:17:44 Liviu Dudau wrote:
> > > On Mon, Feb 03, 2014 at 07:31:31PM +0000, Arnd Bergmann wrote:
> > > > The aperture here reflects the subset of the
> > > > 4GB bus I/O space that is actually mapped into a CPU visible "physical
> > > > I/O aperture" using an inbound mapping of the host bridge. The physical
> > > > I/O aperture in turn gets mapped to the virtual I/O space using
> > > > pci_ioremap_io.
> > >
> > > Agree.
> > >
> > > > The difference between a bus I/O address and a logical
> > > > I/O address is stored in the io_offset.
> > >
> > > Not exactly. If that would be true that means that for an I/O range that
> > > start at bus I/O address zero but physical I/O apperture starts at
> > > 0x40000000 the io_offset is zero. For me, the io_offset should be 0x40000000.
> >
> > That's not how we do it on any of the existing host controllers.
> > Typically the io_offset is zero for the first one, and may be
> > either zero for all the others (meaning BARs get > 64KB values
> > for secondary buses) or between 64KB and 2MB (meaning each bus
> > starts at I/O port number 0).
> 
> In that case it is probably worth to rename my variable into phys_io_offset.
> 
> I need to go back over my driver code. My assumptions were probably wrong
> wrt to meaning of the io_offset.

Ok. I'd still call it 'base' rather than 'offset', although the meaning
isn't all that different.

> > But there should never be an IORESOURCE_IO resource structure that is
> > not in IO space, i.e. within ioport_resource. Doing an "adjustment"
> > is not an operation defined on this structure. What I meant above is that
> > the pci range parser gets this right and gives you a resource that looks
> > like { .flags = IORESOURCE_MEM, .start = phys_base, .end = phys_base +
> > size - 1}, while the resource we want to register is { .flags = IORESOURCE_IO,
> > .start = log_base, .end = log_base + size -1}. In the of_pci_range struct for
> > the I/O space, the "pci_space" is IORESOURCE_IO (for the pci_addr), while the
> > "flags" are IORESOURCE_MEM, to go along with the cpu_addr.
> 
> The pci range parser gives me a range with .flags = IORESOURCE_IO for IO space. It
> does not convert it to IORESOURCE_MEM. Hence the need for adjustment.

Ah, I see that now in the code too. This seems to be a bug in the range parser
though: range->flags should not be initialized to
of_bus_pci_get_flags(parser->range).

	Arnd
