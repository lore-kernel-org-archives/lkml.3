Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaJ1Wbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:31:44 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:49060 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaJ1Wbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:31:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 10/58] dmaengine: Create a generic dma_slave_caps callback
Date: Wed, 29 Oct 2014 00:31:50 +0200
Message-ID: <2404835.bBK1tFY7m2@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1414531573-18807-11-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com> <1414531573-18807-11-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Tuesday 28 October 2014 22:25:25 Maxime Ripard wrote:
> dma_slave_caps is very important to the generic layers that might interact
> with dmaengine, such as ASoC. Unfortunately, it has been added as yet
> another dma_device callback, and most of the existing drivers haven't
> implemented it, reducing its reliability.
> 
> Introduce a generic behaviour to implement this, that rely on both the split
> of device_control to derive which functions are supported and on new
> variables to be set in the dma_device structure.
> 
> These variables holds what used to be the capabilities, that were set
> per-channel. However, this proved to be a bit overkill, since every driver
> filling these so far were hardcoding it, disregarding which channel was
> actually given.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

You might want to consider adding "dmaengine: Move dma_get_slave_caps() 
implementation to dmaengine.c" to this series.

> ---
>  include/linux/dmaengine.h | 41 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index b0efc805937a..be9e60aa8f5e 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -593,6 +593,14 @@ struct dma_tx_state {
>   * @fill_align: alignment shift for memset operations
>   * @dev_id: unique device ID
>   * @dev: struct device reference for dma mapping api
> + * @src_addr_widths: bit mask of src addr widths the device supports
> + * @dst_addr_widths: bit mask of dst addr widths the device supports
> + * @directions: bit mask of slave direction the device supports since
> + * 	the enum dma_transfer_direction is not defined as bits for
> + * 	each type of direction, the dma controller should fill (1 <<
> + * 	<TYPE>) and same should be checked by controller as well
> + * @residue_granularity: granularity of the transfer residue reported
> + *	by tx_status
>   * @device_alloc_chan_resources: allocate resources and return the
>   *	number of allocated descriptors
>   * @device_free_chan_resources: release DMA channel's resources
> @@ -642,6 +650,11 @@ struct dma_device {
>  	int dev_id;
>  	struct device *dev;
> 
> +	u32 src_addr_widths;
> +	u32 dst_addr_widths;
> +	u32 directions;
> +	enum dma_residue_granularity residue_granularity;
> +
>  	int (*device_alloc_chan_resources)(struct dma_chan *chan);
>  	void (*device_free_chan_resources)(struct dma_chan *chan);
> 
> @@ -783,17 +796,37 @@ static inline struct dma_async_tx_descriptor
> *dmaengine_prep_dma_sg(
> 
>  static inline int dma_get_slave_caps(struct dma_chan *chan, struct
> dma_slave_caps *caps) {
> +	struct dma_device *device;
> +
>  	if (!chan || !caps)
>  		return -EINVAL;
> 
> +	device = chan->device;
> +
>  	/* check if the channel supports slave transactions */
> -	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
> +	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
> +		return -ENXIO;
> +
> +	if (device->device_slave_caps)
> +		return device->device_slave_caps(chan, caps);
> +
> +	/*
> +	 * Check whether it reports it uses the generic slave
> +	 * capabilities, if not, that means it doesn't support any
> +	 * kind of slave capabilities reporting.
> +	 */
> +	if (!device->directions)
>  		return -ENXIO;
> 
> -	if (chan->device->device_slave_caps)
> -		return chan->device->device_slave_caps(chan, caps);
> +	caps->src_addr_widths = device->src_addr_widths;
> +	caps->dst_addr_widths = device->dst_addr_widths;
> +	caps->directions = device->directions;
> +	caps->residue_granularity = device->residue_granularity;
> +
> +	caps->cmd_pause = !!device->device_pause;
> +	caps->cmd_terminate = !!device->device_terminate_all;
> 
> -	return -ENXIO;
> +	return 0;
>  }
> 
>  static inline int dmaengine_terminate_all(struct dma_chan *chan)

-- 
Regards,

Laurent Pinchart

