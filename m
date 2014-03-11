Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaCKTQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:16:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50165 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755083AbaCKTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:16:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ruchi Kandoi <kandoiruchi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ghackmann@google.com
Subject: Re: [PATCH] power: add an API to log wakeup reasons
Date: Tue, 11 Mar 2014 20:32:08 +0100
Message-ID: <3827847.Gih6ie3Ah6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394503322-25210-1-git-send-email-kandoiruchi@google.com>
References: <1394503322-25210-1-git-send-email-kandoiruchi@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 10, 2014 07:02:02 PM Ruchi Kandoi wrote:
> Add API log_wakeup_reason() and expose it to userspace via sysfs path
> /sys/kernel/wakeup_reasons/last_resume_reason
> This is useful for power management diagnostic purposes.

What's the use case and how is it supposed to work?

> Signed-off-by: Ruchi Kandoi <kandoiruchi@google.com>
> Signed-off-by: Greg Hackmann <ghackmann@google.com>
> ---
>  include/linux/wakeup_reason.h |  23 +++++++
>  kernel/power/Makefile         |   2 +-
>  kernel/power/wakeup_reason.c  | 140 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 164 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/wakeup_reason.h
>  create mode 100644 kernel/power/wakeup_reason.c
> 
> diff --git a/include/linux/wakeup_reason.h b/include/linux/wakeup_reason.h
> new file mode 100644
> index 0000000..7ce50f0
> --- /dev/null
> +++ b/include/linux/wakeup_reason.h
> @@ -0,0 +1,23 @@
> +/*
> + * include/linux/wakeup_reason.h
> + *
> + * Logs the reason which caused the kernel to resume
> + * from the suspend mode.
> + *
> + * Copyright (C) 2014 Google, Inc.
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _LINUX_WAKEUP_REASON_H
> +#define _LINUX_WAKEUP_REASON_H
> +
> +void log_wakeup_reason(int irq);
> +
> +#endif /* _LINUX_WAKEUP_REASON_H */
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index 29472bf..f98f021 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -5,7 +5,7 @@ obj-y				+= qos.o
>  obj-$(CONFIG_PM)		+= main.o
>  obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
>  obj-$(CONFIG_FREEZER)		+= process.o
> -obj-$(CONFIG_SUSPEND)		+= suspend.o
> +obj-$(CONFIG_SUSPEND)		+= suspend.o wakeup_reason.o
>  obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
>  obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
>  				   block_io.o
> diff --git a/kernel/power/wakeup_reason.c b/kernel/power/wakeup_reason.c
> new file mode 100644
> index 0000000..188a6bf
> --- /dev/null
> +++ b/kernel/power/wakeup_reason.c
> @@ -0,0 +1,140 @@
> +/*
> + * kernel/power/wakeup_reason.c
> + *
> + * Logs the reasons which caused the kernel to resume from
> + * the suspend mode.
> + *
> + * Copyright (C) 2014 Google, Inc.
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/wakeup_reason.h>
> +#include <linux/kernel.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/notifier.h>
> +#include <linux/suspend.h>
> +
> +
> +#define MAX_WAKEUP_REASON_IRQS 32
> +static int irq_list[MAX_WAKEUP_REASON_IRQS];
> +static int irqcount;
> +static struct kobject *wakeup_reason;
> +static spinlock_t resume_reason_lock;
> +
> +static ssize_t reason_show(struct kobject *kobj, struct kobj_attribute *attr,
> +		char *buf)
> +{
> +	int irq_no, buf_offset = 0;
> +	struct irq_desc *desc;
> +	spin_lock(&resume_reason_lock);
> +	for (irq_no = 0; irq_no < irqcount; irq_no++) {
> +		desc = irq_to_desc(irq_list[irq_no]);
> +		if (desc && desc->action && desc->action->name)
> +			buf_offset += sprintf(buf + buf_offset, "%d %s\n",
> +					irq_list[irq_no], desc->action->name);
> +		else
> +			buf_offset += sprintf(buf + buf_offset, "%d\n",
> +					irq_list[irq_no]);
> +	}
> +	spin_unlock(&resume_reason_lock);
> +	return buf_offset;
> +}
> +
> +static struct kobj_attribute resume_reason = __ATTR(last_resume_reason, 0666,
> +		reason_show, NULL);
> +
> +static struct attribute *attrs[] = {
> +	&resume_reason.attr,
> +	NULL,
> +};
> +static struct attribute_group attr_group = {
> +	.attrs = attrs,
> +};
> +
> +/*
> + * logs all the wake up reasons to the kernel
> + * stores the irqs to expose them to the userspace via sysfs
> + */
> +void log_wakeup_reason(int irq)
> +{
> +	struct irq_desc *desc;
> +	desc = irq_to_desc(irq);
> +	if (desc && desc->action && desc->action->name)
> +		printk(KERN_INFO "Resume caused by IRQ %d, %s\n", irq,
> +				desc->action->name);
> +	else
> +		printk(KERN_INFO "Resume caused by IRQ %d\n", irq);
> +
> +	spin_lock(&resume_reason_lock);
> +	if (irqcount == MAX_WAKEUP_REASON_IRQS) {
> +		spin_unlock(&resume_reason_lock);
> +		printk(KERN_WARNING "Resume caused by more than %d IRQs\n",
> +				MAX_WAKEUP_REASON_IRQS);
> +		return;
> +	}
> +
> +	irq_list[irqcount++] = irq;
> +	spin_unlock(&resume_reason_lock);
> +}
> +
> +/* Detects a suspend and clears all the previous wake up reasons*/
> +static int wakeup_reason_pm_event(struct notifier_block *notifier,
> +		unsigned long pm_event, void *unused)
> +{
> +	switch (pm_event) {
> +	case PM_SUSPEND_PREPARE:
> +		spin_lock(&resume_reason_lock);
> +		irqcount = 0;
> +		spin_unlock(&resume_reason_lock);
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block wakeup_reason_pm_notifier_block = {
> +	.notifier_call = wakeup_reason_pm_event,
> +};
> +
> +/* Initializes the sysfs parameter
> + * registers the pm_event notifier
> + */
> +int __init wakeup_reason_init(void)
> +{
> +	int retval;
> +	spin_lock_init(&resume_reason_lock);
> +	retval = register_pm_notifier(&wakeup_reason_pm_notifier_block);
> +	if (retval)
> +		printk(KERN_WARNING "[%s] failed to register PM notifier %d\n",
> +				__func__, retval);
> +
> +	wakeup_reason = kobject_create_and_add("wakeup_reasons", kernel_kobj);
> +	if (!wakeup_reason) {
> +		printk(KERN_WARNING "[%s] failed to create a sysfs kobject\n",
> +				__func__);
> +		return 1;
> +	}
> +	retval = sysfs_create_group(wakeup_reason, &attr_group);
> +	if (retval) {
> +		kobject_put(wakeup_reason);
> +		printk(KERN_WARNING "[%s] failed to create a sysfs group %d\n",
> +				__func__, retval);
> +	}
> +	return 0;
> +}
> +
> +late_initcall(wakeup_reason_init);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
