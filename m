Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaG2Qjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:39:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40778 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaG2Qjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:39:45 -0400
Message-ID: <53D7CE6F.1050407@arm.com>
Date: Tue, 29 Jul 2014 17:40:15 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-7-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-7-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 29 Jul 2014 16:39:41.0300 (UTC) FILETIME=[B1EC8B40:01CFAB4B]
X-MC-Unique: 114072917394205801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/07/14 14:00, Hanjun Guo wrote:
> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
> the former signals to the OS that the hardware is PSCI compliant.
> The latter selects the appropriate conduit for PSCI calls by
> toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
> (SMC).
>
> FADT table contains such information, parse FADT to get the flags
> for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
> function IDs, which means that only PSCI 0.2+ is supported in ACPI.
>
> At the same time, only ACPI 5.1 or higher verison supports PSCI,
> and FADT Major.Minor version was introduced in ACPI 5.1, so we
> will check the version and only parse FADT table with version >= 5.1.
>
> If firmware provides ACPI tables with ACPI version less than 5.1,
> OS will be messed up with those information and have no way to
> bring up secondery CPUs, so disable ACPI if we get an FADT table
> with version less that 5.1.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> ---
>   arch/arm64/include/asm/acpi.h |    2 +
>   arch/arm64/kernel/acpi.c      |   50 ++++++++++++++++++++++
>   arch/arm64/kernel/psci.c      |   95 +++++++++++++++++++++++++++++------------
>   arch/arm64/kernel/setup.c     |    2 +
>   4 files changed, 121 insertions(+), 28 deletions(-)
>
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 44b617f..67dac90 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -18,6 +18,8 @@ extern int acpi_disabled;
>   extern int acpi_noirq;
>   extern int acpi_pci_disabled;
>   extern int acpi_strict;
> +extern int acpi_psci_present;
> +extern int acpi_psci_use_hvc;
>
>   static inline void disable_acpi(void)
>   {
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index f5a10b5..374926f 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -11,6 +11,8 @@
>    *  published by the Free Software Foundation.
>    */
>
> +#define pr_fmt(fmt) "ACPI: " fmt
> +
>   #include <linux/init.h>
>   #include <linux/acpi.h>
>   #include <linux/cpumask.h>
> @@ -34,6 +36,12 @@ EXPORT_SYMBOL(acpi_disabled);
>   int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
>   EXPORT_SYMBOL(acpi_pci_disabled);
>
> +/* 1 to indicate PSCI is implemented */
> +int acpi_psci_present;
> +
> +/* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
> +int acpi_psci_use_hvc;
> +

These can be boolean but can be removed IMO, see below.

>   /*
>    * __acpi_map_table() will be called before page_init(), so early_ioremap()
>    * or early_memremap() should be called here to for ACPI table mapping.
> @@ -54,6 +62,33 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>   	early_iounmap(map, size);
>   }
>
> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
> +{
> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> +
> +	/*
> +	 * Revision in table header is the FADT Major version,
> +	 * and there is a minor version of FADT which was introduced
> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
> +	 * to get arm boot flags, or we will disable ACPI.
> +	 */
> +	if (table->revision < 5 || fadt->minor_version < 1) {
> +		pr_info("FADT version is %d.%d, no PSCI support, should be 5.1 or higher\n",
> +			table->revision, fadt->minor_version);
> +		acpi_psci_present = 0;
> +		disable_acpi();
> +		return -EINVAL;
> +	}
> +
> +	if (acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT)
> +		acpi_psci_present = 1;
> +
> +	if (acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
> +		acpi_psci_use_hvc = 1;
> +

Why not make this macros instead of global variables as I suggested in
previous version. acpi_gbl_FADT is already global and you can avoid
creating new one especially they are just used on boot/init.

Regards,
Sudeep

