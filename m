Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaBCXbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:31:46 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:56397 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbaBCXbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:31:43 -0500
Date: Mon, 3 Feb 2014 16:31:37 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140203233137.GH2519@obsidianresearch.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <21596846.kVTqp7roW4@wuerfel>
 <20140203191837.GC4889@e106497-lin.cambridge.arm.com>
 <3808209.DeG1VobanZ@wuerfel>
 <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 05:07:48PM -0600, Rob Herring wrote:

> > An interesting question however is what the transition plan is to
> > have the code shared between arm32 and arm64: We will certainly need
> > to share at least the dw-pcie and the generic SBSA compliant pci
> > implementation.
> 
> You might want to re-read the SBSA. Unless ARM provides an IP block or
> there is some other standard such as EHCI or AHCI, there is no generic
> implementation. You only have to go look at the Linux EHCI or AHCI
> drivers and see how meaningless and inadequate "use EHCI" is. For PCI,
> the text is so brief in the SBSA there will be no way PCI is going to
> just work given all the variations of root complexes, bridges, address
> windows, etc. we typically see on ARM platforms. I could be wrong and
> some AML magic will solve all the problems. :)

The biggest hinderance I've seen while looking at ARM PCI drivers is
quite simply - they don't follow the PCI-E spec. There is a spec, and
it is not followed.

This fixup in the X-Gene is a solid example, the purpose of the BAR in
a PCI-PCI bridge is very clear: using it to specify the system
DRAM aperature is completely wrong.

Not having working aperture windows in the root complex's bridges is
completely wrong.

Lacking any ability to generate 8 and 16 bit config write TLP's is
wrong.

Starting with an end-port PCI-E core and re-tasking it to be a root
port bridge and ignoring all the requirements with the bridge's config
space is utterly and completely WRONG.

Specifying 'use EHCI, AHCI, etc' - which are all PCI based standards
without clearly specifying exactly how PCI is suppose to work is
completely bonkers.

What is needed is a spec that says:
 1) Here is how you generate config TLPs. A MMIO region that
    conforms to the already specified x86 ECAM would
    be perfect
 2) Here is a dword by dword break down of the entire config space in
    a SOC. Here is where a on-board AHCI controller must show up in
    config space. Here is how an external PCI-E port must show
    up. Etc. Most of this is already specified, but it clearly needs
    to be layed out explicitly for ARM SOCs to actually follow it.
 3) Here is how you specify the aperture(s) associated with PCI BAR's
    and bridge windows in config space. And yes: The CONFIG SPACE
    BARS MUST WORK.
 4) Here is how MSI works, these are the values you put in the
    address/data and here is how you collect the interrupt.
 5) Here is how Legacy INTx must be mapped into the GIC.

This is what x86 does, and they have been doing it well for 10
years. If you want to play in the server game you have to properly
implement PCI.

Jason
