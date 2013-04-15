Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153Ab3DOXGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:06:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:06:36 -0400
Date: Mon, 15 Apr 2013 16:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-fbdev@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2] backlight: platform_lcd: introduce probe callback
Message-Id: <20130415160632.99e867b25418189c95fbc826@linux-foundation.org>
In-Reply-To: <1365711890-15168-1-git-send-email-abrestic@chromium.org>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
	<1365711890-15168-1-git-send-email-abrestic@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013 13:24:50 -0700 Andrew Bresticker <abrestic@chromium.org> wrote:

> Platform LCD devices may need to do some device-specific
> initialization before they can be used (regulator or GPIO setup,
> for example), but currently the driver does not support any way of
> doing this.  This patch adds a probe() callback to plat_lcd_data
> which platform LCD devices can set to indicate that device-specific
> initialization is needed.
> 
> index 17a6b83..f46180e 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -86,6 +86,12 @@ static int platform_lcd_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> +	if (pdata->probe) {
> +		err = pdata->probe(pdata);
> +		if (err)
> +			return err;
> +	}
> +
>  	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
>  			    GFP_KERNEL);
>  	if (!plcd) {
> diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
> index ad3bdfe..23864b2 100644
> --- a/include/video/platform_lcd.h
> +++ b/include/video/platform_lcd.h
> @@ -15,6 +15,7 @@ struct plat_lcd_data;
>  struct fb_info;
>  
>  struct plat_lcd_data {
> +	int	(*probe)(struct plat_lcd_data *);
>  	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
>  	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
>  };

Sigh.  I see that this entire interface has been lovingly undocumented.
It's an invitation for us to grow bugs, incompatibilities, leaks, etc.

Possible example: what happens if pdata->probe does some resource
allocation or device initialisation which should be backed out if, say,
platform_lcd_probe() later fails?

