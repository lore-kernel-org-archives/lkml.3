Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaJTEox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 00:44:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaJTEow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 00:44:52 -0400
Date: Mon, 20 Oct 2014 12:43:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
Message-ID: <20141020044340.GA9589@kroah.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:29:08AM +0800, Neil Zhang wrote:
> The current per-cpu offline info won't be updated if it is
> hotplugged in/out by a kernel governer.
> Let's update it via cpu notifier.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/base/cpu.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..9d61824 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -418,10 +418,35 @@ static void __init cpu_dev_register_generic(void)
>  #endif
>  }
>  
> +static int device_hotplug_notifier(struct notifier_block *nfb,
> +				      unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +	struct device *dev = get_cpu_device(cpu);
> +	int ret;
> +
> +	switch (action & ~CPU_TASKS_FROZEN) {
> +	case CPU_ONLINE:
> +		dev->offline = false;
> +		ret = NOTIFY_OK;
> +		break;
> +	case CPU_DYING:
> +		dev->offline = true;
> +		ret = NOTIFY_OK;
> +		break;
> +	default:
> +		ret = NOTIFY_DONE;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  void __init cpu_dev_init(void)
>  {
>  	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
>  		panic("Failed to register CPU subsystem");
>  
>  	cpu_dev_register_generic();
> +	cpu_notifier(device_hotplug_notifier, 0);
>  }

How much noise is this going to cause on a big/little system that
constantly hot unplug/plugs processors all of the time?

greg k-h
