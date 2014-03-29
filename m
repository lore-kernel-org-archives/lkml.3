Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaC2RG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:06:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41140 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604AbaC2RGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:06:24 -0400
Date: Sat, 29 Mar 2014 14:05:58 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Francois.Bedard@synopsys.com,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        dwmw2@infradead.org, Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH] axs_nand - add driver for NAND controller used on
 Synopsys AXS dev boards
Message-ID: <20140329170558.GA464@arch.cereza>
References: <1394626349-16024-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394626349-16024-1-git-send-email-abrodkin@synopsys.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

I'm Ccing Brian Norris, who's co-maintaining MTD now (although he probably
has this on his queue anyway).

On Mar 12, Alexey Brodkin wrote:
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> 
> Cc: Vineet Gupta <vgupta@synopsys.com>
> ---
>  Documentation/devicetree/bindings/mtd/axs-nand.txt |  17 +
>  drivers/mtd/nand/Kconfig                           |   6 +
>  drivers/mtd/nand/Makefile                          |   1 +
>  drivers/mtd/nand/axs_nand.c                        | 412 +++++++++++++++++++++
>  4 files changed, 436 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/axs-nand.txt
>  create mode 100644 drivers/mtd/nand/axs_nand.c
> 
> diff --git a/Documentation/devicetree/bindings/mtd/axs-nand.txt b/Documentation/devicetree/bindings/mtd/axs-nand.txt
> new file mode 100644
> index 0000000..aab5873
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/axs-nand.txt
> @@ -0,0 +1,17 @@
> +* Synopsys AXS NAND controller
> +
> +Required properties:
> +  - compatible: must be "snps,axs-nand"
> +  - reg: physical base address and size of the registers map
> +
> +The device tree may optionally contain sub-nodes describing partitions of the
> +address space. See partition.txt for more detail.
> +
> +Examples:
> +
> +nand: nand@0x16000 {

It seems it's better to name the node as "flash", as I was recently
advised:

https://www.mail-archive.com/devicetree@vger.kernel.org/msg18763.html

> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	compatible = "snps,axs-nand";
> +	reg = < 0x16000 0x200 >;
> +};
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 93ae6a6..3661822 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -510,4 +510,10 @@ config MTD_NAND_XWAY
>  	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
>  	  to the External Bus Unit (EBU).
>  
> +config MTD_NAND_AXS
> +	tristate "Support for NAND on Synopsys AXS development board"
> +	help
> +	  Enables support for NAND Flash chips on Synopsys AXS development
> +	  boards.
> +
>  endif # MTD_NAND
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index 542b568..635a918 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -49,5 +49,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
>  obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
>  obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
>  obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
> +obj-$(CONFIG_MTD_NAND_AXS)		+= axs_nand.o
>  
>  nand-objs := nand_base.o nand_bbt.o
> diff --git a/drivers/mtd/nand/axs_nand.c b/drivers/mtd/nand/axs_nand.c
> new file mode 100644
> index 0000000..1c87bf0
> --- /dev/null
> +++ b/drivers/mtd/nand/axs_nand.c
> @@ -0,0 +1,412 @@
> +/*
> + * Copyright (C) 2014 Synopsys, Inc. (www.synopsys.com)
> + *
> + * Driver for NAND controller on Synopsys AXS development board.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License v2. See the file COPYING in the main directory of this archive for
> + * more details.
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/io.h>
> +
> +/*
> + * There's an issue with DMA'd data if data buffer is cached.
> + * So to make NAND storage available for now we'll map data buffer in
> + * uncached memory.
> + *
> + * As soon as issue with cached buffer is resolved following define to be
> + * removed as well as sources it enables.
> + */
> +#define DATA_BUFFER_UNCACHED
> +
> +#define BUS_WIDTH	8		/* AXI data bus width in bytes	*/
> +
> +/* DMA buffer descriptor masks */
> +#define BD_STAT_OWN			(1 << 31)
> +#define BD_STAT_BD_FIRST		(1 << 3)
> +#define BD_STAT_BD_LAST			(1 << 2)
> +#define BD_SIZES_BUFFER1_MASK		0xfff
> +
> +#define BD_STAT_BD_COMPLETE	(BD_STAT_BD_FIRST | BD_STAT_BD_LAST)
> +
> +/* Controller command types */
> +#define B_CT_ADDRESS	(0x0 << 16)	/* Address operation		*/
> +#define B_CT_COMMAND	(0x1 << 16)	/* Command operation		*/
> +#define B_CT_WRITE	(0x2 << 16)	/* Write operation		*/

> +#define B_CT_READ	(0x3 << 16)	/* Write operation		*/
> +
^^^
Typo here?

