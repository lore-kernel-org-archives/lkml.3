Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaKFWKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:10:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50819 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750828AbaKFWKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:10:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?ISO-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v5 01/48] kernel: Add support for power-off handler call chain
Date: Thu, 06 Nov 2014 23:30:59 +0100
Message-ID: <3183593.9HaIZKjCKr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415292213-28652-2-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 06, 2014 08:42:45 AM Guenter Roeck wrote:
> Various drivers implement architecture and/or device specific means to
> power off the system.  For the most part, those drivers set the global
> variable pm_power_off to point to a function within the driver.
> 
> This mechanism has a number of drawbacks.  Typically only one scheme
> to remove power is supported (at least if pm_power_off is used).
> At least in theory there can be multiple means remove power, some of
> which may be less desirable. For example, some mechanisms may only
> power off the CPU or the CPU card, while another may power off the
> entire system.  Others may really just execute a restart sequence
> or drop into the ROM monitor. Using pm_power_off can also be racy
> if the function pointer is set from a driver built as module, as the
> driver may be in the process of being unloaded when pm_power_off is
> called. If there are multiple power-off handlers in the system, removing
> a module with such a handler may inadvertently reset the pointer to
> pm_power_off to NULL, leaving the system with no means to remove power.
> 
> Introduce a system power-off handler call chain to solve the described
> problems.  This call chain is expected to be executed from the architecture
> specific machine_power_off() function.  Drivers and architeceture code
> providing system power-off functionality are expected to register with
> this call chain.  When registering a power-off handler, callers can
> provide a priority to control power-off handler execution sequence
> and thus ensure that the power-off handler with the optimal capabilities
> to remove power for a given system is called first.
> 
> Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Philippe Rétornaz <philippe.retornaz@gmail.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Romain Perier <romain.perier@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v5:
> - Rebase to v3.18-rc3
> v4:
> - Do not use notifiers but internal functions and data structures to manage
>   the list of power-off handlers. Drop unused parameters from callbacks, and
>   make the power-off function type void.
>   Code to manage and walk the list of callbacks is derived from notifier.c.
> v3:
> - Rename new file to power_off_handler.c
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> - Execute power-off handlers without any locks held
> v2:
> - poweroff -> power_off
> - Add defines for default priorities
> - Use raw notifiers protected by spinlocks instead of atomic notifiers
> - Add register_poweroff_handler_simple
> - Add devm_register_power_off_handler
> 
>  include/linux/pm.h               |  28 ++++
>  kernel/power/Makefile            |   1 +
>  kernel/power/power_off_handler.c | 293 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 322 insertions(+)
>  create mode 100644 kernel/power/power_off_handler.c
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 383fd68..a4d6bf8 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -35,6 +35,34 @@ extern void (*pm_power_off)(void);
>  extern void (*pm_power_off_prepare)(void);
>  
>  struct device; /* we have a circular dep with device.h */
> +
> +/*
> + * Data structures and callbacks to manage power-off handlers
> + */
> +
> +struct power_off_handler_block {
> +	void (*handler)(struct power_off_handler_block *);
> +	struct power_off_handler_block __rcu *next;
> +	int priority;
> +};
> +
> +int register_power_off_handler(struct power_off_handler_block *);
> +int devm_register_power_off_handler(struct device *,
> +				    struct power_off_handler_block *);
> +int register_power_off_handler_simple(void (*function)(void), int priority);
> +int unregister_power_off_handler(struct power_off_handler_block *);
> +void do_kernel_power_off(void);
> +bool have_kernel_power_off(void);
> +
> +/*
> + * Pre-defined power-off handler priorities
> + */
> +#define POWER_OFF_PRIORITY_FALLBACK	0
> +#define POWER_OFF_PRIORITY_LOW		64
> +#define POWER_OFF_PRIORITY_DEFAULT	128
> +#define POWER_OFF_PRIORITY_HIGH		192
> +#define POWER_OFF_PRIORITY_HIGHEST	255

I'm not sure why we need these gaps in the priority space.

I guess it might be possible to use

enum power_off_priority {
	POWER_OFF_PRIORITY_FALLBACK = 0,
	POWER_OFF_PRIORITY_LOW,
	POWER_OFF_PRIORITY_DEFAULT,
	POWER_OFF_PRIORITY_HIGH,
	POWER_OFF_PRIORITY_HIGHEST,
	POWER_OFF_PRIORITY_LIMIT,
};

and then make register_ complain if priority is POWER_OFF_PRIORITY_LIMIT
or greater.

But I'm OK with the rest, so if no one else sees a problem here,
I'm not going to make a fuss about it.

Rafael

