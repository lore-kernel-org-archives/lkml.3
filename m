Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaJUJhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:37:13 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33825 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJUJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:37:11 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 21 Oct 2014 11:34:05 +0200
From: Johan Hovold <johan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
Message-ID: <20141021093405.GA2113@localhost>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413864783-3271-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:12:17PM -0700, Guenter Roeck wrote:

> v2:
> - poweroff -> power_off

Do you want to stick to power[-_ ]off consistently throughout?

> - Add defines for default priorities
> - Use raw notifiers protected by spinlocks instead of atomic notifiers
> - Add register_poweroff_handler_simple
> - Add devm_register_power_off_handler
> 
>  include/linux/pm.h              |  22 ++++
>  kernel/power/Makefile           |   1 +
>  kernel/power/poweroff_handler.c | 252 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 275 insertions(+)
>  create mode 100644 kernel/power/poweroff_handler.c
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 383fd68..7e0cb36 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -34,7 +34,29 @@
>  extern void (*pm_power_off)(void);
>  extern void (*pm_power_off_prepare)(void);
>  
> +/*
> + * Callbacks to manage poweroff handlers

power-off

> + */
> +
> +struct notifier_block;
>  struct device; /* we have a circular dep with device.h */
> +
> +int register_power_off_handler(struct notifier_block *);
> +int devm_register_power_off_handler(struct device *, struct notifier_block *);
> +int register_power_off_handler_simple(void (*function)(void), int priority);
> +int unregister_power_off_handler(struct notifier_block *);
> +void do_kernel_power_off(void);
> +bool have_kernel_power_off(void);
> +
> +/*
> + * Pre-defined poweroff handler priorities

power-off

> + */
> +#define POWEROFF_PRIORITY_FALLBACK	0
> +#define POWEROFF_PRIORITY_LOW		64
> +#define POWEROFF_PRIORITY_DEFAULT	128
> +#define POWEROFF_PRIORITY_HIGH		192
> +#define POWEROFF_PRIORITY_HIGHEST	255

I think at least these ones should match the interface function and have
a POWER_OFF_PRIORITY_ prefix.

> +
>  #ifdef CONFIG_VT_CONSOLE_SLEEP
>  extern void pm_vt_switch_required(struct device *dev, bool required);
>  extern void pm_vt_switch_unregister(struct device *dev);
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index 29472bf..4d9f0c7 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -2,6 +2,7 @@
>  ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
>  
>  obj-y				+= qos.o
> +obj-y				+= poweroff_handler.o
>  obj-$(CONFIG_PM)		+= main.o
>  obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
>  obj-$(CONFIG_FREEZER)		+= process.o
> diff --git a/kernel/power/poweroff_handler.c b/kernel/power/poweroff_handler.c
> new file mode 100644
> index 0000000..aeb4736
> --- /dev/null
> +++ b/kernel/power/poweroff_handler.c

power_off_handler.c?

> @@ -0,0 +1,252 @@
> +/*
> + * linux/kernel/power/poweroff_handler.c - Poweroff handling functions
> + *
> + * Copyright (c) 2014 Guenter Roeck
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#define pr_fmt(fmt)	"poweroff: " fmt

power-off:?

There's a bunch of these introduced by the driver patches as well (e.g.
poweroff_nb).

Johan
