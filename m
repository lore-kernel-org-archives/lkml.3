Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaAVLzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:55:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56151 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbaAVLy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:54:57 -0500
Date: Wed, 22 Jan 2014 11:54:53 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c and its related
 head file
Message-ID: <20140122115453.GC24288@e102568-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Jan 2014 11:54:54.0411 (UTC) FILETIME=[C3AF31B0:01CF1768]
X-MC-Unique: 114012211545501401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 12:24:58PM +0000, Hanjun Guo wrote:

[...]

> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index bd9bbd0..2210353 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -41,6 +41,7 @@
>  #include <linux/memblock.h>
>  #include <linux/of_fdt.h>
>  #include <linux/of_platform.h>
> +#include <linux/acpi.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/elf.h>
> @@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
>  
>  	arm64_memblock_init();
>  
> +	/* Parse the ACPI tables for possible boot-time configuration */
> +	acpi_boot_table_init();
> +	early_acpi_boot_init();
> +	acpi_boot_init();
> +
>  	paging_init();

Can I ask you please why we need to parse ACPI tables before
paging_init() ?

[...]

> +/*
> + * __acpi_map_table() will be called before page_init(), so early_ioremap()
> + * or early_memremap() should be called here.

Again, why is this needed ? What's needed before paging_init() from ACPI ?

[...]

> +/*
> + * acpi_boot_table_init() and acpi_boot_init()
> + *  called from setup_arch(), always.
> + *	1. checksums all tables
> + *	2. enumerates lapics
> + *	3. enumerates io-apics
> + *
> + * acpi_table_init() is separated to allow reading SRAT without
> + * other side effects.
> + */
> +void __init acpi_boot_table_init(void)
> +{
> +	/*
> +	 * If acpi_disabled, bail out
> +	 */
> +	if (acpi_disabled)
> +		return;
> +
> +	/*
> +	 * Initialize the ACPI boot-time table parser.
> +	 */
> +	if (acpi_table_init()) {
> +		disable_acpi();
> +		return;
> +	}
> +}
> +
> +int __init early_acpi_boot_init(void)
> +{
> +	/*
> +	 * If acpi_disabled, bail out
> +	 */
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	/*
> +	 * Process the Multiple APIC Description Table (MADT), if present
> +	 */
> +	early_acpi_process_madt();
> +
> +	return 0;
> +}
> +
> +int __init acpi_boot_init(void)
> +{
> +	/*
> +	 * If acpi_disabled, bail out
> +	 */
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
> +
> +	/*
> +	 * Process the Multiple APIC Description Table (MADT), if present
> +	 */
> +	acpi_process_madt();
> +
> +	return 0;
> +}

Well, apart from having three init calls, one returning void and two
returning proper values, do not understand why, and do not understand
why we need three calls in the first place...why should we process MADT
twice in two separate calls ? What is supposed to change in between that
prevents you from merging the two together ?

Thanks,
Lorenzo

