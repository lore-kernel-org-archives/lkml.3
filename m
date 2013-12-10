Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3LJNFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:05:31 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:64707 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJNF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:05:28 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC part2 PATCH 8/9] ACPI / ARM64: Update acpi_register_gsi to register with the core IRQ subsystem
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel@lists.linaro.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        Olof Johansson <olof@lixom.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Hanjun Guo <hanjun.guo@linaro.org>
In-Reply-To: <1385999094-3152-9-git-send-email-hanjun.guo@linaro.org>
References: <1385999094-3152-1-git-send-email-hanjun.guo@linaro.org> < 1385999094-3152-9-git-send-email-hanjun.guo@linaro.org>
Date: Tue, 10 Dec 2013 13:05:21 +0000
Message-Id: <20131210130521.3FE89C40A27@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 23:44:53 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> This API is similar to DT based irq_of_parse_and_map but does link
> parent/child IRQ controllers. This is tested for primary GIC PPI and GIC SPI
> interrupts and not for secondary child irq controllers.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/plat/arm-core.c |   36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 9cc0208..17c99e1 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c
> @@ -90,7 +90,7 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
>  
>  static unsigned int gsi_to_irq(unsigned int gsi)
>  {
> -	int irq = irq_create_mapping(NULL, gsi);
> +	int irq = irq_find_mapping(NULL, gsi);

I suspect this will break FDT users that depend on the old behaviour.

g.

>  
>  	return irq;
>  }
> @@ -407,7 +407,39 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
>   */
>  int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>  {
> -	return -1;
> +	unsigned int irq;
> +	unsigned int irq_type;
> + 
> +	/*
> +	 * ACPI have no bindings to indicate SPI or PPI, so we
> +	 * use different mappings from DT in ACPI.
> +	 *
> +	 * For FDT
> +	 * PPI interrupt: in the range [0, 15];
> +	 * SPI interrupt: in the range [0, 987];
> +	 *
> +	 * For ACPI, using identity mapping for hwirq:
> +	 * PPI interrupt: in the range [16, 31];
> +	 * SPI interrupt: in the range [32, 1019];
> +	 */
> +
> +	if (trigger == ACPI_EDGE_SENSITIVE &&
> +				polarity == ACPI_ACTIVE_LOW)
> +		irq_type = IRQ_TYPE_EDGE_FALLING;
> +	else if (trigger == ACPI_EDGE_SENSITIVE &&
> +				polarity == ACPI_ACTIVE_HIGH)
> +		irq_type = IRQ_TYPE_EDGE_RISING;
> +	else if (trigger == ACPI_LEVEL_SENSITIVE &&
> +				polarity == ACPI_ACTIVE_LOW)
> +		irq_type = IRQ_TYPE_LEVEL_LOW;
> +	else if (trigger == ACPI_LEVEL_SENSITIVE &&
> +				polarity == ACPI_ACTIVE_HIGH)
> +		irq_type = IRQ_TYPE_LEVEL_HIGH;
> +	else
> +		irq_type = IRQ_TYPE_NONE;
> +
> +	irq = irq_create_acpi_mapping(gsi, irq_type);
> + 	return irq; 
>  }
>  EXPORT_SYMBOL_GPL(acpi_register_gsi);
>  
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel

