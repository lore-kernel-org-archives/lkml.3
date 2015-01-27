Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbbA0CxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:53:02 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbbA0Cw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:52:59 -0500
Date: Mon, 26 Jan 2015 18:52:56 -0800
From: Darren Hart <dvhart@infradead.org>
To: Julijonas Kikutis <julijonas.kikutis@gmail.com>
Cc: corentin.chary@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: enable better lid handling
Message-ID: <20150127025255.GA118747@vmdeb7>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 09:18:35PM +0000, Julijonas Kikutis wrote:

Hi Julijonas,

Please Cc the maintainer listed in the MAINTERS file for a faster response.

> Some Samsung laptops with SABI3 delay the sleep for 10 seconds after
> the lid is closed and do not wake up from sleep after the lid is opened.
> A SABI command is needed to enable the better behavior.
> 
> Command = 0x6e, d0 = 0x81 enables this behavior. Returns d0 = 0x01.
> Command = 0x6e, d0 = 0x80 disables this behavior. Returns d0 = 0x00.
> 
> Command = 0x6d and any d0 queries the state. This returns:
> d0 = 0x00000*01, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is enabled.
> d0 = 0x00000*00, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is disabled.
> Where * is 0 - laptop has never slept or hibernated after switch on,
>            1 - laptop has hibernated just before,
>            2 - laptop has slept just before.
> 
> Patch addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=75901.
> It adds a sysfs attribute lid_handling with description and also an
> addition to the quirks structure to enable the mode by default.
> 
> However, a user with another laptop in the bug report says that "power
> button has to be pressed twice to wake the machine" in this mode.

This is with this patch applied?

> Therefore, it is enabled by default only for the single laptop that I
> have tested.
> 
> This mode is also needed in UEFI, but there samsung-laptop is
> unfortunately disabled.

I don't follow. What are you saying here?

This looks pretty much ready. The only comments I have are argued against by
staying consistent with the existing driver. So just the above questions and one
comment below. Please clarify, update, and resend. Be sure to add me to Cc this
time :-)

> 
> Signed-off-by: Julijonas Kikutis <julijonas.kikutis@gmail.com>
> ---

...

> @@ -1111,7 +1208,7 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
>  }
>  
>  static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
> -				       struct attribute *attr, int idx)
> +					struct attribute *attr, int idx)
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
>  	struct platform_device *pdev = to_platform_device(dev);
> @@ -1124,6 +1221,8 @@ static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
>  		ok = !!(read_battery_life_extender(samsung) >= 0);
>  	if (attr == &dev_attr_usb_charge.attr)
>  		ok = !!(read_usb_charge(samsung) >= 0);
> +	if (attr == &dev_attr_lid_handling.attr)
> +		ok = !!(read_lid_handling(samsung) >= 0);
>  
>  	return ok ? attr->mode : 0;
>  }
> @@ -1436,6 +1535,10 @@ static int samsung_pm_notification(struct notifier_block *nb,
>  	    samsung->quirks->enable_kbd_backlight)
>  		kbd_backlight_enable(samsung);
>  
> +	if (val == PM_POST_HIBERNATION &&
> +	    samsung->quirks->lid_handling)

This can be one line.


-- 
Darren Hart
Intel Open Source Technology Center
