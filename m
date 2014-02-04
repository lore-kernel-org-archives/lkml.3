Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaBDN5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:57:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33109 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaBDN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <13031998.NR888KZWhk@wuerfel>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
	<CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
	<20140203233137.GH2519@obsidianresearch.com>
	<13031998.NR888KZWhk@wuerfel>
Date: Tue, 4 Feb 2014 07:57:41 -0600
Message-ID: <CAL_JsqLN4RjVzNCfZ50K44RcP61Z8zFOVnpY1+CfVFz_QnSBEg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 3:44 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 03 February 2014 16:31:37 Jason Gunthorpe wrote:
>> Specifying 'use EHCI, AHCI, etc' - which are all PCI based standards
>> without clearly specifying exactly how PCI is suppose to work is
>> completely bonkers.
>>
>> What is needed is a spec that says:
>>  1) Here is how you generate config TLPs. A MMIO region that
>>     conforms to the already specified x86 ECAM would
>>     be perfect
>>  2) Here is a dword by dword break down of the entire config space in
>>     a SOC. Here is where a on-board AHCI controller must show up in
>>     config space. Here is how an external PCI-E port must show
>>     up. Etc. Most of this is already specified, but it clearly needs
>>     to be layed out explicitly for ARM SOCs to actually follow it.
>>  3) Here is how you specify the aperture(s) associated with PCI BAR's
>>     and bridge windows in config space. And yes: The CONFIG SPACE
>>     BARS MUST WORK.
>>  4) Here is how MSI works, these are the values you put in the
>>     address/data and here is how you collect the interrupt.
>>  5) Here is how Legacy INTx must be mapped into the GIC.
>>
>> This is what x86 does, and they have been doing it well for 10
>> years. If you want to play in the server game you have to properly
>> implement PCI.
>
> I'm pretty sure the authors of the SBSA actually thought that was
> what they wrote, by referring to external specifications (pci-3.0,
> ehci, ahci, ...).  However, it seems they were either foolish enough
> to believe that hardware designers would follow these specs, or
> they were intentionally misled and got talked into putting ambiguous
> terminology in because there were already hardware designs that
> are not exactly in line with the spirit of the SBSA but can be
> argued to be conforming to the text for a lax interpretation.
>
> I think EHCI is a much better example than PCI here, because the
> spec has exactly one line to say about it, where it spends a whole
> chapter on PCI.
>
> Here is how a sane person would read SBSA to create a compliant
> implementation:

s/sane/software/

>
>   I have to use EHCI version 1.1 to provide USB-2.0 support. EHCI
>   is a PCI device, so I'll put it behind a PCIe port that complies
>   to the PCIe section of the SBSA. Since EHCI by itself only provides
>   high-speed USB, and USB-2.0 mandates I provide low-speed and
>   full-speed as well, I have to add a USB hub device. It would have
>   been easier to just use OHCI for these, but SBSA says I can't.
>   Now I want to integrate the EHCI into my SoC and not waste one
>   of my precious PCIe root ports, so I have to create another PCI
>   domain with its own ECAM compliant config space to put it into.
>   Fortunately SBSA lets me add an arbitrary number of PCI domains,
>   as long as they are all strictly compliant. To software it will
>   look exactly as if it was on an external card, I just have to
>   ensure the boot loader correctly sets up the clocks and the phy
>   before an SBSA compliant OS gets loaded, all runtime power
>   management will get handled through the EHCI-1.1 energy-efficiency
>   extensions.
>
> Here is how a crazy person would read the same sentence in the SBSA:

s/crazy/hardware/

>
>   I have an IP block that implements the EHCI register set, that
>   should be good enough. It's not a fast device, so I can put it
>   on a non-coherent bus. Since the SoC will be used for networking,
>   I'll put the registers into big-endian configuration to make it
>   easier for the OS to access. I'm not allowed to have USB-1.1
>   according to SBSA, so I can get away without a hub or an extra
>   OHCI. I can't support MSI because it's not a PCI device, and
>   the GIC is pretty full, so I'll just connect the IRQ line to
>   the GPIO controller. In order to do better power management,
>   I'll design a fancy PHY that the device driver will manage
>   for implementing autosuspend. I should also give the OS
>   fine-grained control over the clocks, but it will have to share
>   the clock domain with the other devices on the same edge of the
>   chip. The EHCI device is not part of PCI, which measn I don't
>   have to use the standard SMMU. However, my EHCI implementation
>   can only do 32-bit DMA, and I'll have to design my own IOMMU
>   to let it access the entire memory range. USB-OTG is a great
>   feature and we already paid for having this in our EHCI
>   implementation, better make sure it comes up in endpoint mode
>   after waking up from power saving.

My money is on the latter. I think non-PCI implementations of xHCI
interfaces will be common. This was certainly the case at Calxeda in
what was believed to be a SBSA compliant SOC. However, I think PCI
device or not is the least of the issues and all the other examples
you list are the difficult ones to deal with.

Rob
