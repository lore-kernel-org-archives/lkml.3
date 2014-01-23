Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaAWQvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:51:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33042 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaAWQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:51:22 -0500
Date: Thu, 23 Jan 2014 17:51:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 02/11] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20140123165115.GB23869@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
 <1390486503-1504-3-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390486503-1504-3-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a couple of small nits:

* David Herrmann <dh.herrmann@gmail.com> wrote:

> --- a/arch/x86/kernel/sysfb.c
> +++ b/arch/x86/kernel/sysfb.c
> @@ -33,11 +33,76 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/mutex.h>
>  #include <linux/platform_data/simplefb.h>
>  #include <linux/platform_device.h>
>  #include <linux/screen_info.h>
>  #include <asm/sysfb.h>
>  
> +static DEFINE_MUTEX(sysfb_lock);
> +static struct platform_device *sysfb_dev;
> +
> +int __init sysfb_register(const char *name, int id,
> +			  const struct resource *res, unsigned int res_num,
> +			  const void *data, size_t data_size)
> +{
> +	struct platform_device *pd;
> +	int ret = 0;
> +
> +	mutex_lock(&sysfb_lock);
> +	if (!sysfb_dev) {
> +		pd = platform_device_register_resndata(NULL, name, id,
> +						       res, res_num,
> +						       data, data_size);
> +		if (IS_ERR(pd))
> +			ret = PTR_ERR(pd);
> +		else
> +			sysfb_dev = pd;
> +	}
> +	mutex_unlock(&sysfb_lock);
> +
> +	return ret;
> +}
> +
> +static bool sysfb_match(const struct apertures_struct *apert)
> +{
> +	struct screen_info *si = &screen_info;
> +	unsigned int i;
> +	const struct aperture *a;
> +
> +	for (i = 0; i < apert->count; ++i) {
> +		a = &apert->ranges[i];
> +		if (a->base >= si->lfb_base &&
> +		    a->base < si->lfb_base + ((u64)si->lfb_size << 16))
> +			return true;
> +		if (si->lfb_base >= a->base &&
> +		    si->lfb_base < a->base + a->size)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/* Remove sysfb and disallow new sysfbs from now on. Can be called from any
> + * context except recursively (see also remove_conflicting_framebuffers()). */
> +void sysfb_unregister(const struct apertures_struct *apert, bool primary)

Please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +#ifdef CONFIG_X86_SYSFB
> +#  include <asm/sysfb.h>
> +#endif

I guess a single space is sufficient?

Better yet, I'd include sysfb.h unconditionally:

> @@ -1773,6 +1780,10 @@ register_framebuffer(struct fb_info *fb_info)
>  {
>  	int ret;
>  
> +#ifdef CONFIG_X86_SYSFB
> +	sysfb_unregister(fb_info->apertures, fb_is_primary_device(fb_info));
> +#endif

So, if a dummy sysfb_unregister() inline was defined in the 
!CONFIG_X86_SYSFB case then this ugly #ifdef could possibly be 
removed? Especially as it's used twice.

Thanks,

	Ingo
