Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIOHgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:36:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50320 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaIOHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:34:06 -0400
Date: Sun, 14 Sep 2014 23:28:24 -0700
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
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 06/18] ARM64 / ACPI: Introduce early_param for "acpi"
Message-ID: <20140915062824.GB26649@localhost>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-7-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410530416-30200-7-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:00:04PM +0800, Hanjun Guo wrote:
> From: Al Stone <al.stone@linaro.org>
> 
> Introduce one early parameters "off" for "acpi" to disable ACPI on
> ARM64.
> 
> This ensures the kernel uses the DT on a platform that provides both
> ACPI tables and DT.
> 
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/kernel-parameters.txt |    3 ++-
>  arch/arm64/kernel/acpi.c            |   15 +++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5ae8608..9dfb1d8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -165,7 +165,7 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
>  bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  
> -	acpi=		[HW,ACPI,X86]
> +	acpi=		[HW,ACPI,X86,ARM]

ARM64, not ARM.

>  			Advanced Configuration and Power Interface
>  			Format: { force | off | strict | noirq | rsdt }
>  			force -- enable ACPI if default was off
> @@ -175,6 +175,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  				strictly ACPI specification compliant.
>  			rsdt -- prefer RSDT over (default) XSDT
>  			copy_dsdt -- copy DSDT to memory
> +			For ARM64, ONLY "acpi=off" is available.

Both force and off should be made available, since they're the two main switches here.

>  			See also Documentation/power/runtime_pm.txt, pci=noacpi
>  
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 9252f72..693da7f 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -67,3 +67,18 @@ void __init acpi_boot_table_init(void)
>  	if (acpi_table_init())
>  		disable_acpi();
>  }
> +
> +static int __init parse_acpi(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	/* "acpi=off" disables both ACPI table parsing and interpreter */
> +	if (strcmp(arg, "off") == 0)
> +		disable_acpi();
> +	else
> +		return -EINVAL;	/* Core will print when we return error */

For symmetry, you should handle acpi=force here too (i.e. if someone
disables by default, which I expect we'll ask for when this code is
first merged).

> +
> +	return 0;
> +}
> +early_param("acpi", parse_acpi);
> -- 
> 1.7.9.5
> 
