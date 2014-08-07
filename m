Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaHGJPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:15:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35846 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:15:23 -0400
Message-ID: <53E343A7.9060700@kernel.org>
Date: Thu, 07 Aug 2014 10:15:19 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/4] iio: fix error return code
References: <1407355938-10932-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407355938-10932-3-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 21:12, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
I'll take the view this one is 'obviously' right.  If it isn't
then anyone feel free to shout!

Applied to the togreg branch of iio.git.

Thanks,

Jonathan
> 
> ---
>  drivers/iio/adc/xilinx-xadc-core.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
> index fd2745c..196e269 100644
> --- a/drivers/iio/adc/xilinx-xadc-core.c
> +++ b/drivers/iio/adc/xilinx-xadc-core.c
> @@ -1201,12 +1201,16 @@ static int xadc_probe(struct platform_device *pdev)
>  			goto err_device_free;
>  
>  		xadc->convst_trigger = xadc_alloc_trigger(indio_dev, "convst");
> -		if (IS_ERR(xadc->convst_trigger))
> +		if (IS_ERR(xadc->convst_trigger)) {
> +			ret = PTR_ERR(xadc->convst_trigger);
>  			goto err_triggered_buffer_cleanup;
> +		}
>  		xadc->samplerate_trigger = xadc_alloc_trigger(indio_dev,
>  			"samplerate");
> -		if (IS_ERR(xadc->samplerate_trigger))
> +		if (IS_ERR(xadc->samplerate_trigger)) {
> +			ret = PTR_ERR(xadc->samplerate_trigger);
>  			goto err_free_convst_trigger;
> +		}
>  	}
>  
>  	xadc->clk = devm_clk_get(&pdev->dev, NULL);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
