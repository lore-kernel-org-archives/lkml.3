Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3IYQJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:09:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50599 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3IYQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:09:29 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c4-52430ab86744
Message-id: <52430AB6.8020307@samsung.com>
Date: Wed, 25 Sep 2013 18:09:26 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] media: s5p-tv: Fix mixer driver to work with CCF
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379775649-6331-5-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1379775649-6331-5-git-send-email-m.krawczuk@partner.samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7o7uJyDDP4t1rTYOGM9q8XZpjfs
	FpseX2O1uLxrDptFz4atrBYX18lbnF5zitni8Jt2Vov1M16zOHB6bF5S73Hw3R4mj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4Mp4Oe8Le8FM0YrrB5qYGhjPCnYxcnJICJhInF3RzQxhi0lc
	uLeerYuRi0NIYCmjxKa905khnM+MEisvbmICqeIV0JJ4dvUWO4jNIqAqserVCjCbDWjSsSWf
	GUFsUYEIiT+n97FC1AtK/Jh8jwXEFhEwlXh39xrYBmaBB4wSXxtXgSWEBXwktnw5D3aGkMBE
	Ronbq4q7GDk4OAX8JC5MiAAJMwvoSOxvncYGYctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR
	1NLkguKk9FxDveLE3OLSvHS95PzcTYyQYP+yg3HxMatDjAIcjEo8vJpszkFCrIllxZW5hxgl
	OJiVRHjPMgGFeFMSK6tSi/Lji0pzUosPMTJxcEo1MK59+bjaySfhwM5Ncfty8oWFHj86/vX3
	Ud0bk6al67IUPZ9pcDQ0Xe3Hv9jMnpi0QwKPZ6VfF527uHbxyuWzhOel7D6y/JNy4ilh6Yap
	79jkt/vMZwicp2V1T+tLlbmnX5jY/bMrb/l2L9hy/kNTxWvXD4t2N99iS5J+n3jUwM9wwYf4
	Y0YHb05UYinOSDTUYi4qTgQACwcDfFQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename to 'media: s5p-tv: mixer: integrate with CCF'

On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
> Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
> Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
> Without it Common Clock Framework prints a warning.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

> ---
>  drivers/media/platform/s5p-tv/mixer_drv.c | 34 +++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
> index 8ce7c3e..7eea286 100644
> --- a/drivers/media/platform/s5p-tv/mixer_drv.c
> +++ b/drivers/media/platform/s5p-tv/mixer_drv.c
> @@ -347,19 +347,41 @@ static int mxr_runtime_resume(struct device *dev)
>  {
>  	struct mxr_device *mdev = to_mdev(dev);
>  	struct mxr_resources *res = &mdev->res;
> +	int ret;
>  
>  	dev_dbg(mdev->dev, "resume - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks on */
> -	clk_enable(res->mixer);
> -	clk_enable(res->vp);
> -	clk_enable(res->sclk_mixer);
> +	ret = clk_prepare_enable(res->mixer);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(mixer) failed\n");
> +		goto fail;
> +	}
> +	ret = clk_prepare_enable(res->vp);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(vp) failed\n");
> +		goto fail_mixer;
> +	}
> +	ret = clk_prepare_enable(res->sclk_mixer);
> +	if (ret < 0) {
> +		dev_err(mdev->dev, "clk_prepare_enable(sclk_mixer) failed\n");
> +		goto fail_vp;
> +	}
>  	/* apply default configuration */
>  	mxr_reg_reset(mdev);
>  	dev_dbg(mdev->dev, "resume - finished\n");
>  
>  	mutex_unlock(&mdev->mutex);
>  	return 0;
> +
> +fail_vp:
> +	clk_disable_unprepare(res->vp);
> +fail_mixer:
> +	clk_disable_unprepare(res->mixer);
> +fail:
> +	mutex_unlock(&mdev->mutex);
> +	dev_err(mdev->dev, "resume failed\n");
> +	return ret;
>  }
>  
>  static int mxr_runtime_suspend(struct device *dev)
> @@ -369,9 +391,9 @@ static int mxr_runtime_suspend(struct device *dev)
>  	dev_dbg(mdev->dev, "suspend - start\n");
>  	mutex_lock(&mdev->mutex);
>  	/* turn clocks off */
> -	clk_disable(res->sclk_mixer);
> -	clk_disable(res->vp);
> -	clk_disable(res->mixer);
> +	clk_disable_unprepare(res->sclk_mixer);
> +	clk_disable_unprepare(res->vp);
> +	clk_disable_unprepare(res->mixer);
>  	mutex_unlock(&mdev->mutex);
>  	dev_dbg(mdev->dev, "suspend - finished\n");
>  	return 0;
> 

