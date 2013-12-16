Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3LPScz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:32:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58361 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:32:53 -0500
Message-ID: <52AF474F.7080701@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:32:47 -0700
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
Subject: Re: [PATCHv7 02/12] iommu/of: introduce a global iommu device list
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-3-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-3-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> This enables to find an populated IOMMU device via a device node. This
> can be used to see if an dependee IOMMU is populated or not to keep
> correct device population order. Client devices need to wait an IOMMU
> to be populated.
> 
> Suggested by Thierry Reding and copied his example code.

> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c

> +static struct iommu *of_find_iommu_by_node(struct device_node *np)
> +{
> +	struct iommu *iommu;
> +
> +	mutex_lock(&iommus_lock);
> +	list_for_each_entry(iommu, &iommus_list, list) {
> +		if (iommu->dev->of_node == np) {
> +			mutex_unlock(&iommus_lock);

Now that the list is unlocked, the IOMMU could be removed from the list,
and the driver unregistered. Should you do something like
iommu_get(iommu); before the mutex_unlock() call, and call iommu_put()
somewhere (i.e. in the next patch ...)?
