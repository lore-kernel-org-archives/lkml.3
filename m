Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbbAPOdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:33:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36090 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbbAPOdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:33:47 -0500
Date: Fri, 16 Jan 2015 14:33:37 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
Subject: Re: [PATCH v7 07/17] ARM64 / ACPI: Disable ACPI if FADT revision is
 less than 5.1
Message-ID: <20150116143337.GA14505@red-moon>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-8-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421247905-3749-8-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:04:55PM +0000, Hanjun Guo wrote:
> FADT Major.Minor version was introduced in ACPI 5.1, it is the same
> as ACPI version.
> 
> In ACPI 5.1, some major gaps are fixed for ARM, such as updates in
> MADT table for GIC and SMP init, without those updates, we can not
> get the MPIDR for SMP init, and GICv2/3 related init information, so
> we can't boot arm64 ACPI properly with table versions predating 5.1.
> 
> If firmware provides ACPI tables with ACPI version less than 5.1,
> OS will be messed up with those information and have no way to init

Nit: "that information"

or

"...OS has no way to retrieve the configuration data that is necessary
to init SMP boot protocol and the GIC properly, so.."

> smp and GIC, so disable ACPI if we get an FADT table with version
> less that 5.1.
> 

Patch should be reordered in the series and must be sequenced before
patch 5 for bisectability (that patch implements DT unflattening if ACPI
is disabled), or squashed with previous patches.

Lorenzo

> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Tested-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/kernel/acpi.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 39a1655..4177758 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -13,6 +13,8 @@
>   *  published by the Free Software Foundation.
>   */
>  
> +#define pr_fmt(fmt) "ACPI: " fmt
> +
>  #include <linux/init.h>
>  #include <linux/acpi.h>
>  #include <linux/cpumask.h>
> @@ -49,10 +51,32 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>  	early_memunmap(map, size);
>  }
>  
> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
> +{
> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> +
> +	/*
> +	 * Revision in table header is the FADT Major revision,
> +	 * and there is a minor revision of FADT which was introduced
> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or newer revision
> +	 * to get arm boot flags, or we will disable ACPI.
> +	 */
> +	if (table->revision > 5 ||
> +	    (table->revision == 5 && fadt->minor_revision >= 1))
> +		return 0;
> +
> +	pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
> +		table->revision, fadt->minor_revision);
> +	disable_acpi();
> +
> +	return -EINVAL;
> +}
> +
>  /*
>   * acpi_boot_table_init() called from setup_arch(), always.
>   *	1. find RSDP and get its address, and then find XSDT
>   *	2. extract all tables and checksums them all
> + *	3. check ACPI FADT revision
>   *
>   * We can parse ACPI boot-time tables such as MADT after
>   * this function is called.
> @@ -64,8 +88,13 @@ void __init acpi_boot_table_init(void)
>  		return;
>  
>  	/* Initialize the ACPI boot-time table parser. */
> -	if (acpi_table_init())
> +	if (acpi_table_init()) {
>  		disable_acpi();
> +		return;
> +	}
> +
> +	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
> +		pr_err("Can't find FADT or error happened during parsing FADT\n");
>  }
>  
>  static int __init parse_acpi(char *arg)
> -- 
> 1.9.1
> 
> 
