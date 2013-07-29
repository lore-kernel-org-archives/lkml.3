Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3G2MSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:18:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:22800 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3G2MSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:18:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,768,1367996400"; 
   d="scan'208";a="353545365"
Date: Mon, 29 Jul 2013 17:09:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to
 dma_async_tx_descriptor
Message-ID: <20130729113933.GK29095@intel.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 08:10:06PM +0200, Sebastian Andrzej Siewior wrote:
> In USB RX path it is possible that the we receive less bytes than
> requested. Take the following example:
> The driver for USB-to-UART submits an URB with 256 bytes in size and the
> dmaengine driver in turn programs a transfer of 256 bytes. The transfer
> is programmed and the dma engine waits for the data to arrive. Once data
> is sent on the UART the dma engine begins to move data. If there was
> only one data byte in the USB packet received then the DMA engine will
> only move one byte due to USB restrictions / rules. The real size of the
> transfer has to be notified to the user / caller so he set this to the
> caller.
> This patch adds the transfered member to the dma_async_tx_descriptor
> where the caller can obtain the final size.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/dmaengine.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index cb286b1..c3a4635 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -403,6 +403,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
>   * @tx_submit: set the prepared descriptor(s) to be executed by the engine
>   * @callback: routine to call after this operation is complete
>   * @callback_param: general parameter to pass to the callback routine
> + * @transfered: number of bytes that were really transfered in case the channel
> + *	transfered less than requested.
>   * ---async_tx api specific fields---
>   * @next: at completion submit this descriptor
>   * @parent: pointer to the next level up in the dependency chain
> @@ -416,6 +418,7 @@ struct dma_async_tx_descriptor {
>  	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
>  	dma_async_tx_callback callback;
>  	void *callback_param;
> +	unsigned int transfered;
I think this should be doable with residue as well. You can return DMA_SUCCESS
for status and fill in what is NOT transfered indicating that txn completed but
lesser number of bytes are valid

~Vinod
-- 
