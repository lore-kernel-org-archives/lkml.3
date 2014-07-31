Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaGaGyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:54:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64294 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaGaGx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:59 -0400
Date: Wed, 30 Jul 2014 23:54:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 10/19] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
Message-ID: <20140731065426.GA876@quad.lixom.net>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 24, 2014 at 09:00:16PM +0800, Hanjun Guo wrote:
> +/*
> + * In ACPI mode, the cpu possible map was enumerated before SMP
> + * initialization when MADT table was parsed, so we can get the
> + * possible map here to initialize CPUs.
> + */

The DT smp init will warn if the kernel has been build with too low NR_CPUS.
Does the ACPI core already warn, or did that go missing with this separate code
path?

> +static void __init acpi_smp_init_cpus(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		if (cpu_acpi_read_ops(cpu) != 0)
> +			continue;
> +
> +		cpu_ops[cpu]->cpu_init(NULL, cpu);
> +	}
> +}
> +
> +void __init smp_init_cpus(void)
> +{
> +	if (acpi_disabled)
> +		of_smp_init_cpus();
> +	else
> +		acpi_smp_init_cpus();

I'm liking these deeply split code paths less and less every time I see
them. :(

I would prefer to set up shared state in separate functions, but keep the
control flow the same. Right now you're splitting it completely.

I.e. split data setup between the two, but do the loop calling cpu_init()
the same way. (Yes, that will require you to refactor the DT code path
a bit too...)


-Olof
