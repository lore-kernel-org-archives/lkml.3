Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbbAPKqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:46:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35674 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbbAPKqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:46:09 -0500
Message-ID: <54B8EBE7.808@arm.com>
Date: Fri, 16 Jan 2015 10:45:59 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 12/17] ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and
 register device's gsi
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-13-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1421247905-3749-13-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 15:05, Hanjun Guo wrote:
> Introduce ACPI_IRQ_MODEL_GIC which is needed for ARM64 as GIC is
> used, and then register device's gsi with the core IRQ subsystem.
> 
> acpi_register_gsi() is similar to DT based irq_of_parse_and_map(),
> since gsi is unique in the system, so use hwirq number directly
> for the mapping.
> 
> Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Tested-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/kernel/acpi.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/bus.c       |  3 ++
>  include/linux/acpi.h     |  1 +
>  3 files changed, 77 insertions(+)
> 
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 0b7c3a6..c3e24c4 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -37,6 +37,12 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>  static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
>  
>  /*
> + * Since we're on ARM, the default interrupt routing model
> + * clearly has to be GIC.
> + */
> +enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
> +
> +/*
>   * __acpi_map_table() will be called before page_init(), so early_ioremap()
>   * or early_memremap() should be called here to for ACPI table mapping.
>   */
> @@ -184,6 +190,73 @@ void __init acpi_smp_init_cpus(void)
>  	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
>  }
>  
> +int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
> +{
> +	*irq = irq_find_mapping(NULL, gsi);

Is the ACPI implementation really expecting to only deal with a single
domain for interrupts?

This is likely to lead to a number of issues as we're now implementing
stacked domains (GICv2m, GICv3 ITS are already using that model, and
"wire-to MSI translators" will certainly do the same).

This means that, despite having a single GIC described in ACPI, you may
end-up with multiple domains. I expect you'll be safe with MSI (assuming
you never describe them in ACPI), but any form of wire-to-MSI
translation won't work at all.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
