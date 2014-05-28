Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaE1F3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:29:21 -0400
Received: from erley.org ([97.107.129.9]:46191 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaE1F3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:29:20 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 01:29:19 EDT
Message-ID: <538572E2.5030909@erley.org>
Date: Wed, 28 May 2014 00:23:46 -0500
From: Pat Erley <pat-lkml@erley.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org
CC: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Subject: Re: [PATCH v4 00/16] PCI/iommu: Fix DMA alias problems
References: <20140522230230.2856.40017.stgit@bling.home>
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 06:07 PM, Alex Williamson wrote:
> For testing, this version can be found in my git tree:
>
> git://github.com/awilliam/linux-vfio.git dma-alias-v4
>
> Please report any issues.
>
> v4:
>   - Change dma_func_alias to dma_alias_devfn, holding a single
>     devfn to alias, thereby supporting aliases to the wrong slot.
>     The DMA alias iterator is easily changed, but IOMMU grouping
>     requires significant rework.  This is now done in IOMMU code
>     rather than PCI code.
>
>   - AMD-Vi - try to incorporate IVRS aliases dynamically into
>     PCI alias quirks to make sure that our grouping remains the
>     same.  Potentially this could end up reporting BIOS aliases
>     that we can add to our list of quirks.
>
> v3:
>   - Found several instances where I had PCI_SLOT when I meant
>     PCI_FUNC.  Thanks to Andrew for spotting this.  This should
>     fix the problem he was having with Ricoh quirks.  We also
>     pruned down the func0 quirks to only those that we know are
>     needed.  We can always add them back later.
>
>   - Found a case in intel-iommu of using dev_is_pci() where I
>     really wanted !dev_is_pci().  Fixed.
>
> v2:
>   - Several new Marvell controllers added to quirks.  There's been
>     a lot of success reported with this series in
>     https://bugzilla.kernel.org/show_bug.cgi?id=42679
>
>   - Add quirk for ASMedia and Tundra PCIe-to-PCI bridges that do
>     not expose a PCIe capability.  These have been shown to use
>     the standard PCIe-to-PCI bridge requester ID.
>
>   - Fix copy/paste duplicate Ricoh quirk ID
>
>   - Fixed AMD IOMMU for the "ghost" function case where the DMA
>     alias is for an absent device.  The iommu rlookup table and
>     data fields need to be initializes.
>
>   - Fixed Intel interrupt remapping, I wasn't passing the target
>     bus number, only the alias bus number.
>
> These patches are split across PCI and IOMMU, but I've front-loaded
> all of the PCI infrastructure so that the first 7 patches can be
> applied to PCI-core, the IOMMU maintainers can pickup their patches,
> then we can finish with dead code removal.  Bjorn might also be
> willing to carry the IOMMU changes if the maintainers want to ack
> them.
>
> Original description:
>
> This series attempts to fix a couple issues we've had outstanding in
> the PCI/IOMMU code for a while.  The first issue is with devices that
> use the wrong requester ID for DMA transactions.  We already have a
> sort of half-baked attempt to fix this for several Ricoh devices, but
> the fix only helps them be useful through IOMMU groups, not the
> general DMA case.  There are also several Marvell devices which use
> use a different wrong requester ID and don't even fit into the DMA
> source idea.  This series creates a DMA alias iterator that will
> step through each possible alias of a device, allowing IOMMUs to
> insert mappings for both the device and its aliases.
>
> Hand-in-hand with this is our broken pci_find_upstream_pcie_bridge()
> function, which is known to blowup when it finds itself suddenly at
> a PCIe device without crossing a PCIe-to-PCI bridge (as identified by
> the PCIe capability).  It also likes to make the invalid assumption
> that a PCIe device never has its requester ID masked by any usptream
> bus.  We can fix this using the above new DMA alias iterator, since
> that's effectively what this function was meant to do.
>
> Finally, with all these helpers, it makes sense to consolidate code
> for determining IOMMU groups.  The first step in finding the root
> of a group is finding the final upstream DMA alias for the device,
> then applying additional ACS rules and incorporating device specific
> aliases.  As this is all common to PCI, create a single implementation
> and remove piles of code from the individual IOMMU drivers.
>
> This series allows devices like the Marvell 88SE9123 to finally work
> on Linux with either AMD-Vi or VT-d enabled on the box.  I've
> collected device IDs from various bugs to support as many SKUs of
> these devices as possible, but I'm sure there are others that I've
> missed.
>
> This should also enable motherboards with an onboard ASmedia
> ASM1083/1085 PCIe-to-PCI bridge to work with VT-d enabled.  I've
> acquired an adapter board with this chip, but it actually exposes
> a PCIe capability, unlike most of the onboard controllers.  Therefore
> I expect this series will fix the WARN_ON currently hit during boot,
> but there's a 50/50 chance whether the device behaves like a PCI
> bridge or a PCIe bridge with regard to the requester ID that it uses
> to take ownership of the transaction.  If it turns out to use the
> PCIe bridge model, I expect we can quirk it using a dev_flags bit
> to identify a PCI bridge that takes ownership as if it was a PCIe
> bridge.
>
> Please test and provide feedback.  I expect IOMMU group topology
> should not change from this series, but if a case is found where it
> does, please share.  Also, if there are additional quirks we need
> to add, please either file new or add to the existing bugs.  Thanks,
>
> Alex
>
> ---
>
> Alex Williamson (16):
>        PCI: Add DMA alias iterator
>        PCI: define pci_dev_flags as bit shifts
>        PCI: quirk pci_for_each_dma_alias()
>        PCI: quirk dma_alias_devfn for Ricoh devices
>        PCI: quirk dma_alias_devfn for Marvell devices
>        PCI: Quirk pci_for_each_dma_alias() for bridges
>        PCI: Add quirks for ASMedia and Tundra bridges
>        iommu: Create central IOMMU group lookup/creation interface
>        iommu/amd: Update to use PCI DMA aliases
>        iommu/amd: Use iommu_group_get_for_dev()
>        iommu/intel: Use iommu_group_get_for_dev()
>        iommu/intel: Update to use PCI DMA aliases
>        iommu/fsl: Use iommu_group_get_for_dev() for IOMMU groups
>        iommu: Remove pci.h
>        PCI: Remove pci_find_upstream_pcie_bridge()
>        PCI: Remove pci_get_dma_source()
>
>
This series allows my W510 to boot with firewire and VT-d enabled.  I've 
been working around this issue for 2 years.  Feel free to CC me on any 
further iterations of this series.

17:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
17:00.3 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394
         Controller (rev 01)

17:00.0 0805: 1180:e822 (rev 01)
17:00.3 0c00: 1180:e832 (rev 01)

Tested-by: Pat Erley <pat-lkml@erley.org>


