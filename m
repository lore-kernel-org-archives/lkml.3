Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3LPSeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:34:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54564 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:34:17 -0500
Message-ID: <52AF47A4.6010501@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:34:12 -0700
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
Subject: Re: [PATCHv7 03/12] iommu/of: check if dependee iommu is ready or
 not
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-4-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-4-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> IOMMU devices on the bus need to be poplulated first, then iommu
> master devices are done later.
> 
> With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
> whether a device can be an iommu msater or not. If a device can, we'll
> defer to populate that device till an depending iommu device is
> populated.

> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c

> +int of_iommu_attach(struct device *dev)
> +{
> +	const __be32 *cur, *end;
> +	struct of_phandle_args args;
> +
> +	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> +				       "#iommu-cells", 0, args, cur, end) {
> +		if (!of_find_iommu_by_node(args.np))
> +			return -EPROBE_DEFER;

I think that since of_find_iommu_by_node() should be calling
iommu_get(iommu), the error-case here should loop over the IOMMUs that
have successfully been acquired, and call iommu_put().

You'd also want to implement of_iommu_detach() or iommu_detach() to undo
the iommu_get()s that happen within this function.
