Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3J2S3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:29:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56554 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3J2S3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:29:19 -0400
Message-ID: <526FFE76.6080806@infradead.org>
Date: Tue, 29 Oct 2013 11:29:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, broonie@kernel.org
CC: ning.li@intel.com, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here are a few comments for your next version.


On 10/29/13 11:05, David Cohen wrote:
> From: Fei Yang <fei.yang@intel.com>
> 
> This patch adds driver for ssp spi interface on Intel Mid platform.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Fei Yang <fei.yang@intel.com>
> Reviewed-by: Ning Li <ning.li@intel.com>
> ---
>  drivers/spi/Kconfig                   |   12 +
>  drivers/spi/Makefile                  |    1 +
>  drivers/spi/spi-intel-mid-ssp.c       | 1506 +++++++++++++++++++++++++++++++++
>  include/linux/spi/intel_mid_ssp_spi.h |  330 ++++++++
>  4 files changed, 1849 insertions(+)
>  create mode 100644 drivers/spi/spi-intel-mid-ssp.c
>  create mode 100644 include/linux/spi/intel_mid_ssp_spi.h
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index b9c53cc..e211829 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -211,6 +211,18 @@ config SPI_IMX
>  	  This enables using the Freescale i.MX SPI controllers in master
>  	  mode.
>  
> +config SPI_INTEL_MID_SSP
> +	tristate "SSP SPI controller driver for Intel MID platforms (EXPERIMENTAL)"
> +	depends on X86_INTEL_MID && SPI_MASTER && INTEL_MID_DMAC
> +	help
> +	  Select Y or M to build the unified SSP SPI slave controller driver
> +	  for the Intel MID platforms (Medfield, Clovertrail and Merrifield),
> +	  primarily used to implement a SPI host controller driver over a SSP

I would say:
	                              an SPI                            an SSP

> +	  host controller.
> +
> +	  If you choose to build this driver as module it will be called
> +	  spi-intel-mid-ssp.ko
> +
>  config SPI_LM70_LLP
>  	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
>  	depends on PARPORT
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index ab8d864..60c8a1e 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -38,6 +38,7 @@ obj-$(CONFIG_SPI_FSL_ESPI)		+= spi-fsl-espi.o
>  obj-$(CONFIG_SPI_FSL_SPI)		+= spi-fsl-spi.o
>  obj-$(CONFIG_SPI_GPIO)			+= spi-gpio.o
>  obj-$(CONFIG_SPI_IMX)			+= spi-imx.o
> +obj-$(CONFIG_SPI_INTEL_MID_SSP)		+= spi-intel-mid-ssp.o
>  obj-$(CONFIG_SPI_LM70_LLP)		+= spi-lm70llp.o
>  obj-$(CONFIG_SPI_MPC512x_PSC)		+= spi-mpc512x-psc.o
>  obj-$(CONFIG_SPI_MPC52xx_PSC)		+= spi-mpc52xx-psc.o
> diff --git a/drivers/spi/spi-intel-mid-ssp.c b/drivers/spi/spi-intel-mid-ssp.c
> new file mode 100644
> index 0000000..b3b9fe8
> --- /dev/null
> +++ b/drivers/spi/spi-intel-mid-ssp.c
> @@ -0,0 +1,1506 @@
> +/*
> + * spi-intel-mid-ssp.c
> + * This driver supports Bulverde SSP core used on Intel MID platforms
> + * It supports SSP of Moorestown & Medfield platforms and handles clock
> + * slave & master modes.
> + *
> + * Copyright (c) 2013, Intel Corporation.
> + * Contacts: Ning Li <ning.li@intel.com>
> + *	     David Cohen <david.a.cohen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + */
> +
> +/*
> + * Note:
> + *
> + * Supports DMA and non-interrupt polled transfers.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/highmem.h>
> +#include <linux/pci.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/intel_mid_dma.h>
> +#include <linux/pm_qos.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/completion.h>
> +#include <asm/intel-mid.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/spi/intel_mid_ssp_spi.h>
> +
> +#define DRIVER_NAME "intel_mid_ssp_spi_unified"
> +
> +static int ssp_timing_wr;
> +
> +#ifdef DUMP_RX
> +static void dump_trailer(const struct device *dev, char *buf, int len, int sz)
> +{
> +	int tlen1 = (len < sz ? len : sz);
> +	int tlen2 =  ((len - sz) > sz) ? sz : (len - sz);
> +	unsigned char *p;
> +	static char msg[MAX_SPI_TRANSFER_SIZE];
> +

#include <linux/printk.h>

and try to use print_hex_dump() for this instead of rolling your own...

> +	memset(msg, '\0', sizeof(msg));
> +	p = buf;
> +	while (p < buf + tlen1)
> +		sprintf(msg, "%s%02x", msg, (unsigned int)*p++);
> +
> +	if (tlen2 > 0) {
> +		sprintf(msg, "%s .....", msg);
> +		p = (buf+len) - tlen2;
> +		while (p < buf + len)
> +			sprintf(msg, "%s%02x", msg, (unsigned int)*p++);
> +	}
> +
> +	dev_info(dev, "DUMP: %p[0:%d ... %d:%d]:%s", buf, tlen1 - 1,
> +		   len-tlen2, len - 1, msg);
> +}
> +#endif
> +
> +static void flush(struct ssp_drv_context *sspc)
> +{
> +	void *reg = sspc->ioaddr;
> +	u32 i = 0;
> +
> +	/* If the transmit fifo is not empty, reset the interface. */
> +	if (!is_tx_fifo_empty(sspc)) {
> +		dev_err(&sspc->pdev->dev, "TX FIFO not empty. Reset of SPI IF");
> +		disable_interface(sspc);
> +		return;
> +	}
> +
> +	dev_dbg(&sspc->pdev->dev, " SSSR=%x\r\n", read_SSSR(reg));
> +	while (!is_rx_fifo_empty(sspc) && (i < SPI_FIFO_SIZE + 1)) {
> +		read_SSDR(reg);
> +		i++;
> +	}
> +	WARN(i > 0, "%d words flush occured\n", i);

	                            occurred

