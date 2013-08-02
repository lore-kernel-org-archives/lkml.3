Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3HBUwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:52:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45769 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3HBUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:52:04 -0400
Message-ID: <51FC1BF1.7080401@wwwdotorg.org>
Date: Fri, 02 Aug 2013 14:52:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Richard Zhao <rizhao@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vinod.koul@intel.com, djbw@fb.com
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate possible
 check of_node
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com> <51FBA0BB.6080408@ti.com>
In-Reply-To: <51FBA0BB.6080408@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 06:06 AM, Santosh Shilimkar wrote:
> On Thursday 01 August 2013 10:00 PM, Richard Zhao wrote:
>> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
>> so the filter function could access of_node in of_phandle_args.
>>
> Am just curious the reasoning behind doing so. Can you please expand
> above bit more with why you need to change it.

I believe that this patch is attempting to solve an issue I pointed out
with the following patch, which enhances the Tegra DMA controller driver
to support the standard DMA DT bindings:

https://lkml.org/lkml/2013/7/24/7
[PATCH 2/9] dma: tegra20-apbdma: move to generic device tree bindings

The issue is in particular that patch included:

> +static bool tegra_dma_filter_fn(struct dma_chan *dc, void *param)
> +{
> +	if (dc->device->dev->driver == &tegra_dmac_driver.driver) {
> +		struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +		unsigned req = *(unsigned *)param;
> +
> +		tdc->slave_id = req;
> +
> +		return true;
> +	}
> +	return false;
> +}

Which is checking that the provider of the DMA channel is the correct
DMA controller. The DMA core should be able to work this out, since at
least under DT, the DT property specifies both the DMA controller's
phandle and the DMA specifier, so that DMA core should be able to
validate that it only attempts to match DMA channels for the specified
DMA controller, without each DMA controller driver having to implement a
custom filter function to do that.
