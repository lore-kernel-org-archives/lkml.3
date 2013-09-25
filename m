Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3IYPql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:46:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61192 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3IYPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:46:39 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-06-5243055ddddb
Message-id: <5243055C.7070205@samsung.com>
Date: Wed, 25 Sep 2013 17:46:36 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] media: s5p-tv: Restore vpll clock rate
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379775649-6331-3-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1379775649-6331-3-git-send-email-m.krawczuk@partner.samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7pxrM5BBo2xFhtnrGe1ONv0ht1i
	0+NrrBaXd81hs+jZsJXV4uI6eYvTa04xWxx+085qsX7GaxYHTo/NS+o9Dr7bw+TRt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGWeu3WYumCVa8WhVXANji2AXIweHhICJxIxX3l2MnECmmMSF
	e+vZuhi5OIQEljJK3OndzAzhfGaUePnxNxNIFa+AlkTT5ScsIDaLgKrEiRvn2EFsNqBBx5Z8
	ZgSxRQUiJP6c3scKUS8o8WPyPbB6EQFTiXd3r4FtYBZ4wCjxtXEVWEJYwEmi+8M6VohtExkl
	bl/sZwZJcAr4Sexs2g42iVlAR2J/6zQ2CFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGKppYm
	FxQnpeca6RUn5haX5qXrJefnbmKEhPrXHYxLj1kdYhTgYFTi4b3A7BwkxJpYVlyZe4hRgoNZ
	SYT3LBNQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2NqMLe1rs/M+Bl/Qxa/+KSn9317ZWT4ab7y
	PgFpmyUJ0y+vu1x1dpVz34UD3e+6e1suCixQff14Ca+j1UsXn0VXNvZXFsw8yWYfJmfTfH3a
	k+T5187Obfkev9mXe6X/9Y18L48n+7Y7bp3BVXy97zfjzyapuXLxjZNrwjufnTggpnXpQfTy
	b4lKLMUZiYZazEXFiQByB/67UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As you can see sdo, hdmi and mixer are saparate drivers that are
parts of s5p-tv drivers set. Could you rename commit name to
'media: s5p-tv: sdo: Restore vpll clock rate after streamoff'


On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
> Restore vpll clock rate if start stream fail or stream is off.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> index 0afa90f..e49ac6c 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -55,6 +55,8 @@ struct sdo_device {
>  	struct clk *dacphy;
>  	/** clock for control of VPLL */
>  	struct clk *fout_vpll;
> +	/** vpll rate before sdo stream was on */
> +	unsigned long vpll_rate;
>  	/** regulator for SDO IP power */
>  	struct regulator *vdac;
>  	/** regulator for SDO plug detection */
> @@ -193,17 +195,33 @@ static int sdo_s_power(struct v4l2_subdev *sd, int on)
>  
>  static int sdo_streamon(struct sdo_device *sdev)
>  {
> +	int ret;
> +
>  	/* set proper clock for Timing Generator */
> -	clk_set_rate(sdev->fout_vpll, 54000000);
> +	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
> +	ret = clk_set_rate(sdev->fout_vpll, 54000000);
> +	if (ret < 0) {
> +		dev_err(sdev->dev, "Failed to set vpll rate\n");
> +		return ret;
> +	}
>  	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",

Could you also remove the line below in a new 'sdo: cleanup' patch?
Change dev_info to dev_dbg in the line above.

>  	clk_get_rate(sdev->fout_vpll));
>  	/* enable clock in SDO */
>  	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	clk_enable(sdev->dacphy);
> +	ret = clk_enable(sdev->dacphy);
> +	if (ret < 0) {
> +		dev_err(sdev->dev, "clk_enable(dacphy) failed\n");
> +		goto fail;
> +	}
>  	/* enable DAC */
>  	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
>  	sdo_reg_debug(sdev);
>  	return 0;
> +	
> +fail:
> +	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
> +	return ret;
>  }
>  
>  static int sdo_streamoff(struct sdo_device *sdev)
> @@ -220,6 +238,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	}
>  	if (tries == 0)
>  		dev_err(sdev->dev, "failed to stop streaming\n");

Produce some warning if the line below fails.

> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
>  	return tries ? 0 : -EIO;
>  }
>  
> 

