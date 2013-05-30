Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3E3MYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:24:07 -0400
Received: from 5.mo5.mail-out.ovh.net ([87.98.173.103]:58658 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753Ab3E3MYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:24:02 -0400
X-Greylist: delayed 4606 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 08:24:02 EDT
Date: Thu, 30 May 2013 13:03:06 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.y.victor@gmail.com
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] backlight: Turn backlight on/off when necessary
Message-ID: <20130530110306.GG19468@game.jcrosoft.org>
References: <1369901633-31561-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369901633-31561-1-git-send-email-Ying.Liu@freescale.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3674092872235854823
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:13 Thu 30 May     , Liu Ying wrote:
> We don't have to turn backlight on/off everytime a blanking
> or unblanking event comes because the backlight status may have
> already been what we want. Another thought is that one backlight
> device may be shared by multiple framebuffers. We don't hope that
> blanking one of the framebuffers would turn the backlight off for
> all the other framebuffers, since they are likely active to show
> display content. This patch adds logic to record each framebuffer's
> backlight status to determine the backlight device use count and
> whether the backlight should be turned on or off.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
>  drivers/video/backlight/backlight.c |   23 +++++++++++++++++------
>  include/linux/backlight.h           |    6 ++++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index c74e7aa..97ea2b8 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -31,13 +31,14 @@ static const char *const backlight_types[] = {
>  			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
>  /* This callback gets called when something important happens inside a
>   * framebuffer driver. We're looking if that important event is blanking,
> - * and if it is, we're switching backlight power as well ...
> + * and if it is and necessary, we're switching backlight power as well ...
>   */
>  static int fb_notifier_callback(struct notifier_block *self,
>  				unsigned long event, void *data)
>  {
>  	struct backlight_device *bd;
>  	struct fb_event *evdata = data;
> +	int node = evdata->info->node;
>  
>  	/* If we aren't interested in this event, skip it immediately ... */
>  	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
> @@ -49,11 +50,21 @@ static int fb_notifier_callback(struct notifier_block *self,
>  		if (!bd->ops->check_fb ||
>  		    bd->ops->check_fb(bd, evdata->info)) {
>  			bd->props.fb_blank = *(int *)evdata->data;
> -			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
> -				bd->props.state &= ~BL_CORE_FBBLANK;
> -			else
> -				bd->props.state |= BL_CORE_FBBLANK;
> -			backlight_update_status(bd);
> +			if (bd->props.fb_blank == FB_BLANK_UNBLANK &&
> +			    !bd->fb_bl_on[node]) {
> +				bd->fb_bl_on[node] = true;
> +				if (!bd->use_count++) {
> +					bd->props.state &= ~BL_CORE_FBBLANK;
> +					backlight_update_status(bd);
> +				}
> +			} else if (bd->props.fb_blank != FB_BLANK_UNBLANK &&
> +				   bd->fb_bl_on[node]) {
> +				bd->fb_bl_on[node] = false;
> +				if (!(--bd->use_count)) {
> +					bd->props.state |= BL_CORE_FBBLANK;
> +					backlight_update_status(bd);
> +				}
> +			}
>  		}
>  	mutex_unlock(&bd->ops_lock);
>  	return 0;
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index da9a082..5de71a0 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -9,6 +9,7 @@
>  #define _LINUX_BACKLIGHT_H
>  
>  #include <linux/device.h>
> +#include <linux/fb.h>
>  #include <linux/mutex.h>
>  #include <linux/notifier.h>
>  
> @@ -101,6 +102,11 @@ struct backlight_device {
>  	struct notifier_block fb_notif;
>  
>  	struct device dev;
> +
> +	/* Multiple framebuffers may share one backlight device */
> +	bool fb_bl_on[FB_MAX];


I don't like such array at all

I understand the fact you will have only on hw backlight for x fb or overlay
but have a static on no

if you want to track all user create a strcut and register it or do more
simple just as a int to count the number of user and shut down it if 0 and
enable it otherwise

Best Regards,
J.
> +
> +	int use_count;
>  };
>  
>  static inline void backlight_update_status(struct backlight_device *bd)
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
