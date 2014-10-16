Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaJPQUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:20:23 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:37155 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaJPQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:20:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 40/53] dmaengine: xilinx: Split device_control
Date: Thu, 16 Oct 2014 19:20:33 +0300
Message-ID: <16437910.e1eS0oSP8W@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413454672-27400-41-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com> <1413454672-27400-41-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 12:17:39 Maxime Ripard wrote:
> Split the device_control callback of the Xilinx VDMA driver to make use of
> the newly introduced callbacks, that will eventually be used to retrieve
> slave capabilities.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/dma/xilinx/xilinx_vdma.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dma/xilinx/xilinx_vdma.c
> b/drivers/dma/xilinx/xilinx_vdma.c index 42a13e8d4607..35024e7b9f9f 100644
> --- a/drivers/dma/xilinx/xilinx_vdma.c
> +++ b/drivers/dma/xilinx/xilinx_vdma.c
> @@ -996,8 +996,10 @@ error:
>   * xilinx_vdma_terminate_all - Halt the channel and free descriptors
>   * @chan: Driver specific VDMA Channel pointer
>   */
> -static void xilinx_vdma_terminate_all(struct xilinx_vdma_chan *chan)
> +static int xilinx_vdma_terminate_all(struct dma_chan *dchan)

I'm pretty sure you now miss a return statement at the end of the function. 
With that fixed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  {
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
>  	/* Halt the DMA engine */
>  	xilinx_vdma_halt(chan);
> 
> @@ -1070,27 +1072,6 @@ int xilinx_vdma_channel_set_config(struct dma_chan
> *dchan, }
>  EXPORT_SYMBOL(xilinx_vdma_channel_set_config);
> 
> -/**
> - * xilinx_vdma_device_control - Configure DMA channel of the device
> - * @dchan: DMA Channel pointer
> - * @cmd: DMA control command
> - * @arg: Channel configuration
> - *
> - * Return: '0' on success and failure value on error
> - */
> -static int xilinx_vdma_device_control(struct dma_chan *dchan,
> -				      enum dma_ctrl_cmd cmd, unsigned long arg)
> -{
> -	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> -
> -	if (cmd != DMA_TERMINATE_ALL)
> -		return -ENXIO;
> -
> -	xilinx_vdma_terminate_all(chan);
> -
> -	return 0;
> -}
> -
>  /*
> ---------------------------------------------------------------------------
> -- * Probe and remove
>   */
> @@ -1295,7 +1276,7 @@ static int xilinx_vdma_probe(struct platform_device
> *pdev) xilinx_vdma_free_chan_resources;
>  	xdev->common.device_prep_interleaved_dma =
>  				xilinx_vdma_dma_prep_interleaved;
> -	xdev->common.device_control = xilinx_vdma_device_control;
> +	xdev->common.device_terminate_all = xilinx_vdma_terminate_all;
>  	xdev->common.device_tx_status = xilinx_vdma_tx_status;
>  	xdev->common.device_issue_pending = xilinx_vdma_issue_pending;

-- 
Regards,

Laurent Pinchart

