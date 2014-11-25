Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaLBHaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:30:02 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaLBHaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:30:00 -0500
Date: Tue, 25 Nov 2014 14:39:37 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 2/3] platform: x86: dell-rbtn: Export notifier for other
 kernel modules
Message-ID: <20141125223936.GD116670@vmdeb7>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
 <1416755361-17357-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416755361-17357-3-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 04:09:20PM +0100, Pali Rohár wrote:
> This patch exports notifier functions so other modules can receive HW switch
> events. By default when some module register notifier, dell-rbtn driver

The commit message needs to describe the problem being addressed as well. Why is
this necessary?

> automatically remove rfkill interfaces from system (it is expected that other
> module will use events for other rfkill interface). This behaviour can be
> changed with new module parameter "auto_remove_rfkill".

We try to avoid using such parameters to define behavior when possible.

Why is it justified to use auto_remove_rfkill here? When is it needed? As
opposed to doing something that works based on the detected hardware? (It could
be this is the right thing, but we have to justify it).

> 
> This patch is designed for dell-laptop module for receiving those events.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/platform/x86/dell-rbtn.c |   87 ++++++++++++++++++++++++++++++++++++--
>  drivers/platform/x86/dell-rbtn.h |   35 +++++++++++++++
>  2 files changed, 119 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/platform/x86/dell-rbtn.h
> 
> diff --git a/drivers/platform/x86/dell-rbtn.c b/drivers/platform/x86/dell-rbtn.c
> index f1f039a..69c17e8 100644
> --- a/drivers/platform/x86/dell-rbtn.c
> +++ b/drivers/platform/x86/dell-rbtn.c
> @@ -128,6 +128,74 @@ static void rbtn_disable(struct acpi_device *device)
>  }
>  
>  
> +/*** notifier export functions ***/
> +

If you want to emphasize a comment, use a block comment. Apply throughout.

/*
 * notifier export functions
 */

> +static bool auto_remove_rfkill = true;
> +
> +static ATOMIC_NOTIFIER_HEAD(rbtn_chain_head);
> +
> +static int rbtn_inc_count(struct device *dev, void *data)
> +{
> +	int *count = data;
> +
> +	(*count)++;
> +	return 0;
> +}
> +
> +static int rbtn_switch_dev(struct device *dev, void *data)
> +{
> +	struct acpi_device *device = to_acpi_device(dev);
> +	bool enable = data;
> +
> +	if (enable)
> +		rbtn_enable(device);
> +	else
> +		rbtn_disable(device);
> +
> +	return 0;
> +}
> +
> +int dell_rbtn_notifier_register(struct notifier_block *nb)
> +{
> +	int ret;
> +	bool first;

Descending line length order. Apply throughout where feasible.

	bool first;
	int ret;

> +
> +	ret = 0;
> +	driver_for_each_device(&rbtn_driver.drv, NULL, &ret, rbtn_inc_count);
> +	if (ret == 0)
> +		return -ENODEV;
> +
> +	first = !rbtn_chain_head.head;

Maybe it's just late... but "first" what?

> +
> +	ret = atomic_notifier_chain_register(&rbtn_chain_head, nb);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (auto_remove_rfkill && first)
> +		driver_for_each_device(&rbtn_driver.drv, NULL, (void *)false,
> +				       rbtn_switch_dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dell_rbtn_notifier_register);
> +
> +int dell_rbtn_notifier_unregister(struct notifier_block *nb)
> +{
> +	int ret;
> +
> +	ret = atomic_notifier_chain_unregister(&rbtn_chain_head, nb);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (auto_remove_rfkill && !rbtn_chain_head.head)
> +		driver_for_each_device(&rbtn_driver.drv, NULL, (void *)true,
> +				       rbtn_switch_dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dell_rbtn_notifier_unregister);
> +
> +
>  /*** acpi driver functions ***/
>  
>  static int rbtn_add(struct acpi_device *device)
> @@ -138,6 +206,9 @@ static int rbtn_add(struct acpi_device *device)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (auto_remove_rfkill && rbtn_chain_head.head)
> +		return 0;
> +
>  	return rbtn_enable(device);
>  }
>  
> @@ -151,10 +222,13 @@ static void rbtn_notify(struct acpi_device *device, u32 event)
>  {
>  	struct rfkill *rfkill = device->driver_data;
>  
> -	if (event == 0x80)
> +	if (rfkill && event == 0x80)
>  		rbtn_query(rfkill, device);
> -	else
> +
> +	if (!rbtn_chain_head.head && event != 0x80)
>  		dev_info(&device->dev, "Received unknown event (0x%x)\n", event);
> +
> +	atomic_notifier_call_chain(&rbtn_chain_head, event, device);
>  }
>  
>  
> @@ -162,7 +236,9 @@ static void rbtn_notify(struct acpi_device *device, u32 event)
>  
>  static int __init rbtn_init(void)
>  {
> -	return acpi_bus_register_driver(&rbtn_driver);
> +	/* ignore errors so module always loads and exports needed functions */
> +	acpi_bus_register_driver(&rbtn_driver);
> +	return 0;
>  }
>  
>  static void __exit rbtn_exit(void)
> @@ -170,9 +246,14 @@ static void __exit rbtn_exit(void)
>  	acpi_bus_unregister_driver(&rbtn_driver);
>  }
>  
> +module_param(auto_remove_rfkill, bool, 0444);
>  module_init(rbtn_init);
>  module_exit(rbtn_exit);
>  
> +MODULE_PARM_DESC(auto_remove_rfkill, "automatically remove rfkill devices when "
> +				     "other module start receiving events from "

another module starts

> +				     "this module and re-add them when last "

when the last

> +				     "module stop receving events");

stops

>  MODULE_DEVICE_TABLE(acpi, rbtn_ids);
>  MODULE_DESCRIPTION("Dell Airplane Mode Switch driver");
>  MODULE_AUTHOR("Pali Rohár <pali.rohar@gmail.com>");
> diff --git a/drivers/platform/x86/dell-rbtn.h b/drivers/platform/x86/dell-rbtn.h
> new file mode 100644
> index 0000000..41ffbc8
> --- /dev/null
> +++ b/drivers/platform/x86/dell-rbtn.h
> @@ -0,0 +1,35 @@
> +/*
> +    Dell Airplane Mode Switch driver
> +    Copyright (C) 2014  Pali Rohár <pali.rohar@gmail.com>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +*/

See Mika's comments on block quote formatting.

> +
> +#ifndef _DELL_RBTN_H_
> +#define _DELL_RBTN_H_
> +
> +struct notifier_block;
> +
> +#if defined(CONFIG_DELL_RBTN) || defined(CONFIG_DELL_RBTN_MODULE)
> +int dell_rbtn_notifier_register(struct notifier_block *nb);
> +int dell_rbtn_notifier_unregister(struct notifier_block *nb);
> +#else
> +static inline int dell_rbtn_notifier_register(struct notifier_block *nb)
> +{
> +	return -ENODEV;
> +}
> +static inline int dell_rbtn_notifier_unregister(struct notifier_block *nb)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
> +#endif
> -- 
> 1.7.9.5
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
