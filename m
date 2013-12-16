Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3LPTPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:15:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51459 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3LPTPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:15:34 -0500
Message-ID: <52AF5003.4040406@wwwdotorg.org>
Date: Mon, 16 Dec 2013 12:09:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 09/12] iommu/tegra: smmu: get swgroups from DT "iommus="
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-10-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-10-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> This provides the info about which swgroups a device belongs to. This
> info is passed from DT. This is necessary for the unified SMMU driver
> among Tegra SoCs since each has different H/W accelerators.

> diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt

> -Required properties:
> +Required properties in the IOMMU node:
...
> +- iommus: phandle to an iommu device which a device is
> +  attached to and indicates which swgroups a device belongs to(SWGROUP ID).
> +  SWGROUP ID is from 0 to 63, and a device can belong to multiple SWGROUPS.

Shouldn't that property have been deleted from the "Required properties
in the IOMMU node" section, when it got move to the "Required properties
in device nodes affected by the IOMMU" section?

> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c

> +static int smmu_of_get_swgroups(struct device *dev, unsigned long *swgroups)

> +	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> +					       "#iommu-cells", 0, args, cur, end) {
> +		if (args.np != smmu_handle->dev->of_node)
> +			continue;
> +
> +		BUG_ON(args.args_count != 2);

Wouldn't it be better to WARN() and prevent the IOMMU from affecting
that given client device, i.e. simply return some error?

> @@ -719,21 +812,16 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,

> -	client->dev = dev;
> -	client->as = as;
> -	map = (unsigned long *)dev->platform_data;
> -	if (!map)
> -		return -EINVAL;

OK good, so this does get deleted. Ignore my comment re: this on an
earlier patch then.
