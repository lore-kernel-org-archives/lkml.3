Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaAVJco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:32:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:54537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbaAVJck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:32:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="470621805"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Liu Ying <Ying.Liu@freescale.com>, jg1.han@samsung.com
Cc: linux-fbdev@vger.kernel.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] backlight: turn backlight on/off when necessary
In-Reply-To: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
User-Agent: Notmuch/0.17+27~gabca3dcf08ba (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Jan 2014 11:35:55 +0200
Message-ID: <87sisg5pfo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Liu Ying <Ying.Liu@freescale.com> wrote:
> We don't have to turn backlight on/off everytime a blanking
> or unblanking event comes because the backlight status may
> have already been what we want. Another thought is that one
> backlight device may be shared by multiple framebuffers. We
> don't hope blanking one of the framebuffers may turn the
> backlight off for all the other framebuffers, since they are
> likely being active to display something. This patch adds
> some logics to record each framebuffer's backlight usage to
> determine the backlight device use count and whether the
> backlight should be turned on or off. To be more specific,
> only one unblank operation on a certain blanked framebuffer
> may increase the backlight device's use count by one, while
> one blank operation on a certain unblanked framebuffer may
> decrease the use count by one, because the userspace is
> likely to unblank a unblanked framebuffer or blank a blanked
> framebuffer.
>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v1 can be found at https://lkml.org/lkml/2013/5/30/139
>
> v1->v2:
> * Make the commit message be more specific about the condition
>   in which backlight device use count can be increased/decreased.
> * Correct the setting for bd->props.fb_blank.
>
>  drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
>  include/linux/backlight.h           |    6 ++++++
>  2 files changed, 27 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 5d05555..42044be 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -34,13 +34,15 @@ static const char *const backlight_types[] = {
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
> +	int fb_blank = 0;
>  
>  	/* If we aren't interested in this event, skip it immediately ... */
>  	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
> @@ -51,12 +53,24 @@ static int fb_notifier_callback(struct notifier_block *self,
>  	if (bd->ops)
>  		if (!bd->ops->check_fb ||
>  		    bd->ops->check_fb(bd, evdata->info)) {
> -			bd->props.fb_blank = *(int *)evdata->data;
> -			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
> -				bd->props.state &= ~BL_CORE_FBBLANK;
> -			else
> -				bd->props.state |= BL_CORE_FBBLANK;
> -			backlight_update_status(bd);
> +			fb_blank = *(int *)evdata->data;
> +			if (fb_blank == FB_BLANK_UNBLANK &&
> +			    !bd->fb_bl_on[node]) {
> +				bd->fb_bl_on[node] = true;
> +				if (!bd->use_count++) {
> +					bd->props.state &= ~BL_CORE_FBBLANK;
> +					bd->props.fb_blank = FB_BLANK_UNBLANK;
> +					backlight_update_status(bd);
> +				}
> +			} else if (fb_blank != FB_BLANK_UNBLANK &&
> +				   bd->fb_bl_on[node]) {
> +				bd->fb_bl_on[node] = false;
> +				if (!(--bd->use_count)) {
> +					bd->props.state |= BL_CORE_FBBLANK;
> +					bd->props.fb_blank = FB_BLANK_POWERDOWN;
> +					backlight_update_status(bd);
> +				}
> +			}

Anything backlight worries me a little, and there are actually three
changes bundled into one patch here:

1. Changing bd->props.state and bd->props.fb_blank only when use_count
   changes from 0->1 or 1->0.

2. Calling backlight_update_status() only with the above change, and not
   on all notifier callbacks.

3. Setting bd->props.fb_blank always to either FB_BLANK_UNBLANK or
   FB_BLANK_POWERDOWN instead of *(int *)evdata->data.

The rationale in the commit message seems plausible, and AFAICT the code
does what it says on the box, so for that (and for that alone) you can
have my

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

*BUT* it would be laborous to figure out whether this change in
behaviour might regress some drivers. I'm just punting on that. And that
brings us back to the three changes above - in a bisect POV it might be
helpful to split the patch up. Up to the maintainers.

HTH,
Jani.


>  		}
>  	mutex_unlock(&bd->ops_lock);
>  	return 0;
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 5f9cd96..7264742 100644
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
> @@ -104,6 +105,11 @@ struct backlight_device {
>  	struct list_head entry;
>  
>  	struct device dev;
> +
> +	/* Multiple framebuffers may share one backlight device */
> +	bool fb_bl_on[FB_MAX];
> +
> +	int use_count;
>  };
>  
>  static inline void backlight_update_status(struct backlight_device *bd)
> -- 
> 1.7.9.5
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
