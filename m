Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaBRWUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:20:43 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33750 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaBRWUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:20:40 -0500
Message-ID: <5303dcb6.2587440a.3f18.fffff1ba@mx.google.com>
From: sebastian.capella@linaro.org
Date: Tue, 18 Feb 2014 14:20:42 -0800
To: tomi.valkeinen@ti.com, shuah.kh@samsung.com, rpurdie@rpsys.net,
        rafael.j.wysocki@intel.com, plagnioj@jcrosoft.com,
        FlorianSchandinat@gmx.de
Cc: shuahkhan@gmail.com, shuah.kh@samsung.com, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [v2] backlight: Convert from Legacy pm ops to dev_pm_ops
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan <shuah.kh@samsung.com> wrote:

> Convert drivers/video/backlight/class to use dev_pm_ops for power
> management and remove Legacy PM ops hooks. With this change, rtc class
> registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
> Legacy class->suspend/resume. When __device_suspend() runs call-backs,
> it will find class->pm ops for the backlight class.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>
>
> ---
> v2: Updated changelog to correct device class.
>
>  drivers/video/backlight/backlight.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index c74e7aa..0ffb251 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
>  
>  static struct class *backlight_class;
>  
> -static int backlight_suspend(struct device *dev, pm_message_t state)
> +static int backlight_suspend(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
>  
> @@ -236,6 +236,9 @@ static int backlight_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
> +			 backlight_resume);
> +
>  static void bl_device_release(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> @@ -414,8 +417,7 @@ static int __init backlight_class_init(void)
>  	}
>  
>  	backlight_class->dev_attrs = bl_device_attributes;
> -	backlight_class->suspend = backlight_suspend;
> -	backlight_class->resume = backlight_resume;
> +	backlight_class->pm = &backlight_class_dev_pm_ops;
>  	return 0;
>  }
>  