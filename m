Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3JKNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:34:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab3JKNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:33:57 -0400
Date: Fri, 11 Oct 2013 06:33:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Youquan Song <youquan.song@intel.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com,
        andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Message-ID: <20131011133343.GB32689@kroah.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381527738-9339-2-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:42:17PM -0400, Youquan Song wrote:
> Currently, the DMA channel calculates its data transferred only at network
> device driver. When other devices like UART or SPI etc, transfers data by DMA 
> mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.

Is that really a problem?  I have never heard anyone complaining about
it.  Where are the reports of this?

> This patch add a new function which will calculate how many the data has been
> transferred after doing it by DMA mode. It can be used by other modules and
> also simplify current duplicated code.
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  drivers/dma/dmaengine.c   |   35 +++++++++++++++++++----------------
>  include/linux/dmaengine.h |    3 +++
>  2 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 9162ac8..4356a7e 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -901,6 +901,23 @@ void dma_async_device_unregister(struct dma_device *device)
>  }
>  EXPORT_SYMBOL(dma_async_device_unregister);
>  
> +dma_cookie_t
> +dma_tx_submit_cal(struct dma_async_tx_descriptor *tx,
> +		struct dma_chan *chan, size_t len)
> +{
> +
> +	dma_cookie_t cookie;
> +	cookie = tx->tx_submit(tx);
> +
> +	preempt_disable();
> +	__this_cpu_add(chan->local->bytes_transferred, len);
> +	__this_cpu_inc(chan->local->memcpy_count);
> +	preempt_enable();
> +
> +	return cookie;
> +
> +}

You create a function, yet no driver can use it as it's not exported, so
I guess you don't want anyone to use it :)

Anyway, I don't think this is a good idea, see my response to the serial
driver patch for why not.

sorry,

greg k-h
