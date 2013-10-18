Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3JRSHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:07:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:30489 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab3JRSHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:07:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,524,1378882800"; 
   d="scan'208";a="413369529"
Message-ID: <1382119610.30870.4.camel@smile>
Subject: Re: [PATCH v2 01/13] dmatest: make driver unmap also source buffers
 by itself
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, dave.jiang@intel.com,
        t.figa@samsung.com, kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Date: Fri, 18 Oct 2013 21:06:50 +0300
In-Reply-To: <1382117733-16720-2-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
	 <1382117733-16720-2-git-send-email-b.zolnierkie@samsung.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 19:35 +0200, Bartlomiej Zolnierkiewicz wrote:
> Make the driver DMA unmap also source buffers by itself
> (currently it DMA unmaps only destination buffers) as
> a preparation for introducing generic 'ummap' data.
> 
> Cc: Dan Williams <djbw@fb.com>

I think you may update Dan's address.


I assume you run exactly this module to test your DMA drivers.
If so, please take my
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/dma/dmatest.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 92f796c..f4a2a25 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -597,11 +597,10 @@ static int dmatest_func(void *data)
>  	set_user_nice(current, 10);
>  
>  	/*
> -	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
> -	 * dst buffers are freed by ourselves below
> +	 * src and dst buffers are freed by ourselves below
>  	 */
> -	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
> -	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
> +	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
> +		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
>  
>  	while (!kthread_should_stop()
>  	       && !(params->iterations && total_tests >= params->iterations)) {
> @@ -750,7 +749,8 @@ static int dmatest_func(void *data)
>  			continue;
>  		}
>  
> -		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
> +		/* Unmap by myself */
> +		unmap_src(dev->dev, dma_srcs, len, src_cnt);
>  		unmap_dst(dev->dev, dma_dsts, params->buf_size, dst_cnt);
>  
>  		error_count = 0;

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
