Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaKDJlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:41:22 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55768 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaKDJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415086357-4619-1-git-send-email-vincent.wan@amd.com>
References: <1415086357-4619-1-git-send-email-vincent.wan@amd.com>
Date: Tue, 4 Nov 2014 10:41:15 +0100
Message-ID: <CAPDyKFqWiJS3ckfY1Ap0VwAbss0qdJoeA+2BCw=DZStdq=h7bA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: Add a quirk for AMD SDHC transfer mode register
 need to be cleared for cmd without data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Vincent Wan <vincent.wan@amd.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 08:32, Vincent Wan <vincent.wan@amd.com> wrote:
> SDHC controller in AMD chipsets require SDHC transfer mode
> register to be cleared for commands without data. The issue was
> uncovered during testing eMMC cards on KB/ML based platforms.
>
> Signed-off-by: Vincent Wan <vincent.wan@amd.com>
> Signed-off-by: Arindam Nath <arindam.nath@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Tested-by: Vikram B <vikram.b@amd.com>
> Tested-by: Raghavendra Swamy <raghavendra.swamy@amd.com>

The patch needs to be rebased towwards my latest next branch, it had a
minor conflict. I can normally handle such myself, but I decided since
the rebase was needed anyway, let's me give you a few comments.

> ---
>  drivers/mmc/host/sdhci-pci.c | 27 +++++++++++++++++++++++++++
>  drivers/mmc/host/sdhci.c     | 11 ++++++++---
>  include/linux/mmc/sdhci.h    |  2 ++
>  3 files changed, 37 insertions(+), 3 deletions(-)

This patch should be split into two parts.

1) The sdhci core specific part. "mmc: sdhci:...."
2) The sdhci-pci part. "mmc: sdhci-pci: ...."

Kind regards
Uffe

>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 6119297..8f5c998 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -645,6 +645,23 @@ static const struct sdhci_pci_fixes sdhci_rtsx = {
>         .probe_slot     = rtsx_probe_slot,
>  };
>
> +static int amd_probe(struct sdhci_pci_chip *chip)
> +{
> +       struct pci_dev  *smbus_dev;
> +
> +       smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
> +                       PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
> +
> +       if (smbus_dev && (smbus_dev->revision < 0x51))
> +               chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
> +
> +       return 0;
> +}
> +
> +static const struct sdhci_pci_fixes sdhci_amd = {
> +       .probe          = amd_probe,
> +};
> +
>  static const struct pci_device_id pci_ids[] = {
>         {
>                 .vendor         = PCI_VENDOR_ID_RICOH,
> @@ -1045,6 +1062,16 @@ static const struct pci_device_id pci_ids[] = {
>                 .driver_data    = (kernel_ulong_t)&sdhci_o2,
>         },
>
> +       {
> +               .vendor         = PCI_VENDOR_ID_AMD,
> +               .device         = PCI_ANY_ID,
> +               .class          = PCI_CLASS_SYSTEM_SDHCI << 8,
> +               .class_mask     = 0xFFFF00,
> +               .subvendor      = PCI_ANY_ID,
> +               .subdevice      = PCI_ANY_ID,
> +               .driver_data    = (kernel_ulong_t)&sdhci_amd,
> +       },
> +
>         {       /* Generic SD host controller */
>                 PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
>         },
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ada1a3e..8085f26 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -889,10 +889,15 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
>         struct mmc_data *data = cmd->data;
>
>         if (data == NULL) {
> -               /* clear Auto CMD settings for no data CMDs */
> -               mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
> -               sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
> +               if (host->quirks2 &
> +                       SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD) {
> +                       sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
> +               } else {
> +                       /* clear Auto CMD settings for no data CMDs */
> +                       mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
> +                       sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
>                                 SDHCI_TRNS_AUTO_CMD23), SDHCI_TRANSFER_MODE);
> +               }
>                 return;
>         }
>
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index dba793e..0a287aa 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -100,6 +100,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK2_BROKEN_DDR50                      (1<<7)
>  /* Stop command (CMD12) can set Transfer Complete when not using MMC_RSP_BUSY */
>  #define SDHCI_QUIRK2_STOP_WITH_TC                      (1<<8)
> +/* need clear transfer mode register before send cmd */
> +#define SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD (1<<9)
>
>         int irq;                /* Device IRQ */
>         void __iomem *ioaddr;   /* Mapped address */
> --
> 1.8.1.2
>
