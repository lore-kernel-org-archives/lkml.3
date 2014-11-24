Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaKXNPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:15:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbaKXNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:15:49 -0500
Message-ID: <54732F83.6070306@suse.de>
Date: Mon, 24 Nov 2014 14:15:47 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
CC: Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] wd719x: Introduce Western Digital WD7193/7197/7296
 PCI SCSI card driver
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org> <1416831074-24282-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1416831074-24282-3-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 01:11 PM, Ondrej Zary wrote:
> Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296 PCI
> SCSI controllers based on WD33C296A chip.
> Tested with WD7193 card.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/Kconfig  |    8 +
>  drivers/scsi/Makefile |    1 +
>  drivers/scsi/wd719x.c | 1008 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/wd719x.h |  249 ++++++++++++
>  4 files changed, 1266 insertions(+)
>  create mode 100644 drivers/scsi/wd719x.c
>  create mode 100644 drivers/scsi/wd719x.h
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 3a820f6..fd81d14 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1451,6 +1451,14 @@ config SCSI_NSP32
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nsp32.
>  
> +config SCSI_WD719X
> +	tristate "Western Digital WD7193/7197/7296 support"
> +	depends on PCI && SCSI
> +	select EEPROM_93CX6
> +	---help---
> +	  This is a driver for Western Digital WD7193, WD7197 and WD7296 PCI
> +	  SCSI controllers (based on WD33C296A chip).
> +
>  config SCSI_DEBUG
>  	tristate "SCSI debugging host simulator"
>  	depends on SCSI
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 59f1ce6..d8bfca5 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -143,6 +143,7 @@ obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
>  obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
>  obj-$(CONFIG_XEN_SCSI_FRONTEND)	+= xen-scsifront.o
>  obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
> +obj-$(CONFIG_SCSI_WD719X)	+= wd719x.o
>  
>  obj-$(CONFIG_ARM)		+= arm/
>  
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> new file mode 100644
> index 0000000..ce6dafd
> --- /dev/null
> +++ b/drivers/scsi/wd719x.c
> @@ -0,0 +1,1008 @@
> +/*
> + * Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
> + * Copyright 2013 Ondrej Zary
> + *
> + * Original driver by
> + * Aaron Dewell <dewell@woods.net>
> + * Gaerti <Juergen.Gaertner@mbox.si.uni-hannover.de>
> + *
> + * HW documentation available in book:
> + *
> + * SPIDER Command Protocol
> + * by Chandru M. Sippy
> + * SCSI Storage Products (MCP)
> + * Western Digital Corporation
> + * 09-15-95
> + *
> + * http://web.archive.org/web/20070717175254/http://sun1.rrzn.uni-hannover.de/gaertner.juergen/wd719x/Linux/Docu/Spider/
> + */
> +
> +/*
> + * Driver workflow:
> + * 1. SCSI command is transformed to SCB (Spider Control Block) by the
> + *    queuecommand function.
> + * 2. The address of the SCB is stored in a list to be able to access it, if
> + *    something goes wrong.
> + * 3. The address of the SCB is written to the Controller, which loads the SCB
> + *    via BM-DMA and processes it.
> + * 4. After it has finished, it generates an interrupt, and sets registers.
> + *
> + * flaws:
> + *  - abort/reset functions
> + *
> + * ToDo:
> + *  - tagged queueing
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/firmware.h>
> +#include <linux/eeprom_93cx6.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +#include "wd719x.h"
> +
> +/* low-level register access */
> +static inline u8 wd719x_readb(struct wd719x *wd, u8 reg)
> +{
> +	return ioread8(wd->base + reg);
> +}
> +
> +static inline u32 wd719x_readl(struct wd719x *wd, u8 reg)
> +{
> +	return ioread32(wd->base + reg);
> +}
> +
> +static inline void wd719x_writeb(struct wd719x *wd, u8 reg, u8 val)
> +{
> +	iowrite8(val, wd->base + reg);
> +}
> +
> +static inline void wd719x_writew(struct wd719x *wd, u8 reg, u16 val)
> +{
> +	iowrite16(val, wd->base + reg);
> +}
> +
> +static inline void wd719x_writel(struct wd719x *wd, u8 reg, u32 val)
> +{
> +	iowrite32(val, wd->base + reg);
> +}
> +
> +/* wait until the command register is ready */
> +static inline int wd719x_wait_ready(struct wd719x *wd)
> +{
> +	int i = 0;
> +
> +	do {
> +		if (wd719x_readb(wd, WD719X_AMR_COMMAND) == WD719X_CMD_READY)
> +			return 0;
> +		udelay(1);
> +	} while (i++ < WD719X_WAIT_FOR_CMD_READY);
> +
> +	dev_err(&wd->pdev->dev, "command register is not ready: 0x%02x\n",
> +		wd719x_readb(wd, WD719X_AMR_COMMAND));
> +
> +	return -ETIMEDOUT;
> +}
> +
> +/* poll interrupt status register until command finishes */
> +static inline int wd719x_wait_done(struct wd719x *wd, int timeout)
> +{
> +	u8 status;
> +
> +	while (timeout > 0) {
> +		status = wd719x_readb(wd, WD719X_AMR_INT_STATUS);
> +		if (status)
> +			break;
> +		timeout--;
> +		udelay(1);
> +	}
> +
> +	if (timeout <= 0) {
> +		dev_err(&wd->pdev->dev, "direct command timed out\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	if (status != WD719X_INT_NOERRORS) {
> +		dev_err(&wd->pdev->dev, "direct command failed, status 0x%02x, SUE 0x%02x\n",
> +			status, wd719x_readb(wd, WD719X_AMR_SCB_ERROR));
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int wd719x_direct_cmd(struct wd719x *wd, u8 opcode, u8 dev, u8 lun,
> +			     u8 tag, dma_addr_t data, int timeout)
> +{
> +	int ret = 0;
> +
> +	/* clear interrupt status register (allow command register to clear) */
> +	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
> +
> +	/* Wait for the Command register to become free */
> +	if (wd719x_wait_ready(wd))
> +		return -ETIMEDOUT;
> +
> +	/* make sure we get NO interrupts */
> +	dev |= WD719X_DISABLE_INT;
> +	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, dev);
> +	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_2, lun);
> +	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_3, tag);
> +	if (data)
> +		wd719x_writel(wd, WD719X_AMR_SCB_IN, data);
> +
> +	/* clear interrupt status register again */
> +	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
> +
> +	/* Now, write the command */
> +	wd719x_writeb(wd, WD719X_AMR_COMMAND, opcode);
> +
> +	if (timeout)	/* wait for the command to complete */
> +		ret = wd719x_wait_done(wd, timeout);
> +
> +	/* clear interrupt status register (clean up) */
> +	if (opcode != WD719X_CMD_READ_FIRMVER)
> +		wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
> +
> +	return ret;
> +}
> +
> +static void wd719x_destroy(struct wd719x *wd)
> +{
> +	struct wd719x_scb *scb;
> +
> +	/* stop the RISC */
> +	if (wd719x_direct_cmd(wd, WD719X_CMD_SLEEP, 0, 0, 0, 0,
> +			      WD719X_WAIT_FOR_RISC))
> +		dev_warn(&wd->pdev->dev, "RISC sleep command failed\n");
> +	/* disable RISC */
> +	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, 0);
> +
> +	/* free all SCBs */
> +	list_for_each_entry(scb, &wd->active_scbs, list)
> +		pci_free_consistent(wd->pdev, sizeof(struct wd719x_scb), scb,
> +				    scb->phys);
> +	list_for_each_entry(scb, &wd->free_scbs, list)
> +		pci_free_consistent(wd->pdev, sizeof(struct wd719x_scb), scb,
> +				    scb->phys);
> +	/* free internal buffers */
> +	pci_free_consistent(wd->pdev, wd->fw_size, wd->fw_virt, wd->fw_phys);
> +	wd->fw_virt = NULL;
> +	pci_free_consistent(wd->pdev, WD719X_HASH_TABLE_SIZE, wd->hash_virt,
> +			    wd->hash_phys);
> +	wd->hash_virt = NULL;
> +	pci_free_consistent(wd->pdev, sizeof(struct wd719x_host_param),
> +			    wd->params, wd->params_phys);
> +	wd->params = NULL;
> +	free_irq(wd->pdev->irq, wd);
> +}
> +
> +/* finish a SCSI command, mark SCB (if any) as free, unmap buffers */
> +static void wd719x_finish_cmd(struct scsi_cmnd *cmd, int result)
> +{
> +	struct wd719x *wd = shost_priv(cmd->device->host);
> +	struct wd719x_scb *scb = (struct wd719x_scb *) cmd->host_scribble;
> +
> +	if (scb) {
> +		list_move(&scb->list, &wd->free_scbs);
> +		dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
> +				 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +		scsi_dma_unmap(cmd);
> +	}
> +	cmd->result = result << 16;
> +	cmd->scsi_done(cmd);
> +}
> +
> +static int wd719x_send_scb(struct wd719x_scb *scb)
> +{
> +	struct wd719x *wd = shost_priv(scb->cmd->device->host);
> +
> +	/* wait for the Command register to become free */
> +	if (wd719x_wait_ready(wd))
> +		return DID_TIME_OUT;
> +
> +	/* first write pointer to the AMR */
> +	wd719x_writel(wd, WD719X_AMR_SCB_IN, scb->phys);
> +	/* send SCB opcode */
> +	wd719x_writeb(wd, WD719X_AMR_COMMAND, WD719X_CMD_PROCESS_SCB);
> +
> +	return DID_OK;
> +}
> +
> +/* Build a SCB and send it to the card using send_scb */
> +static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
> +{
> +	int i, result, count_sg;
> +	unsigned long flags;
> +	struct wd719x_scb *scb;
> +	struct wd719x *wd = shost_priv(sh);
> +	dma_addr_t phys;
> +
> +	cmd->host_scribble = NULL;
> +
> +	/* get a free SCB - either from existing ones or allocate a new one */
> +	spin_lock_irqsave(wd->sh->host_lock, flags);
> +	scb = list_first_entry_or_null(&wd->free_scbs, struct wd719x_scb, list);
> +	if (scb) {
> +		list_del(&scb->list);
> +		phys = scb->phys;
> +	} else {
> +		spin_unlock_irqrestore(wd->sh->host_lock, flags);
> +		scb = pci_alloc_consistent(wd->pdev, sizeof(struct wd719x_scb),
> +					   &phys);
> +		spin_lock_irqsave(wd->sh->host_lock, flags);
> +		if (!scb) {
> +			dev_err(&wd->pdev->dev, "unable to allocate SCB\n");
> +			wd719x_finish_cmd(cmd, DID_ERROR);
> +			spin_unlock_irqrestore(wd->sh->host_lock, flags);
> +			return 0;
> +		}
> +	}
> +	memset(scb, 0, sizeof(struct wd719x_scb));
> +	list_add(&scb->list, &wd->active_scbs);
> +
> +	scb->phys = phys;
> +	scb->cmd = cmd;
> +	cmd->host_scribble = (char *) scb;
> +
> +	scb->CDB_tag = 0;	/* Tagged queueing not supported yet */
> +	scb->devid = cmd->device->id;
> +	scb->lun = cmd->device->lun;
> +
> +	/* copy the command */
> +	memcpy(scb->CDB, cmd->cmnd, cmd->cmd_len);
> +
> +	/* map sense buffer */
> +	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
> +	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
> +			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +	dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
> +			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
> +
> +	/* request autosense */
> +	scb->SCB_options |= WD719X_SCB_FLAGS_AUTO_REQUEST_SENSE;
> +
> +	/* check direction */
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE)
> +		scb->SCB_options |= WD719X_SCB_FLAGS_CHECK_DIRECTION
> +				 |  WD719X_SCB_FLAGS_PCI_TO_SCSI;
> +	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
> +		scb->SCB_options |= WD719X_SCB_FLAGS_CHECK_DIRECTION;
> +
> +	/* Scather/gather */
> +	count_sg = scsi_dma_map(cmd);
> +	if (count_sg < 0) {
> +		wd719x_finish_cmd(cmd, DID_ERROR);
> +		spin_unlock_irqrestore(wd->sh->host_lock, flags);
> +		return 0;
> +	}
> +	BUG_ON(count_sg > WD719X_SG);
> +
> +	if (count_sg) {
> +		struct scatterlist *sg;
> +
> +		scb->data_length = cpu_to_le32(count_sg *
> +					       sizeof(struct wd719x_sglist));
> +		scb->data_p = cpu_to_le32(scb->phys +
> +					  offsetof(struct wd719x_scb, sg_list));
> +
> +		scsi_for_each_sg(cmd, sg, count_sg, i) {
> +			scb->sg_list[i].ptr = cpu_to_le32(sg_dma_address(sg));
> +			scb->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
> +		}
> +		scb->SCB_options |= WD719X_SCB_FLAGS_DO_SCATTER_GATHER;
> +	} else { /* zero length */
> +		scb->data_length = 0;
> +		scb->data_p = 0;
> +	}
> +
> +	result = wd719x_send_scb(scb);
> +	if (result != DID_OK) {
> +		dev_warn(&wd->pdev->dev, "can't queue SCB\n");
> +		wd719x_finish_cmd(cmd, result);
> +	}
> +
> +	spin_unlock_irqrestore(wd->sh->host_lock, flags);
> +
> +	return 0;
> +}
Why did you use 'wait_ready' here?
Any sane HBA driver should set the queue depth parameters
correctly to avoid this from happening.
Wouldn't it be far better to just return HOST_BUSY here if
the command register isn't free and submit the command
directly otherwise?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)
