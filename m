Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3J2UO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:14:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:13837 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3J2UOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,595,1378882800"; 
   d="scan'208";a="419319348"
Message-ID: <5270181D.9020401@linux.intel.com>
Date: Tue, 29 Oct 2013 13:18:37 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com> <20131029183115.GB12193@gimli>
In-Reply-To: <20131029183115.GB12193@gimli>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 10/29/2013 11:31 AM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Oct 29, 2013 at 11:05:49AM -0700, David Cohen wrote:
>> diff --git a/drivers/spi/spi-intel-mid-ssp.c b/drivers/spi/spi-intel-mid-ssp.c
>> new file mode 100644
>> index 0000000..b3b9fe8
>> --- /dev/null
>> +++ b/drivers/spi/spi-intel-mid-ssp.c
>> @@ -0,0 +1,1506 @@
>> +/*
>> + * spi-intel-mid-ssp.c
>> + * This driver supports Bulverde SSP core used on Intel MID platforms
>> + * It supports SSP of Moorestown & Medfield platforms and handles clock
>> + * slave & master modes.
>> + *
>> + * Copyright (c) 2013, Intel Corporation.
>> + * Contacts: Ning Li <ning.li@intel.com>
>> + *	     David Cohen <david.a.cohen@linux.intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program; if not, write to the Free Software Foundation, Inc.,
>> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>> + *
>> + */
>> +
>> +/*
>> + * Note:
>> + *
>> + * Supports DMA and non-interrupt polled transfers.
>> + *
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/highmem.h>
>> +#include <linux/pci.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/intel_mid_dma.h>
>> +#include <linux/pm_qos.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/completion.h>
>> +#include <asm/intel-mid.h>
>> +
>> +#include <linux/spi/spi.h>
>> +#include <linux/spi/intel_mid_ssp_spi.h>
>> +
>> +#define DRIVER_NAME "intel_mid_ssp_spi_unified"
>> +
>> +static int ssp_timing_wr;
>
> this will prevent multiple instances of the same driver.

Yeah. I'll fix it.

>
>> +#ifdef DUMP_RX
>> +static void dump_trailer(const struct device *dev, char *buf, int len, int sz)
>> +{
>> +	int tlen1 = (len < sz ? len : sz);
>> +	int tlen2 =  ((len - sz) > sz) ? sz : (len - sz);
>> +	unsigned char *p;
>> +	static char msg[MAX_SPI_TRANSFER_SIZE];
>> +
>> +	memset(msg, '\0', sizeof(msg));
>> +	p = buf;
>> +	while (p < buf + tlen1)
>> +		sprintf(msg, "%s%02x", msg, (unsigned int)*p++);
>> +
>> +	if (tlen2 > 0) {
>> +		sprintf(msg, "%s .....", msg);
>> +		p = (buf+len) - tlen2;
>> +		while (p < buf + len)
>> +			sprintf(msg, "%s%02x", msg, (unsigned int)*p++);
>> +	}
>> +
>> +	dev_info(dev, "DUMP: %p[0:%d ... %d:%d]:%s", buf, tlen1 - 1,
>> +		   len-tlen2, len - 1, msg);
>> +}
>> +#endif
>
> either move this to debugfs or stub the function out ifndef DUMP_RX,
> then you don't need the ifdefs when calling it.

Agreed.

>
>> +static inline u8 ssp_cfg_get_mode(u8 ssp_cfg)
>> +{
>> +	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
>
> instead, couldn't you use driver data to pass some flags to the driver ?
> I can't see intel_mid_identify_cpu and having drivers depend on
> arch-specific code is usually a bad practice.

I'll find a way to get rid of this.

>
>> +		return (ssp_cfg) & 0x03;
>> +	else
>
> else isn't needed here

Agreed.

>
>> +static inline u32 is_tx_fifo_empty(struct ssp_drv_context *sspc)
>> +{
>> +	u32 sssr;
>
> blank line here would aid readability
>

Agreed.

>> +	sssr = read_SSSR(sspc->ioaddr);
>> +	if ((sssr & SSSR_TFL_MASK) || (sssr & SSSR_TNF) == 0)
>> +		return 0;
>> +	else
>
> else isn't necessary

Agreed.

>
>> +static inline u32 is_rx_fifo_empty(struct ssp_drv_context *sspc)
>> +{
>> +	return ((read_SSSR(sspc->ioaddr) & SSSR_RNE) == 0);
>
> you don't need the outter parenthesis here, GCC should've warned you,
> even.

Yeah. checkpatch supposed to warn too. I'll fix it.

>
>> +static inline void disable_interface(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line here
>
>> +	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
>> +}
>> +
>> +static inline void disable_triggers(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> and here...
>
>> +	write_SSCR1(read_SSCR1(reg) & ~sspc->cr1_sig, reg);
>> +}
>> +
>> +
>> +static void flush(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>> +	u32 i = 0;
>> +
>> +	/* If the transmit fifo is not empty, reset the interface. */
>> +	if (!is_tx_fifo_empty(sspc)) {
>> +		dev_err(&sspc->pdev->dev, "TX FIFO not empty. Reset of SPI IF");
>> +		disable_interface(sspc);
>> +		return;
>> +	}
>
> not so sure, if the transmit fifo isn't empty and you reset it, you
> could end up corrupting data which is about to be shifted into the wire,
> couldn't you ?
>
> Is this a case which would *really* happen in normal conditions ? If so,
> why ?

