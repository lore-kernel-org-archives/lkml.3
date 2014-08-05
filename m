Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaHEQn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:43:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:49632 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaHEQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:43:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,805,1400050800"; 
   d="scan'208";a="580373727"
Date: Tue, 5 Aug 2014 22:02:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: nsekhar@ti.com, joelf@ti.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] ARM: edma: Fix configuration parsing for SoCs with
 multiple eDMA3 CC
Message-ID: <20140805163229.GZ8181@intel.com>
References: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:26:56PM +0300, Peter Ujfalusi wrote:
> The edma_setup_from_hw() should know about the CC number when parsing the
> CCCFG register - when it reads the register to be precise. The base
> addresses for CCs stored in an array and we need to provide the correct id
> to edma_read() in order to read the correct register.

Just an othognal question:

I still see lot of code for edma in arm/. What is the plan to re/move that
to dma/

-- 
~Vinod
> 
> Cc: <stable@vger.kernel.org> # 3.16
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/common/edma.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 88099175fc56..d86771abbf57 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1443,14 +1443,14 @@ void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no)
>  EXPORT_SYMBOL(edma_assign_channel_eventq);
>  
>  static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
> -			      struct edma *edma_cc)
> +			      struct edma *edma_cc, int cc_id)
>  {
>  	int i;
>  	u32 value, cccfg;
>  	s8 (*queue_priority_map)[2];
>  
>  	/* Decode the eDMA3 configuration from CCCFG register */
> -	cccfg = edma_read(0, EDMA_CCCFG);
> +	cccfg = edma_read(cc_id, EDMA_CCCFG);
>  
>  	value = GET_NUM_REGN(cccfg);
>  	edma_cc->num_region = BIT(value);
> @@ -1464,7 +1464,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
>  	value = GET_NUM_EVQUE(cccfg);
>  	edma_cc->num_tc = value + 1;
>  
> -	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
> +	dev_dbg(dev, "eDMA3 CC%d HW configuration (cccfg: 0x%08x):\n", cc_id,
> +		cccfg);
>  	dev_dbg(dev, "num_region: %u\n", edma_cc->num_region);
>  	dev_dbg(dev, "num_channel: %u\n", edma_cc->num_channels);
>  	dev_dbg(dev, "num_slot: %u\n", edma_cc->num_slots);
> @@ -1684,7 +1685,7 @@ static int edma_probe(struct platform_device *pdev)
>  			return -ENOMEM;
>  
>  		/* Get eDMA3 configuration from IP */
> -		ret = edma_setup_from_hw(dev, info[j], edma_cc[j]);
> +		ret = edma_setup_from_hw(dev, info[j], edma_cc[j], j);
>  		if (ret)
>  			return ret;
>  
> -- 
> 2.0.2
> 

-- 