> +/* Controller command options */
> +#define B_WFR		(1 << 19)	/* 1b - Wait for ready		*/
> +#define B_LC		(1 << 18)	/* 1b - Last cycle		*/
> +#define B_IWC		(1 << 13)	/* 1b - Interrupt when complete	*/
> +
> +enum {
> +	NAND_ISR_DATAREQUIRED = 0,
> +	NAND_ISR_TXUNDERFLOW,
> +	NAND_ISR_TXOVERFLOW,
> +	NAND_ISR_DATAAVAILABLE,
> +	NAND_ISR_RXUNDERFLOW,
> +	NAND_ISR_RXOVERFLOW,
> +	NAND_ISR_TXDMACOMPLETE,
> +	NAND_ISR_RXDMACOMPLETE,
> +	NAND_ISR_DESCRIPTORUNAVAILABLE,
> +	NAND_ISR_CMDDONE,
> +	NAND_ISR_CMDAVAILABLE,
> +	NAND_ISR_CMDERROR,
> +	NAND_ISR_DATATRANSFEROVER,
> +	NAND_ISR_NONE
> +};
> +
> +enum {
> +	AC_FIFO = 0,		/* Address and command fifo */
> +	IDMAC_BDADDR = 0x18,	/* IDMAC descriptor list base address */
> +	INT_STATUS = 0x118,	/* Interrupt status register */
> +	INT_CLR_STATUS = 0x120	/* Interrupt clear status register */
> +};
> +
> +#define AXS_BUF_SIZE	(PAGE_ALIGN(NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE))
> +
> +struct asx_nand_bd {
> +	__le32 status;		/* DES0 */
> +	__le32 sizes;		/* DES1 */
> +	dma_addr_t buffer_ptr0;	/* DES2 */
> +	dma_addr_t buffer_ptr1;	/* DES3 */
> +};
> +
> +struct axs_nand_host {
> +	struct nand_chip	nand_chip;
> +	struct mtd_info		mtd;
> +	void __iomem		*io_base;
> +	struct device		*dev;
> +	struct asx_nand_bd	*bd;	/* Buffer descriptor */
> +	dma_addr_t		bd_dma;	/* DMA handle for buffer descriptor */
> +	uint8_t			*db;	/* Data buffer */
> +	dma_addr_t		db_dma;	/* DMA handle for data buffer */
> +};
> +
> +/**
> + * reg_set - Sets register with provided value.
> + * @host:	Pointer to private data structure.
> + * @reg:	Register offset from base address.
> + * @value:	Value to set in register.
> + */
> +static inline void reg_set(struct axs_nand_host *host, int reg, int value)
> +{
> +	iowrite32(value, host->io_base + reg);
> +}
> +
> +/**
> + * reg_get - Gets value of specified register.
> + * @priv:	Pointer to private data structure.
> + * @reg:	Register offset from base address.
> + *
> + * returns:	Value of requested register.
> + */
> +static inline unsigned int reg_get(struct axs_nand_host *host, int reg)
> +{
> +	return ioread32(host->io_base + reg);
> +}
> +
> +/**
> + * xplorer_nand_write_buf - write buffer to chip
> + * @mtd:	MTD device structure
> + * @buf:	Data buffer
> + * @len:	Number of bytes to write
> + *
> + * returns:	1 if requested flag is set, otherwise 0

Hm.. this documentation seems wrong.

> + */
> +static unsigned int axs_flag_is_set(struct axs_nand_host *host, int flag)
> +{
> +	unsigned int reg = reg_get(host, INT_STATUS);
> +
> +	if (reg & (1 << flag)) {
> +		reg_set(host, INT_CLR_STATUS, 1 << flag);

Hm... so you clear the flag as well? How about chosing a different name
for the function (axs_flag_clear_set() or something)?

> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * axs_nand_write_buf - write buffer to chip
> + * @mtd:	MTD device structure
> + * @buf:	Data buffer
> + * @len:	Number of bytes to write
> + */
> +static void axs_nand_write_buf(struct mtd_info *mtd,
> +		const uint8_t *buf, int len)
> +{
> +	struct nand_chip *this = mtd->priv;
> +	struct axs_nand_host *host = this->priv;
> +
> +	memcpy(host->db, buf, len);
> +#ifndef DATA_BUFFER_UNCACHED
> +	dma_sync_single_for_device(host->dev, host->db_dma, len, DMA_TO_DEVICE);
> +#endif
> +
> +	/* Setup buffer descriptor */
> +	host->bd->status = BD_STAT_OWN | BD_STAT_BD_COMPLETE;
> +	host->bd->sizes = cpu_to_le32(ALIGN(len, BUS_WIDTH) &
> +				      BD_SIZES_BUFFER1_MASK);
> +	host->bd->buffer_ptr0 = cpu_to_le32(host->db_dma);
> +	host->bd->buffer_ptr1 = 0;
> +
> +	/* Issue "write" command */
> +	reg_set(host, AC_FIFO, B_CT_WRITE | B_WFR | B_IWC | B_LC | (len - 1));
> +
> +	/* Wait for NAND command and DMA to complete */
> +	while (!axs_flag_is_set(host, NAND_ISR_CMDDONE))
> +		;
> +	while (!axs_flag_is_set(host, NAND_ISR_TXDMACOMPLETE))
> +		;

Just a suggestion: isn't a bit dangerous to have these endless loops?
I'd rather add some timeout to bail and print some error, but I'm sure
you know better.

> +}
> +
> +/**
> + * axs_nand_read_buf -  read chip data into buffer
> + * @mtd:	MTD device structure
> + * @buf:	Buffer to store data
> + * @len:	Number of bytes to read
> + */
> +static void axs_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> +{
> +	struct nand_chip *this = mtd->priv;
> +	struct axs_nand_host *host = this->priv;
> +
> +	/* Setup buffer descriptor */
> +	host->bd->status = BD_STAT_OWN | BD_STAT_BD_COMPLETE;
> +	host->bd->sizes = cpu_to_le32(ALIGN(len, BUS_WIDTH) &
> +				      BD_SIZES_BUFFER1_MASK);
> +	host->bd->buffer_ptr0 = cpu_to_le32(host->db_dma);
> +	host->bd->buffer_ptr1 = 0;
> +
> +	/* Issue "read" command */
> +	reg_set(host, AC_FIFO, B_CT_READ | B_WFR | B_IWC | B_LC | (len - 1));
> +
> +	/* Wait for NAND command and DMA to complete */
> +	while (!axs_flag_is_set(host, NAND_ISR_CMDDONE))
> +		;
> +	while (!axs_flag_is_set(host, NAND_ISR_RXDMACOMPLETE))
> +		;

Ditto.

> +
> +#ifndef DATA_BUFFER_UNCACHED
> +	dma_sync_single_for_cpu(host->dev, host->db_dma, len, DMA_FROM_DEVICE);
> +#endif
> +	if (buf != host->db)
> +		memcpy(buf, host->db, len);
> +}
> +
> +/**
> + * axs_nand_read_byte - read one byte from the chip
> + * @mtd:	MTD device structure
> + *
> + * returns:	read data byte
> + */
> +static uint8_t axs_nand_read_byte(struct mtd_info *mtd)
> +{
> +	struct nand_chip *this = mtd->priv;
> +	struct axs_nand_host *host = this->priv;
> +
> +	axs_nand_read_buf(mtd, host->db, sizeof(uint8_t));
> +	return (uint8_t)host->db[0];
> +}
> +
> +/**
> + * axs_nand_read_word - read one word from the chip
> + * @mtd:	MTD device structure
> + *
> + * returns:	read data word
> + */
> +static uint16_t axs_nand_read_word(struct mtd_info *mtd)
> +{
> +	struct nand_chip *this = mtd->priv;
> +	struct axs_nand_host *host = this->priv;
> +
> +	axs_nand_read_buf(mtd, host->db, sizeof(uint16_t));
> +	return (uint16_t)host->db[0];
> +}
> +
> +/**
> + * Hardware specific access to control-lines
> + * @mtd:	MTD device structure
> + * @cmd:	NAND command
> + * @ctrl:	NAND control options
> + */
> +static void axs_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
> +		unsigned int ctrl)
> +{
> +	struct nand_chip *nand_chip = mtd->priv;
> +	struct axs_nand_host *host = nand_chip->priv;
> +
> +	if (cmd == NAND_CMD_NONE)
> +		return;
> +
> +	cmd = cmd & 0xff;
> +
> +	switch (ctrl & (NAND_ALE | NAND_CLE)) {
> +	/* Address */
> +	case NAND_ALE:
> +		cmd |= B_CT_ADDRESS;
> +		break;
> +
> +	/* Command */
> +	case NAND_CLE:
> +		cmd |= B_CT_COMMAND | B_WFR;
> +
> +		break;
> +
> +	default:
> +		dev_err(host->dev, "Unknown ctrl %#x\n", ctrl);
> +		BUG_ON(1);

Hm... do you really need to call BUG(). I suggest that you read the
big warning about this in include/asm-generic/bug.h.

> +	}
> +
> +	reg_set(host, AC_FIFO, cmd | B_LC);
> +	while (!axs_flag_is_set(host, NAND_ISR_CMDDONE))
> +		;

Another endless loops...

> +}
> +
> +static int axs_nand_probe(struct platform_device *pdev)
> +{
> +	struct mtd_part_parser_data ppdata;
> +	struct nand_chip *nand_chip;
> +	struct axs_nand_host *host;
> +	struct resource res_regs;
> +	struct mtd_info *mtd;
> +	int err;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	/* Get registers base address from device tree */
> +	err = of_address_to_resource(pdev->dev.of_node, 0, &res_regs);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to retrieve registers base from device tree\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Allocate memory for the device structure (and zero it) */
> +	host = kzalloc(sizeof(struct axs_nand_host), GFP_KERNEL);
> +	if (!host) {
> +		dev_err(&pdev->dev, "Failed to allocate device structure.\n");

You don't need to print an OOM message.

> +		return -ENOMEM;
> +	}
> +
> +	host->io_base = devm_ioremap_resource(&pdev->dev, &res_regs);
> +	if (IS_ERR(host->io_base)) {
> +		err = PTR_ERR(host->io_base);
> +		goto out;
> +	}
> +	dev_dbg(&pdev->dev, "Registers base address is 0x%p\n", host->io_base);
> +
> +	host->bd = dmam_alloc_coherent(&pdev->dev, sizeof(struct asx_nand_bd),
> +				       &host->bd_dma, GFP_KERNEL);

Managed DMA alloc? Nice, I just learned something new! :-)

> +	if (!host->bd) {
> +		dev_err(&pdev->dev, "Failed to allocate buffer descriptor\n");
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	memset(host->bd, 0, sizeof(struct asx_nand_bd));
> +
> +#ifdef DATA_BUFFER_UNCACHED
> +	host->db = dmam_alloc_coherent(&pdev->dev, AXS_BUF_SIZE,
> +#else
> +	host->db = dmam_alloc_noncoherent(&pdev->dev, AXS_BUF_SIZE,
> +#endif
> +				       &host->db_dma, GFP_KERNEL);
> +	if (!host->db) {
> +		dev_err(&pdev->dev, "Failed to allocate data buffer\n");
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	dev_dbg(&pdev->dev, "Data buffer mapped @ %p, DMA @ %x\n", host->db,
> +		host->db_dma);
> +
> +	mtd = &host->mtd;
> +	nand_chip = &host->nand_chip;
> +	host->dev = &pdev->dev;
> +
> +	nand_chip->priv = host;
> +	mtd->priv = nand_chip;
> +	mtd->name = "axs_nand";
> +	mtd->owner = THIS_MODULE;
> +	mtd->dev.parent = &pdev->dev;
> +	ppdata.of_node = pdev->dev.of_node;
> +
> +	nand_chip->cmd_ctrl = axs_nand_cmd_ctrl;
> +	nand_chip->read_byte = axs_nand_read_byte;
> +	nand_chip->read_word = axs_nand_read_word;
> +	nand_chip->write_buf = axs_nand_write_buf;
> +	nand_chip->read_buf = axs_nand_read_buf;
> +	nand_chip->ecc.mode = NAND_ECC_SOFT;
> +
> +	dev_set_drvdata(&pdev->dev, host);
> +
> +	reg_set(host, IDMAC_BDADDR, host->bd_dma);
> +
> +	if (nand_scan_ident(mtd, 1, NULL)) {
> +		err = -ENXIO;
> +		goto out1;
> +	}
> +
> +	if (nand_scan_tail(mtd)) {
> +		err = -ENXIO;
> +		goto out1;
> +	}
> +

I guess you can replace the nand_scan_ident() + nand_scan_tail(), with
nand_scan(). Or maybe you have a reason for this?

> +	err = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
> +	if (!err)
> +		return err;
> +
> +	nand_release(mtd);
> +
> +out1:
> +	dev_set_drvdata(&pdev->dev, NULL);
> +out:
> +	kfree(host);
> +	return err;
> +}
> +
> +static int axs_nand_remove(struct platform_device *ofdev)
> +{
> +	struct axs_nand_host *host = dev_get_drvdata(&ofdev->dev);
> +	struct mtd_info *mtd = &host->mtd;
> +
> +	nand_release(mtd);
> +	dev_set_drvdata(&ofdev->dev, NULL);
> +	iounmap(host->io_base);

This unmap is not needed, since you're using managed (devm) ioremap.

> +	kfree(host);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id axs_nand_dt_ids[] = {
> +	{ .compatible = "snps,axs-nand", },
> +	{ /* Sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, axs_nand_match);
> +
> +static struct platform_driver axs_nand_driver = {
> +	.probe		= axs_nand_probe,
> +	.remove		= axs_nand_remove,
> +	.driver = {
> +		.name = "asx-nand",
> +		.owner = THIS_MODULE,
> +		.of_match_table = axs_nand_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(axs_nand_driver);
> +
> +MODULE_AUTHOR("Alexey Brodkin <abrodkin@synopsys.com>");
> +MODULE_DESCRIPTION("NAND driver for Synopsys AXS development board");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.5.3
> 

If you fix all this you can add my:

Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
