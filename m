Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaEUJfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:35:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59481 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEUJfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:35:04 -0400
Message-ID: <537C7348.7060202@arm.com>
Date: Wed, 21 May 2014 10:35:04 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org> <ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
In-Reply-To: <ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 21 May 2014 09:35:00.0768 (UTC) FILETIME=[EFD72A00:01CF74D7]
X-MC-Unique: 114052110350111801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/05/14 07:29, Viresh Kumar wrote:
> All drivers expecting CPU's OPPs from device tree initialize OPP table using
> of_init_opp_table() and there is nothing driver specific in that. They all do it
> in the same way adding to code redundancy.
>
> It would be better if we can get rid of code redundancy by initializing CPU OPPs
> from core code for all CPUs that have a "operating-points" property defined in
> their node.
>
> This patch initializes OPPs as soon as CPU device is registered in
> register_cpu().
>

This is really nice getting rid of all duplicate code.

> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V1-V2:
> A colleague spotted some extra debug prints in my first mail :(
>
> Replace
> + pr_err("****%s: failed to init OPP table for cpu%d, err: %d\n",
> with
> + pr_err("%s: failed to init OPP table for cpu%d, err: %d\n",
>
>   drivers/base/cpu.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..74ce944 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -16,6 +16,7 @@
>   #include <linux/acpi.h>
>   #include <linux/of.h>
>   #include <linux/cpufeature.h>
> +#include <linux/pm_opp.h>
>
>   #include "base.h"
>
> @@ -349,11 +350,20 @@ int register_cpu(struct cpu *cpu, int num)
>   	if (cpu->hotpluggable)
>   		cpu->dev.groups = hotplugable_cpu_attr_groups;
>   	error = device_register(&cpu->dev);
> -	if (!error)
> +	if (!error) {
>   		per_cpu(cpu_sys_devices, num) = &cpu->dev;
> -	if (!error)
>   		register_cpu_under_node(num, cpu_to_node(num));
>
> +		/* Initialize CPUs OPP table */
> +		if (of_node_get(cpu->dev.of_node)) {
> +			error = of_init_opp_table(&cpu->dev);
> +			if (error && error != -ENODEV)

As Rafael mentioned it's better to have a wrapper function to hide these
details. You should consider the fact that of_init_opp_table returns -EINVAL if
CONFIG_PM_OPP not defined as well as when the list is invalid in the DT.
IMO we can return -ENOSYS if not implemented(i.e. !CONFIG_PM_OPP)

> +				pr_err("%s: failed to init OPP table for cpu%d, err: %d\n",
> +					__func__, num, error);
> +			of_node_put(cpu->dev.of_node);
> +		}
> +	}
> +
>   	return error;
>   }
>

Regards,
Sudeep


