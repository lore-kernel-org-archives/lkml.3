Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaLRJDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaLRJDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:03:05 -0500
Message-ID: <5492982B.6060106@redhat.com>
Date: Thu, 18 Dec 2014 10:02:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, rjw@rjwysocki.net,
        lenb@kernel.org, tj@kernel.org, arnd@arndb.de, mjg59@srcf.ucam.org
CC: hanjun.guo@linaro.org, leo.duran@amd.com, graeme.gregory@linaro.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [RFC PATCH 2/2] ata: ahci_platform: Add ACPI _CLS matching
References: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com> <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18-12-14 00:16, Suravee Suthikulpanit wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This patch adds ACPI supports for AHCI platform driver, which uses _CLS
> method to match the device.
>
> The following is an example of ASL structure in DSDT for a SATA controller,
> which contains _CLS package to be matched by the ahci_platform driver:
>
>    Device (AHC0) // AHCI Controller
>    {
>      Name(_HID, "AMDI0600")
>      Name (_CCA, 1)
>      Name (_CLS, Package (3)
>      {
>        0x01, // Base Class: Mass Storage
>        0x06, // Sub-Class: serial ATA
>        0x01, // Interface: AHCI
>      })
>      Name (_CRS, ResourceTemplate ()
>      {
>        Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
>        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
>      })
>    }
>
> Also, since ATA driver should not require PCI support for ATA_ACPI,
> this patch removes dependency in the driver/ata/Kconfig.
>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

The ahci_platform changes done here look good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>   drivers/ata/Kconfig         |  2 +-
>   drivers/ata/ahci_platform.c | 10 ++++++++++
>   2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index cd4cccb..edb00c6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -48,7 +48,7 @@ config ATA_VERBOSE_ERROR
>
>   config ATA_ACPI
>   	bool "ATA ACPI Support"
> -	depends on ACPI && PCI
> +	depends on ACPI
>   	default y
>   	help
>   	  This option adds support for ATA-related ACPI objects.
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 06f1d59..54568ec 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -20,6 +20,9 @@
>   #include <linux/platform_device.h>
>   #include <linux/libata.h>
>   #include <linux/ahci_platform.h>
> +#ifdef CONFIG_ATA_ACPI
> +#include <linux/acpi.h>
> +#endif
>   #include "ahci.h"
>
>   static const struct ata_port_info ahci_port_info = {
> @@ -71,6 +74,10 @@ static const struct of_device_id ahci_of_match[] = {
>   };
>   MODULE_DEVICE_TABLE(of, ahci_of_match);
>
> +#ifdef CONFIG_ATA_ACPI
> +static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
> +#endif
> +
>   static struct platform_driver ahci_driver = {
>   	.probe = ahci_probe,
>   	.remove = ata_platform_remove_one,
> @@ -78,6 +85,9 @@ static struct platform_driver ahci_driver = {
>   		.name = "ahci",
>   		.owner = THIS_MODULE,
>   		.of_match_table = ahci_of_match,
> +#ifdef CONFIG_ATA_ACPI
> +		.acpi_cls = &ahci_cls,
> +#endif
>   		.pm = &ahci_pm_ops,
>   	},
>   };
>
