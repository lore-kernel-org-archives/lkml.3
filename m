Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3KSVwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:52:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57610 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3KSVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:52:06 -0500
Message-ID: <528BDD81.1000507@wwwdotorg.org>
Date: Tue, 19 Nov 2013 14:52:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        galak@codeaurora.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 6/9] iommu/tegra: smmu: get swgroups from DT "iommus="
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com> <1384853593-32202-7-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1384853593-32202-7-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 02:33 AM, Hiroshi Doyu wrote:
> This provides the info about which swgroups a device belongs to. This
> info is passed from DT. This is necessary for the unified SMMU driver
> among Tegra SoCs since each has different H/W accelerators.

> diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt

>  - nvidia,#asids : # of ASIDs
>  - dma-window : IOVA start address and length.
>  - nvidia,ahb : phandle to the ahb bus connected to SMMU.
> +- iommus: phandle to an iommu device which a device is
> +  attached to and indicates which swgroups a device belongs to(SWGROUP ID).
> +  SWGROUP ID is from 0 to 63, and a device can belong to multiple SWGROUPS.

I'm sure I've said this before:

#iommu-cells isn't documented.

The list of properties you added to is a list of properties that the
IOMMU node should contain. However, the iommus property is something
that *client* nodes should contain, not the IOMMU node itself.

Instead, I think you want something like:

-Required properties:
+Required properties in the IOMMU node:
 ... the current list of properties
+#iommu-cells. Should be 2. In client IOMMU specifiers, the two cells
+  represent a 64-bit bitmask of SWGROUP IDs under which the device
+  initiates transactions. The least significant word is first. See
+  <dt-bindings/memory/tegra-swgroup.h> for a list of valid values.
+
+Required properties in device nodes affected by the IOMMU:
+- iommus: A list of phandle plus specifier pairs for each IOMMU that
+    affects master transactions initiated by the device. The number of
+    cells in each specifier is defined by the #iommu-cells property in
+    the IOMMU node referred to by the phandle. The meaning of the
+    specifier cells is defined by the referenced IOMMU's binding.

Aside from those layout/wording issues, this is certainly the binding
that I think makes sense.

> +	host1x {
> +		compatible = "nvidia,tegra30-host1x", "simple-bus";
> +		iommus = <&smmu TEGRA_SWGROUP_CELLS(HC)>;
> +		....
> +		gr3d {
> +			compatible = "nvidia,tegra30-gr3d";
> +			nvidia,memory-clients = <&smmu TEGRA_SWGROUP_CELLS(NV)
> +						       TEGRA_SWGROUP_CELLS(NV2)>;

I think you forgot to update "nvidia,memory-clients" to "iommus" there.

> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c

> +static int smmu_of_get_swgroups(struct device *dev, unsigned long *swgroups)

This doesn't seem to be used by anything in this patch.

