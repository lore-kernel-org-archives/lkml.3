Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFFVYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:24:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54505 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752191AbaFFVYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:24:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V4 4/8] driver/core: cpu: initialize opp table
Date: Fri, 06 Jun 2014 23:41:40 +0200
Message-ID: <1525676.DA5e83Tunr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <ce68a1ba333ab080a2428242d8fa4d4629064a4d.1401191054.git.viresh.kumar@linaro.org>
References: <cover.1401191054.git.viresh.kumar@linaro.org> <ce68a1ba333ab080a2428242d8fa4d4629064a4d.1401191054.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 05:20:53 PM Viresh Kumar wrote:
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
> +	of_init_opp_table(&cpu->dev);

Having thought a bit more about that I don't really like this.

In the ACPI land we have a processor driver that binds to CPU devices and
carries out similar initialization.  I kind of prefer that to littering
core code with platform-specific stuff.

Rafael

