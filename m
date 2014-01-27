Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaA0L0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:26:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40751 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbaA0L0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:26:49 -0500
Date: Mon, 27 Jan 2014 11:26:47 +0000
From: Mark Rutland <mark.rutland@arm.com>
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
        Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 17/20] clocksource / arch_timer: Use ACPI GTDT table to
 initialize arch timer
Message-ID: <20140127112647.GC16516@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-18-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389961514-13562-18-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 12:25:11PM +0000, Hanjun Guo wrote:
> ACPI GTDT (Generic Timer Description Table) contains information for
> arch timer initialization, this patch use this table to probe arm timer.
> 
> GTDT table is used for ARM/ARM64 only, please refer to chapter 5.2.24
> of ACPI 5.0 spec for detailed inforamtion
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/clocksource/arm_arch_timer.c |  100 +++++++++++++++++++++++++++++-----
>  1 file changed, 85 insertions(+), 15 deletions(-)

[...]

> +static void __init register_arch_interrupt(u32 interrupt, u32 flags,
> +					int *arch_timer_ppi)
> +{
> +	int trigger, polarity;
> +
> +	if (!interrupt || !arch_timer_ppi)
> +		return;
> +
> +	trigger = (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
> +			: ACPI_LEVEL_SENSITIVE;
> +
> +	polarity = (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
> +			: ACPI_ACTIVE_HIGH;
> +
> +	*arch_timer_ppi = acpi_register_gsi(NULL, interrupt, trigger,
> +						polarity);
> +}

Why does this take a pointer to the irq rather than returning the irq
(as with irq_of_parse_and_map)?

This looks awfully generic. Are the timer interrupts encoded specially
or is this useful for parsing other interrupts?

> +
> +static int __init acpi_parse_gtdt(struct acpi_table_header *table)
> +{
> +	struct acpi_table_gtdt *gtdt;
> +
> +	gtdt = (struct acpi_table_gtdt *)table;
> +	if (!gtdt)
> +		return -EINVAL;
> +
> +	arch_timer_rate = arch_timer_get_cntfrq();
> +
> +	if (!arch_timer_rate) {
> +		pr_warn("arch_timer: Could not get frequency from CNTFREG\n");

s/CNTFREG/CNTFREQ/

This is probably worth a pr_err at least, the system is unlikely to get
very far if the timers don't work.

Thanks,
Mark.
