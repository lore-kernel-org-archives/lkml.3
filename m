Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaJ0VjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:39:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:31360 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaJ0VjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:39:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,798,1406617200"; 
   d="scan'208";a="597216574"
Message-ID: <544EBB70.6020507@intel.com>
Date: Mon, 27 Oct 2014 22:38:56 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH V2] Driver cpu: update online when cpu_up/down besides
 sysfs
References: <1414378748-8855-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1414378748-8855-1-git-send-email-zhangwm@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 3:59 AM, Neil Zhang wrote:
> The current per-cpu offline info won't be updated when we use
> any other method besides sysfs to call cpu_up/down.
> Thus the cpu/online can't reflect the real online status.
>
> This patch is going to fix the issue introduced by commit
> 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c (Driver core:
> Use generic offline/online for CPU offline/online)
>
> CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Tested-by: Dan Streetman <ddstreet@ieee.org>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>

Oh dear, no.

Please first tell me what exactly the problem you're seeing is.

> ---
>   drivers/base/cpu.c |   25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..9d61824 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -418,10 +418,35 @@ static void __init cpu_dev_register_generic(void)
>   #endif
>   }
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
>   void __init cpu_dev_init(void)
>   {
>   	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
>   		panic("Failed to register CPU subsystem");
>   
>   	cpu_dev_register_generic();
> +	cpu_notifier(device_hotplug_notifier, 0);
>   }

