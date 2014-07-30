Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaG3RfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:35:13 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:37678 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbaG3RfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:35:07 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:2811:8aec:a585:9833]
In-Reply-To: <20140730152646.GC20162@leverpostej>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
	<20140730152646.GC20162@leverpostej>
Date: Wed, 30 Jul 2014 10:35:06 -0700
Message-ID: <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
From: Olof Johansson <olof@lixom.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 30, 2014 at 8:26 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Thierry,
>
> This looks sane to me.
>
> I just have a few questions below which are hopefully simple/stupid.
>
> On Fri, Jul 04, 2014 at 04:29:17PM +0100, Thierry Reding wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> This commit introduces a generic device tree binding for IOMMU devices.
>> Only a very minimal subset is described here, but it is enough to cover
>> the requirements of both the Exynos System MMU and Tegra SMMU as
>> discussed here:
>>
>>     https://lkml.org/lkml/2014/4/27/346
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>> Changes in v4:
>> - clarify that disabling an IOMMU DT node may not disable translation
>> - be more explicit that examples are only examples
>> - add multi-ID master example
>>
>> Changes in v3:
>> - use #iommu-cells instead of #address-cells/#size-cells
>> - drop optional iommu-names property
>>
>> Changes in v2:
>> - add notes about "dma-ranges" property (drop note from commit message)
>> - document priorities of "iommus" property vs. "dma-ranges" property
>> - drop #iommu-cells in favour of #address-cells and #size-cells
>> - remove multiple-master device example
>>
>>  Documentation/devicetree/bindings/iommu/iommu.txt | 172 ++++++++++++++++++++++
>>  1 file changed, 172 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt
>> new file mode 100644
>> index 000000000000..464a81eaaf61
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iommu/iommu.txt
>> @@ -0,0 +1,172 @@
>> +This document describes the generic device tree binding for IOMMUs and their
>> +master(s).
>> +
>> +
>> +IOMMU device node:
>> +==================
>> +
>> +An IOMMU can provide the following services:
>> +
>> +* Remap address space to allow devices to access physical memory ranges that
>> +  they otherwise wouldn't be capable of accessing.
>> +
>> +  Example: 32-bit DMA to 64-bit physical addresses
>> +
>> +* Implement scatter-gather at page level granularity so that the device does
>> +  not have to.
>> +
>> +* Provide system protection against "rogue" DMA by forcing all accesses to go
>> +  through the IOMMU and faulting when encountering accesses to unmapped
>> +  address regions.
>> +
>> +* Provide address space isolation between multiple contexts.
>> +
>> +  Example: Virtualization
>> +
>> +Device nodes compatible with this binding represent hardware with some of the
>> +above capabilities.
>> +
>> +IOMMUs can be single-master or multiple-master. Single-master IOMMU devices
>> +typically have a fixed association to the master device, whereas multiple-
>> +master IOMMU devices can translate accesses from more than one master.
>> +
>> +The device tree node of the IOMMU device's parent bus must contain a valid
>> +"dma-ranges" property that describes how the physical address space of the
>> +IOMMU maps to memory. An empty "dma-ranges" property means that there is a
>> +1:1 mapping from IOMMU to memory.
>> +
>> +Required properties:
>> +--------------------
>> +- #iommu-cells: The number of cells in an IOMMU specifier needed to encode an
>> +  address.
>> +
>> +The meaning of the IOMMU specifier is defined by the device tree binding of
>> +the specific IOMMU. Below are a few examples of typical use-cases:
>> +
>> +- #iommu-cells = <0>: Single master IOMMU devices are not configurable and
>> +  therefore no additional information needs to be encoded in the specifier.
>> +  This may also apply to multiple master IOMMU devices that do not allow the
>> +  association of masters to be configured. Note that an IOMMU can by design
>> +  be multi-master yet only expose a single master in a given configuration.
>> +  In such cases the number of cells will usually be 1 as in the next case.
>> +- #iommu-cells = <1>: Multiple master IOMMU devices may need to be configured
>> +  in order to enable translation for a given master. In such cases the single
>> +  address cell corresponds to the master device's ID. In some cases more than
>> +  one cell can be required to represent a single master ID.
>> +- #iommu-cells = <4>: Some IOMMU devices allow the DMA window for masters to
>> +  be configured. The first cell of the address in this may contain the master
>> +  device's ID for example, while the second cell could contain the start of
>> +  the DMA window for the given device. The length of the DMA window is given
>> +  by the third and fourth cells.
>> +
>> +Note that these are merely examples and real-world use-cases may use different
>> +definitions to represent their individual needs. Always refer to the specific
>> +IOMMU binding for the exact meaning of the cells that make up the specifier.
>> +
>> +
>> +IOMMU master node:
>> +==================
>> +
>> +Devices that access memory through an IOMMU are called masters. A device can
>> +have multiple master interfaces (to one or more IOMMU devices).
>> +
>> +Required properties:
>> +--------------------
>> +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
>> +  master interfaces of the device. One entry in the list describes one master
>> +  interface of the device.
>> +
>> +When an "iommus" property is specified in a device tree node, the IOMMU will
>> +be used for address translation. If a "dma-ranges" property exists in the
>> +device's parent node it will be ignored. An exception to this rule is if the
>> +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
>> +parent shall take effect. Note that merely disabling a device tree node does
>> +not guarantee that the IOMMU is really disabled since the hardware may not
>> +have a means to turn off translation.

