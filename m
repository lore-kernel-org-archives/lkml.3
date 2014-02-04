Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaBDTLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:11:00 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:43087 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaBDTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:10:58 -0500
Date: Tue, 4 Feb 2014 12:10:55 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140204191055.GC25695@obsidianresearch.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <13031998.NR888KZWhk@wuerfel>
 <20140204181514.GA25695@obsidianresearch.com>
 <8676627.b6SYsazoah@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8676627.b6SYsazoah@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 07:34:50PM +0100, Arnd Bergmann wrote:

> Well, the way I see it, we already have support for arbitrary
> PCI domains in the kernel, and that works fine, so we can just
> as well use it. That way we don't have to partition the available
> 256 buses among the host bridges, and anything that needs a separate
> PCI config space can live in its own world. Quite often when you
> have multiple PCI hosts, they actually have different ways to
> get at the config space and don't even share the same driver.

> On x86, any kind of HT/PCI/PCIe/PCI-x bridge is stuffed into a
> single domain so they can support OSs that only know the
> traditional config space access methods, but I don't see
> any real advantage to that for other architectures.

Supporting a standard configration interface is a solid reason, but
there is alot more going on.

For instance to support peer-to-peer IO you need to have a consisent,
non-overlapping set of bus/device/function/tag to uniquely route TLPs
within the chip. Cross domain TLP routing in HW is non-trivial.

IOMMUs (and SR-IOv) rely on the BDF to identify the originating device
for each TLP. Multiple domains means a much more complex IOMMU
environment.

Failure to integrate on-chip devices into the PCI world also means
thing like SR-IOv won't work sanely with on-chip devices.

The only reason we should see multi-domain on a SOC is because the HW
design was lazy. Being lazy misses the Big Picture where PCI is the
cornerstone of many important Server/Enterprise technologies.

> > SOC internal peripherals should all show up in the bus 0 config space
> > of the only domain and SOC PCI-E physical ports should show up on bus
> > 0 as PCI-PCI bridges. This is all covered in the PCI-E specs regarding
> > the root complex.
> > 
> > Generally I would expect the internal peripherals to still be
> > internally connected with AXI, but also connected through the ECAM
> > space for configuration, control, power management and address
> > assignment.
> 
> That would of course be very nice from a software perspective,
> but I think that is much less likely for any practical
> implementation.

Well, all x86 implementations do this already.. It actually isn't that
big a deal from a HW perspective, you just have to think about it
fully, understand PCI, and position your registers accordingly.

Jason
