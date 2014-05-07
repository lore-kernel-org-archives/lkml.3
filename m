Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaEGQhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:37:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60677 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaEGQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:37:29 -0400
Message-ID: <536A6145.2080106@wwwdotorg.org>
Date: Wed, 07 May 2014 10:37:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christopher Freeman <cfreeman@nvidia.com>, ldewangan@nvidia.com,
        swarren@nvidia.com, vinod.koul@intel.com, dan.j.williams@intel.com
CC: dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] dma: tegra: finer granularity residual for tx_status
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com> <1399411343-12222-2-git-send-email-cfreeman@nvidia.com>
In-Reply-To: <1399411343-12222-2-git-send-email-cfreeman@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 03:22 PM, Christopher Freeman wrote:
> Get word-level granularity from hardware for calculating
> the transfer count remaining.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c

> +static int tegra_dma_wcount_in_bytes(struct dma_chan *dc)

A lot of the code in this function is identical to the code in
tegra_dma_terminate_all() which does the same thing. Can this be pulled
out into a shared utility function?

> +	tegra_dma_pause(tdc, true);

Is this continual pausing/resuming of the DMA operation going to
negatively affect performance?

> +	/* in case of interrupt, handle it and don't read wcount reg */
> +	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
> +	if (status & TEGRA_APBDMA_STATUS_ISE_EOC) {
> +		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
> +		dev_info(tdc2dev(tdc), "%s():handling isr\n", __func__);

If you swap the order of patches 1 and 2, then you can just add that
line as dev_dbg() from the start, and you won't need to change it in the
next patch.

> +		tdc->isr_handler(tdc, false);
> +		tegra_dma_resume(tdc);
> +		return 0;

Why resume and return here? Shouldn't those last 2 lines be removed, so
the code can simply continue through the balance of the function and
return the actual status. tegra_dma_terminate_all() does that.

> @@ -812,9 +851,22 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
>  	list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
>  		dma_desc = sg_req->dma_desc;
>  		if (dma_desc->txd.cookie == cookie) {
> +			hw_byte_count = tegra_dma_wcount_in_bytes(dc);
> +
> +			if (!list_empty(&tdc->pending_sg_req))

Since this code is inside a loop that iterates over tha list, I don't
think the list can ever be empty.

> +				first_entry =
> +					list_first_entry(&tdc->pending_sg_req,
> +						typeof(*first_entry), node);
> +
>  			residual =  dma_desc->bytes_requested -
>  					(dma_desc->bytes_transferred %
>  						dma_desc->bytes_requested);
> +
> +			/* hw byte count only applies to current transaction */
> +			if (first_entry &&
> +				first_entry->dma_desc->txd.cookie == cookie)
> +				residual -= hw_byte_count;
> +
>  			dma_set_residue(txstate, residual);

Why not re-order the added code so that all the new code is added in one
place, and the hw_byte_count value is only calculated if it's used, i.e.:

residual = ...;
first_entry = ...;
if (sg_reg == first_entry) {
    hw_byte_count = ...;
    residual -= hw_byte_count;
}

