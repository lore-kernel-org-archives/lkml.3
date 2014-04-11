Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaDKIoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:44:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46633 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbaDKIoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:44:01 -0400
Message-ID: <5347AB33.8000606@ti.com>
Date: Fri, 11 Apr 2014 14:13:31 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 07/14] arm: common: edma: API to request non default
 queue for a channel
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-8-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-8-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2014 06:36 PM, Peter Ujfalusi wrote:
> When using eDMA3 via dmaengine all dma channels will use the default queue.
> Since during request time we do not have means to change this it need to be done
> later, before the DMA has been started.
> With the added function it is possible to move the channel to a non default
> queue if it is possible, otherwise (when only one EQ/TC is available for the CC)
> the default queue is going to be used.
> For example: For optimal system performance the audio (cyclic) DMA should
> be placed to a separate queue which is different than what the rest of the
> system is using.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/common/edma.c             | 27 +++++++++++++++++++++++++++
>  include/linux/platform_data/edma.h |  2 ++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index be267b2080be..eaf6dd19f082 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -712,6 +712,33 @@ int edma_alloc_channel(int channel,
>  }
>  EXPORT_SYMBOL(edma_alloc_channel);
>  
> +/**
> + * edma_request_non_default_queue - try to map the channel to non default queue
> + * @channel: dma channel returned from edma_alloc_channel()
> + *
> + * For certain type of applications like audio it is preferred to not use the
> + * default event queue/tc to avoid eDMA caused latency.
> + *
> + * This function will iterate through the event queues available for the CC and
> + * picks the first EQ/TC which is not set as the default for the CC
> + */
> +void edma_request_non_default_queue(int channel)
> +{
> +	unsigned ctlr = EDMA_CTLR(channel);
> +	enum dma_event_q eventq_no = EVENTQ_DEFAULT;
> +	int i;
> +
> +	for (i = 0; i < edma_cc[ctlr]->num_tc; i++) {
> +		if (i != edma_cc[ctlr]->default_queue) {
> +			eventq_no = i;
> +			break;
> +		}
> +	}
> +
> +	channel = EDMA_CHAN_SLOT(channel);
> +	map_dmach_queue(ctlr, channel, eventq_no);
> +}
> +EXPORT_SYMBOL(edma_request_non_default_queue);

With this API, the caller cannot be sure of what the final affect on the
channel will be. It depends a lot on what the default queue setting is.
And that can change independent of this API.

I am not an expert in dmaengine, but it looks like we are trying to
workaround the fact that dmaengine does not support multiple transfer
priorities for a dma_chan. If yes, it will be better to add support for
doing this in dmaengine core itself. A generic priority space could be
supported which each DMA device can then map to its hardware support.

Thanks,
Sekhar
