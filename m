Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162584AbaDCISO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:18:14 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40391 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162421AbaDCISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:18:08 -0400
Message-ID: <533D194C.6020700@linaro.org>
Date: Thu, 03 Apr 2014 10:18:20 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 09/11] ARM: mvebu: Register notifier callback for the
 cpuidle transition
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com> <1396005211-15573-10-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1396005211-15573-10-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 12:13 PM, Gregory CLEMENT wrote:
> In order to have well encapsulated code, we use notifier callbacks for
> CPU_PM_ENTER and CPU_PM_EXIT inside the mvebu power management code.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm/mach-mvebu/pmsu.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
> index 968c8c02c126..9ea2bb44d573 100644
> --- a/arch/arm/mach-mvebu/pmsu.c
> +++ b/arch/arm/mach-mvebu/pmsu.c
> @@ -18,6 +18,7 @@
>
>   #define pr_fmt(fmt) "mvebu-pmsu: " fmt
>
> +#include <linux/cpu_pm.h>
>   #include <linux/kernel.h>
>   #include <linux/init.h>
>   #include <linux/of_address.h>
> @@ -263,4 +264,21 @@ static noinline void armada_370_xp_pmsu_idle_restore(void)
>   	writel(reg, pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
>   }
>
> +static int armada_370_xp_cpu_pm_notify(struct notifier_block *self,
> +				    unsigned long action, void *hcpu)
> +{
> +	if (action == CPU_PM_ENTER) {
> +		unsigned int hw_cpu = cpu_logical_map(smp_processor_id());
> +		mvebu_pmsu_set_cpu_boot_addr(hw_cpu, armada_370_xp_cpu_resume);
> +	} else if (action == CPU_PM_EXIT) {
> +		armada_370_xp_pmsu_idle_restore();
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block armada_370_xp_cpu_pm_notifier = {
> +	.notifier_call = armada_370_xp_cpu_pm_notify,
> +};
> +
>   early_initcall(armada_370_xp_pmsu_init);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

