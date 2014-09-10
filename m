Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaIJKMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaIJKM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:12:27 -0400
Message-ID: <541023EB.70705@redhat.com>
Date: Wed, 10 Sep 2014 12:11:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com, tj@kernel.org
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
References: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/09/2014 10:37 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch adds ACPI support for non-PCI SATA contoller in ahci_platform driver.
> It adds ACPI matching table in ahci_platform to support AMD Seattle SATA controller
> with following ASL structure in DSDT:
> 
>     Device (SATA0)
>     {
>       Name(_HID, "AMDI0600")	// Seattle AHSATA
>       Name (_CCA, 1)		// Cache-coherent controller
>       Name (_CRS, ResourceTemplate ()
>       {
>         Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
>         Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
>       })
>     }
> 
> Since ATA driver should not require PCI support for ATA_ACPI,
> this patch also removes dependency in the driver/ata/Kconfig.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Looks good to me, one small nitpick inline.

Acked-by: Hans de Goede <hdegoede@redhat.com>



> ---
>  drivers/ata/Kconfig         |  2 +-
>  drivers/ata/ahci_platform.c | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index e1b9278..f2e6c9e 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -48,7 +48,7 @@ config ATA_VERBOSE_ERROR
>  
>  config ATA_ACPI
>  	bool "ATA ACPI Support"
> -	depends on ACPI && PCI
> +	depends on ACPI
>  	default y
>  	help
>  	  This option adds support for ATA-related ACPI objects.
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index f61ddb9..3499bab 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -20,6 +20,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/libata.h>
>  #include <linux/ahci_platform.h>
> +#ifdef CONFIG_ATA_ACPI
> +#include <linux/acpi.h>
> +#endif
>  #include "ahci.h"
>  
>  static const struct ata_port_info ahci_port_info = {
> @@ -87,6 +90,13 @@ static const struct of_device_id ahci_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>  
> +#ifdef CONFIG_ATA_ACPI
> +static const struct acpi_device_id ahci_acpi_match[] = {
> +	{ "AMDI0600", 0 }, /* AMD Seattle AHCI */
> +	{ },
> +};
> +#endif
> +
>  static struct platform_driver ahci_driver = {
>  	.probe = ahci_probe,
>  	.remove = ata_platform_remove_one,
> @@ -94,6 +104,9 @@ static struct platform_driver ahci_driver = {
>  		.name = "ahci",
>  		.owner = THIS_MODULE,
>  		.of_match_table = ahci_of_match,
> +#ifdef CONFIG_ATA_ACPI
> +		.acpi_match_table = ACPI_PTR(ahci_acpi_match),
> +#endif

Hmm, is the cast here really necessary ? AFAIK nowadays we usually
don't need this cast macros, and they can hide accidental prototype
differences, so they are better avoided.


>  		.pm = &ahci_pm_ops,
>  	},
>  };
> 

Regards,

Hans
