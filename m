Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164AbaDKQwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:52:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:51301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934988AbaDKQwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,842,1389772800"; 
   d="scan'208";a="519027716"
Date: Fri, 11 Apr 2014 22:13:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: dan.j.williams@intel.com, nsekhar@ti.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, joelf@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, mporter@linaro.org
Subject: Re: [PATCH v2 03/14] dma: edma: Add support for DMA_PAUSE/RESUME
 operation
Message-ID: <20140411164327.GD32284@intel.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
 <1396357575-30585-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396357575-30585-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 04:06:04PM +0300, Peter Ujfalusi wrote:
> Pause/Resume can be used by the audio stack when the stream is paused/resumed
> The edma platform code has support for this and the legacy audio stack used
> this.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/edma.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 2742867fd1e6..7891378a03f0 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -240,6 +240,26 @@ static int edma_slave_config(struct edma_chan *echan,
>  	return 0;
>  }
>  
> +static int edma_dma_pause(struct edma_chan *echan)
> +{
> +	/* Pause/Resume only allowed with cyclic mode */
> +	if (!echan->edesc->cyclic)
> +		return -EINVAL;
why this artificial restriction? The driver can do pause even for non cyclic
cases too? Yes the usage is in cyclic context but why should we limit any future
work on this?

-- 
~Vinod
> +
> +	edma_pause(echan->ch_num);
> +	return 0;
> +}
> +
> +static int edma_dma_resume(struct edma_chan *echan)
> +{
> +	/* Pause/Resume only allowed with cyclic mode */
> +	if (!echan->edesc->cyclic)
> +		return -EINVAL;
> +
> +	edma_resume(echan->ch_num);
> +	return 0;
> +}
> +
>  static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  			unsigned long arg)
>  {
> @@ -255,6 +275,14 @@ static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  		config = (struct dma_slave_config *)arg;
>  		ret = edma_slave_config(echan, config);
>  		break;
> +	case DMA_PAUSE:
> +		ret = edma_dma_pause(echan);
> +		break;
> +
> +	case DMA_RESUME:
> +		ret = edma_dma_resume(echan);
> +		break;
> +
>  	default:
>  		ret = -ENOSYS;
>  	}
> -- 
> 1.9.1
> 

-- 
