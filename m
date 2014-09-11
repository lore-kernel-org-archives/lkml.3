Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaIKUR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:17:26 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37240 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaIKURY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:17:24 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd28:d59f:629b:bb3e:ba7e]
In-Reply-To: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
Date: Thu, 11 Sep 2014 13:17:23 -0700
Message-ID: <CAOesGMh_Ku-pReg5LHVFvRM0-s_zEO4rgAvaD5rv-eTfPD71Yw@mail.gmail.com>
Subject: Re: [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
From: Olof Johansson <olof@lixom.net>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 1:37 PM,  <suravee.suthikulpanit@amd.com> wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This patch adds ACPI support for non-PCI SATA contoller in ahci_platform driver.
> It adds ACPI matching table in ahci_platform to support AMD Seattle SATA controller
> with following ASL structure in DSDT:
>
>     Device (SATA0)
>     {
>       Name(_HID, "AMDI0600")    // Seattle AHSATA
>       Name (_CCA, 1)            // Cache-coherent controller
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
>         bool "ATA ACPI Support"
> -       depends on ACPI && PCI
> +       depends on ACPI
>         default y
>         help
>           This option adds support for ATA-related ACPI objects.
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
> +       { "AMDI0600", 0 }, /* AMD Seattle AHCI */
> +       { },
> +};
> +#endif
> +
>  static struct platform_driver ahci_driver = {
>         .probe = ahci_probe,
>         .remove = ata_platform_remove_one,
> @@ -94,6 +104,9 @@ static struct platform_driver ahci_driver = {
>                 .name = "ahci",
>                 .owner = THIS_MODULE,
>                 .of_match_table = ahci_of_match,
> +#ifdef CONFIG_ATA_ACPI
> +               .acpi_match_table = ACPI_PTR(ahci_acpi_match),
> +#endif

The whole point of having ACPI_PTR() is to avoid having ifdefs like
these. The structure member is always there, so there's no need to
have it conditionally compiled out.

Come to think of it, the match table should be under CONFIG_ACPI
instead -- why do a separate config option just for this?


-Olof
