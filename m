Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaI2SRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:17:53 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:52339 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaI2SRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <1411937610-22125-4-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <1411937610-22125-4-git-send-email-suravee.suthikulpanit@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Sep 2014 12:17:29 -0600
Message-ID: <CAErSpo6SngcV6_Ew0DOjW+xTw8y6j3UmwdPw1x-tk_AB=mapaQ@mail.gmail.com>
Subject: Re: [RFC 3/4] arm64: Do not call enable PCI resources when specify PCI_PROBE_ONLY
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 2:53 PM,  <suravee.suthikulpanit@amd.com> wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> When specify PCI_PROBE_ONLY, the resource parent does not get assigned.
> Therefore, pci_enable_resources() return error saying that
> "BAR x not claimed".
>
> Note: This same logic is also used in the arch/arm/kernel/bios32.c
>
> Cc: Liviu Dudau <Liviu.Dudau@arm.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  arch/arm64/kernel/pci.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> index ce5836c..7fd4d2b 100644
> --- a/arch/arm64/kernel/pci.c
> +++ b/arch/arm64/kernel/pci.c
> @@ -68,3 +68,11 @@ void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>         bus->domain_nr = domain;
>  }
>  #endif
> +
> +int pcibios_enable_device(struct pci_dev *dev, int mask)
> +{
> +       if (pci_has_flag(PCI_PROBE_ONLY))
> +               return 0;
> +
> +       return pci_enable_resources(dev, mask);

I had thought of "PCI_PROBE_ONLY" as the "look but don't touch" flag,
i.e., never change any BAR or bridge window assignments.  But I guess
the current usage is more general than that: we also use it to

  - avoid pci_enable_resources(), which only turns on IO/MEM bits in
the command register
  - avoid pcie_bus_configure_settings(), which programs MPS and MRRS
  - avoid pci_read_bridge_bases(), which really just *reads* bridge windows
  - avoid pcibios_reserve_legacy_regions(), which doesn't touch any
PCI registers
  - enables pci_claim_resource()

This seems like more than necessary, but I don't know all the history.
In particular, I don't know why PCI_PROBE_ONLY should make a
difference to things like claiming resources.

> +}
> --
> 1.9.3
>b
