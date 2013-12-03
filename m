Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3LCRuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:50:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38005 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3LCRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:50:10 -0500
Message-ID: <529E19CD.1050705@wwwdotorg.org>
Date: Tue, 03 Dec 2013 10:50:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
CC: andriy.shevchenko@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4] dma: add channel request API that supports deferred
 probe
References: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:04 AM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> dma_request_slave_channel() simply returns NULL whenever DMA channel
> lookup fails. Lookup could fail for two distinct reasons:
> 
> a) No DMA specification exists for the channel name.
>    This includes situations where no DMA specifications exist at all, or
>    other general lookup problems.
> 
> b) A DMA specification does exist, yet the driver for that channel is not
>    yet registered.
> 
> Case (b) should trigger deferred probe in client drivers. However, since
> they have no way to differentiate the two situations, it cannot.
> 
> Implement new function dma_request_slave_channel_reason(), which performs
> identically to dma_request_slave_channel(), except that it returns an
> error-pointer rather than NULL, which allows callers to detect when
> deferred probe should occur.
> 
> Eventually, all drivers should be converted to this new API, the old API
> removed, and the new API renamed to the more desirable name. This patch
> doesn't convert the existing API and all drivers in one go, since some
> drivers call dma_request_slave_channel() then dma_request_channel() if
> that fails. That would require either modifying dma_request_channel() in
> the same way, or adding extra error-handling code to all affected
> drivers, and there are close to 100 drivers using the other API, rather
> than just the 15-20 or so that use dma_request_slave_channel(), which
> might be tenable in a single patch.
> 
> acpi_dma_request_slave_chan_by_name() doesn't currently implement
> deferred probe. It should, but this will be addressed later.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v4:
> * Add {} around both branches in of_dma_request_slave_channel().
> v3:
> * s/_or_err/_reason/ in the new API name.
> * Simplify changes to of_dma_request_slave_channel() so that the new
>   "bool defer" parameter is not needed.
> * Revert changes to acpi-dma.c and handle the return value conversion
>   in dma_request_slave_channel_reason() instead.
> * Mention that acpi_dma_request_slave_chan_by_name() should implement
>   deferred probe, but that will happen later.
> v2:
> * include <linux/err.h> in <linux/dmaengine.h>
> * Return -ENODATA if slave_id or chan_id out-of-range.
> * Return an error-pointer not NULL if we can't find a matching DMA
>   controller or translate the channel.
> 
> This patch is a dependency for:
> * A series that reworks many of the Tegra drivers.
> * A series that enhances ASoC's dmaengine code to support deferred probe.
> 
> As such, it needs to go into a topic branch on its own, based directly
> on 3.13-rc1. If the DMA maintainers ack the patches I'm happy to create
> this topic branch myself and send a pull request to the DMA tree. Or the
> patches can be applied to a topic branch by the DMA maintainers and I
> will merge their topic branch into the Tegra rework branch that I
> mentioned.

Vinod, does this patch look OK to you? Are you able to stage it into a
topic branch that I can pull into the Tegra tree as a dependency?
