Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AKRGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:06:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3AKRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:06:08 -0500
Date: Fri, 11 Jan 2013 09:06:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Input: twl4030-vibra: Convert to use devm_* in
 probe
Message-ID: <20130111170605.GC11224@core.coreip.homeip.net>
References: <1357896483-20764-1-git-send-email-peter.ujfalusi@ti.com>
 <1357896483-20764-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357896483-20764-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:28:00AM +0100, Peter Ujfalusi wrote:
> Cleanup to use devm_* when it is possible at probe time.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Applied, thank you Peter.

> ---
>  drivers/input/misc/twl4030-vibra.c | 26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
> index 78eb6b3..e2e2a26 100644
> --- a/drivers/input/misc/twl4030-vibra.c
> +++ b/drivers/input/misc/twl4030-vibra.c
> @@ -219,7 +219,7 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>  	if (!info)
>  		return -ENOMEM;
>  
> @@ -227,11 +227,10 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
>  	info->coexist = twl4030_vibra_check_coexist(pdata, twl4030_core_node);
>  	INIT_WORK(&info->play_work, vibra_play_work);
>  
> -	info->input_dev = input_allocate_device();
> +	info->input_dev = devm_input_allocate_device(&pdev->dev);
>  	if (info->input_dev == NULL) {
>  		dev_err(&pdev->dev, "couldn't allocate input device\n");
> -		ret = -ENOMEM;
> -		goto err_kzalloc;
> +		return -ENOMEM;
>  	}
>  
>  	input_set_drvdata(info->input_dev, info);
> @@ -246,7 +245,7 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
>  	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
>  	if (ret < 0) {
>  		dev_dbg(&pdev->dev, "couldn't register vibrator to FF\n");
> -		goto err_ialloc;
> +		return ret;
>  	}
>  
>  	ret = input_register_device(info->input_dev);
> @@ -262,28 +261,11 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
>  
>  err_iff:
>  	input_ff_destroy(info->input_dev);
> -err_ialloc:
> -	input_free_device(info->input_dev);
> -err_kzalloc:
> -	kfree(info);
>  	return ret;
>  }
>  
> -static int twl4030_vibra_remove(struct platform_device *pdev)
> -{
> -	struct vibra_info *info = platform_get_drvdata(pdev);
> -
> -	/* this also free ff-memless and calls close if needed */
> -	input_unregister_device(info->input_dev);
> -	kfree(info);
> -	platform_set_drvdata(pdev, NULL);
> -
> -	return 0;
> -}
> -
>  static struct platform_driver twl4030_vibra_driver = {
>  	.probe		= twl4030_vibra_probe,
> -	.remove		= twl4030_vibra_remove,
>  	.driver		= {
>  		.name	= "twl4030-vibra",
>  		.owner	= THIS_MODULE,
> -- 
> 1.8.1
> 

-- 
Dmitry
