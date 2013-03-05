Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3CEJ2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:28:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:60172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab3CEJ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:27:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="scan'208";a="271196044"
Date: Tue, 5 Mar 2013 14:33:15 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/10] dmatest: move dmatest_channels and nr_channels
 to dmatest_info
Message-ID: <20130305090315.GC28136@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:09:28AM +0200, Andy Shevchenko wrote:
> We don't need to have them global and later we would like to protect access to
> them as well.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 7f9e3cc..475a21a 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -109,6 +109,7 @@ struct dmatest_chan {
>   * @timeout:		transfer timeout in msec, -1 for infinite timeout
>   */
>  struct dmatest_info {
> +	/* Test parameters */
>  	unsigned int	buf_size;
>  	char		channel[20];
>  	char		device[20];
> @@ -118,17 +119,14 @@ struct dmatest_info {
>  	unsigned int	xor_sources;
>  	unsigned int	pq_sources;
>  	int		timeout;
> +
> +	/* Internal state */
> +	struct list_head	channels;
> +	unsigned int		nr_channels;
>  };
Ideally this should be folded into previous...

>  
>  static struct dmatest_info test_info;
>  
> -/*
> - * These are protected by dma_list_mutex since they're only used by
> - * the DMA filter function callback
> - */
> -static LIST_HEAD(dmatest_channels);
> -static unsigned int nr_channels;
> -
>  static bool dmatest_match_channel(struct dmatest_info *info,
>  		struct dma_chan *chan)
>  {
> @@ -690,8 +688,8 @@ static int dmatest_add_channel(struct dmatest_info *info,
>  	pr_info("dmatest: Started %u threads using %s\n",
>  		thread_count, dma_chan_name(chan));
>  
> -	list_add_tail(&dtc->node, &dmatest_channels);
> -	nr_channels++;
> +	list_add_tail(&dtc->node, &info->channels);
> +	info->nr_channels++;
>  
>  	return 0;
>  }
> @@ -725,7 +723,8 @@ static int run_threaded_test(struct dmatest_info *info)
>  			}
>  		} else
>  			break; /* no more channels available */
> -		if (info->max_channels && nr_channels >= info->max_channels)
> +		if (info->max_channels &&
> +		    info->nr_channels >= info->max_channels)
>  			break; /* we have all we need */
>  	}
>  	return err;
> @@ -736,14 +735,15 @@ static void stop_threaded_test(struct dmatest_info *info)
>  	struct dmatest_chan *dtc, *_dtc;
>  	struct dma_chan *chan;
>  
> -	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
> +	list_for_each_entry_safe(dtc, _dtc, &info->channels, node) {
>  		list_del(&dtc->node);
>  		chan = dtc->chan;
>  		dmatest_cleanup_channel(dtc);
> -		pr_debug("dmatest: dropped channel %s\n",
> -			 dma_chan_name(chan));
> +		pr_debug("dmatest: dropped channel %s\n", dma_chan_name(chan));
>  		dma_release_channel(chan);
>  	}
> +
> +	info->nr_channels = 0;
>  }
>  
>  static int __init dmatest_init(void)
> @@ -752,6 +752,9 @@ static int __init dmatest_init(void)
>  
>  	memset(info, 0, sizeof(*info));
>  
> +	INIT_LIST_HEAD(&info->channels);
> +
> +	/* Set default parameters */
>  	info->buf_size = test_buf_size;
>  	strlcpy(info->channel, test_channel, sizeof(info->channel));
>  	strlcpy(info->device, test_device, sizeof(info->device));
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
