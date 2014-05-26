Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaEZXP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:15:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58306 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751128AbaEZXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:15:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V3 4/8] driver/core: cpu: initialize opp table
Date: Tue, 27 May 2014 01:32:58 +0200
Message-ID: <3104462.ta2PpIfF9J@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6379a5109bf6b4875cc1656b025f9b8186bbb91a.1400736536.git.viresh.kumar@linaro.org>
References: <cover.1400736536.git.viresh.kumar@linaro.org> <6379a5109bf6b4875cc1656b025f9b8186bbb91a.1400736536.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2014 11:07:28 AM Viresh Kumar wrote:
> Drivers expecting CPU's OPPs from device tree initialize OPP table themselves by
> calling of_init_opp_table() and there is nothing driver specific in that. They
> all do it in the same redundant way.
> 
> It would be better if we can get rid of redundancy by initializing CPU OPPs from
> CPU core code for all CPUs (that have a "operating-points" property defined in
> their node).
> 
> This patch adds another routine in cpu.c: of_init_cpu_opp_table() and calls it
> right after CPU device is registered in register_cpu(). A dummy implementation
> is also provided to make it lightweight for platforms that don't need it.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/base/cpu.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..818cfe8 100644
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
> @@ -322,6 +323,25 @@ static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
>  }
>  #endif
>  
> +#if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
> +static inline void of_init_cpu_opp_table(struct cpu *cpu)

Do you actually use cpu anywere in this function for anything other than
just accessing cpu->dev?  If not, why not to pass cpu->dev to it and
move it somewhere in the OPP core?

> +{
> +	int error;
> +
> +	/* Initialize CPU's OPP table */
> +	error = of_init_opp_table(&cpu->dev);
> +	if (!error)
> +		dev_dbg(&cpu->dev, "%s: created OPP table for cpu: %d\n",
> +			__func__, cpu->dev.id);
> +	/* Print error only if there is an issue with OPP table */
> +	else if (error != -ENOSYS && error != -ENODEV)
> +		dev_err(&cpu->dev, "%s: failed to init OPP table for cpu%d, err: %d\n",
> +			__func__, cpu->dev.id, error);
> +}
> +#else
> +static inline void of_init_cpu_opp_table(struct cpu *cpu) {}
> +#endif
> +
>  /*
>   * register_cpu - Setup a sysfs device for a CPU.
>   * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
> @@ -349,10 +369,12 @@ int register_cpu(struct cpu *cpu, int num)
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
> +	of_init_cpu_opp_table(cpu);
>  
>  	return error;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
