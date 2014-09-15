Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaIOPBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:01:53 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33007 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaIOPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:01:51 -0400
Date: Mon, 15 Sep 2014 16:01:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 14/18] ARM64 / ACPI: Add GICv2 specific ACPI boot
 support
Message-ID: <20140915150136.GF5415@arm.com>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-15-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410530416-30200-15-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:00:12PM +0100, Hanjun Guo wrote:
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 5b3546b..9869377 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -23,6 +23,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/bootmem.h>
>  #include <linux/smp.h>
> +#include <linux/irqchip/arm-gic-acpi.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/cpu_ops.h>
> @@ -312,6 +313,28 @@ void __init acpi_boot_table_init(void)
>  		pr_err("Can't find FADT or error happened during parsing FADT\n");
>  }
>  
> +void __init acpi_gic_init(void)
> +{
> +	struct acpi_table_header *table;
> +	acpi_status status;
> +	acpi_size tbl_size;
> +	int err;
> +
> +	status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
> +	if (ACPI_FAILURE(status)) {
> +		const char *msg = acpi_format_exception(status);
> +
> +		pr_err("Failed to get MADT table, %s\n", msg);
> +		return;
> +	}
> +
> +	err = gic_v2_acpi_init(table);
> +	if (err)
> +		pr_err("Failed to initialize GIC IRQ controller");
> +
> +	early_acpi_os_unmap_memory((char *)table, tbl_size);
> +}

Maybe this was discussed already but why does this function need to live
under arch/arm64? Isn't the driver code more appropriate?

-- 
Catalin