How do you know if the IOMMU is disabled then? Runtime by checking
status of the iommu?

>> +
>> +
>> +Notes:
>> +======
>> +
>> +One possible extension to the above is to use an "iommus" property along with
>> +a "dma-ranges" property in a bus device node (such as PCI host bridges). This
>> +can be useful to describe how children on the bus relate to the IOMMU if they
>> +are not explicitly listed in the device tree (e.g. PCI devices). However, the
>> +requirements of that use-case haven't been fully determined yet. Implementing
>> +this is therefore not recommended without further discussion and extension of
>> +this binding.
>> +
>> +
>> +Examples:
>> +=========
>> +
>> +Single-master IOMMU:
>> +--------------------
>> +
>> +     iommu {
>> +             #iommu-cells = <0>;
>> +     };
>> +
>> +     master {
>> +             iommus = <&/iommu>;
>
> Nit: this should be iommus = <&{/iommu}>, or it's not valid dts syntax.
>
>> +     };
>> +
>> +Multiple-master IOMMU with fixed associations:
>> +----------------------------------------------
>> +
>> +     /* multiple-master IOMMU */
>> +     iommu {
>> +             /*
>> +              * Masters are statically associated with this IOMMU and
>> +              * address translation is always enabled.
>> +              */
>> +             #iommu-cells = <0>;
>
> I don't follow why translation being always enabled is relevant to the
> example; that would seem to be independent from the binding.
>
> Surely the key point is that with no way to distinguish devices, they
> presumably share the same translations?
>
>> +     };
>> +
>> +     /* static association with IOMMU */
>> +     master@1 {
>> +             reg = <1>;
>> +             iommus = <&/iommu>;
>> +     };
>> +
>> +     /* static association with IOMMU */
>> +     master@2 {
>> +             reg = <2>;
>> +             iommus = <&/iommu>;
>> +     };
>> +
>> +Multiple-master IOMMU:
>> +----------------------
>> +
>> +     iommu {
>> +             /* the specifier represents the ID of the master */
>> +             #iommu-cells = <1>;
>> +     };
>> +
>> +     master@1 {
>> +             /* device has master ID 42 in the IOMMU */
>> +             iommus = <&/iommu 42>;
>> +     };
>> +
>> +     master@2 {
>> +             /* device has master IDs 23 and 24 in the IOMMU */
>> +             iommus = <&/iommu 23>, <&/iommu 24>;
>> +     };
>
> In future I suspect master will need to be able to identify which master
> IDs correspond to which of their master ports (where each port might
> have an arbitrary number of master IDs).
>
> While we don't need that for the first run, it would be nice to have
> that looked into so master bindings don't come up with arbitrarily
> different ways of doing that.

iommu-names would be the logical extension to handle that, just like
we do with other resources, right?

>> +
>> +Multiple-master IOMMU with configurable DMA window:
>> +---------------------------------------------------
>> +
>> +     / {
>> +             #address-cells = <1>;
>> +             #size-cells = <1>;
>> +
>> +             iommu {
>> +                     /* master ID, address and length of DMA window */
>> +                     #iommu-cells = <4>;
>> +             };
>> +
>> +             master {
>> +                     /* master ID 42, 4 GiB DMA window starting at 0 */
>> +                     iommus = <&/iommu  42  0  0x1 0x0>;
>
> Is this that window is from the POV of the master, i.e. the master can
> address 0x0 to 0xffffffff when generating transactions, and these get
> translated somehow?
>
> Or is this the physical addresses to allocate to the master?

It needs to be clarified in the documentation, but as far as I know it
is the DMA address space that is used.

It is somewhat confusing to have size-cells = 1 and then use 2 cells
for size in the iommu property. It's legal and expected, but having
size-cells in the example adds a little confusion.

Either way, I'm OK with fixing the above with an incremental patch,
assuming there is no disagreements on what's said above.


-Olof
