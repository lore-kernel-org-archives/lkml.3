Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab3LKUtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:49:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59489 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:49:33 -0500
Message-ID: <52A8CFD9.6030002@wwwdotorg.org>
Date: Wed, 11 Dec 2013 13:49:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chaitanya Bandi <bandik@nvidia.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com
CC: thierry.reding@gmail.com, ldewangan@nvidia.com, dmaengine@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: Use runtime_pm for clk enable/disable
References: <1386751756-12583-1-git-send-email-bandik@nvidia.com>
In-Reply-To: <1386751756-12583-1-git-send-email-bandik@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 01:49 AM, Chaitanya Bandi wrote:
> Used runtime_pm APIs for clock enabling/disabling.
> Made changes such that clock is not enabled during
> idle. Also moved the usage of clk prepare/unprepare
> such that they are not called in isr context.

Hmm. This is going to cause conflicts with the patch I'm taking through
the Tegra tree which converts the driver to support the standard DMA DT
bindings. Perhaps this can wait until 3.15, or perhaps we can merge the
Tegra branch back into the DMA tree to resolve the conflict.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c

> - * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + * Copyright (c) 2012-13, NVIDIA CORPORATION.  All rights reserved.

s/13/2013/

> @@ -580,6 +580,11 @@ static void handle_once_dma_done(struct tegra_dma_channel *tdc,
>  	list_add_tail(&sgreq->node, &tdc->free_sg_req);
>  
>  	/* Do not start DMA if it is going to be terminate */
> +	if (list_empty(&tdc->pending_sg_req) && (!to_terminate)) {
> +		clk_disable(tdc->tdma->dma_clk);
> +		pm_runtime_put(tdc->tdma->dev);
> +	}
> +
>  	if (to_terminate || list_empty(&tdc->pending_sg_req))
>  		return;

Don't you want to insert the new code before the comment? Otherwise,
you're separating the existing comment and code.

Here and many other places, both pm_runtime_get/put *and*
clk_enable/disable are called. Why doesn't the code *just* call
pm_runtime_get/put, and let the implementation of those APIs perform the
clock_enable/disable? That'd be a lot more typical.

Most of the new calls to pm_runtime_*()/clk_{en,dis}able() are missing
error checking.

> @@ -682,12 +687,21 @@ static void tegra_dma_issue_pending(struct dma_chan *dc)

> +	pm_runtime_get(tdc->tdma->dev);

I think you need pm_runtime_get_sync() here to make sure the clock gets
turned on immediately? Perhaps that why...

> +	ret = clk_enable(tdc->tdma->dma_clk);

... there's also direct manipulation of the clock everywhere.

Also, shouldn't the DMA core be calling pm_runtime_get(), rather than
each individual DMA driver?