> +
> +	return;
> +}
> +
> +
> +
> +	/* set the dma done bit to 1 */

unneeded comment (obvious)

> +	sspc->txdma_done = 1;
> +	sspc->rxdma_done = 1;
> +
> +	sspc->tx_param.drv_context  = sspc;
> +	sspc->tx_param.direction = TX_DIRECTION;
> +	sspc->rx_param.drv_context  = sspc;
> +	sspc->rx_param.direction = RX_DIRECTION;
> +
> +	sspc->dma_initialized = 1;
> +	return;

> +/**
> + * map_dma_buffers() - Map DMA buffer before a transfer
> + * @sspc:	Pointer to the private drivzer context

		                       driver

> +static void poll_transfer_complete(struct ssp_drv_context *sspc)
> +{
> +	struct spi_message *msg;
> +
> +	/* Update total byte transfered return count actual bytes read */

	                     transferred;

> +	sspc->cur_msg->actual_length += sspc->len - (sspc->rx_end - sspc->rx);
> +
> +	sspc->cur_msg->status = 0;
> +	msg = sspc->cur_msg;
> +	if (likely(msg->complete))
> +		msg->complete(msg->context);
> +	complete(&sspc->msg_done);
> +}
> +
> +/**
> + * ssp_int() - Interrupt handler
> + * @irq
> + * @dev_id

Please finish the kernel-doc notation (or drop it).

> + *
> + * The SSP interrupt is not used for transfer which are handled by
> + * DMA or polling: only under/over run are catched to detect
> + * broken transfers.
> + */
> +static irqreturn_t ssp_int(int irq, void *dev_id)
> +{
> +	struct ssp_drv_context *sspc = dev_id;
> +	void *reg = sspc->ioaddr;
> +	struct device *dev = &sspc->pdev->dev;
> +	u32 status = read_SSSR(reg);
> +
> +	/* It should never be our interrupt since SSP will */
> +	/* only trigs interrupt for under/over run.        */

	        trigger

> +	if (likely(!(status & sspc->mask_sr)))
> +		return IRQ_NONE;
> +
> +	if (status & SSSR_ROR || status & SSSR_TUR) {
> +		dev_err(dev, "--- SPI ROR or TUR occurred : SSSR=%x\n",	status);
> +		WARN_ON(1);
> +		if (status & SSSR_ROR)
> +			dev_err(dev, "we have Overrun\n");
> +		if (status & SSSR_TUR)
> +			dev_err(dev, "we have Underrun\n");
> +	}
> +
> +	/* We can fall here when not using DMA mode */
> +	if (!sspc->cur_msg) {
> +		disable_interface(sspc);
> +		disable_triggers(sspc);
> +	}
> +	/* clear status register */
> +	write_SSSR(sspc->clear_sr, reg);
> +	return IRQ_HANDLED;
> +}
> +


