Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaBDJpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:45:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaBDJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:45:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 04 Feb 2014 10:44:52 +0100
Message-ID: <13031998.NR888KZWhk@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140203233137.GH2519@obsidianresearch.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com> <20140203233137.GH2519@obsidianresearch.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jfVENLrAKIRzQJuXdzfgDYsisV6HPfTUWvo6hf1lokR
 xi1bfIZChuYi/rvNn85EiwyO8WfaouSKGVLgD0JYYX30hF9fnk
 babZPPAb8rdiEzQNlhP0mxblabvHL/Nxn/G7fkYTdEj8nm2XFM
 8KonUnxQqqJCz5if02wlNjza0O1B4b/5TCn6DLS8vucpKOiDO/
 vDY45CrmXgXTVxj9x3kQghVQC9YKljakkZxjc7hK4FVbXHntTC
 RG92XuUGJvl+rSwJfYlCeMY8LhOrxqfSkFThmz7pW81vL0p8dx
 bv1i50e3Bc+tws6WQSHROTWUGk0Ci8bruCWE4szdEaucfd5mwF
 RMtqi57DJUaKrtyY3JVM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 16:31:37 Jason Gunthorpe wrote:
> Specifying 'use EHCI, AHCI, etc' - which are all PCI based standards
> without clearly specifying exactly how PCI is suppose to work is
> completely bonkers.
> 
> What is needed is a spec that says:
>  1) Here is how you generate config TLPs. A MMIO region that
>     conforms to the already specified x86 ECAM would
>     be perfect
>  2) Here is a dword by dword break down of the entire config space in
>     a SOC. Here is where a on-board AHCI controller must show up in
>     config space. Here is how an external PCI-E port must show
>     up. Etc. Most of this is already specified, but it clearly needs
>     to be layed out explicitly for ARM SOCs to actually follow it.
>  3) Here is how you specify the aperture(s) associated with PCI BAR's
>     and bridge windows in config space. And yes: The CONFIG SPACE
>     BARS MUST WORK.
>  4) Here is how MSI works, these are the values you put in the
>     address/data and here is how you collect the interrupt.
>  5) Here is how Legacy INTx must be mapped into the GIC.
> 
> This is what x86 does, and they have been doing it well for 10
> years. If you want to play in the server game you have to properly
> implement PCI.

I'm pretty sure the authors of the SBSA actually thought that was
what they wrote, by referring to external specifications (pci-3.0,
ehci, ahci, ...).  However, it seems they were either foolish enough
to believe that hardware designers would follow these specs, or
they were intentionally misled and got talked into putting ambiguous
terminology in because there were already hardware designs that
are not exactly in line with the spirit of the SBSA but can be
argued to be conforming to the text for a lax interpretation.

I think EHCI is a much better example than PCI here, because the
spec has exactly one line to say about it, where it spends a whole
chapter on PCI.

Here is how a sane person would read SBSA to create a compliant
implementation:

  I have to use EHCI version 1.1 to provide USB-2.0 support. EHCI
  is a PCI device, so I'll put it behind a PCIe port that complies
  to the PCIe section of the SBSA. Since EHCI by itself only provides
  high-speed USB, and USB-2.0 mandates I provide low-speed and
  full-speed as well, I have to add a USB hub device. It would have
  been easier to just use OHCI for these, but SBSA says I can't.
  Now I want to integrate the EHCI into my SoC and not waste one
  of my precious PCIe root ports, so I have to create another PCI
  domain with its own ECAM compliant config space to put it into.
  Fortunately SBSA lets me add an arbitrary number of PCI domains,
  as long as they are all strictly compliant. To software it will
  look exactly as if it was on an external card, I just have to
  ensure the boot loader correctly sets up the clocks and the phy
  before an SBSA compliant OS gets loaded, all runtime power
  management will get handled through the EHCI-1.1 energy-efficiency
  extensions.

Here is how a crazy person would read the same sentence in the SBSA:

  I have an IP block that implements the EHCI register set, that
  should be good enough. It's not a fast device, so I can put it
  on a non-coherent bus. Since the SoC will be used for networking,
  I'll put the registers into big-endian configuration to make it
  easier for the OS to access. I'm not allowed to have USB-1.1
  according to SBSA, so I can get away without a hub or an extra
  OHCI. I can't support MSI because it's not a PCI device, and
  the GIC is pretty full, so I'll just connect the IRQ line to
  the GPIO controller. In order to do better power management,
  I'll design a fancy PHY that the device driver will manage
  for implementing autosuspend. I should also give the OS
  fine-grained control over the clocks, but it will have to share
  the clock domain with the other devices on the same edge of the
  chip. The EHCI device is not part of PCI, which measn I don't
  have to use the standard SMMU. However, my EHCI implementation
  can only do 32-bit DMA, and I'll have to design my own IOMMU
  to let it access the entire memory range. USB-OTG is a great
  feature and we already paid for having this in our EHCI
  implementation, better make sure it comes up in endpoint mode
  after waking up from power saving.

	Arnd
