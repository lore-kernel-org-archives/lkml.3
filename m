Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3DZWhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:37:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3378 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3DZWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:37:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,561,1363158000"; 
   d="scan'208";a="42042527"
Date: Fri, 26 Apr 2013 15:37:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 13/15] clockevents: Provide sysfs interface
Message-ID: <20130426223729.GA782@sboyd-linux.qualcomm.com>
References: <20130425142452.908423538@linutronix.de>
 <20130425143436.371634778@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425143436.371634778@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Thomas Gleixner wrote:
> Provide a simple sysfs interface for the clockevent devices. Show the
> current active clockevent device.
> 

Neat. Does this do anything about clockevents that aren't in use
for the tick devices or broadcast device?

> Index: tip/kernel/time/clockevents.c
> ===================================================================
> --- tip.orig/kernel/time/clockevents.c
> +++ tip/kernel/time/clockevents.c
> @@ -460,4 +461,89 @@ void clockevents_notify(unsigned long re
>  	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(clockevents_notify);
> +
> +#ifdef CONFIG_SYSFS
> +struct bus_type clockevents_subsys = {
> +	.name		= "clockevents",
> +	.dev_name       = "clockevent",
> +};
> +
> +static DEFINE_PER_CPU(struct device, tick_percpu_dev);
> +static struct tick_device *tick_get_tick_dev(struct device *dev);
> +
> +static ssize_t sysfs_show_current_tick_dev(struct device *dev,
> +					   struct device_attribute *attr,
> +					   char *buf)
> +{
> +	struct tick_device *td;
> +	ssize_t count = 0;
> +
> +	raw_spin_lock_irq(&clockevents_lock);
> +	td = tick_get_tick_dev(dev);
> +	if (td && td->evtdev)
> +		count = snprintf(buf, PAGE_SIZE, "%s\n", td->evtdev->name);
> +	raw_spin_unlock_irq(&clockevents_lock);
> +	return count;
> +}
> +static DEVICE_ATTR(current_device, 0444, sysfs_show_current_tick_dev, NULL);
> +
> +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> +static struct device tick_bc_dev = {
> +	.init_name	= "broadcast",
> +	.id		= 0,
> +	.bus		= &clockevents_subsys,
> +};
> +
> +static struct tick_device *tick_get_tick_dev(struct device *dev)
> +{
> +	return dev == &tick_bc_dev ? tick_get_broadcast_device() :
> +		&per_cpu(tick_cpu_device, dev->id);
> +}
> +
> +static int tick_broadcast_init_sysfs(void)

__init?

> +{
> +	int err = device_register(&tick_bc_dev);
> +
> +	if (!err)
> +		err = device_create_file(&tick_bc_dev, &dev_attr_current_device);
> +	return err;
> +}
> +#else
> +static struct tick_device *tick_get_tick_dev(struct device *dev)
> +{
> +	return &per_cpu(tick_cpu_device, dev->id);
> +}
> +static inline int tick_broadcast_init_sysfs(void) { return 0; }
>  #endif
> +
> +int __init tick_init_sysfs(void)

static?

> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct device *dev = &per_cpu(tick_percpu_dev, cpu);
> +		int err;
> +
> +		dev->id = cpu;
> +		dev->bus = &clockevents_subsys;
> +		err = device_register(dev);
> +		if (!err)
> +			err = device_create_file(dev, &dev_attr_current_device);
> +		if (err)
> +			return err;
> +	}
> +	return tick_broadcast_init_sysfs();
> +}

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
