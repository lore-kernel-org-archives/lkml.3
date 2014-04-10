Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294AbaDJQg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:36:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45555 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbaDJQgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:36:54 -0400
Message-ID: <5346C88E.8010504@ti.com>
Date: Thu, 10 Apr 2014 11:36:30 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 08/14] DMA: edma: Use different eventq for cyclic channels
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-9-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-9-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
> To improve latency with cyclic DMA operation it is preferred to
> use different eventq/tc than the default which is used by all
> other drivers (mmc, spi, i2c, etc).
> When preparing the cyclic dma ask for non default queue for the
> channel which is going to be used with cyclic mode.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/edma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 1dd9e8806975..10048b40fac8 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -628,6 +628,9 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>  		edesc->pset[i].opt |= TCINTEN;
>  	}
>  
> +	/* Use different eventq/tc for cyclic DMA to reduce latency */
> +	edma_request_non_default_queue(echan->ch_num);
> +
>  	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
>  }
>  
> 

Is there any way to guarantee that the non-default queue is of the
highest priority, or in other words default queue is of lowest priority.
I know you set queue 1 as default because by default 0 is higher
priority. And then assigning non-default queue.

When assigning default to Queue 1, it would be good to also call
assign_priority_to_queue and set QUEPRI to 7 for Queue 1. Since 0, 2 and
4 are all non-defaults.

Thanks,
-Joel
