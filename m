Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3LSSdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:33:17 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65478 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3LSSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:33:14 -0500
Date: Thu, 19 Dec 2013 19:33:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20131219183310.GF32508@gmail.com>
References: <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
 <1387473881-26179-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387473881-26179-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> +/*
> + * Unregister the sysfb and prevent new sysfbs from getting registered. Can be
> + * called from any context except recursively or from sysfb_register().
> + * Used by remove_conflicting_framebuffers() and friends.
> + */
> +void sysfb_unregister(const struct apertures_struct *apert, bool primary)
> +{
> +	mutex_lock(&sysfb_lock);
> +	if (!IS_ERR(sysfb_dev) && sysfb_dev) {
> +		if (sysfb_match(apert, primary)) {
> +			platform_device_unregister(sysfb_dev);
> +			sysfb_dev = ERR_PTR(-EALREADY);
> +		}
> +	} else {
> +		/* if !sysfb_dev, set err so no new sysfb is probed later */
> +		sysfb_dev = ERR_PTR(-EALREADY);

Just a small detail: we can get into this 'else' branch not just with 
NULL, but also with IS_ERR(sysfb_dev). In that case we override 
whatever error code is contained in sysfb_dev and overwrite it with 
ERR_PTR(-EALREADY).

(Probably not a big deal, because we don't actually ever seem to 
extract the error code from the pointer, but wanted to mention it.)

> +#ifdef CONFIG_X86_SYSFB
> +#include <asm/sysfb.h>
> +#endif

Pet peeve, this looks sexier:

#ifdef CONFIG_X86_SYSFB
# include <asm/sysfb.h>
#endif

> @@ -1604,6 +1607,17 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
>  	}
>  }
>  
> +static void remove_conflicting_sysfb(const struct apertures_struct *apert,
> +				     bool primary)
> +{
> +	if (!apert)
> +		return;
> +
> +#ifdef CONFIG_X86_SYSFB
> +	sysfb_unregister(apert, primary);
> +#endif
> +}

So why not make sysfb_unregister() accept a !apert parameter (it would 
simply return), at which point remove_conflicting_sysfb() could be 
eliminated and just be replaced with a direct sysfb_unregister() call 
- with no #ifdefs.

We only need #ifdefs for the sysfb_unregister() declaration in the .h 
file.

At first sight this looks simpler and cleaner for the fix itself - no 
need for extra cleanups for this detail.

Thanks,

	Ingo