I'll leave this question to Ning.

>
>> +	dev_dbg(&sspc->pdev->dev, " SSSR=%x\r\n", read_SSSR(reg));
>> +	while (!is_rx_fifo_empty(sspc) && (i < SPI_FIFO_SIZE + 1)) {
>> +		read_SSDR(reg);
>> +		i++;
>> +	}
>> +	WARN(i > 0, "%d words flush occured\n", i);
>
> similarly, you could be ignoring data you *should* indeed be handling.

That seems the case, yes.

>
>> +
>> +	return;
>
> return statement is unnecessary.

Agreed.

>
>> +static int null_writer(struct ssp_drv_context *sspc)
>
> looks like these two functions (null_\(writer\|reader\)) need some
> documentation. Why do they exist ?

I'll make sure next version has comments for it.

>
>> +static int u8_writer(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
>> +		|| (sspc->tx == sspc->tx_end))
>> +		return 0;
>> +
>> +	write_SSDR(*(u8 *)(sspc->tx), reg);
>> +	++sspc->tx;
>> +
>> +	return 1;
>> +}
>> +
>> +static int u8_reader(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	while ((read_SSSR(reg) & SSSR_RNE)
>> +		&& (sspc->rx < sspc->rx_end)) {
>> +		*(u8 *)(sspc->rx) = read_SSDR(reg);
>> +		++sspc->rx;
>> +	}
>> +
>> +	return sspc->rx == sspc->rx_end;
>> +}
>> +
>> +static int u16_writer(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
>
> the extra comparisson here is superfluous.

Agreed.

>
>> +		|| (sspc->tx == sspc->tx_end))
>> +		return 0;
>> +
>> +	write_SSDR(*(u16 *)(sspc->tx), reg);
>> +	sspc->tx += 2;
>> +
>> +	return 1;
>> +}
>> +
>> +static int u16_reader(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	while ((read_SSSR(reg) & SSSR_RNE) && (sspc->rx < sspc->rx_end)) {
>> +		*(u16 *)(sspc->rx) = read_SSDR(reg);
>> +		sspc->rx += 2;
>> +	}
>> +
>> +	return sspc->rx == sspc->rx_end;
>> +}
>> +
>> +static int u32_writer(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
>
> the extra comparisson here is superfluous.

Agreed.

>
>> +		|| (sspc->tx == sspc->tx_end))
>> +		return 0;
>> +
>> +	write_SSDR(*(u32 *)(sspc->tx), reg);
>> +	sspc->tx += 4;
>> +
>> +	return 1;
>> +}
>> +
>> +static int u32_reader(struct ssp_drv_context *sspc)
>> +{
>> +	void *reg = sspc->ioaddr;
>
> blank line
>
>> +	while ((read_SSSR(reg) & SSSR_RNE) && (sspc->rx < sspc->rx_end)) {
>> +		*(u32 *)(sspc->rx) = read_SSDR(reg);
>> +		sspc->rx += 4;
>> +	}
>> +
>> +	return sspc->rx == sspc->rx_end;
>> +}
>> +
>> +static bool chan_filter(struct dma_chan *chan, void *param)
>> +{
>> +	struct ssp_drv_context *sspc = param;
>> +
>> +	if (sspc->dmac1 && chan->device->dev == &sspc->dmac1->dev)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>> +/**
>> + * unmap_dma_buffers() - Unmap the DMA buffers used during the last transfer.
>> + * @sspc:	Pointer to the private driver context
>> + */
>> +static void unmap_dma_buffers(struct ssp_drv_context *sspc)
>> +{
>> +	struct device *dev = &sspc->pdev->dev;
>> +
>> +	if (!sspc->dma_mapped)
>> +		return;
>
> blank line
>
>> +	dma_unmap_single(dev, sspc->rx_dma, sspc->len, PCI_DMA_FROMDEVICE);
>> +	dma_unmap_single(dev, sspc->tx_dma, sspc->len, PCI_DMA_TODEVICE);
>> +	sspc->dma_mapped = 0;
>
> you shouldn't need this dma_mapped flag here...
>
>> +static void ssp_spi_dma_done(void *arg)
>> +{
>> +	struct callback_param *cb_param = (struct callback_param *)arg;
>> +	struct ssp_drv_context *sspc = cb_param->drv_context;
>> +	struct device *dev = &sspc->pdev->dev;
>> +	void *reg = sspc->ioaddr;
>> +
>> +	if (cb_param->direction == TX_DIRECTION)
>> +		sspc->txdma_done = 1;
>> +	else
>> +		sspc->rxdma_done = 1;
>> +
>> +	dev_dbg(dev, "DMA callback for direction %d [RX done:%d] [TX done:%d]\n",
>> +		cb_param->direction, sspc->rxdma_done,
>> +		sspc->txdma_done);
>> +
>> +	if (sspc->txdma_done && sspc->rxdma_done) {
>> +		/* Clear Status Register */
>> +		write_SSSR(sspc->clear_sr, reg);
>> +		dev_dbg(dev, "DMA done\n");
>> +		/* Disable Triggers to DMA or to CPU*/
>> +		disable_triggers(sspc);
>> +		unmap_dma_buffers(sspc);
>> +
>> +		queue_work(sspc->dma_wq, &sspc->complete_work);
>
> I fail to see the need for this workstruct, why can't you call
> complete() directly ?
>
>> +static irqreturn_t ssp_int(int irq, void *dev_id)
>> +{
>> +	struct ssp_drv_context *sspc = dev_id;
>> +	void *reg = sspc->ioaddr;
>> +	struct device *dev = &sspc->pdev->dev;
>> +	u32 status = read_SSSR(reg);
>> +
>> +	/* It should never be our interrupt since SSP will */
>> +	/* only trigs interrupt for under/over run.        */
>
> wrong comment style

I'll fix it

>
>> +	if (likely(!(status & sspc->mask_sr)))
>> +		return IRQ_NONE;
>> +
>> +	if (status & SSSR_ROR || status & SSSR_TUR) {
>> +		dev_err(dev, "--- SPI ROR or TUR occurred : SSSR=%x\n",	status);
>> +		WARN_ON(1);
>> +		if (status & SSSR_ROR)
>> +			dev_err(dev, "we have Overrun\n");
>> +		if (status & SSSR_TUR)
>> +			dev_err(dev, "we have Underrun\n");
>> +	}
>
> I would split these two caes here:
>
> if (status & ROR)
> 	dev_WARN(dev, "Overrun\n");
>
> if (status & TUR)
> 	dev_WARN(dev, "Underrun\n");
>
> no need for nested ifs.

Agreed.

>
>> +static void poll_transfer(unsigned long data)
>> +{
>> +	struct ssp_drv_context *sspc = (void *)data;
>> +
>> +	if (sspc->tx) {
>> +		while (sspc->tx != sspc->tx_end) {
>> +			if (ssp_timing_wr) {
>> +				int timeout = 100;
>> +				/* It is used as debug UART on Tangier. Since
>> +				   baud rate = 115200, it needs at least 312us
>> +				   for one word transferring. Becuase of silicon
>> +				   issue, it MUST check SFIFOL here instead of
>> +				   TNF. It is the workaround for A0 stepping*/
>
> wrong comment style.

I'll fix it.

>
>> +				while (--timeout &&
>> +					((read_SFIFOL(sspc->ioaddr)) & 0xFFFF))
>> +					udelay(10);
>> +			}
>> +			sspc->write(sspc);
>> +			sspc->read(sspc);
>> +		}
>> +	}
>
> you can make this look sligthly better if you:
>
> if (!sspc->tx)
> 	bail();
>
> while (sspc->tx != sspc->tx_end) {
> 	if (sspc->timing_wr) {
> 		int timeout = 100;
>
> 		....
> 	}
> }
>
> it'll decrease one indentation level.

I'll consider it in next version.

>
>> +static void start_bitbanging(struct ssp_drv_context *sspc)
>
> I would prefix with ssp_

That makes sense.

>
>> +static int handle_message(struct ssp_drv_context *sspc)
>> +{
>> +	struct chip_data *chip = NULL;
>> +	struct spi_transfer *transfer = NULL;
>> +	void *reg = sspc->ioaddr;
>> +	u32 cr1;
>> +	struct device *dev = &sspc->pdev->dev;
>> +	struct spi_message *msg = sspc->cur_msg;
>> +
>> +	chip = spi_get_ctldata(msg->spi);
>> +
>> +	/* We handle only one transfer message since the protocol module has to
>> +	   control the out of band signaling. */
>
> wrong comment style.

I'll fix it.

>
>> +	transfer = list_entry(msg->transfers.next, struct spi_transfer,
>> +					transfer_list);
>> +
>> +	/* Check transfer length */
>> +	if (unlikely((transfer->len > MAX_SPI_TRANSFER_SIZE) ||
>> +		(transfer->len == 0))) {
>> +		dev_warn(dev, "transfer length null or greater than %d\n",
>> +			MAX_SPI_TRANSFER_SIZE);
>> +		dev_warn(dev, "length = %d\n", transfer->len);
>> +		msg->status = -EINVAL;
>> +
>> +		if (msg->complete)
>> +			msg->complete(msg->context);
>> +		complete(&sspc->msg_done);
>> +		return 0;
>> +	}
>> +
>> +	/* Flush any remaining data (in case of failed previous transfer) */
>> +	flush(sspc);
>> +
>> +	sspc->tx  = (void *)transfer->tx_buf;
>> +	sspc->rx  = (void *)transfer->rx_buf;
>> +	sspc->len = transfer->len;
>> +	sspc->write = chip->write;
>> +	sspc->read = chip->read;
>> +
>> +	if (likely(chip->dma_enabled)) {
>> +		sspc->dma_mapped = map_dma_buffers(sspc);
>> +		if (unlikely(!sspc->dma_mapped))
>> +			return 0;
>> +	} else {
>> +		sspc->write = sspc->tx ? chip->write : null_writer;
>> +		sspc->read  = sspc->rx ? chip->read : null_reader;
>> +	}
>> +	sspc->tx_end = sspc->tx + transfer->len;
>> +	sspc->rx_end = sspc->rx + transfer->len;
>> +	write_SSSR(sspc->clear_sr, reg);
>> +
>> +	/* setup the CR1 control register */
>> +	cr1 = chip->cr1 | sspc->cr1_sig;
>> +
>> +	if (likely(sspc->quirks & QUIRKS_DMA_USE_NO_TRAIL)) {
>> +		/* in case of len smaller than burst size, adjust the RX     */
>> +		/* threshold. All other cases will use the default threshold */
>> +		/* value. The RX fifo threshold must be aligned with the DMA */
>> +		/* RX transfer size, which may be limited to a multiple of 4 */
>> +		/* bytes due to 32bits DDR access.                           */
>
> wrong comment style

Ditto

>
>> +static int ssp_spi_probe(struct pci_dev *pdev,
>> +	const struct pci_device_id *ent)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct spi_master *master;
>> +	struct ssp_drv_context *sspc = 0;
>> +	int status;
>> +	u32 iolen = 0;
>> +	u8 ssp_cfg;
>> +	int pos;
>> +	void __iomem *syscfg_ioaddr;
>> +	unsigned long syscfg;
>> +
>> +	/* Check if the SSP we are probed for has been allocated */
>> +	/* to operate as SPI. This information is retreived from */
>> +	/* the field adid of the Vendor-Specific PCI capability  */
>> +	/* which is used as a configuration register.            */
>
> wrong comment style

Ditto

>
>> +static int ssp_spi_runtime_suspend(struct device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int ssp_spi_runtime_resume(struct device *dev)
>> +{
>> +	return 0;
>> +}
>
> why even add these if they're no-ops ?

I'll remove them.

>
>> +static int __init ssp_spi_init(void)
>> +{
>> +	return pci_register_driver(&ssp_spi_driver);
>> +}
>> +
>> +late_initcall(ssp_spi_init);
>
> does it have to be late ? Can't you just use module_pci_driver()
> instead ?

I'll let Ning to answer this.

>
>> @@ -0,0 +1,330 @@
>> +/*
>> + *  Copyright (C) Intel 2013
>> + *
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> + *
>> + *  This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License as published by
>> + *  the Free Software Foundation; either version 2 of the License, or
>> + *  (at your option) any later version.
>
> companies usually don't like this "at your option any later version"
> statement. Usually it's GPL2 only...

Hm. I've no opinion about. :)
But I'll make sure this follows the same standard of .c file.

Br, David