> diff --git a/include/linux/spi/intel_mid_ssp_spi.h b/include/linux/spi/intel_mid_ssp_spi.h
> new file mode 100644
> index 0000000..a3bb973
> --- /dev/null
> +++ b/include/linux/spi/intel_mid_ssp_spi.h
> @@ -0,0 +1,330 @@
> +/*
> + *  Copyright (C) Intel 2013
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + */
> +#ifndef INTEL_MID_SSP_SPI_H_
> +#define INTEL_MID_SSP_SPI_H_
> +
> +#include <linux/completion.h>
> +#include <linux/intel_mid_dma.h>
> +#include <linux/interrupt.h>
> +#include <linux/pm_qos.h>
> +#include <linux/spi/spi.h>
> +

> +#define SSCR0_DSS   (0x0000000f)     /* Data Size Select (mask) */
> +#define SSCR0_DataSize(x)  ((x) - 1)    /* Data Size Select [4..16] */
> +#define SSCR0_FRF   (0x00000030)     /* FRame Format (mask) */
> +#define SSCR0_Motorola        (0x0 << 4)         /* Motorola's SPI mode */

#include <linux/bitops.h>

> +#define SSCR0_ECS   (1 << 6) /* External clock select */

#define SSCR0_ECS	BIT(6)	/* External clock select */

etc.

