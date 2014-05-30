Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaE3NQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:16:10 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40535 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbaE3NQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
Date: Fri, 30 May 2014 08:16:05 -0500
Message-ID: <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
From: Rob Herring <robherring2@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
>
>     https://lkml.org/lkml/2014/4/27/346
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - add notes about "dma-ranges" property (drop note from commit message)
> - document priorities of "iommus" property vs. "dma-ranges" property
> - drop #iommu-cells in favour of #address-cells and #size-cells
> - remove multiple-master device example
>
>  Documentation/devicetree/bindings/iommu/iommu.txt | 167 ++++++++++++++++++++++
>  1 file changed, 167 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
>
> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt
> new file mode 100644
> index 000000000000..6ce759afcc94
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iommu/iommu.txt
> @@ -0,0 +1,167 @@
> +This document describes the generic device tree binding for IOMMUs and their
> +master(s).
> +
> +
> +IOMMU device node:
> +==================
> +
> +An IOMMU can provide the following services:
> +
> +* Remap address space to allow devices to access physical memory ranges that
> +  they otherwise wouldn't be capable of accessing.
> +
> +  Example: 32-bit DMA to 64-bit physical addresses
> +
> +* Implement scatter-gather at page level granularity so that the device does
> +  not have to.
> +
> +* Provide system protection against "rogue" DMA by forcing all accesses to go
> +  through the IOMMU and faulting when encountering accesses to unmapped
> +  address regions.
> +
> +* Provide address space isolation between multiple contexts.
> +
> +  Example: Virtualization
> +
> +Device nodes compatible with this binding represent hardware with some of the
> +above capabilities.
> +
> +IOMMUs can be single-master or multiple-master. Single-master IOMMU devices
> +typically have a fixed association to the master device, whereas multiple-
> +master IOMMU devices can translate accesses from more than one master.
> +
> +The device tree node of the IOMMU device's parent bus must contain a valid
> +"dma-ranges" property that describes how the physical address space of the
> +IOMMU maps to memory. An empty "dma-ranges" property means that there is a
> +1:1 mapping from IOMMU to memory.
> +
> +Required properties:
> +--------------------
> +- #address-cells: The number of cells in an IOMMU specifier needed to encode
> +  an address.
> +- #size-cells: The number of cells in an IOMMU specifier needed to represent
> +  the length of an address range.
> +
> +Typical values for the above include:
> +- #address-cells = <0>, size-cells = <0>: Single master IOMMU devices are not
> +  configurable and therefore no additional information needs to be encoded in
> +  the specifier. This may also apply to multiple master IOMMU devices that do
> +  not allow the association of masters to be configured.
> +- #address-cells = <1>, size-cells = <0>: Multiple master IOMMU devices may
> +  need to be configured in order to enable translation for a given master. In
> +  such cases the single address cell corresponds to the master device's ID.
> +- #address-cells = <2>, size-cells = <2>: Some IOMMU devices allow the DMA
> +  window for masters to be configured. The first cell of the address in this
> +  may contain the master device's ID for example, while the second cell could
> +  contain the start of the DMA window for the given device. The length of the
> +  DMA window is specified by two additional cells.
> +
> +
> +IOMMU master node:
> +==================
> +
> +Devices that access memory through an IOMMU are called masters. A device can
> +have multiple master interfaces (to one or more IOMMU devices).
> +
> +Required properties:
> +--------------------
> +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
> +  master interfaces of the device. One entry in the list describes one master
> +  interface of the device.
> +
> +When an "iommus" property is specified in a device tree node, the IOMMU will
> +be used for address translation. If a "dma-ranges" property exists in the
> +device's parent node it will be ignored. An exception to this rule is if the
> +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
> +parent shall take effect.

Just thinking out loud, could you have dma-ranges in the iommu node
for the case when the iommu is enabled rather than putting the DMA
window information into the iommus property?

This would probably mean that you need both #iommu-cells and #address-cells.

> +
> +Optional properties:
> +--------------------
> +- iommu-names: A list of names identifying each entry in the "iommus"
> +  property.

Do we really need a name here? I would not expect that you have
clearly documented names here from the datasheet like you would for
interrupts or clocks, so you'd just be making up names. Sorry, but I'm
not a fan of names properties in general.

> +
> +
> +Notes:
> +======
> +
> +One possible extension to the above is to use an "iommus" property along with
> +a "dma-ranges" property in a bus device node (such as PCI host bridges). This
> +can be useful to describe how children on the bus relate to the IOMMU if they
> +are not explicitly listed in the device tree (e.g. PCI devices). However, the
> +requirements of that use-case haven't been fully determined yet. Implementing
> +this is therefore not recommended without further discussion and extension of
> +this binding.
> +
> +

[...]

> +Multiple-master IOMMU:
> +----------------------
> +
> +       iommu {
> +               /* the specifier represents the ID of the master */
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +       };
> +
> +       master {
> +               /* device has master ID 42 in the IOMMU */
> +               iommus = <&/iommu 42>;
> +       };

Presumably the ID would be the streamID on ARM's SMMU. How would a
master with 8 streamIDs be described? This is what Calxeda midway has
for SATA and I would expect that to be somewhat common. Either you
need some ID masking or you'll have lots of duplication when you have
windows.

Rob
