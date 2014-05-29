Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaE2WmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:42:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42466 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaE2WmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:42:20 -0400
Message-ID: <5387B7B6.70102@ti.com>
Date: Thu, 29 May 2014 17:41:58 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arvind.chauhan@arm.com>,
        <inderpal.s@samsung.com>, <chander.kashyap@linaro.org>, <pavel@ucw.cz>,
        <len.brown@intel.com>, <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V4 4/8] driver/core: cpu: initialize opp table
References: <cover.1401191054.git.viresh.kumar@linaro.org> <ce68a1ba333ab080a2428242d8fa4d4629064a4d.1401191054.git.viresh.kumar@linaro.org>
In-Reply-To: <ce68a1ba333ab080a2428242d8fa4d4629064a4d.1401191054.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 06:50 AM, Viresh Kumar wrote:
> Drivers expecting CPU's OPPs from device tree initialize OPP table themselves by
> calling of_init_opp_table() and there is nothing driver specific in that. They
> all do it in the same redundant way.
> 
> It would be better if we can get rid of redundancy by initializing CPU OPPs from
> CPU core code for all CPUs (that have a "operating-points" property defined in
> their node).
> 
> This patch calls of_init_opp_table() right after CPU device is registered in
> register_cpu(). of_init_opp_table() also has a dummy implementation which simply
> returns -ENOSYS when CONFIG_OPP or CONFIG_OF isn't supported by some platform.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/base/cpu.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..790183f 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -16,6 +16,7 @@
>  #include <linux/acpi.h>
>  #include <linux/of.h>
>  #include <linux/cpufeature.h>
> +#include <linux/pm_opp.h>
>  
>  #include "base.h"
>  
> @@ -349,10 +350,12 @@ int register_cpu(struct cpu *cpu, int num)
>  	if (cpu->hotpluggable)
>  		cpu->dev.groups = hotplugable_cpu_attr_groups;
>  	error = device_register(&cpu->dev);
> -	if (!error)
> -		per_cpu(cpu_sys_devices, num) = &cpu->dev;
> -	if (!error)
> -		register_cpu_under_node(num, cpu_to_node(num));
> +	if (error)
> +		return error;
> +
> +	per_cpu(cpu_sys_devices, num) = &cpu->dev;
> +	register_cpu_under_node(num, cpu_to_node(num));

The change so far is a improvement in error handling -> which,
personally I find nice, but not necessarily related to the $subject or
covered in commit message. I suggest splitting that specific change
out as a patch of it's own.

> +	of_init_opp_table(&cpu->dev);
tricky... :) I finally did catchup on previous discussions
https://patchwork.kernel.org/patch/4199601/
https://patchwork.kernel.org/patch/4199741/
https://patchwork.kernel.org/patch/4215901/
https://patchwork.kernel.org/patch/4220431/

So, will let Rafael comment better here.

>  
>  	return error;
>  }
> 


-- 
Regards,
Nishanth Menon