> +#define SSCR0_SSE   (1 << 7) /* Synchronous Serial Port Enable */
> +
> +#define SSCR0_SCR   (0x000fff00)      /* Serial Clock Rate (mask) */
> +#define SSCR0_SerClkDiv(x) (((x) - 1) << 8) /* Divisor [1..4096] */
> +#define SSCR0_EDSS  (1 << 20)           /* Extended data size select */
> +#define SSCR0_NCS   (1 << 21)           /* Network clock select */
> +#define SSCR0_RIM    (1 << 22)           /* Receive FIFO overrrun int mask */
> +#define SSCR0_TUM   (1 << 23)           /* Transmit FIFO underrun int mask */
> +#define SSCR0_FRDC (0x07000000)     /* Frame rate divider control (mask) */
> +#define SSCR0_SlotsPerFrm(x) (((x) - 1) << 24) /* Time slots per frame */
> +#define SSCR0_ADC   (1 << 30)           /* Audio clock select */
> +#define SSCR0_MOD  (1 << 31)           /* Mode (normal or network) */
> +
> +#define SSCR1_RIE    (1 << 0) /* Receive FIFO Interrupt Enable */
> +#define SSCR1_TIE     (1 << 1) /* Transmit FIFO Interrupt Enable */
> +#define SSCR1_LBM   (1 << 2) /* Loop-Back Mode */
> +#define SSCR1_SPO   (1 << 3) /* SSPSCLK polarity setting */
> +#define SSCR1_SPH   (1 << 4) /* Motorola SPI SSPSCLK phase setting */
> +#define SSCR1_MWDS           (1 << 5) /* Microwire Transmit Data Size */
> +#define SSCR1_TFT    (0x000003c0)     /* Transmit FIFO Threshold (mask) */
> +#define SSCR1_TxTresh(x) (((x) - 1) << 6) /* level [1..16] */
> +#define SSCR1_RFT    (0x00003c00)     /* Receive FIFO Threshold (mask) */
> +#define SSCR1_RxTresh(x) (((x) - 1) << 10) /* level [1..16] */
> +
> +#define SSSR_TNF		(1 << 2)	/* Tx FIFO Not Full */
> +#define SSSR_RNE		(1 << 3)	/* Rx FIFO Not Empty */
> +#define SSSR_BSY		(1 << 4)	/* SSP Busy */
> +#define SSSR_TFS		(1 << 5)	/* Tx FIFO Service Request */
> +#define SSSR_RFS		(1 << 6)	/* Rx FIFO Service Request */
> +#define SSSR_ROR		(1 << 7)	/* Rx FIFO Overrun */
> +#define SSSR_TFL_MASK           (0x0f << 8)     /* Tx FIFO level field mask */
> +
> +#define SSCR0_TIM    (1 << 23)          /* Transmit FIFO Under Run Int Mask */
> +#define SSCR0_RIM    (1 << 22)          /* Receive FIFO Over Run int Mask */
> +#define SSCR0_NCS    (1 << 21)          /* Network Clock Select */
> +#define SSCR0_EDSS   (1 << 20)          /* Extended Data Size Select */
> +
> +#define SSCR0_TISSP      (1 << 4)  /* TI Sync Serial Protocol */
> +#define SSCR0_PSP        (3 << 4)  /* PSP - Programmable Serial Protocol */
> +#define SSCR1_TTELP      (1 << 31) /* TXD Tristate Enable Last Phase */
> +#define SSCR1_TTE        (1 << 30) /* TXD Tristate Enable */
> +#define SSCR1_EBCEI      (1 << 29) /* Enable Bit Count Error interrupt */
> +#define SSCR1_SCFR       (1 << 28) /* Slave Clock free Running */
> +#define SSCR1_ECRA       (1 << 27) /* Enable Clock Request A */
> +#define SSCR1_ECRB       (1 << 26) /* Enable Clock request B */
> +#define SSCR1_SCLKDIR    (1 << 25) /* Serial Bit Rate Clock Direction */
> +#define SSCR1_SFRMDIR    (1 << 24) /* Frame Direction */
> +#define SSCR1_RWOT       (1 << 23) /* Receive Without Transmit */
> +#define SSCR1_TRAIL      (1 << 22) /* Trailing Byte */
> +#define SSCR1_TSRE       (1 << 21) /* Transmit Service Request Enable */
> +#define SSCR1_RSRE       (1 << 20) /* Receive Service Request Enable */
> +#define SSCR1_TINTE      (1 << 19) /* Receiver Time-out Interrupt enable */
> +#define SSCR1_PINTE      (1 << 18) /* Trailing Byte Interupt Enable */
> +#define SSCR1_STRF       (1 << 15) /* Select FIFO or EFWR */
> +#define SSCR1_EFWR       (1 << 14) /* Enable FIFO Write/Read */
> +#define SSCR1_IFS        (1 << 16) /* Invert Frame Signal */
> +
> +#define SSSR_BCE         (1 << 23) /* Bit Count Error */
> +#define SSSR_CSS         (1 << 22) /* Clock Synchronisation Status */
> +#define SSSR_TUR         (1 << 21) /* Transmit FIFO Under Run */
> +#define SSSR_EOC         (1 << 20) /* End Of Chain */
> +#define SSSR_TINT        (1 << 19) /* Receiver Time-out Interrupt */
> +#define SSSR_PINT        (1 << 18) /* Peripheral Trailing Byte Interrupt */
> +
> +#define SSPSP_FSRT       (1 << 25)   /* Frame Sync Relative Timing */
> +#define SSPSP_DMYSTOP(x) ((x) << 23) /* Dummy Stop */
> +#define SSPSP_SFRMWDTH(x)((x) << 16) /* Serial Frame Width */
> +#define SSPSP_SFRMDLY(x) ((x) << 9)  /* Serial Frame Delay */
> +#define SSPSP_DMYSTRT(x) ((x) << 7)  /* Dummy Start */
> +#define SSPSP_STRTDLY(x) ((x) << 4)  /* Start Delay */
> +#define SSPSP_ETDS       (1 << 3)    /* End of Transfer data State */
> +#define SSPSP_SFRMP      (1 << 2)    /* Serial Frame Polarity */
> +#define SSPSP_SCMODE(x)  ((x) << 0)  /* Serial Bit Rate Clock Mode */


-- 
~Randy
