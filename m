Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaIOHey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:34:54 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51583 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaIOHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:34:19 -0400
Date: Mon, 15 Sep 2014 00:13:04 -0700
From: Olof Johansson <olof@lixom.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v4 15/18] ARM64 / ACPI: Parse GTDT to initialize arch
 timer
Message-ID: <20140915071304.GG26649@localhost>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-16-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410530416-30200-16-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:00:13PM +0800, Hanjun Guo wrote:
> Using the information presented by GTDT to initialize the arch
> timer (not memory-mapped).
> 
> Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/kernel/time.c             |    7 ++
>  drivers/clocksource/arm_arch_timer.c |  117 ++++++++++++++++++++++++++++------
>  include/linux/clocksource.h          |    6 ++
>  3 files changed, 111 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index 1a7125c..42f9195 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -35,6 +35,7 @@
>  #include <linux/delay.h>
>  #include <linux/clocksource.h>
>  #include <linux/clk-provider.h>
> +#include <linux/acpi.h>
>  
>  #include <clocksource/arm_arch_timer.h>
>  
> @@ -72,6 +73,12 @@ void __init time_init(void)
>  
>  	tick_setup_hrtimer_broadcast();
>  
> +	/*
> +	 * Since ACPI or FDT will only one be available in the system,
> +	 * we can use acpi_generic_timer_init() here safely
> +	 */
> +	acpi_generic_timer_init();
> +
>  	arch_timer_rate = arch_timer_get_rate();
>  	if (!arch_timer_rate)
>  		panic("Unable to initialise architected timer.\n");
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec1..397783f 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/io.h>
>  #include <linux/slab.h>
>  #include <linux/sched_clock.h>
> +#include <linux/acpi.h>
>  
>  #include <asm/arch_timer.h>
>  #include <asm/virt.h>
> @@ -338,8 +339,12 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
>  	if (arch_timer_rate)
>  		return;
>  
> -	/* Try to determine the frequency from the device tree or CNTFRQ */
> -	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> +	/*
> +	 * Try to determine the frequency from the device tree or CNTFRQ,
> +	 * if ACPI is enabled, get the frequency from CNTFRQ ONLY.
> +	 */

If ACPI is enabled, the tree won't have been unflattened and there wouldn't be
a property to match. So I don't think the extra check is needed here.

If anything, add a check to make sure "np" is non-null instead.

> +	if (!acpi_disabled ||
> +	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
>  		if (cntbase)
>  			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
>  		else


-Olof
