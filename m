Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaKKJ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:27:33 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38256 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaKKJ12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <1415638712-18486-1-git-send-email-linux@rainbow-software.org>
References: <1415638712-18486-1-git-send-email-linux@rainbow-software.org>
Date: Tue, 11 Nov 2014 10:27:27 +0100
Message-ID: <CAPDyKFpUS6yG1Fq+dVFn_8AG7-_B-_moo2JCz4AQBKgvp-YaHQ@mail.gmail.com>
Subject: Re: [PATCH v4] mmc: add Toshiba PCI SD controller driver
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 November 2014 17:58, Ondrej Zary <linux@rainbow-software.org> wrote:
> This patch resurrects an old never-finished driver for Toshiba PCI SD
> controllers found in some older Toshiba laptops (such as Portege R100):
>
> 02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA Controller [1179:0805] (rev 05)
>
> The code is fixed, cleaned up and successfully tested with SD, SDHC, SDXC and
> MMC cards on Portege R100. (MMC cards don't even work in Windows!)
> SDIO probably does not work (don't have any SDIO card).
>
> The hardware is slow (around 2 MB/s - same in Windows) because it does not
> support bus mastering (busmaster enable bit cannot be set in PCI control reg).
> Also the card clock is limited to 16MHz (33MHz PCI clock divided by 2).
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Hi Ondrej,

I get these compiler warning while building for x86. Can you please fix them.

../drivers/mmc/host/toshsd.c: In function ‘toshsd_init’:
../drivers/mmc/host/toshsd.c:70:9: warning: large integer implicitly
truncated to unsigned type [-Woverflow]
         host->ioaddr + SD_INTMASKCARD);
         ^

Kind regards
Uffe

> ---
> Changes in v4:
>  - added missing includes
>  - removed IO access wrappers
>  - uses threaded IRQ instead of tasklets
>  - converted bit defines to use BIT macro
> ---
> Changes in v3:
>  - fixed a bug causing no-response commands to fail
>  - reordered functions to remove forward declarations
>  - uses threaded IRQ instead of tasklets
>  - PM functions converted to new style
> ---
>  drivers/mmc/host/Kconfig  |    5 +
>  drivers/mmc/host/Makefile |    1 +
>  drivers/mmc/host/toshsd.c |  716 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/host/toshsd.h |  176 +++++++++++
>  4 files changed, 898 insertions(+)
>  create mode 100644 drivers/mmc/host/toshsd.c
>  create mode 100644 drivers/mmc/host/toshsd.h
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 1386065..882bfe5 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -748,3 +748,8 @@ config MMC_SUNXI
>         help
>           This selects support for the SD/MMC Host Controller on
>           Allwinner sunxi SoCs.
> +
> +config MMC_TOSHIBA_PCI
> +       tristate "Toshiba Type A SD/MMC Card Interface Driver"
> +       depends on PCI
> +       help
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index b09ecfb..f7b0a77 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_MMC_WMT)         += wmt-sdmmc.o
>  obj-$(CONFIG_MMC_MOXART)       += moxart-mmc.o
>  obj-$(CONFIG_MMC_SUNXI)                += sunxi-mmc.o
>  obj-$(CONFIG_MMC_USDHI6ROL0)   += usdhi6rol0.o
> +obj-$(CONFIG_MMC_TOSHIBA_PCI)  += toshsd.o
>
>  obj-$(CONFIG_MMC_REALTEK_PCI)  += rtsx_pci_sdmmc.o
>  obj-$(CONFIG_MMC_REALTEK_USB)  += rtsx_usb_sdmmc.o
> diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
> new file mode 100644
> index 0000000..3cadff9
> --- /dev/null
> +++ b/drivers/mmc/host/toshsd.c
> @@ -0,0 +1,716 @@
> +/*
> + *  Toshiba PCI Secure Digital Host Controller Interface driver
> + *
> + *  Copyright (C) 2014 Ondrej Zary
> + *  Copyright (C) 2007 Richard Betts, All Rights Reserved.
> + *
> + *     Based on asic3_mmc.c, copyright (c) 2005 SDG Systems, LLC and,
> + *     sdhci.c, copyright (C) 2005-2006 Pierre Ossman
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/scatterlist.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/pm.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/mmc.h>
> +
> +#include "toshsd.h"
> +
> +#define DRIVER_NAME "toshsd"
> +
> +static const struct pci_device_id pci_ids[] = {
> +       { PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA, 0x0805) },
> +       { /* end: all zeroes */ },
> +};
> +
> +MODULE_DEVICE_TABLE(pci, pci_ids);
> +
> +static void toshsd_init(struct toshsd_host *host)
> +{
> +       /* enable clock */
> +       pci_write_config_byte(host->pdev, SD_PCICFG_CLKSTOP,
> +                                       SD_PCICFG_CLKSTOP_ENABLE_ALL);
> +       pci_write_config_byte(host->pdev, SD_PCICFG_CARDDETECT, 2);
> +
> +       /* reset */
> +       iowrite16(0, host->ioaddr + SD_SOFTWARERESET); /* assert */
> +       mdelay(2);
> +       iowrite16(1, host->ioaddr + SD_SOFTWARERESET); /* deassert */
> +       mdelay(2);
> +
> +       /* Clear card registers */
> +       iowrite16(0, host->ioaddr + SD_CARDCLOCKCTRL);
> +       iowrite32(0, host->ioaddr + SD_CARDSTATUS);
> +       iowrite32(0, host->ioaddr + SD_ERRORSTATUS0);
> +       iowrite16(0, host->ioaddr + SD_STOPINTERNAL);
> +
> +       /* SDIO clock? */
> +       iowrite16(0x100, host->ioaddr + SDIO_BASE + SDIO_CLOCKNWAITCTRL);
> +
> +       /* enable LED */
> +       pci_write_config_byte(host->pdev, SD_PCICFG_SDLED_ENABLE1,
> +                                       SD_PCICFG_LED_ENABLE1_START);
> +       pci_write_config_byte(host->pdev, SD_PCICFG_SDLED_ENABLE2,
> +                                       SD_PCICFG_LED_ENABLE2_START);
> +
> +       /* set interrupt masks */
> +       iowrite32(~(SD_CARD_RESP_END | SD_CARD_RW_END | SD_CARD_CARD_REMOVED_0
> +                     | SD_CARD_CARD_INSERTED_0 | SD_BUF_READ_ENABLE
> +                     | SD_BUF_WRITE_ENABLE | SD_BUF_CMD_TIMEOUT),
> +                     host->ioaddr + SD_INTMASKCARD);
> +
> +       iowrite16(0x1000, host->ioaddr + SD_TRANSACTIONCTRL);
> +}
> +
> +/* Set MMC clock / power.
> + * Note: This controller uses a simple divider scheme therefore it cannot run
> + * SD/MMC cards at full speed (24/20MHz). HCLK (=33MHz PCI clock?) is too high
> + * and the next slowest is 16MHz (div=2).
> + */
> +static void __toshsd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +{
> +       struct toshsd_host *host = mmc_priv(mmc);
> +
> +       if (ios->clock) {
> +               u16 clk;
> +               int div = 1;
> +
> +               while (ios->clock < HCLK / div)
> +                       div *= 2;
> +
> +               clk = div >> 2;
> +
> +               if (div == 1) { /* disable the divider */
> +                       pci_write_config_byte(host->pdev, SD_PCICFG_CLKMODE,
> +                                             SD_PCICFG_CLKMODE_DIV_DISABLE);
> +                       clk |= SD_CARDCLK_DIV_DISABLE;
> +               } else
> +                       pci_write_config_byte(host->pdev, SD_PCICFG_CLKMODE, 0);
> +
> +               clk |= SD_CARDCLK_ENABLE_CLOCK;
> +               iowrite16(clk, host->ioaddr + SD_CARDCLOCKCTRL);
> +
> +               mdelay(10);
> +       } else
> +               iowrite16(0, host->ioaddr + SD_CARDCLOCKCTRL);
> +
> +       switch (ios->power_mode) {
> +       case MMC_POWER_OFF:
> +               pci_write_config_byte(host->pdev, SD_PCICFG_POWER1,
> +                                       SD_PCICFG_PWR1_OFF);
> +               mdelay(1);
> +               break;
> +       case MMC_POWER_UP:
> +               break;
> +       case MMC_POWER_ON:
> +               pci_write_config_byte(host->pdev, SD_PCICFG_POWER1,
> +                                       SD_PCICFG_PWR1_33V);
> +               pci_write_config_byte(host->pdev, SD_PCICFG_POWER2,
> +                                       SD_PCICFG_PWR2_AUTO);
> +               mdelay(20);
> +               break;
> +       }
> +
> +       switch (ios->bus_width) {
> +       case MMC_BUS_WIDTH_1:
> +               iowrite16(SD_CARDOPT_REQUIRED | SD_CARDOPT_DATA_RESP_TIMEOUT(14)
> +                               | SD_CARDOPT_C2_MODULE_ABSENT
> +                               | SD_CARDOPT_DATA_XFR_WIDTH_1,
> +                               host->ioaddr + SD_CARDOPTIONSETUP);
> +               break;
> +       case MMC_BUS_WIDTH_4:
> +               iowrite16(SD_CARDOPT_REQUIRED | SD_CARDOPT_DATA_RESP_TIMEOUT(14)
> +                               | SD_CARDOPT_C2_MODULE_ABSENT
> +                               | SD_CARDOPT_DATA_XFR_WIDTH_4,
> +                               host->ioaddr + SD_CARDOPTIONSETUP);
> +               break;
> +       }
> +}
> +
> +static void toshsd_set_led(struct toshsd_host *host, unsigned char state)
> +{
> +       iowrite16(state, host->ioaddr + SDIO_BASE + SDIO_LEDCTRL);
> +}
> +
> +static void toshsd_finish_request(struct toshsd_host *host)
> +{
> +       struct mmc_request *mrq = host->mrq;
> +
> +       /* Write something to end the command */
> +       host->mrq = NULL;
> +       host->cmd = NULL;
> +       host->data = NULL;
> +
> +       toshsd_set_led(host, 0);
> +       mmc_request_done(host->mmc, mrq);
> +}
> +
> +static irqreturn_t toshsd_thread_irq(int irq, void *dev_id)
> +{
> +       struct toshsd_host *host = dev_id;
> +       struct mmc_data *data = host->data;
> +       struct sg_mapping_iter *sg_miter = &host->sg_miter;
> +       unsigned short *buf;
> +       int count;
> +       unsigned long flags;
> +
> +       if (!data) {
> +               dev_warn(&host->pdev->dev, "Spurious Data IRQ\n");
> +               if (host->cmd) {
> +                       host->cmd->error = -EIO;
> +                       toshsd_finish_request(host);
> +               }
> +               return IRQ_NONE;
> +       }
> +       spin_lock_irqsave(&host->lock, flags);
> +
> +       if (!sg_miter_next(sg_miter))
> +               return IRQ_HANDLED;
> +       buf = sg_miter->addr;
> +
> +       /* Ensure we dont read more than one block. The chip will interrupt us
> +        * When the next block is available.
> +        */
> +       count = sg_miter->length;
> +       if (count > data->blksz)
> +               count = data->blksz;
> +
> +       dev_dbg(&host->pdev->dev, "count: %08x, flags %08x\n", count,
> +               data->flags);
> +
> +       /* Transfer the data */
> +       if (data->flags & MMC_DATA_READ)
> +               ioread32_rep(host->ioaddr + SD_DATAPORT, buf, count >> 2);
> +       else
> +               iowrite32_rep(host->ioaddr + SD_DATAPORT, buf, count >> 2);
> +
> +       sg_miter->consumed = count;
> +       sg_miter_stop(sg_miter);
> +
> +       spin_unlock_irqrestore(&host->lock, flags);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void toshsd_cmd_irq(struct toshsd_host *host)
> +{
> +       struct mmc_command *cmd = host->cmd;
> +       u8 *buf = (u8 *) cmd->resp;
> +       u16 data;
> +
> +       if (!host->cmd) {
> +               dev_warn(&host->pdev->dev, "Spurious CMD irq\n");
> +               return;
> +       }
> +
> +       host->cmd = NULL;
> +
> +       if (cmd->flags & MMC_RSP_PRESENT && cmd->flags & MMC_RSP_136) {
> +               /* R2 */
> +               buf[12] = 0xff;
> +               data = ioread16(host->ioaddr + SD_RESPONSE0);
> +               buf[13] = data & 0xff;
> +               buf[14] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE1);
> +               buf[15] = data & 0xff;
> +               buf[8] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE2);
> +               buf[9] = data & 0xff;
> +               buf[10] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE3);
> +               buf[11] = data & 0xff;
> +               buf[4] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE4);
> +               buf[5] = data & 0xff;
> +               buf[6] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE5);
> +               buf[7] = data & 0xff;
> +               buf[0] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE6);
> +               buf[1] = data & 0xff;
> +               buf[2] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE7);
> +               buf[3] = data & 0xff;
> +       } else if (cmd->flags & MMC_RSP_PRESENT) {
> +               /* R1, R1B, R3, R6, R7 */
> +               data = ioread16(host->ioaddr + SD_RESPONSE0);
> +               buf[0] = data & 0xff;
> +               buf[1] = data >> 8;
> +               data = ioread16(host->ioaddr + SD_RESPONSE1);
> +               buf[2] = data & 0xff;
> +               buf[3] = data >> 8;
> +       }
> +
> +       dev_dbg(&host->pdev->dev, "Command IRQ complete %d %d %x\n",
> +               cmd->opcode, cmd->error, cmd->flags);
> +
> +       /* If there is data to handle we will
> +        * finish the request in the mmc_data_end_irq handler.*/
> +       if (host->data)
> +               return;
> +
> +       toshsd_finish_request(host);
> +}
> +
> +static void toshsd_data_end_irq(struct toshsd_host *host)
> +{
> +       struct mmc_data *data = host->data;
> +
> +       host->data = NULL;
> +
> +       if (!data) {
> +               dev_warn(&host->pdev->dev, "Spurious data end IRQ\n");
> +               return;
> +       }
> +
> +       if (data->error == 0)
> +               data->bytes_xfered = data->blocks * data->blksz;
> +       else
> +               data->bytes_xfered = 0;
> +
> +       dev_dbg(&host->pdev->dev, "Completed data request xfr=%d\n",
> +               data->bytes_xfered);
> +
> +       iowrite16(0, host->ioaddr + SD_STOPINTERNAL);
> +
> +       toshsd_finish_request(host);
> +}
> +
> +static irqreturn_t toshsd_irq(int irq, void *dev_id)
> +{
> +       struct toshsd_host *host = dev_id;
> +       u32 int_reg, int_mask, int_status, detail;
> +       int error = 0, ret = IRQ_HANDLED;
> +
> +       spin_lock(&host->lock);
> +       int_status = ioread32(host->ioaddr + SD_CARDSTATUS);
> +       int_mask = ioread32(host->ioaddr + SD_INTMASKCARD);
> +       int_reg = int_status & ~int_mask & ~IRQ_DONT_CARE_BITS;
> +
> +       dev_dbg(&host->pdev->dev, "IRQ status:%x mask:%x\n",
> +               int_status, int_mask);
> +
> +       /* nothing to do: it's not our IRQ */
> +       if (!int_reg) {
> +               ret = IRQ_NONE;
> +               goto irq_end;
> +       }
> +
> +       if (int_reg & SD_BUF_CMD_TIMEOUT) {
> +               error = -ETIMEDOUT;
> +               dev_dbg(&host->pdev->dev, "Timeout\n");
> +       } else if (int_reg & SD_BUF_CRC_ERR) {
> +               error = -EILSEQ;
> +               dev_err(&host->pdev->dev, "BadCRC\n");
> +       } else if (int_reg & (SD_BUF_ILLEGAL_ACCESS
> +                               | SD_BUF_CMD_INDEX_ERR
> +                               | SD_BUF_STOP_BIT_END_ERR
> +                               | SD_BUF_OVERFLOW
> +                               | SD_BUF_UNDERFLOW
> +                               | SD_BUF_DATA_TIMEOUT)) {
> +               dev_err(&host->pdev->dev, "Buffer status error: { %s%s%s%s%s%s}\n",
> +                       int_reg & SD_BUF_ILLEGAL_ACCESS ? "ILLEGAL_ACC " : "",
> +                       int_reg & SD_BUF_CMD_INDEX_ERR ? "CMD_INDEX " : "",
> +                       int_reg & SD_BUF_STOP_BIT_END_ERR ? "STOPBIT_END " : "",
> +                       int_reg & SD_BUF_OVERFLOW ? "OVERFLOW " : "",
> +                       int_reg & SD_BUF_UNDERFLOW ? "UNDERFLOW " : "",
> +                       int_reg & SD_BUF_DATA_TIMEOUT ? "DATA_TIMEOUT " : "");
> +
> +               detail = ioread32(host->ioaddr + SD_ERRORSTATUS0);
> +               dev_err(&host->pdev->dev, "detail error status { %s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
> +                       detail & SD_ERR0_RESP_CMD_ERR ? "RESP_CMD " : "",
> +                       detail & SD_ERR0_RESP_NON_CMD12_END_BIT_ERR ? "RESP_END_BIT " : "",
> +                       detail & SD_ERR0_RESP_CMD12_END_BIT_ERR ? "RESP_END_BIT " : "",
> +                       detail & SD_ERR0_READ_DATA_END_BIT_ERR ? "READ_DATA_END_BIT " : "",
> +                       detail & SD_ERR0_WRITE_CRC_STATUS_END_BIT_ERR ? "WRITE_CMD_END_BIT " : "",
> +                       detail & SD_ERR0_RESP_NON_CMD12_CRC_ERR ? "RESP_CRC " : "",
> +                       detail & SD_ERR0_RESP_CMD12_CRC_ERR ? "RESP_CRC " : "",
> +                       detail & SD_ERR0_READ_DATA_CRC_ERR ? "READ_DATA_CRC " : "",
> +                       detail & SD_ERR0_WRITE_CMD_CRC_ERR ? "WRITE_CMD_CRC " : "",
> +                       detail & SD_ERR1_NO_CMD_RESP ? "NO_CMD_RESP " : "",
> +                       detail & SD_ERR1_TIMEOUT_READ_DATA ? "READ_DATA_TIMEOUT " : "",
> +                       detail & SD_ERR1_TIMEOUT_CRS_STATUS ? "CRS_STATUS_TIMEOUT " : "",
> +                       detail & SD_ERR1_TIMEOUT_CRC_BUSY ? "CRC_BUSY_TIMEOUT " : "");
> +               error = -EIO;
> +       }
> +
> +       if (error) {
> +               if (host->cmd)
> +                       host->cmd->error = error;
> +
> +               if (error == -ETIMEDOUT) {
> +                       iowrite32(int_status &
> +                                 ~(SD_BUF_CMD_TIMEOUT | SD_CARD_RESP_END),
> +                                 host->ioaddr + SD_CARDSTATUS);
> +               } else {
> +                       toshsd_init(host);
> +                       __toshsd_set_ios(host->mmc, &host->mmc->ios);
> +                       goto irq_end;
> +               }
> +       }
> +
> +       /* Card insert/remove. The mmc controlling code is stateless. */
> +       if (int_reg & (SD_CARD_CARD_INSERTED_0 | SD_CARD_CARD_REMOVED_0)) {
> +               iowrite32(int_status &
> +                         ~(SD_CARD_CARD_REMOVED_0 | SD_CARD_CARD_INSERTED_0),
> +                         host->ioaddr + SD_CARDSTATUS);
> +
> +               if (int_reg & SD_CARD_CARD_INSERTED_0)
> +                       toshsd_init(host);
> +
> +               mmc_detect_change(host->mmc, 1);
> +       }
> +
> +       /* Data transfer */
> +       if (int_reg & (SD_BUF_READ_ENABLE | SD_BUF_WRITE_ENABLE)) {
> +               iowrite32(int_status &
> +                         ~(SD_BUF_WRITE_ENABLE | SD_BUF_READ_ENABLE),
> +                         host->ioaddr + SD_CARDSTATUS);
> +
> +               ret = IRQ_WAKE_THREAD;
> +               goto irq_end;
> +       }
> +
> +       /* Command completion */
> +       if (int_reg & SD_CARD_RESP_END) {
> +               iowrite32(int_status & ~(SD_CARD_RESP_END),
> +                         host->ioaddr + SD_CARDSTATUS);
> +               toshsd_cmd_irq(host);
> +       }
> +
> +       /* Data transfer completion */
> +       if (int_reg & SD_CARD_RW_END) {
> +               iowrite32(int_status & ~(SD_CARD_RW_END),
> +                         host->ioaddr + SD_CARDSTATUS);
> +               toshsd_data_end_irq(host);
> +       }
> +irq_end:
> +       spin_unlock(&host->lock);
> +       return ret;
> +}
> +
> +static void toshsd_start_cmd(struct toshsd_host *host, struct mmc_command *cmd)
> +{
> +       struct mmc_data *data = host->data;
> +       int c = cmd->opcode;
> +
> +       dev_dbg(&host->pdev->dev, "Command opcode: %d\n", cmd->opcode);
> +
> +       if (cmd->opcode == MMC_STOP_TRANSMISSION) {
> +               iowrite16(SD_STOPINT_ISSUE_CMD12,
> +                         host->ioaddr + SD_STOPINTERNAL);
> +
> +               cmd->resp[0] = cmd->opcode;
> +               cmd->resp[1] = 0;
> +               cmd->resp[2] = 0;
> +               cmd->resp[3] = 0;
> +
> +               toshsd_finish_request(host);
> +               return;
> +       }
> +
> +       switch (mmc_resp_type(cmd)) {
> +       case MMC_RSP_NONE:
> +               c |= SD_CMD_RESP_TYPE_NONE;
> +               break;
> +
> +       case MMC_RSP_R1:
> +               c |= SD_CMD_RESP_TYPE_EXT_R1;
> +               break;
> +       case MMC_RSP_R1B:
> +               c |= SD_CMD_RESP_TYPE_EXT_R1B;
> +               break;
> +       case MMC_RSP_R2:
> +               c |= SD_CMD_RESP_TYPE_EXT_R2;
> +               break;
> +       case MMC_RSP_R3:
> +               c |= SD_CMD_RESP_TYPE_EXT_R3;
> +               break;
> +
> +       default:
> +               dev_err(&host->pdev->dev, "Unknown response type %d\n",
> +                       mmc_resp_type(cmd));
> +               break;
> +       }
> +
> +       host->cmd = cmd;
> +
> +       if (cmd->opcode == MMC_APP_CMD)
> +               c |= SD_CMD_TYPE_ACMD;
> +
> +       if (cmd->opcode == MMC_GO_IDLE_STATE)
> +               c |= (3 << 8);  /* removed from ipaq-asic3.h for some reason */
> +
> +       if (data) {
> +               c |= SD_CMD_DATA_PRESENT;
> +
> +               if (data->blocks > 1) {
> +                       iowrite16(SD_STOPINT_AUTO_ISSUE_CMD12,
> +                                 host->ioaddr + SD_STOPINTERNAL);
> +                       c |= SD_CMD_MULTI_BLOCK;
> +               }
> +
> +               if (data->flags & MMC_DATA_READ)
> +                       c |= SD_CMD_TRANSFER_READ;
> +
> +               /* MMC_DATA_WRITE does not require a bit to be set */
> +       }
> +
> +       /* Send the command */
> +       iowrite32(cmd->arg, host->ioaddr + SD_ARG0);
> +       iowrite16(c, host->ioaddr + SD_CMD);
> +}
> +
> +static void toshsd_start_data(struct toshsd_host *host, struct mmc_data *data)
> +{
> +       unsigned int flags = SG_MITER_ATOMIC;
> +
> +       dev_dbg(&host->pdev->dev, "setup data transfer: blocksize %08x  nr_blocks %d, offset: %08x\n",
> +               data->blksz, data->blocks, data->sg->offset);
> +
> +       host->data = data;
> +
> +       if (data->flags & MMC_DATA_READ)
> +               flags |= SG_MITER_TO_SG;
> +       else
> +               flags |= SG_MITER_FROM_SG;
> +
> +       sg_miter_start(&host->sg_miter, data->sg, data->sg_len, flags);
> +
> +       /* Set transfer length and blocksize */
> +       iowrite16(data->blocks, host->ioaddr + SD_BLOCKCOUNT);
> +       iowrite16(data->blksz, host->ioaddr + SD_CARDXFERDATALEN);
> +}
> +
> +/* Process requests from the MMC layer */
> +static void toshsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
> +{
> +       struct toshsd_host *host = mmc_priv(mmc);
> +       unsigned long flags;
> +
> +       /* abort if card not present */
> +       if (!(ioread16(host->ioaddr + SD_CARDSTATUS) & SD_CARD_PRESENT_0)) {
> +               mrq->cmd->error = -ENOMEDIUM;
> +               mmc_request_done(mmc, mrq);
> +               return;
> +       }
> +
> +       spin_lock_irqsave(&host->lock, flags);
> +
> +       WARN_ON(host->mrq != NULL);
> +
> +       host->mrq = mrq;
> +
> +       if (mrq->data)
> +               toshsd_start_data(host, mrq->data);
> +
> +       toshsd_set_led(host, 1);
> +
> +       toshsd_start_cmd(host, mrq->cmd);
> +
> +       spin_unlock_irqrestore(&host->lock, flags);
> +}
> +
> +static void toshsd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +{
> +       struct toshsd_host *host = mmc_priv(mmc);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&host->lock, flags);
> +       __toshsd_set_ios(mmc, ios);
> +       spin_unlock_irqrestore(&host->lock, flags);
> +}
> +
> +static int toshsd_get_ro(struct mmc_host *mmc)
> +{
> +       struct toshsd_host *host = mmc_priv(mmc);
> +
> +       /* active low */
> +       return !(ioread16(host->ioaddr + SD_CARDSTATUS) & SD_CARD_WRITE_PROTECT);
> +}
> +
> +static int toshsd_get_cd(struct mmc_host *mmc)
> +{
> +       struct toshsd_host *host = mmc_priv(mmc);
> +
> +       return !!(ioread16(host->ioaddr + SD_CARDSTATUS) & SD_CARD_PRESENT_0);
> +}
> +
> +static struct mmc_host_ops toshsd_ops = {
> +       .request = toshsd_request,
> +       .set_ios = toshsd_set_ios,
> +       .get_ro = toshsd_get_ro,
> +       .get_cd = toshsd_get_cd,
> +};
> +
> +
> +static void toshsd_powerdown(struct toshsd_host *host)
> +{
> +       /* mask all interrupts */
> +       iowrite32(0xffffffff, host->ioaddr + SD_INTMASKCARD);
> +       /* disable card clock */
> +       iowrite16(0x000, host->ioaddr + SDIO_BASE + SDIO_CLOCKNWAITCTRL);
> +       iowrite16(0, host->ioaddr + SD_CARDCLOCKCTRL);
> +       /* power down card */
> +       pci_write_config_byte(host->pdev, SD_PCICFG_POWER1, SD_PCICFG_PWR1_OFF);
> +       /* disable clock */
> +       pci_write_config_byte(host->pdev, SD_PCICFG_CLKSTOP, 0);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int toshsd_pm_suspend(struct device *dev)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +       struct toshsd_host *host = pci_get_drvdata(pdev);
> +
> +       toshsd_powerdown(host);
> +
> +       pci_save_state(pdev);
> +       pci_enable_wake(pdev, PCI_D3hot, 0);
> +       pci_disable_device(pdev);
> +       pci_set_power_state(pdev, PCI_D3hot);
> +
> +       return 0;
> +}
> +
> +static int toshsd_pm_resume(struct device *dev)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +       struct toshsd_host *host = pci_get_drvdata(pdev);
> +       int ret;
> +
> +       pci_set_power_state(pdev, PCI_D0);
> +       pci_restore_state(pdev);
> +       ret = pci_enable_device(pdev);
> +       if (ret)
> +               return ret;
> +
> +       toshsd_init(host);
> +
> +       return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static int toshsd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +       int ret;
> +       struct toshsd_host *host;
> +       struct mmc_host *mmc;
> +       resource_size_t base;
> +
> +       ret = pci_enable_device(pdev);
> +       if (ret)
> +               return ret;
> +
> +       mmc = mmc_alloc_host(sizeof(struct toshsd_host), &pdev->dev);
> +       if (!mmc) {
> +               ret = -ENOMEM;
> +               goto err;
> +       }
> +
> +       host = mmc_priv(mmc);
> +       host->mmc = mmc;
> +
> +       host->pdev = pdev;
> +       pci_set_drvdata(pdev, host);
> +
> +       ret = pci_request_regions(pdev, DRIVER_NAME);
> +       if (ret)
> +               goto free;
> +
> +       host->ioaddr = pci_iomap(pdev, 0, 0);
> +       if (!host->ioaddr) {
> +               ret = -ENOMEM;
> +               goto release;
> +       }
> +
> +       /* Set MMC host parameters */
> +       mmc->ops = &toshsd_ops;
> +       mmc->caps = MMC_CAP_4_BIT_DATA;
> +       mmc->ocr_avail = MMC_VDD_32_33;
> +
> +       mmc->f_min = HCLK / 512;
> +       mmc->f_max = HCLK;
> +
> +       spin_lock_init(&host->lock);
> +
> +       toshsd_init(host);
> +
> +       ret = request_threaded_irq(pdev->irq, toshsd_irq, toshsd_thread_irq,
> +                                  IRQF_SHARED, DRIVER_NAME, host);
> +       if (ret)
> +               goto unmap;
> +
> +       mmc_add_host(mmc);
> +
> +       base = pci_resource_start(pdev, 0);
> +       dev_dbg(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);
> +
> +       pm_suspend_ignore_children(&pdev->dev, 1);
> +
> +       return 0;
> +
> +unmap:
> +       pci_iounmap(pdev, host->ioaddr);
> +release:
> +       pci_release_regions(pdev);
> +free:
> +       mmc_free_host(mmc);
> +       pci_set_drvdata(pdev, NULL);
> +err:
> +       pci_disable_device(pdev);
> +       return ret;
> +}
> +
> +static void toshsd_remove(struct pci_dev *pdev)
> +{
> +       struct toshsd_host *host = pci_get_drvdata(pdev);
> +
> +       mmc_remove_host(host->mmc);
> +       toshsd_powerdown(host);
> +       free_irq(pdev->irq, host);
> +       pci_iounmap(pdev, host->ioaddr);
> +       pci_release_regions(pdev);
> +       mmc_free_host(host->mmc);
> +       pci_set_drvdata(pdev, NULL);
> +       pci_disable_device(pdev);
> +}
> +
> +static const struct dev_pm_ops toshsd_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(toshsd_pm_suspend, toshsd_pm_resume)
> +};
> +
> +static struct pci_driver toshsd_driver = {
> +       .name = DRIVER_NAME,
> +       .id_table = pci_ids,
> +       .probe = toshsd_probe,
> +       .remove = toshsd_remove,
> +       .driver.pm = &toshsd_pm_ops,
> +};
> +
> +static int __init toshsd_drv_init(void)
> +{
> +       return pci_register_driver(&toshsd_driver);
> +}
> +
> +static void __exit toshsd_drv_exit(void)
> +{
> +       pci_unregister_driver(&toshsd_driver);
> +}
> +
> +module_init(toshsd_drv_init);
> +module_exit(toshsd_drv_exit);
> +
> +MODULE_AUTHOR("Ondrej Zary, Richard Betts");
> +MODULE_DESCRIPTION("Toshiba PCI Secure Digital Host Controller Interface driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mmc/host/toshsd.h b/drivers/mmc/host/toshsd.h
> new file mode 100644
> index 0000000..b6c0d89
> --- /dev/null
> +++ b/drivers/mmc/host/toshsd.h
> @@ -0,0 +1,176 @@
> +/*
> + *  Toshiba PCI Secure Digital Host Controller Interface driver
> + *
> + *  Copyright (C) 2014 Ondrej Zary
> + *  Copyright (C) 2007 Richard Betts, All Rights Reserved.
> + *
> + *      Based on asic3_mmc.c Copyright (c) 2005 SDG Systems, LLC
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#define HCLK   33000000        /* 33 MHz (PCI clock) */
> +
> +#define SD_PCICFG_CLKSTOP      0x40    /* 0x1f = clock controller, 0 = stop */
> +#define SD_PCICFG_GATEDCLK     0x41    /* Gated clock */
> +#define SD_PCICFG_CLKMODE      0x42    /* Control clock of SD controller */
> +#define SD_PCICFG_PINSTATUS    0x44    /* R/O: read status of SD pins */
> +#define SD_PCICFG_POWER1       0x48
> +#define SD_PCICFG_POWER2       0x49
> +#define SD_PCICFG_POWER3       0x4a
> +#define SD_PCICFG_CARDDETECT   0x4c
> +#define SD_PCICFG_SLOTS                0x50    /* R/O: define support slot number */
> +#define SD_PCICFG_EXTGATECLK1  0xf0    /* Could be used for gated clock */
> +#define SD_PCICFG_EXTGATECLK2  0xf1    /* Could be used for gated clock */
> +#define SD_PCICFG_EXTGATECLK3  0xf9    /* Bit 1: double buffer/single buffer */
> +#define SD_PCICFG_SDLED_ENABLE1        0xfa
> +#define SD_PCICFG_SDLED_ENABLE2        0xfe
> +
> +#define SD_PCICFG_CLKMODE_DIV_DISABLE  BIT(0)
> +#define SD_PCICFG_CLKSTOP_ENABLE_ALL   0x1f
> +#define SD_PCICFG_LED_ENABLE1_START    0x12
> +#define SD_PCICFG_LED_ENABLE2_START    0x80
> +
> +#define SD_PCICFG_PWR1_33V     0x08    /* Set for 3.3 volts */
> +#define SD_PCICFG_PWR1_OFF     0x00    /* Turn off power */
> +#define SD_PCICFG_PWR2_AUTO    0x02
> +
> +#define SD_CMD                 0x00    /* also for SDIO */
> +#define SD_ARG0                        0x04    /* also for SDIO */
> +#define SD_ARG1                        0x06    /* also for SDIO */
> +#define SD_STOPINTERNAL                0x08
> +#define SD_BLOCKCOUNT          0x0a    /* also for SDIO */
> +#define SD_RESPONSE0           0x0c    /* also for SDIO */
> +#define SD_RESPONSE1           0x0e    /* also for SDIO */
> +#define SD_RESPONSE2           0x10    /* also for SDIO */
> +#define SD_RESPONSE3           0x12    /* also for SDIO */
> +#define SD_RESPONSE4           0x14    /* also for SDIO */
> +#define SD_RESPONSE5           0x16    /* also for SDIO */
> +#define SD_RESPONSE6           0x18    /* also for SDIO */
> +#define SD_RESPONSE7           0x1a    /* also for SDIO */
> +#define SD_CARDSTATUS          0x1c    /* also for SDIO */
> +#define SD_BUFFERCTRL          0x1e    /* also for SDIO */
> +#define SD_INTMASKCARD         0x20    /* also for SDIO */
> +#define SD_INTMASKBUFFER       0x22    /* also for SDIO */
> +#define SD_CARDCLOCKCTRL       0x24
> +#define SD_CARDXFERDATALEN     0x26    /* also for SDIO */
> +#define SD_CARDOPTIONSETUP     0x28    /* also for SDIO */
> +#define SD_ERRORSTATUS0                0x2c    /* also for SDIO */
> +#define SD_ERRORSTATUS1                0x2e    /* also for SDIO */
> +#define SD_DATAPORT            0x30    /* also for SDIO */
> +#define SD_TRANSACTIONCTRL     0x34    /* also for SDIO */
> +#define SD_SOFTWARERESET       0xe0    /* also for SDIO */
> +
> +/* registers above marked "also for SDIO" and all SDIO registers below can be
> + * accessed at SDIO_BASE + reg address */
> +#define SDIO_BASE       0x100
> +
> +#define SDIO_CARDPORTSEL       0x02
> +#define SDIO_CARDINTCTRL       0x36
> +#define SDIO_CLOCKNWAITCTRL    0x38
> +#define SDIO_HOSTINFORMATION   0x3a
> +#define SDIO_ERRORCTRL         0x3c
> +#define SDIO_LEDCTRL           0x3e
> +
> +#define SD_TRANSCTL_SET                BIT(8)
> +
> +#define SD_CARDCLK_DIV_DISABLE BIT(15)
> +#define SD_CARDCLK_ENABLE_CLOCK        BIT(8)
> +#define SD_CARDCLK_CLK_DIV_512 BIT(7)
> +#define SD_CARDCLK_CLK_DIV_256 BIT(6)
> +#define SD_CARDCLK_CLK_DIV_128 BIT(5)
> +#define SD_CARDCLK_CLK_DIV_64  BIT(4)
> +#define SD_CARDCLK_CLK_DIV_32  BIT(3)
> +#define SD_CARDCLK_CLK_DIV_16  BIT(2)
> +#define SD_CARDCLK_CLK_DIV_8   BIT(1)
> +#define SD_CARDCLK_CLK_DIV_4   BIT(0)
> +#define SD_CARDCLK_CLK_DIV_2   0
> +
> +#define SD_CARDOPT_REQUIRED            0x000e
> +#define SD_CARDOPT_DATA_RESP_TIMEOUT(x)        (((x) & 0x0f) << 4) /* 4 bits */
> +#define SD_CARDOPT_C2_MODULE_ABSENT    BIT(14)
> +#define SD_CARDOPT_DATA_XFR_WIDTH_1    (1 << 15)
> +#define SD_CARDOPT_DATA_XFR_WIDTH_4    (0 << 15)
> +
> +#define SD_CMD_TYPE_CMD                        (0 << 6)
> +#define SD_CMD_TYPE_ACMD               (1 << 6)
> +#define SD_CMD_TYPE_AUTHEN             (2 << 6)
> +#define SD_CMD_RESP_TYPE_NONE          (3 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R1                (4 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R1B       (5 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R2                (6 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R3                (7 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R6                (4 << 8)
> +#define SD_CMD_RESP_TYPE_EXT_R7                (4 << 8)
> +#define SD_CMD_DATA_PRESENT            BIT(11)
> +#define SD_CMD_TRANSFER_READ           BIT(12)
> +#define SD_CMD_MULTI_BLOCK             BIT(13)
> +#define SD_CMD_SECURITY_CMD            BIT(14)
> +
> +#define SD_STOPINT_ISSUE_CMD12         BIT(0)
> +#define SD_STOPINT_AUTO_ISSUE_CMD12    BIT(8)
> +
> +#define SD_CARD_RESP_END       BIT(0)
> +#define SD_CARD_RW_END         BIT(2)
> +#define SD_CARD_CARD_REMOVED_0 BIT(3)
> +#define SD_CARD_CARD_INSERTED_0        BIT(4)
> +#define SD_CARD_PRESENT_0      BIT(5)
> +#define SD_CARD_UNK6           BIT(6)
> +#define SD_CARD_WRITE_PROTECT  BIT(7)
> +#define SD_CARD_CARD_REMOVED_3 BIT(8)
> +#define SD_CARD_CARD_INSERTED_3        BIT(9)
> +#define SD_CARD_PRESENT_3      BIT(10)
> +
> +#define SD_BUF_CMD_INDEX_ERR   BIT(16)
> +#define SD_BUF_CRC_ERR         BIT(17)
> +#define SD_BUF_STOP_BIT_END_ERR        BIT(18)
> +#define SD_BUF_DATA_TIMEOUT    BIT(19)
> +#define SD_BUF_OVERFLOW                BIT(20)
> +#define SD_BUF_UNDERFLOW       BIT(21)
> +#define SD_BUF_CMD_TIMEOUT     BIT(22)
> +#define SD_BUF_UNK7            BIT(23)
> +#define SD_BUF_READ_ENABLE     BIT(24)
> +#define SD_BUF_WRITE_ENABLE    BIT(25)
> +#define SD_BUF_ILLEGAL_FUNCTION        BIT(29)
> +#define SD_BUF_CMD_BUSY                BIT(30)
> +#define SD_BUF_ILLEGAL_ACCESS  BIT(31)
> +
> +#define SD_ERR0_RESP_CMD_ERR                   BIT(0)
> +#define SD_ERR0_RESP_NON_CMD12_END_BIT_ERR     BIT(2)
> +#define SD_ERR0_RESP_CMD12_END_BIT_ERR         BIT(3)
> +#define SD_ERR0_READ_DATA_END_BIT_ERR          BIT(4)
> +#define SD_ERR0_WRITE_CRC_STATUS_END_BIT_ERR   BIT(5)
> +#define SD_ERR0_RESP_NON_CMD12_CRC_ERR         BIT(8)
> +#define SD_ERR0_RESP_CMD12_CRC_ERR             BIT(9)
> +#define SD_ERR0_READ_DATA_CRC_ERR              BIT(10)
> +#define SD_ERR0_WRITE_CMD_CRC_ERR              BIT(11)
> +
> +#define SD_ERR1_NO_CMD_RESP            BIT(16)
> +#define SD_ERR1_TIMEOUT_READ_DATA      BIT(20)
> +#define SD_ERR1_TIMEOUT_CRS_STATUS     BIT(21)
> +#define SD_ERR1_TIMEOUT_CRC_BUSY       BIT(22)
> +
> +#define IRQ_DONT_CARE_BITS (SD_CARD_PRESENT_3 \
> +       | SD_CARD_WRITE_PROTECT \
> +       | SD_CARD_UNK6 \
> +       | SD_CARD_PRESENT_0 \
> +       | SD_BUF_UNK7 \
> +       | SD_BUF_CMD_BUSY)
> +
> +struct toshsd_host {
> +       struct pci_dev *pdev;
> +       struct mmc_host *mmc;
> +
> +       spinlock_t lock;
> +
> +       struct mmc_request *mrq;/* Current request */
> +       struct mmc_command *cmd;/* Current command */
> +       struct mmc_data *data;  /* Current data request */
> +
> +       struct sg_mapping_iter sg_miter; /* for PIO */
> +
> +       void __iomem *ioaddr; /* mapped address */
> +};
> --
> Ondrej Zary
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
