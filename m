Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbbAUAyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:54:11 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46707 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbAUAyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1421419702-17812-3-git-send-email-architt@codeaurora.org>
References: <1421419702-17812-1-git-send-email-architt@codeaurora.org>
	<1421419702-17812-3-git-send-email-architt@codeaurora.org>
Date: Tue, 20 Jan 2015 16:54:05 -0800
Message-ID: <CAAK6Zt0xAY=kD68y1vQP1-AoEHdmyjuzsMTCSQyykPnuwbZLJA@mail.gmail.com>
Subject: Re: [PATCH 2/5] mtd: nand: Add qcom nand controller driver
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Archit Taneja <architt@codeaurora.org>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, galak@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 6:48 AM, Archit Taneja <architt@codeaurora.org> wrote:
> +/*
> + * the bad block marker is readable only when we read the page with ECC
> + * disabled. all the read/write commands like NAND_CMD_READOOB, NAND_CMD_READ0
> + * and NAND_CMD_PAGEPROG are executed in the driver with ECC enabled. therefore,
> + * the default nand helper functions to detect a bad block or mark a bad block
> + * can't be used.
> + */
> +static int qcom_nandc_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
> +{
> +       int page, r, mark, bad = 0;
> +       struct nand_chip *chip = mtd->priv;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       struct qcom_nandc_data *this = chip->priv;
> +       u32 flash_status;
> +
> +       pre_command(this, NAND_CMD_NONE);
> +
> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
> +
> +       /*
> +        * configure registers for a raw page read, the address is set to the
> +        * beginning of the last codeword
> +        */
> +       this->use_ecc = false;
> +       set_address(this, this->cw_size * (cwperpage - 1), page);
> +
> +       /* we just read one codeword that contains the bad block marker */
> +       update_rw_regs(this, 1, true);
> +
> +       read_cw(this, this->cw_size, 0);
> +
> +       r = submit_descs(this);
> +       if (r) {
> +               dev_err(this->dev, "error submitting descs\n");
> +               goto err;
> +       }
> +
> +       flash_status = this->reg_read_buf[0];
> +
> +       /*
> +        * unable to read the marker successfully, is that sufficient to report
> +        * the block as bad?
> +        */
> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR)) {
> +               dev_warn(this->dev, "error while reading bad block mark\n");
> +               goto err;
> +       }
> +
> +       mark = mtd->writesize - (this->cw_size * (cwperpage - 1));
> +
> +       if (chip->options & NAND_BUSWIDTH_16)
> +               bad = this->data_buffer[mark] != 0xff ||
> +                       this->data_buffer[mark + 1] != 0xff;
> +
> +       bad = this->data_buffer[mark] != 0xff;
> +err:
> +       free_descs(this);
> +
> +       return bad;
> +}
> +
> +static int qcom_nandc_block_markbad(struct mtd_info *mtd, loff_t ofs)
> +{
> +       int page, r;
> +       struct nand_chip *chip = mtd->priv;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       struct qcom_nandc_data *this = chip->priv;
> +       u32 flash_status;
> +
> +       pre_command(this, NAND_CMD_NONE);
> +
> +       /* fill our internal buffer's oob area with 0's */
> +       memset(this->data_buffer, 0x00, mtd->writesize + mtd->oobsize);
> +
> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
> +
> +       this->use_ecc = false;
> +       set_address(this, this->cw_size * (cwperpage - 1), page);
> +
> +       /* we just write to one codeword that contains the bad block marker*/
> +       update_rw_regs(this, 1, false);
> +
> +       /*
> +        * overwrite the last codeword with 0s, this will result in setting
> +        * the bad block marker to 0 too
> +        */
> +       write_cw(this, this->cw_size, 0);
> +
> +       r = submit_descs(this);
> +       if (r) {
> +               dev_err(this->dev, "error submitting descs\n");
> +               r = -EIO;
> +               goto err;
> +       }
> +
> +       flash_status = this->reg_read_buf[0];
> +
> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR))
> +               r = -EIO;
> +
> +err:
> +       free_descs(this);
> +
> +       return r;
> +}

Looks like this code marks block bad and reads bad block information
based on information in the OOB area. And in qcom_nandc_init,
NAND_SKIP_BBTSCAN is set, meaning that this is the code used in
practice on the chip in the mtd_block_isbad path. Can this driver be
used with an on-flash OOB table by editing the init function's chip
flags, or would it need more significant changes to allow that?

Thanks,
Dan

On Fri, Jan 16, 2015 at 6:48 AM, Archit Taneja <architt@codeaurora.org> wrote:
> The Qualcomm NAND controller is found in SoCs like IPQ806x, MSM7xx, MDM9x15
> series.
>
> It exists as a sub block inside the IPs EBI2 (External Bus Interface 2) and
> QPIC (Qualcomm Parallel Interface Controller). These IPs provide a broader
> interface for external slow peripheral devices such as LCD and NAND/NOR flash
> memory or SRAM like interfaces.
>
> We add support for the NAND controller found within EBI2. For the SoCs of our
> interest, we only use the NAND controller within EBI2. Therefore, it's safe for
> us to assume that the NAND controller is a standalone block within the SoC.
>
> The controller supports 512B, 2kB, 4kB and 8kB page 8-bit and 16-bit NAND flash
> devices. It contains a HW ECC block that supports BCH ECC (4, 8 and 16 bit
> correction/step) and RS ECC(4 bit correction/step) that covers main and spare
> data. The controller contains an internal 512 byte page buffer to which we
> read/write via DMA. The EBI2 type NAND controller uses ADM DMA for register
> read/write and data transfers. The controller performs page reads and writes at
> a codeword/step level of 512 bytes. It can support up to 2 external chips of
> different configurations.
>
> The driver prepares register read and write configuraton descriptors for each
> codeword, followed by data descriptors to read or write data from the
> controller's internal buffer. It uses a single ADM DMA channel that we get via
> dmaengine API. The controller requires 2 ADM CRCIs for command and data flow
> control. These are passed via DT.
>
> Signed-off-by: Archit Taneja <architt@codeaurora.org>
> ---
>  drivers/mtd/nand/Kconfig      |    7 +
>  drivers/mtd/nand/Makefile     |    1 +
>  drivers/mtd/nand/qcom_nandc.c | 1995 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 2003 insertions(+)
>  create mode 100644 drivers/mtd/nand/qcom_nandc.c
>
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 7d0150d..03ad13d 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -524,4 +524,11 @@ config MTD_NAND_SUNXI
>         help
>           Enables support for NAND Flash chips on Allwinner SoCs.
>
> +config MTD_NAND_QCOM
> +       tristate "Support for NAND on QCOM SoCs"
> +       depends on ARCH_QCOM && QCOM_ADM
> +       help
> +         Enables support for NAND flash chips on SoCs containing the EBI2 NAND
> +         controller. This controller is found on IPQ806x SoC.
> +
>  endif # MTD_NAND
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index bd38f21..bdf82a9 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -51,5 +51,6 @@ obj-$(CONFIG_MTD_NAND_GPMI_NAND)      += gpmi-nand/
>  obj-$(CONFIG_MTD_NAND_XWAY)            += xway_nand.o
>  obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)   += bcm47xxnflash/
>  obj-$(CONFIG_MTD_NAND_SUNXI)           += sunxi_nand.o
> +obj-$(CONFIG_MTD_NAND_QCOM)            += qcom_nandc.o
>
>  nand-objs := nand_base.o nand_bbt.o nand_timings.o
> diff --git a/drivers/mtd/nand/qcom_nandc.c b/drivers/mtd/nand/qcom_nandc.c
> new file mode 100644
> index 0000000..18b4280
> --- /dev/null
> +++ b/drivers/mtd/nand/qcom_nandc.c
> @@ -0,0 +1,1995 @@
> +/*
> + * Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/bitops.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +#include <linux/module.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_mtd.h>
> +#include <linux/delay.h>
> +
> +/* NANDc reg offsets */
> +#define NAND_FLASH_CMD                 0x00
> +#define NAND_ADDR0                     0x04
> +#define NAND_ADDR1                     0x08
> +#define NAND_FLASH_CHIP_SELECT         0x0c
> +#define NAND_EXEC_CMD                  0x10
> +#define NAND_FLASH_STATUS              0x14
> +#define NAND_BUFFER_STATUS             0x18
> +#define NAND_DEV0_CFG0                 0x20
> +#define NAND_DEV0_CFG1                 0x24
> +#define NAND_DEV0_ECC_CFG              0x28
> +#define NAND_DEV1_ECC_CFG              0x2c
> +#define NAND_DEV1_CFG0                 0x30
> +#define NAND_DEV1_CFG1                 0x34
> +#define NAND_READ_ID                   0x40
> +#define NAND_READ_STATUS               0x44
> +#define NAND_DEV_CMD0                  0xa0
> +#define NAND_DEV_CMD1                  0xa4
> +#define NAND_DEV_CMD2                  0xa8
> +#define NAND_DEV_CMD_VLD               0xac
> +#define SFLASHC_BURST_CFG              0xe0
> +#define NAND_ERASED_CW_DETECT_CFG      0xe8
> +#define NAND_ERASED_CW_DETECT_STATUS   0xec
> +#define NAND_EBI2_ECC_BUF_CFG          0xf0
> +#define FLASH_BUF_ACC                  0x100
> +
> +#define NAND_CTRL                      0xf00
> +#define NAND_VERSION                   0xf08
> +#define NAND_READ_LOCATION_0           0xf20
> +#define NAND_READ_LOCATION_1           0xf24
> +
> +/* NAND_FLASH_CMD bits */
> +#define PAGE_ACC                       BIT(4)
> +#define LAST_PAGE                      BIT(5)
> +
> +/* NAND_FLASH_CHIP_SELECT bits */
> +#define NAND_DEV_SEL                   0
> +#define DM_EN                          BIT(2)
> +
> +/* NAND_FLASH_STATUS bits */
> +#define FS_OP_ERR                      BIT(4)
> +#define FS_READY_BSY_N                 BIT(5)
> +#define FS_MPU_ERR                     BIT(8)
> +#define FS_DEVICE_STS_ERR              BIT(16)
> +#define FS_DEVICE_WP                   BIT(23)
> +
> +/* NAND_BUFFER_STATUS bits */
> +#define BS_UNCORRECTABLE_BIT           BIT(8)
> +#define BS_CORRECTABLE_ERR_MSK         0x1f
> +
> +/* NAND_DEVn_CFG0 bits */
> +#define DISABLE_STATUS_AFTER_WRITE     4
> +#define CW_PER_PAGE                    6
> +#define UD_SIZE_BYTES                  9
> +#define ECC_PARITY_SIZE_BYTES_RS       19
> +#define SPARE_SIZE_BYTES               23
> +#define NUM_ADDR_CYCLES                        27
> +#define STATUS_BFR_READ                        30
> +#define SET_RD_MODE_AFTER_STATUS       31
> +
> +/* NAND_DEVn_CFG0 bits */
> +#define DEV0_CFG1_ECC_DISABLE          0
> +#define WIDE_FLASH                     1
> +#define NAND_RECOVERY_CYCLES           2
> +#define CS_ACTIVE_BSY                  5
> +#define BAD_BLOCK_BYTE_NUM             6
> +#define BAD_BLOCK_IN_SPARE_AREA                16
> +#define WR_RD_BSY_GAP                  17
> +#define ENABLE_BCH_ECC                 27
> +
> +/* NAND_DEV0_ECC_CFG bits */
> +#define ECC_CFG_ECC_DISABLE            0
> +#define ECC_SW_RESET                   1
> +#define ECC_MODE                       4
> +#define ECC_PARITY_SIZE_BYTES_BCH      8
> +#define ECC_NUM_DATA_BYTES             16
> +#define ECC_FORCE_CLK_OPEN             30
> +
> +/* NAND_DEV_CMD1 bits */
> +#define READ_ADDR                      0
> +
> +/* NAND_DEV_CMD_VLD bits */
> +#define READ_START_VLD                 0
> +
> +/* NAND_EBI2_ECC_BUF_CFG bits */
> +#define NUM_STEPS                      0
> +
> +/* NAND_ERASED_CW_DETECT_CFG bits */
> +#define ERASED_CW_ECC_MASK             1
> +#define AUTO_DETECT_RES                        0
> +#define MASK_ECC                       (1 << ERASED_CW_ECC_MASK)
> +#define RESET_ERASED_DET               (1 << AUTO_DETECT_RES)
> +#define ACTIVE_ERASED_DET              (0 << AUTO_DETECT_RES)
> +#define CLR_ERASED_PAGE_DET            (RESET_ERASED_DET | MASK_ECC)
> +#define SET_ERASED_PAGE_DET            (ACTIVE_ERASED_DET | MASK_ECC)
> +
> +/* NAND_ERASED_CW_DETECT_STATUS bits */
> +#define PAGE_ALL_ERASED                        BIT(7)
> +#define CODEWORD_ALL_ERASED            BIT(6)
> +#define PAGE_ERASED                    BIT(5)
> +#define CODEWORD_ERASED                        BIT(4)
> +#define ERASED_PAGE                    (PAGE_ALL_ERASED | PAGE_ERASED)
> +#define ERASED_CW                      (CODEWORD_ALL_ERASED | CODEWORD_ERASED)
> +
> +/* Version Mask */
> +#define NAND_VERSION_MAJOR_MASK                0xf0000000
> +#define NAND_VERSION_MAJOR_SHIFT       28
> +#define NAND_VERSION_MINOR_MASK                0x0fff0000
> +#define NAND_VERSION_MINOR_SHIFT       16
> +
> +/* NAND OP_CMDs */
> +#define PAGE_READ                      0x2
> +#define PAGE_READ_WITH_ECC             0x3
> +#define PAGE_READ_WITH_ECC_SPARE       0x4
> +#define PROGRAM_PAGE                   0x6
> +#define PAGE_PROGRAM_WITH_ECC          0x7
> +#define PROGRAM_PAGE_SPARE             0x9
> +#define BLOCK_ERASE                    0xa
> +#define FETCH_ID                       0xb
> +#define RESET_DEVICE                   0xd
> +
> +/*
> + * the NAND controller performs reads/writes with ECC in 512 byte chunks.
> + * the driver calls the chunks 'step' or 'codeword' interchangeably
> + */
> +#define NANDC_STEP_SIZE                        512
> +
> +/*
> + * the largest page size we support is 8K, this will have 16 steps/codewords
> + * of 512 bytes each
> + */
> +#define        MAX_NUM_STEPS                   (SZ_8K / NANDC_STEP_SIZE)
> +
> +/* we read at most 3 registers per codeword scan */
> +#define MAX_REG_RD                     (3 * MAX_NUM_STEPS)
> +
> +/* ECC modes */
> +#define ECC_NONE       BIT(0)
> +#define ECC_RS_4BIT    BIT(1)
> +#define        ECC_BCH_4BIT    BIT(2)
> +#define        ECC_BCH_8BIT    BIT(3)
> +
> +struct desc_info {
> +       struct list_head list;
> +
> +       enum dma_transfer_direction dir;
> +       struct scatterlist sgl;
> +       struct dma_async_tx_descriptor *dma_desc;
> +
> +       bool mapped;
> +};
> +
> +/*
> + * holds the current register values that we want to write. acts as a contiguous
> + * chunk of memory which we use to write the controller registers through DMA.
> + */
> +struct nandc_regs {
> +       u32 cmd;
> +       u32 addr0;
> +       u32 addr1;
> +       u32 chip_sel;
> +       u32 exec;
> +
> +       u32 cfg0;
> +       u32 cfg1;
> +       u32 ecc_bch_cfg;
> +
> +       u32 clrflashstatus;
> +       u32 clrreadstatus;
> +
> +       u32 cmd1;
> +       u32 vld;
> +
> +       u32 orig_cmd1;
> +       u32 orig_vld;
> +
> +       u32 ecc_buf_cfg;
> +};
> +
> +/*
> + * @data_buffer:               DMA buffer for page read/writes
> + * @buf_size/count/start:      markers for chip->read_buf/write_buf functions
> + * @data_pos/oob_pos:          DMA address offset markers for data/oob within
> + *                             the data_buffer
> + * @reg_read_buf:              buffer for reading register data via DMA
> + * @reg_read_pos:              marker for data read in reg_read_buf
> + * @cfg0, cfg1, cfg0_raw..:    NANDc register configurations needed for
> + *                             ecc/non-ecc mode for the current nand flash
> + *                             device
> + * @regs:                      a contiguous chunk of memory for DMA register
> + *                             writes
> + * @list:                      DMA descriptor list
> + * @ecc_strength:              4 bit or 8 bit ecc, received via DT
> + * @bus_width:                 8 bit or 16 bit NAND bus width, received via DT
> + * @cmd_crci:                  ADM DMA CRCI for command flow control
> + * @data_crci:                 ADM DMA CRCI for data flow control
> + * @ecc_modes:                 supported ECC modes by the current controller,
> + *                             initialized via DT match data
> + * @cw_size:                   the number of bytes in a single step/codeword
> + *                             of a page, consisting of all data, ecc, spare
> + *                             and reserved bytes
> + * @cw_data:                   the number of bytes within a codeword protected
> + *                             by ECC
> + * @bch_enabled:               flag to tell whether BCH or RS ECC mode is used
> + * @page:                      current page in use by the controller
> + * @erased_page:               tracker to tell if last page was erased or not
> + * @status:                    value to be returned if NAND_CMD_STATUS command
> + *                             is executed
> + * @dma_done:                  completion param to denote end of last
> + *                             descriptor in the list
> + */
> +struct qcom_nandc_data {
> +       struct platform_device *pdev;
> +       struct device *dev;
> +
> +       void __iomem *base;
> +       struct resource *res;
> +
> +       struct clk *core_clk;
> +       struct clk *aon_clk;
> +
> +       struct dma_chan *chan;
> +       struct dma_slave_config slave_conf;
> +
> +       struct nand_chip chip;
> +       struct mtd_info mtd;
> +
> +       u8              *data_buffer;
> +       dma_addr_t      data_buffer_paddr;
> +       int             buf_size;
> +       int             buf_count;
> +       int             buf_start;
> +       int             data_pos;
> +       int             oob_pos;
> +
> +       u32 *reg_read_buf;
> +       dma_addr_t reg_read_paddr;
> +       int reg_read_pos;
> +
> +       u32 cfg0, cfg1;
> +       u32 cfg0_raw, cfg1_raw;
> +       u32 ecc_buf_cfg;
> +       u32 ecc_bch_cfg;
> +       u32 clrflashstatus;
> +       u32 clrreadstatus;
> +       u32 sflashc_burst_cfg;
> +       u32 cmd1, vld;
> +
> +       struct nandc_regs *regs;
> +
> +       struct list_head list;
> +
> +       int ecc_strength;
> +       int bus_width;
> +       unsigned int cmd_crci;
> +       unsigned int data_crci;
> +
> +       u32 ecc_modes;
> +
> +       int cw_size;
> +       int cw_data;
> +       bool use_ecc;
> +       bool bch_enabled;
> +       int page;
> +       bool erased_page;
> +       u8 status;
> +       int last_command;
> +       struct completion dma_done;
> +};
> +
> +static inline unsigned int nandc_read(struct qcom_nandc_data *this, int offset)
> +{
> +       return ioread32(this->base + offset);
> +}
> +
> +static inline void nandc_write(struct qcom_nandc_data *this, int offset,
> +               unsigned int val)
> +{
> +       iowrite32(val, this->base + offset);
> +}
> +
> +static void set_address(struct qcom_nandc_data *this, u16 column, int page)
> +{
> +       struct nand_chip *chip = &this->chip;
> +       struct nandc_regs *regs = this->regs;
> +
> +       if (chip->options & NAND_BUSWIDTH_16)
> +               column >>= 1;
> +
> +       regs->addr0 = page << 16 | column;
> +       regs->addr1 = page >> 16 & 0xff;
> +}
> +
> +static void update_rw_regs(struct qcom_nandc_data *this, int num_cw, bool read)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       if (this->use_ecc) {
> +               if (read)
> +                       regs->cmd = PAGE_READ_WITH_ECC | PAGE_ACC | LAST_PAGE;
> +               else
> +                       regs->cmd = PROGRAM_PAGE | PAGE_ACC | LAST_PAGE;
> +
> +               regs->cfg0 = (this->cfg0 & ~(7U << CW_PER_PAGE)) |
> +                               (num_cw - 1) << CW_PER_PAGE;
> +
> +               regs->cfg1 = this->cfg1;
> +               regs->ecc_bch_cfg = this->ecc_bch_cfg;
> +       } else {
> +               if (read)
> +                       regs->cmd = PAGE_READ | PAGE_ACC | LAST_PAGE;
> +               else
> +                       regs->cmd = PROGRAM_PAGE | PAGE_ACC | LAST_PAGE;
> +
> +               regs->cfg0 = (this->cfg0_raw & ~(7U << CW_PER_PAGE)) |
> +                               (num_cw - 1) << CW_PER_PAGE;
> +
> +               regs->cfg1 = this->cfg1_raw;
> +               regs->ecc_bch_cfg = 1 << ECC_CFG_ECC_DISABLE;
> +       }
> +
> +       regs->ecc_buf_cfg = this->ecc_buf_cfg;
> +       regs->clrflashstatus = this->clrflashstatus;
> +       regs->clrreadstatus = this->clrreadstatus;
> +       regs->exec = 1;
> +}
> +
> +/*
> + * write_reg_dma:      prepares a descriptor to write a given number of
> + *                     contiguous registers
> + *
> + * @first:             offset of the first register in the contiguous block
> + * @reg:               starting address containing the reg values to write
> + * @num_regs:          number of registers to write
> + * @flow_control:      flow control enabled/disabled
> + */
> +static int write_reg_dma(struct qcom_nandc_data *this, int first,
> +               u32 *reg, int num_regs, bool flow_control)
> +{
> +       struct desc_info *desc;
> +       struct dma_async_tx_descriptor *dma_desc;
> +       struct scatterlist *sgl;
> +       int size;
> +       int r;
> +
> +       desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +       if (!desc)
> +               return -ENOMEM;
> +
> +       list_add_tail(&desc->list, &this->list);
> +
> +       sgl = &desc->sgl;
> +
> +       size = num_regs * sizeof(u32);
> +
> +       sg_init_one(sgl, reg, size);
> +
> +       desc->dir = DMA_MEM_TO_DEV;
> +
> +       dma_map_sg(this->dev, sgl, 1, desc->dir);
> +
> +       this->slave_conf.device_fc = flow_control ? 1 : 0;
> +       this->slave_conf.dst_addr = this->res->start + first;
> +       this->slave_conf.dst_maxburst = 16;
> +       this->slave_conf.slave_id = this->cmd_crci;
> +
> +       r = dmaengine_slave_config(this->chan, &this->slave_conf);
> +       if (r) {
> +               dev_err(this->dev, "failed to configure dma channel\n");
> +               goto err;
> +       }
> +
> +       dma_desc = dmaengine_prep_slave_sg(this->chan, sgl, 1, desc->dir, 0);
> +       if (!dma_desc) {
> +               dev_err(this->dev, "failed to prepare register write desc\n");
> +               r = PTR_ERR(dma_desc);
> +               goto err;
> +       }
> +
> +       desc->dma_desc = dma_desc;
> +
> +       desc->mapped = true;
> +
> +       return 0;
> +err:
> +       kfree(desc);
> +
> +       return r;
> +}
> +
> +/*
> + * read_reg_dma:       prepares a descriptor to read a given number of
> + *                     contiguous registers to the reg_read_buf pointer
> + *
> + * @first:             offset of the first register in the contiguous block
> + * @num_regs:          number of registers to read
> + * @flow_control:      flow control enabled/disabled
> + */
> +static int read_reg_dma(struct qcom_nandc_data *this, int first,
> +               int num_regs, bool flow_control)
> +{
> +       struct desc_info *desc;
> +       struct dma_async_tx_descriptor *dma_desc;
> +       struct scatterlist *sgl;
> +       int size;
> +       int r;
> +
> +       desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +       if (!desc)
> +               return -ENOMEM;
> +
> +       list_add_tail(&desc->list, &this->list);
> +
> +       sgl = &desc->sgl;
> +
> +       size = num_regs * sizeof(u32);
> +
> +       sg_init_one(sgl, this->reg_read_buf + this->reg_read_pos, size);
> +
> +       desc->dir = DMA_DEV_TO_MEM;
> +
> +       dma_map_sg(this->dev, sgl, 1, desc->dir);
> +
> +       this->slave_conf.device_fc = flow_control ? 1 : 0;
> +       this->slave_conf.src_addr = this->res->start + first;
> +       this->slave_conf.src_maxburst = 16;
> +       this->slave_conf.slave_id = this->data_crci;
> +
> +       r = dmaengine_slave_config(this->chan, &this->slave_conf);
> +       if (r) {
> +               dev_err(this->dev, "failed to configure dma channel\n");
> +               goto err;
> +       }
> +
> +       dma_desc = dmaengine_prep_slave_sg(this->chan, sgl, 1, desc->dir, 0);
> +       if (!dma_desc) {
> +               dev_err(this->dev, "failed to prepare register read desc\n");
> +               r = PTR_ERR(dma_desc);
> +               goto err;
> +       }
> +
> +       desc->dma_desc = dma_desc;
> +
> +       desc->mapped = true;
> +
> +       this->reg_read_pos += num_regs;
> +
> +       return 0;
> +err:
> +       kfree(desc);
> +
> +       return r;
> +}
> +
> +/*
> + * read_data_dma:      prepares a DMA descriptor to transfer data from the
> + *                     controller's internal buffer to data_buffer
> + *
> + * @reg_off:           offset within the controller's data buffer
> + * @buf_off:           offset in data_buffer where we want to write the data
> + *                     read from the controller
> + * @size:              DMA transaction size in bytes
> + */
> +static int read_data_dma(struct qcom_nandc_data *this, int reg_off,
> +               int *buf_off, int size)
> +{
> +       struct desc_info *desc;
> +       struct dma_async_tx_descriptor *dma_desc;
> +       struct scatterlist *sgl;
> +       void *vaddr;
> +       dma_addr_t address;
> +       int r;
> +
> +       desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +       if (!desc)
> +               return -ENOMEM;
> +
> +       list_add_tail(&desc->list, &this->list);
> +
> +       sgl = &desc->sgl;
> +
> +       vaddr = this->data_buffer + *buf_off;
> +       address = this->data_buffer_paddr + *buf_off;
> +
> +       sg_init_one(sgl, vaddr, size);
> +       sgl->dma_address = address;
> +
> +       desc->dir = DMA_DEV_TO_MEM;
> +
> +       this->slave_conf.device_fc = 0;
> +       this->slave_conf.src_addr = this->res->start + reg_off;
> +       this->slave_conf.src_maxburst = 16;
> +
> +       r = dmaengine_slave_config(this->chan, &this->slave_conf);
> +       if (r) {
> +               dev_err(this->dev, "failed to configure dma channel\n");
> +               goto err;
> +       }
> +
> +       dma_desc = dmaengine_prep_slave_sg(this->chan, sgl, 1, desc->dir, 0);
> +       if (!dma_desc) {
> +               dev_err(this->dev, "failed to prepare data read desc\n");
> +               r = PTR_ERR(dma_desc);
> +               goto err;
> +       }
> +
> +       desc->dma_desc = dma_desc;
> +
> +       *buf_off += size;
> +
> +       return 0;
> +err:
> +       kfree(desc);
> +
> +       return r;
> +}
> +
> +/*
> + * write_data_dma:     prepares a DMA descriptor to transfer data from
> + *                     data_buffer to the controller's internal buffer
> + *
> + * @reg_off:           offset within the controller's data buffer
> + * @buf_off:           offset in data_buffer where we want to read the data to
> + *                     be written to the controller
> + * @size:              DMA transaction size in bytes
> + */
> +static int write_data_dma(struct qcom_nandc_data *this, int reg_off,
> +               int *buf_off, int size)
> +{
> +       struct desc_info *desc;
> +       struct dma_async_tx_descriptor *dma_desc;
> +       struct scatterlist *sgl;
> +       void *vaddr;
> +       dma_addr_t address;
> +       int r;
> +
> +       desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +       if (!desc)
> +               return -ENOMEM;
> +
> +       list_add_tail(&desc->list, &this->list);
> +
> +       sgl = &desc->sgl;
> +
> +       vaddr = this->data_buffer + *buf_off;
> +       address = this->data_buffer_paddr + *buf_off;
> +
> +       sg_init_one(sgl, vaddr, size);
> +       sgl->dma_address = address;
> +
> +       desc->dir = DMA_MEM_TO_DEV;
> +
> +       this->slave_conf.device_fc = 0;
> +       this->slave_conf.dst_addr = this->res->start + reg_off;
> +       this->slave_conf.dst_maxburst = 16;
> +
> +       r = dmaengine_slave_config(this->chan, &this->slave_conf);
> +       if (r) {
> +               dev_err(this->dev, "failed to configure dma channel\n");
> +               goto err;
> +       }
> +
> +       dma_desc = dmaengine_prep_slave_sg(this->chan, sgl, 1, desc->dir, 0);
> +       if (!dma_desc) {
> +               dev_err(this->dev, "failed to prepare data write desc\n");
> +               r = PTR_ERR(dma_desc);
> +               goto err;
> +       }
> +
> +       desc->dma_desc = dma_desc;
> +
> +       *buf_off += size;
> +
> +       return 0;
> +err:
> +       kfree(desc);
> +
> +       return r;
> +}
> +
> +/* read_cw:            helper to prepare descriptors to read one codeword
> + *
> + * @data_size:         data bytes to be fetched
> + * @oob_size:          oob bytes to be fetched
> + */
> +static int read_cw(struct qcom_nandc_data *this, int data_size, int oob_size)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       write_reg_dma(this, NAND_FLASH_CMD, &regs->cmd, 3, true);
> +       write_reg_dma(this, NAND_DEV0_CFG0, &regs->cfg0, 3, false);
> +       write_reg_dma(this, NAND_EBI2_ECC_BUF_CFG, &regs->ecc_buf_cfg,
> +               1, false);
> +
> +       write_reg_dma(this, NAND_EXEC_CMD, &regs->exec, 1, false);
> +
> +       read_reg_dma(this, NAND_FLASH_STATUS, 2, true);
> +       read_reg_dma(this, NAND_ERASED_CW_DETECT_STATUS, 1, false);
> +
> +       if (data_size)
> +               read_data_dma(this, FLASH_BUF_ACC, &this->data_pos, data_size);
> +
> +       if (oob_size)
> +               read_data_dma(this, FLASH_BUF_ACC + data_size, &this->oob_pos,
> +                       oob_size);
> +
> +       return 0;
> +}
> +
> +/*
> + * write_cw:           helper to prepare descriptors to write one codeword
> + *
> + * @data_size:         data bytes to be written to NANDc internal buffer
> + * @oob_size:          oob bytes to be written to NANDc internal buffer
> + */
> +static int write_cw(struct qcom_nandc_data *this, int data_size, int oob_size)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       write_reg_dma(this, NAND_FLASH_CMD, &regs->cmd, 3, true);
> +       write_reg_dma(this, NAND_DEV0_CFG0, &regs->cfg0, 3, false);
> +       write_reg_dma(this, NAND_EBI2_ECC_BUF_CFG, &regs->ecc_buf_cfg,
> +               1, false);
> +
> +       write_data_dma(this, FLASH_BUF_ACC, &this->data_pos, data_size);
> +
> +       /* oob */
> +       if (oob_size)
> +               write_data_dma(this, FLASH_BUF_ACC + data_size, &this->oob_pos,
> +                       oob_size);
> +
> +       write_reg_dma(this, NAND_EXEC_CMD, &regs->exec, 1, false);
> +
> +       read_reg_dma(this, NAND_FLASH_STATUS, 1, true);
> +
> +       write_reg_dma(this, NAND_FLASH_STATUS, &regs->clrflashstatus, 1, false);
> +       write_reg_dma(this, NAND_READ_STATUS, &regs->clrreadstatus, 1, false);
> +
> +       return 0;
> +}
> +
> +/*
> + * the following functions are used within chip->cmdfunc() to perform different
> + * NAND_CMD_* commands
> + */
> +
> +/* nandc_param: sets up descriptors for NAND_CMD_PARAM */
> +static int nandc_param(struct qcom_nandc_data *this)
> +{
> +       int size;
> +       struct nandc_regs *regs = this->regs;
> +
> +       /*
> +        * NAND_CMD_PARAM is called before we know much about the FLASH chip
> +        * in use. we configure the controller to perform a raw read of 512
> +        * bytes to read onfi params
> +        */
> +       regs->cmd = PAGE_READ | PAGE_ACC | LAST_PAGE;
> +       regs->addr0 = 0;
> +       regs->addr1 = 0;
> +       regs->cfg0 =  0 << CW_PER_PAGE
> +                       | 512 << UD_SIZE_BYTES
> +                       | 5 << NUM_ADDR_CYCLES
> +                       | 0 << SPARE_SIZE_BYTES;
> +
> +       regs->cfg1 =  7 << NAND_RECOVERY_CYCLES
> +                       | 0 << CS_ACTIVE_BSY
> +                       | 17 << BAD_BLOCK_BYTE_NUM
> +                       | 1 << BAD_BLOCK_IN_SPARE_AREA
> +                       | 2 << WR_RD_BSY_GAP
> +                       | 0 << WIDE_FLASH
> +                       | 1 << DEV0_CFG1_ECC_DISABLE;
> +
> +       regs->ecc_bch_cfg = 1 << ECC_CFG_ECC_DISABLE;
> +
> +       /* configure CMD1 and VLD for ONFI param probing */
> +       regs->vld = (this->vld & ~(1 << READ_START_VLD))
> +                       | 0 << READ_START_VLD;
> +
> +       regs->cmd1 = (this->cmd1 & ~(0xFF << READ_ADDR))
> +                       | NAND_CMD_PARAM << READ_ADDR;
> +
> +       regs->exec = 1;
> +
> +       regs->orig_cmd1 = this->cmd1;
> +       regs->orig_vld = this->vld;
> +
> +       write_reg_dma(this, NAND_DEV_CMD_VLD, &regs->vld, 1, false);
> +       write_reg_dma(this, NAND_DEV_CMD1, &regs->cmd1, 1, false);
> +
> +       size = this->buf_count = 512;
> +
> +       read_cw(this, size, 0);
> +
> +       /* restore CMD1 and VLD regs */
> +       write_reg_dma(this, NAND_DEV_CMD1, &regs->orig_cmd1, 1, false);
> +       write_reg_dma(this, NAND_DEV_CMD_VLD, &regs->orig_vld, 1, false);
> +
> +       return 0;
> +}
> +
> +/*
> + * read_page:          sets up descriptors for NAND_CMD_READ0/NAND_CMD_READOOB
> + * @oob_only:          only read oob area to data_buffer, discard data
> + */
> +static int read_page(struct qcom_nandc_data *this, bool oob_only)
> +{
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       int i;
> +
> +       /* queue cmd descs for each codeword */
> +       for (i = 0; i < cwperpage; i++) {
> +               int data_size, oob_size;
> +
> +               if (i == (cwperpage - 1)) {
> +                       data_size = ecc->size - ((cwperpage - 1) << 2);
> +                       oob_size = (cwperpage << 2) + ecc->bytes;
> +               } else {
> +                       data_size = this->cw_data;
> +                       oob_size = ecc->bytes;
> +               }
> +
> +               read_cw(this, oob_only ? 0 : data_size, oob_size);
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * write_page: sets up descriptors for NAND_CMD_PAGEPROG. this function writes
> + *             the complete page along with oob data. currently, we can't
> + *             configure our controller to write only oob or only data
> + */
> +static int write_page(struct qcom_nandc_data *this)
> +{
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       int i;
> +
> +       /* queue cmd descs for each word */
> +       for (i = 0; i < cwperpage; i++) {
> +               int data_size, oob_size;
> +
> +               if (i == (cwperpage - 1)) {
> +                       data_size = ecc->size - ((cwperpage - 1) << 2);
> +                       oob_size = cwperpage << 2;
> +
> +                       /*
> +                        * the last codewords contains both ecc and oob,
> +                        * configure dma descs for both of them
> +                        */
> +                       write_cw(this, data_size, oob_size);
> +               } else {
> +                       data_size = this->cw_data;
> +                       oob_size = ecc->bytes;
> +
> +                       /*
> +                        * we skip writing oob for the first n - 1 codewords as
> +                        * they consist of just ecc, that's written by the
> +                        * controller by itself, we just move our marker
> +                        * accordingly
> +                        */
> +                       write_cw(this, data_size, 0);
> +
> +                       this->oob_pos += oob_size;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +/* erase_block:        sets up descriptors for NAND_CMD_ERASE1 */
> +static int erase_block(struct qcom_nandc_data *this, int page_addr)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       regs->cmd = BLOCK_ERASE | PAGE_ACC | LAST_PAGE;
> +       regs->addr0 = page_addr;
> +       regs->addr1 = 0;
> +       regs->cfg0 = this->cfg0_raw & ~(7 << CW_PER_PAGE);
> +       regs->cfg1 = this->cfg1_raw;
> +       regs->exec = 1;
> +       regs->clrflashstatus = this->clrflashstatus;
> +       regs->clrreadstatus = this->clrreadstatus;
> +
> +       write_reg_dma(this, NAND_FLASH_CMD, &regs->cmd, 3, true);
> +       write_reg_dma(this, NAND_DEV0_CFG0, &regs->cfg0, 2, false);
> +       write_reg_dma(this, NAND_EXEC_CMD, &regs->exec, 1, false);
> +
> +       read_reg_dma(this, NAND_FLASH_STATUS, 1, true);
> +
> +       write_reg_dma(this, NAND_FLASH_STATUS, &regs->clrflashstatus, 1, false);
> +       write_reg_dma(this, NAND_READ_STATUS, &regs->clrreadstatus, 1, false);
> +
> +       return 0;
> +}
> +
> +/* read_id:    sets up descriptors for NAND_CMD_READID */
> +static int read_id(struct qcom_nandc_data *this, int column)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       if (column == -1)
> +               return 0;
> +
> +       regs->cmd = FETCH_ID;
> +       regs->addr0 = column;
> +       regs->addr1 = 0;
> +       regs->chip_sel = DM_EN;
> +       regs->exec = 1;
> +
> +       write_reg_dma(this, NAND_FLASH_CMD, &regs->cmd, 4, true);
> +       write_reg_dma(this, NAND_EXEC_CMD, &regs->exec, 1, false);
> +
> +       read_reg_dma(this, NAND_READ_ID, 1, true);
> +
> +       return 0;
> +}
> +
> +/* reset:      sets up descriptors for NAND_CMD_RESET */
> +static int reset(struct qcom_nandc_data *this)
> +{
> +       struct nandc_regs *regs = this->regs;
> +
> +       regs->cmd = RESET_DEVICE;
> +       regs->exec = 1;
> +
> +       write_reg_dma(this, NAND_FLASH_CMD, &regs->cmd, 1, true);
> +       write_reg_dma(this, NAND_EXEC_CMD, &regs->exec, 1, false);
> +
> +       read_reg_dma(this, NAND_FLASH_STATUS, 1, true);
> +
> +       return 0;
> +}
> +
> +static void dma_callback(void *param)
> +{
> +       struct qcom_nandc_data *this = (struct qcom_nandc_data *) param;
> +       struct completion *c = &this->dma_done;
> +
> +       complete(c);
> +}
> +
> +static int submit_descs(struct qcom_nandc_data *this)
> +{
> +       struct completion *c = &this->dma_done;
> +       struct desc_info *desc;
> +       int r;
> +
> +       init_completion(c);
> +
> +       list_for_each_entry(desc, &this->list, list) {
> +               /*
> +                * we add a callback the last descriptor in our list to notify
> +                * completion of command
> +                */
> +               if (list_is_last(&desc->list, &this->list)) {
> +                       desc->dma_desc->callback = dma_callback;
> +                       desc->dma_desc->callback_param = this;
> +               }
> +
> +               dmaengine_submit(desc->dma_desc);
> +       }
> +
> +       dma_async_issue_pending(this->chan);
> +
> +       r = wait_for_completion_timeout(c, msecs_to_jiffies(500));
> +       if (!r)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static void free_descs(struct qcom_nandc_data *this)
> +{
> +       struct desc_info *desc, *n;
> +
> +       list_for_each_entry_safe(desc, n, &this->list, list) {
> +               list_del(&desc->list);
> +               if (desc->mapped)
> +                       dma_unmap_sg(this->dev, &desc->sgl, 1, desc->dir);
> +               kfree(desc);
> +       }
> +}
> +
> +static void pre_command(struct qcom_nandc_data *this, int command)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +
> +       this->buf_count = 0;
> +       this->buf_start = 0;
> +       this->data_pos = 0;
> +       this->oob_pos = mtd->writesize;
> +       this->reg_read_pos = 0;
> +       this->use_ecc = false;
> +       this->erased_page = false;
> +       this->last_command = command;
> +
> +       if (command == NAND_CMD_READ0 ||
> +                       command == NAND_CMD_READOOB ||
> +                       command == NAND_CMD_SEQIN ||
> +                       command == NAND_CMD_PARAM) {
> +
> +               this->buf_count = mtd->writesize + mtd->oobsize;
> +               memset(this->data_buffer, 0xff, this->buf_count);
> +               memset(this->reg_read_buf, 0, MAX_REG_RD * sizeof(u32));
> +       }
> +}
> +
> +/*
> + * when using RS ECC, the NAND controller flags an error when reading an
> + * erased page. however, there are special characters at certain offsets when
> + * we read the erased page. we check here if the page is really empty. if so,
> + * we replace the magic characters with 0xffs
> + */
> +static void empty_page_fixup(struct qcom_nandc_data *this)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       int i;
> +
> +       /* if BCH is enabled, HW will take care of detecting erased pages */
> +       if (this->bch_enabled || !this->use_ecc)
> +               return;
> +
> +       for (i = 0; i < cwperpage; i++) {
> +               u8 *empty1, *empty2;
> +               u32 flash_status = this->reg_read_buf[3 * i];
> +
> +               /*
> +                * an erased page flags an error in NAND_FLASH_STATUS, check if
> +                * the page is erased by looking for 0x54s at offsets 3 and 175
> +                * from the beginning of each codeword
> +                */
> +               if (flash_status & FS_OP_ERR) {
> +                       empty1 = &this->data_buffer[3 + i * this->cw_data];
> +                       empty2 = &this->data_buffer[175 + i * this->cw_data];
> +
> +                       /*
> +                        * the error wasn't because of an erased page, bail out
> +                        * and let someone else do the error checking
> +                        */
> +                       if (!((*empty1 == 0x54 && *empty2 == 0xff) ||
> +                                       (*empty1 == 0xff && *empty2 == 0x54)))
> +                               return;
> +               }
> +       }
> +
> +       for (i = 0; i < mtd->writesize && (this->data_buffer[i] == 0xff ||
> +               (i % this->cw_data == 3 || i % this->cw_data == 175)); i++) {
> +       }
> +
> +       if (i < mtd->writesize)
> +               return;
> +
> +       /*
> +        * the whole page is 0xffs besides the magic offsets, we replace the
> +        * 0x54s with 0xffs
> +        */
> +       for (i = 0; i < cwperpage; i++) {
> +               this->data_buffer[3 + i * this->cw_data] = 0xff;
> +               this->data_buffer[175 + i * this->cw_data] = 0xff;
> +       }
> +
> +       /*
> +        * raise the erased page flag so that parse_read_errors() doesn't think
> +        * it's an error
> +        */
> +       this->erased_page = true;
> +}
> +
> +/*
> + * this is called after NAND_CMD_PAGEPROG and NAND_CMD_ERASE1 to set our
> + * privately maintained status byte, this status byte can be read after
> + * NAND_CMD_STATUS is called
> + */
> +static void parse_erase_write_errors(struct qcom_nandc_data *this, int command)
> +{
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int num_cw;
> +       int i;
> +
> +       num_cw = command == NAND_CMD_PAGEPROG ? ecc->steps : 1;
> +
> +       for (i = 0; i < num_cw; i++) {
> +               u32 flash_status;
> +
> +               flash_status = this->reg_read_buf[i];
> +
> +               if (flash_status & FS_MPU_ERR)
> +                       this->status &= ~NAND_STATUS_WP;
> +
> +               if (flash_status & FS_OP_ERR || (i == (num_cw - 1) &&
> +                               (flash_status & FS_DEVICE_STS_ERR)))
> +                       this->status |= NAND_STATUS_FAIL;
> +       }
> +}
> +
> +static void post_command(struct qcom_nandc_data *this, int command)
> +{
> +       switch (command) {
> +       case NAND_CMD_READID:
> +               memcpy(this->data_buffer, this->reg_read_buf, this->buf_count);
> +               break;
> +       case NAND_CMD_READ0:
> +       case NAND_CMD_READ1:
> +               empty_page_fixup(this);
> +               break;
> +       case NAND_CMD_PAGEPROG:
> +       case NAND_CMD_ERASE1:
> +               parse_erase_write_errors(this, command);
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
> +static void qcom_nandc_command(struct mtd_info *mtd, unsigned int command,
> +                        int column, int page_addr)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       struct qcom_nandc_data *this = chip->priv;
> +       bool wait = true;
> +       int r = 0;
> +
> +       pre_command(this, command);
> +
> +       switch (command) {
> +       case NAND_CMD_RESET:
> +               r = reset(this);
> +               break;
> +
> +       case NAND_CMD_READID:
> +               this->buf_count = 4;
> +               r = read_id(this, column);
> +               break;
> +
> +       case NAND_CMD_READ0:
> +       case NAND_CMD_READOOB:
> +               this->buf_start = column;
> +               this->use_ecc = true;
> +
> +               if (command == NAND_CMD_READOOB)
> +                       this->buf_start += mtd->writesize;
> +
> +               /*
> +                * for now, the controller always reads complete page data, we
> +                * configure DMA to read data + oob or only oob from the
> +                * controller's buffer into data_buffer
> +                */
> +               set_address(this, 0, page_addr);
> +               update_rw_regs(this, ecc->steps, true);
> +
> +               r = read_page(this, command == NAND_CMD_READOOB);
> +               break;
> +
> +       case NAND_CMD_PARAM:
> +               r = nandc_param(this);
> +               break;
> +
> +       case NAND_CMD_SEQIN:
> +               this->buf_start = column;
> +               this->page = page_addr;
> +               set_address(this, 0, page_addr);
> +               wait = false;
> +               break;
> +
> +       case NAND_CMD_PAGEPROG:
> +               this->use_ecc = true;
> +               update_rw_regs(this, ecc->steps, false);
> +               r = write_page(this);
> +               break;
> +
> +       case NAND_CMD_ERASE1:
> +               r = erase_block(this, page_addr);
> +               break;
> +
> +       case NAND_CMD_STATUS:
> +               wait = false;
> +               break;
> +
> +       case NAND_CMD_NONE:
> +       default:
> +               wait = false;
> +               break;
> +       }
> +
> +       if (r) {
> +               dev_err(this->dev, "failure executing command %d\n",
> +                       command);
> +               free_descs(this);
> +               return;
> +       }
> +
> +       if (wait) {
> +               r = submit_descs(this);
> +               if (r)
> +                       dev_err(this->dev,
> +                               "failure submitting descs for command %d\n",
> +                               command);
> +       }
> +
> +       free_descs(this);
> +
> +       post_command(this, command);
> +}
> +
> +/*
> + * the bad block marker is readable only when we read the page with ECC
> + * disabled. all the read/write commands like NAND_CMD_READOOB, NAND_CMD_READ0
> + * and NAND_CMD_PAGEPROG are executed in the driver with ECC enabled. therefore,
> + * the default nand helper functions to detect a bad block or mark a bad block
> + * can't be used.
> + */
> +static int qcom_nandc_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
> +{
> +       int page, r, mark, bad = 0;
> +       struct nand_chip *chip = mtd->priv;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       struct qcom_nandc_data *this = chip->priv;
> +       u32 flash_status;
> +
> +       pre_command(this, NAND_CMD_NONE);
> +
> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
> +
> +       /*
> +        * configure registers for a raw page read, the address is set to the
> +        * beginning of the last codeword
> +        */
> +       this->use_ecc = false;
> +       set_address(this, this->cw_size * (cwperpage - 1), page);
> +
> +       /* we just read one codeword that contains the bad block marker */
> +       update_rw_regs(this, 1, true);
> +
> +       read_cw(this, this->cw_size, 0);
> +
> +       r = submit_descs(this);
> +       if (r) {
> +               dev_err(this->dev, "error submitting descs\n");
> +               goto err;
> +       }
> +
> +       flash_status = this->reg_read_buf[0];
> +
> +       /*
> +        * unable to read the marker successfully, is that sufficient to report
> +        * the block as bad?
> +        */
> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR)) {
> +               dev_warn(this->dev, "error while reading bad block mark\n");
> +               goto err;
> +       }
> +
> +       mark = mtd->writesize - (this->cw_size * (cwperpage - 1));
> +
> +       if (chip->options & NAND_BUSWIDTH_16)
> +               bad = this->data_buffer[mark] != 0xff ||
> +                       this->data_buffer[mark + 1] != 0xff;
> +
> +       bad = this->data_buffer[mark] != 0xff;
> +err:
> +       free_descs(this);
> +
> +       return bad;
> +}
> +
> +static int qcom_nandc_block_markbad(struct mtd_info *mtd, loff_t ofs)
> +{
> +       int page, r;
> +       struct nand_chip *chip = mtd->priv;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       struct qcom_nandc_data *this = chip->priv;
> +       u32 flash_status;
> +
> +       pre_command(this, NAND_CMD_NONE);
> +
> +       /* fill our internal buffer's oob area with 0's */
> +       memset(this->data_buffer, 0x00, mtd->writesize + mtd->oobsize);
> +
> +       page = (int)(ofs >> chip->page_shift) & chip->pagemask;
> +
> +       this->use_ecc = false;
> +       set_address(this, this->cw_size * (cwperpage - 1), page);
> +
> +       /* we just write to one codeword that contains the bad block marker*/
> +       update_rw_regs(this, 1, false);
> +
> +       /*
> +        * overwrite the last codeword with 0s, this will result in setting
> +        * the bad block marker to 0 too
> +        */
> +       write_cw(this, this->cw_size, 0);
> +
> +       r = submit_descs(this);
> +       if (r) {
> +               dev_err(this->dev, "error submitting descs\n");
> +               r = -EIO;
> +               goto err;
> +       }
> +
> +       flash_status = this->reg_read_buf[0];
> +
> +       if (flash_status & (FS_OP_ERR | FS_MPU_ERR))
> +               r = -EIO;
> +
> +err:
> +       free_descs(this);
> +
> +       return r;
> +}
> +
> +static int parse_read_errors(struct qcom_nandc_data *this)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       unsigned int max_bitflips = 0;
> +       int i;
> +
> +       for (i = 0; i < cwperpage; i++) {
> +               int stat;
> +               u32 flash_status = this->reg_read_buf[3 * i];
> +               u32 buffer_status = this->reg_read_buf[3 * i + 1];
> +               u32 erased_cw_status = this->reg_read_buf[3 * i + 2];
> +
> +               if (flash_status & (FS_OP_ERR | FS_MPU_ERR)) {
> +
> +                       /* ignore erased codeword errors */
> +                       if (this->bch_enabled) {
> +                               if ((erased_cw_status & ERASED_CW) == ERASED_CW)
> +                                       continue;
> +                       } else if (this->erased_page == true) {
> +                               continue;
> +                       }
> +
> +                       if (buffer_status & BS_UNCORRECTABLE_BIT) {
> +                               mtd->ecc_stats.failed++;
> +                               continue;
> +                       }
> +               }
> +
> +               stat = buffer_status & BS_CORRECTABLE_ERR_MSK;
> +               mtd->ecc_stats.corrected += stat;
> +
> +               max_bitflips = max_t(unsigned int, max_bitflips, stat);
> +       }
> +
> +       return max_bitflips;
> +}
> +
> +static int qcom_nandc_read_page_hwecc(struct mtd_info *mtd,
> +               struct nand_chip *chip, uint8_t *buf, int oob_required,
> +               int page)
> +{
> +       struct qcom_nandc_data *this = chip->priv;
> +
> +       chip->read_buf(mtd, buf, mtd->writesize);
> +       if (oob_required)
> +               chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
> +
> +       return parse_read_errors(this);
> +}
> +
> +/*
> + * the NAND controller cannot write only data or only oob within a codeword.
> + * this is because the controller can't be configured on the fly between
> + * codewords to change the amount of data that needs to be written to the
> + * nand chip. this results in a write performance drop. this can be
> + * optimized if we perform the extra read-copy-write operation only on the
> + * codeword that has spare data
> + */
> +static int qcom_nandc_write_page_hwecc(struct mtd_info *mtd,
> +               struct nand_chip *chip, const uint8_t *buf,
> +               int oob_required)
> +{
> +       struct qcom_nandc_data *this = chip->priv;
> +
> +       /* it's all okay when we intend to write both data and oob */
> +       if (oob_required) {
> +               chip->write_buf(mtd, buf, mtd->writesize);
> +               chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
> +               return 0;
> +       }
> +
> +       /*
> +        * the controller will write oob even when we don't want to write to it.
> +        * we read the original OOB, copy it to our buffer and do a full page
> +        * write so that the OOB doesn't change
> +        */
> +       chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, this->page);
> +
> +       this->buf_start = 0;
> +
> +       chip->write_buf(mtd, buf, mtd->writesize);
> +
> +       return 0;
> +}
> +
> +static int qcom_nandc_write_oob(struct mtd_info *mtd, struct nand_chip *chip,
> +                             int page)
> +{
> +       struct qcom_nandc_data *this = chip->priv;
> +       int status = 0;
> +
> +       /* read complete data + oob */
> +       chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
> +
> +       /*
> +        * override the read oob with the new oob content in oob_poi, perform
> +        * a full page write
> +        */
> +       memcpy(this->data_buffer + mtd->writesize, chip->oob_poi,
> +               mtd->oobsize);
> +
> +       chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);
> +
> +       status = chip->waitfunc(mtd, chip);
> +
> +       return status & NAND_STATUS_FAIL ? -EIO : 0;
> +}
> +
> +static uint8_t qcom_nandc_read_byte(struct mtd_info *mtd)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +       struct qcom_nandc_data *this = chip->priv;
> +       uint8_t *buf = (uint8_t *) this->data_buffer;
> +       uint8_t ret = 0x0;
> +
> +       if (this->last_command == NAND_CMD_STATUS) {
> +               ret = this->status;
> +
> +               this->status = NAND_STATUS_READY | NAND_STATUS_WP;
> +
> +               return ret;
> +       }
> +
> +       if (this->buf_start < this->buf_count)
> +               ret = buf[this->buf_start++];
> +
> +       return ret;
> +}
> +
> +/*
> + * TODO: We always copy DMA to our internal buffer. Try to use the buffer passed
> + * mtd first. Fallback to data_buffer only if the upper layer buffer can't be
> + * used
> + */
> +static void qcom_nandc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +       struct qcom_nandc_data *this = chip->priv;
> +       int real_len = min_t(size_t, len, this->buf_count - this->buf_start);
> +
> +       memcpy(buf, this->data_buffer + this->buf_start, real_len);
> +       this->buf_start += real_len;
> +}
> +
> +static void qcom_nandc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
> +               int len)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +       struct qcom_nandc_data *this = chip->priv;
> +       int real_len = min_t(size_t, len, this->buf_count - this->buf_start);
> +
> +       memcpy(this->data_buffer + this->buf_start, buf, real_len);
> +
> +       this->buf_start += real_len;
> +}
> +
> +/* we support only one external chip for now */
> +static void qcom_nandc_select_chip(struct mtd_info *mtd, int chipnr)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +       struct qcom_nandc_data *this = chip->priv;
> +
> +       if (chipnr <= 0)
> +               return;
> +
> +       dev_warn(this->dev, "invalid chip select\n");
> +}
> +
> +/*
> + * NAND controller page layout info
> + *
> + * |-----------------------|     |---------------------------------|
> + * |           xx.......xx|      |             *********xx.......xx|
> + * |   DATA    xx..ECC..xx|      |     DATA    **SPARE**xx..ECC..xx|
> + * |   (516)   xx.......xx|      |  (516-n*4)  **(n*4)**xx.......xx|
> + * |           xx.......xx|      |             *********xx.......xx|
> + * |-----------------------|     |---------------------------------|
> + *     codeword 1,2..n-1                       codeword n
> + *  <---(528/532 Bytes)---->      <-------(528/532 Bytes)---------->
> + *
> + * n = number of codewords in the page
> + * . = ECC bytes
> + * * = spare bytes
> + * x = unused/reserved bytes
> + *
> + * 2K page: n = 4, spare = 16 bytes
> + * 4K page: n = 8, spare = 32 bytes
> + * 8K page: n = 16, spare = 64 bytes
> + *
> + * the qcom nand controller operates at a sub page/codeword level. each
> + * codeword is 528 and 532 bytes for 4 bit and 8 bit ECC modes respectively.
> + * the number of ECC bytes vary based on the ECC strength and the bus width.
> + *
> + * the first n - 1 codewords contains 516 bytes of user data, the remaining
> + * 12/16 bytes consist of ECC and reserved data. The nth codeword contains
> + * both user data and spare(oobavail) bytes that sum up to 516 bytes.
> + *
> + * the layout described above is used by the controller when the ECC block is
> + * enabled. When we read a page with ECC enabled, the unused/reserved bytes are
> + * skipped and not copied to our internal buffer. therefore, the nand_ecclayout
> + * layouts defined below doesn't consider the positions occupied by the reserved
> + * bytes
> + *
> + * when the ECC block is disabled, one unused byte (or two for 16 bit bus width)
> + * in the last codeword is the position of bad block marker. the bad block
> + * marker cannot be accessed when ECC is enabled.
> + *
> + */
> +
> +/* 2K page, 4 bit ECC */
> +static struct nand_ecclayout layout_oob_64 = {
> +       .eccbytes       = 40,
> +       .eccpos         = {
> +                        0,  1,  2,  3,  4,  5,  6,  7,  8,  9,
> +                       10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
> +                       20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
> +                       46, 47, 48, 49, 50, 51, 52, 53, 54, 55,
> +                         },
> +
> +       .oobfree        = {
> +                               { 30, 16 },
> +                         },
> +};
> +
> +/* 4K page, 4 bit ECC, 8/16 bit bus width */
> +static struct nand_ecclayout layout_oob_128 = {
> +       .eccbytes       = 80,
> +       .eccpos         = {
> +                 0,   1,  2,    3,   4,   5,   6,   7,   8,   9,
> +                10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
> +                20,  21,  22,  23,  24,  25,  26,  27,  28,  29,
> +                30,  31,  32,  33,  34,  35,  36,  37,  38,  39,
> +                40,  41,  42,  43,  44,  45,  46,  47,  48,  49,
> +                50,  51,  52,  53,  54,  55,  56,  57,  58,  59,
> +                60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
> +               102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
> +                         },
> +       .oobfree        = {
> +                               { 70, 32 },
> +                         },
> +};
> +
> +/* 4K page, 8 bit ECC, 8 bit bus width */
> +static struct nand_ecclayout layout_oob_224_x8 = {
> +       .eccpos         = {
> +                 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
> +                13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
> +                26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,
> +                39,  40,  41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,
> +                52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,  64,
> +                65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,
> +                78,  79,  80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,
> +               123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135,
> +                       },
> +       .oobfree        = {
> +                               { 91, 32 },
> +                         },
> +};
> +
> +/* 4K page, 8 bit ECC, 16 bit bus width */
> +static struct nand_ecclayout layout_oob_224_x16 = {
> +       .eccbytes       = 112,
> +       .eccpos         = {
> +                 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,
> +                14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,
> +                28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,  41,
> +                42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54,  55,
> +                56,  57,  58,  59,  60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
> +                70,  71,  72,  73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,
> +                84,  85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,  96,  97,
> +               130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
> +       },
> +       .oobfree        = {
> +                               { 98, 32 },
> +                         },
> +};
> +
> +/* 8K page, 4 bit ECC, 8/16 bit bus width */
> +static struct nand_ecclayout layout_oob_256 = {
> +       .eccbytes       = 160,
> +       .eccpos         = {
> +                 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
> +                10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
> +                20,  21,  22,  23,  24,  25,  26,  27,  28,  29,
> +                30,  31,  32,  33,  34,  35,  36,  37,  38,  39,
> +                40,  41,  42,  43,  44,  45,  46,  47,  48,  49,
> +                50,  51,  52,  53,  54,  55,  56,  57,  58,  59,
> +                60,  61,  62,  63,  64,  65,  66,  67,  68,  69,
> +                70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
> +                80,  81,  82,  83,  84,  85,  86,  87,  88,  89,
> +                90,  91,  92,  93,  94,  96,  97,  98,  99, 100,
> +               101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
> +               111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
> +               121, 122, 123, 124, 125, 126, 127, 128, 129, 130,
> +               131, 132, 133, 134, 135, 136, 137, 138, 139, 140,
> +               141, 142, 143, 144, 145, 146, 147, 148, 149, 150,
> +               215, 216, 217, 218, 219, 220, 221, 222, 223, 224,
> +               },
> +       .oobfree        = {
> +                               { 151, 64 },
> +                         },
> +};
> +
> +/*
> + * this is called before scan_ident, we do some minimal configurations so
> + * that reading ID and ONFI params work
> + */
> +static void qcom_nandc_pre_init(struct qcom_nandc_data *this)
> +{
> +       /* kill onenand */
> +       nandc_write(this, SFLASHC_BURST_CFG, 0);
> +
> +       /* enable ADM DMA */
> +       nandc_write(this, NAND_FLASH_CHIP_SELECT, DM_EN);
> +
> +       /* save the original values of these registers */
> +       this->cmd1 = nandc_read(this, NAND_DEV_CMD1);
> +       this->vld = nandc_read(this, NAND_DEV_CMD_VLD);
> +
> +       /* initial status value */
> +       this->status = NAND_STATUS_READY | NAND_STATUS_WP;
> +}
> +
> +static int qcom_nandc_ecc_init(struct qcom_nandc_data *this)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage;
> +       bool wide_bus;
> +
> +       /* the nand controller fetches codewords/chunks of 512 bytes */
> +       cwperpage = mtd->writesize >> 9;
> +
> +       /* strength is the net strength of the complete page */
> +       ecc->strength = this->ecc_strength * cwperpage;
> +
> +       wide_bus = chip->options & NAND_BUSWIDTH_16 ? true : false;
> +
> +       if (ecc->strength >= 32) {
> +               /* 8 bit ECC defaults to BCH ECC on all platforms */
> +               ecc->bytes = wide_bus ? 14 : 13;
> +       } else {
> +               /*
> +                * if the controller supports BCH for 4 bit ECC, the controller
> +                * uses lesser bytes for ECC. If RS is used, the ECC bytes is
> +                * always 10 bytes
> +                */
> +               if (this->ecc_modes & ECC_BCH_4BIT)
> +                       ecc->bytes = wide_bus ? 8 : 7;
> +               else
> +                       ecc->bytes = 10;
> +       }
> +
> +       /* each step consists of 512 bytes of data */
> +       ecc->size = NANDC_STEP_SIZE;
> +
> +       ecc->read_page          = qcom_nandc_read_page_hwecc;
> +       ecc->write_page         = qcom_nandc_write_page_hwecc;
> +       ecc->write_oob          = qcom_nandc_write_oob;
> +
> +       switch (mtd->oobsize) {
> +       case 64:
> +               ecc->layout = &layout_oob_64;
> +               break;
> +       case 128:
> +               ecc->layout = &layout_oob_128;
> +               break;
> +       case 224:
> +               if (wide_bus)
> +                       ecc->layout = &layout_oob_224_x16;
> +               else
> +                       ecc->layout = &layout_oob_224_x8;
> +               break;
> +       case 256:
> +               ecc->layout = &layout_oob_256;
> +               break;
> +       default:
> +               dev_err(this->dev, "unsupported NAND device, oobsize %d\n",
> +                       mtd->oobsize);
> +               return -ENODEV;
> +       }
> +
> +       ecc->mode = NAND_ECC_HW;
> +
> +       /* enable ecc by default */
> +       this->use_ecc = true;
> +
> +       /* free old buffer, allocate one with page data + oob size */
> +       dma_free_coherent(this->dev, this->buf_size, this->data_buffer,
> +               this->data_buffer_paddr);
> +
> +       this->buf_size = mtd->writesize + mtd->oobsize;
> +
> +       this->data_buffer = dma_alloc_coherent(this->dev, this->buf_size,
> +                               &this->data_buffer_paddr, GFP_KERNEL);
> +       if (!this->data_buffer)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static void qcom_nandc_hw_post_init(struct qcom_nandc_data *this)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +       struct nand_chip *chip = &this->chip;
> +       struct nand_ecc_ctrl *ecc = &chip->ecc;
> +       int cwperpage = ecc->steps;
> +       int spare_bytes, bad_block_byte;
> +       bool wide_bus;
> +       int ecc_mode = 0;
> +
> +       wide_bus = chip->options & NAND_BUSWIDTH_16 ? true : false;
> +
> +       if (ecc->strength >= 32) {
> +               this->cw_size = 532;
> +
> +               spare_bytes = wide_bus ? 0 : 2;
> +
> +               this->bch_enabled = true;
> +               ecc_mode = 1;
> +       } else {
> +               this->cw_size = 528;
> +
> +               if (this->ecc_modes & ECC_BCH_4BIT) {
> +                       spare_bytes = wide_bus ? 2 : 4;
> +
> +                       this->bch_enabled = true;
> +                       ecc_mode = 0;
> +               } else {
> +                       spare_bytes = wide_bus ? 0 : 1;
> +               }
> +       }
> +
> +       /*
> +        * DATA_UD_BYTES varies based on whether the read/write command protects
> +        * spare data with ECC too. We protect spare data by default, so we set
> +        * it to main + spare data, which are 512 and 4 bytes respectively.
> +        */
> +       this->cw_data = 516;
> +
> +       bad_block_byte = mtd->writesize - this->cw_size * (cwperpage - 1) + 1;
> +
> +       this->cfg0 = (cwperpage - 1) << CW_PER_PAGE
> +                               | this->cw_data << UD_SIZE_BYTES
> +                               | 0 << DISABLE_STATUS_AFTER_WRITE
> +                               | 5 << NUM_ADDR_CYCLES
> +                               | ecc->bytes << ECC_PARITY_SIZE_BYTES_RS
> +                               | 0 << STATUS_BFR_READ
> +                               | 1 << SET_RD_MODE_AFTER_STATUS
> +                               | spare_bytes << SPARE_SIZE_BYTES;
> +
> +       this->cfg1 = 7 << NAND_RECOVERY_CYCLES
> +                               | 0 <<  CS_ACTIVE_BSY
> +                               | bad_block_byte << BAD_BLOCK_BYTE_NUM
> +                               | 0 << BAD_BLOCK_IN_SPARE_AREA
> +                               | 2 << WR_RD_BSY_GAP
> +                               | wide_bus << WIDE_FLASH
> +                               | this->bch_enabled << ENABLE_BCH_ECC;
> +
> +       this->cfg0_raw = (cwperpage - 1) << CW_PER_PAGE
> +                               | this->cw_size << UD_SIZE_BYTES
> +                               | 5 << NUM_ADDR_CYCLES
> +                               | 0 << SPARE_SIZE_BYTES;
> +
> +       this->cfg1_raw = 7 << NAND_RECOVERY_CYCLES
> +                               | 0 << CS_ACTIVE_BSY
> +                               | 17 << BAD_BLOCK_BYTE_NUM
> +                               | 1 << BAD_BLOCK_IN_SPARE_AREA
> +                               | 2 << WR_RD_BSY_GAP
> +                               | wide_bus << WIDE_FLASH
> +                               | 1 << DEV0_CFG1_ECC_DISABLE;
> +
> +       this->ecc_bch_cfg = this->bch_enabled << ECC_CFG_ECC_DISABLE
> +                               | 0 << ECC_SW_RESET
> +                               | this->cw_data << ECC_NUM_DATA_BYTES
> +                               | 1 << ECC_FORCE_CLK_OPEN
> +                               | ecc_mode << ECC_MODE
> +                               | ecc->bytes << ECC_PARITY_SIZE_BYTES_BCH;
> +
> +       this->ecc_buf_cfg = 0x203 << NUM_STEPS;
> +
> +       this->clrflashstatus = FS_READY_BSY_N;
> +       this->clrreadstatus = 0xc0;
> +
> +       dev_dbg(this->dev, "cfg0 %x cfg1 %x ecc_buf_cfg %x ecc_bch cfg %x "
> +               "cw_size %d cw_data %d strength %d parity_bytes %d "
> +               "steps %d\n", this->cfg0, this->cfg1, this->ecc_buf_cfg,
> +               this->ecc_bch_cfg, this->cw_size, this->cw_data,
> +               ecc->strength, ecc->bytes, cwperpage);
> +}
> +
> +static int qcom_nandc_alloc(struct qcom_nandc_data *this)
> +{
> +       int r;
> +
> +       r = dma_set_coherent_mask(this->dev, DMA_BIT_MASK(32));
> +       if (r) {
> +               dev_err(this->dev, "failed to set DMA mask\n");
> +               return r;
> +       }
> +
> +       /*
> +        * we don't know the page size of the NAND chip yet, set the buffer size
> +        * to 512 bytes for now, that's sufficient for reading ID or ONFI params
> +        */
> +       this->buf_size = SZ_512;
> +
> +       this->data_buffer = dma_alloc_coherent(this->dev, this->buf_size,
> +                               &this->data_buffer_paddr, GFP_KERNEL);
> +       if (!this->data_buffer)
> +               return -ENOMEM;
> +
> +       this->regs = devm_kzalloc(this->dev, sizeof(struct nandc_regs),
> +                       GFP_KERNEL);
> +       if (!this->regs)
> +               return -ENOMEM;
> +
> +       this->reg_read_buf = devm_kzalloc(this->dev, MAX_REG_RD * sizeof(u32),
> +                               GFP_KERNEL);
> +       if (!this->reg_read_buf)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&this->list);
> +
> +       this->chan = dma_request_slave_channel(this->dev, "rxtx");
> +       if (!this->chan) {
> +               dev_err(this->dev, "failed to request slave channel\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static void qcom_nandc_unalloc(struct qcom_nandc_data *this)
> +{
> +       dma_free_coherent(this->dev, this->buf_size, this->data_buffer,
> +               this->data_buffer_paddr);
> +
> +       dma_release_channel(this->chan);
> +}
> +
> +static int qcom_nandc_init(struct qcom_nandc_data *this)
> +{
> +       struct mtd_info *mtd = &this->mtd;
> +       struct nand_chip *chip = &this->chip;
> +       struct mtd_part_parser_data ppdata = {};
> +       int r;
> +
> +       mtd->priv = chip;
> +       mtd->name = "qcom-nandc";
> +       mtd->owner = THIS_MODULE;
> +
> +       chip->priv = this;
> +
> +       chip->cmdfunc           = qcom_nandc_command;
> +       chip->select_chip       = qcom_nandc_select_chip;
> +       chip->read_byte         = qcom_nandc_read_byte;
> +       chip->read_buf          = qcom_nandc_read_buf;
> +       chip->write_buf         = qcom_nandc_write_buf;
> +       chip->block_bad         = qcom_nandc_block_bad;
> +       chip->block_markbad     = qcom_nandc_block_markbad;
> +
> +       /* TODO: both can be supported, need to implement them */
> +       chip->options |= NAND_NO_SUBPAGE_WRITE | NAND_SKIP_BBTSCAN;
> +
> +       if (this->bus_width == 16)
> +               chip->options |= NAND_BUSWIDTH_16;
> +
> +       qcom_nandc_pre_init(this);
> +
> +       r = nand_scan_ident(mtd, 1, NULL);
> +       if (r)
> +               return r;
> +
> +       r = qcom_nandc_ecc_init(this);
> +       if (r)
> +               return r;
> +
> +       r = nand_scan_tail(mtd);
> +       if (r)
> +               return r;
> +
> +       qcom_nandc_hw_post_init(this);
> +
> +       ppdata.of_node = this->dev->of_node;
> +       r = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
> +       if (r)
> +               return r;
> +
> +       return 0;
> +}
> +
> +static int qcom_nandc_parse_dt(struct platform_device *pdev)
> +{
> +       struct device_node *np;
> +       struct qcom_nandc_data *this;
> +       int r;
> +
> +       np = pdev->dev.of_node;
> +       if (!np)
> +               return -ENODEV;
> +
> +       this = platform_get_drvdata(pdev);
> +       if (!this)
> +               return -ENODEV;
> +
> +       this->ecc_strength = of_get_nand_ecc_strength(np);
> +       if (this->ecc_strength < 0) {
> +               dev_warn(this->dev,
> +                       "incorrect ecc strength, setting to 4 bits/step\n");
> +               this->ecc_strength = 4;
> +       }
> +
> +       this->bus_width = of_get_nand_bus_width(np);
> +       if (this->bus_width < 0) {
> +               dev_warn(this->dev, "incorrect bus width, setting to 8\n");
> +               this->bus_width = 8;
> +       }
> +
> +       r = of_property_read_u32(np, "qcom,cmd-crci", &this->cmd_crci);
> +       if (r) {
> +               dev_err(this->dev, "command CRCI unspecified\n");
> +               return r;
> +       }
> +
> +       r = of_property_read_u32(np, "qcom,data-crci", &this->data_crci);
> +       if (r) {
> +               dev_err(this->dev, "data CRCI unspecified\n");
> +               return r;
> +       }
> +
> +       return 0;
> +}
> +
> +#define EBI2_NANDC_ECC_MODES   (ECC_RS_4BIT | ECC_BCH_8BIT)
> +
> +static const struct of_device_id qcom_nandc_of_match[] = {
> +       {       .compatible = "qcom,ebi2-nandc",
> +               .data = (void *) EBI2_NANDC_ECC_MODES,
> +       },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, qcom_nandc_of_match);
> +
> +static int qcom_nandc_probe(struct platform_device *pdev)
> +{
> +       struct qcom_nandc_data *this;
> +       const struct of_device_id *match;
> +       int r;
> +
> +       this = devm_kzalloc(&pdev->dev, sizeof(*this), GFP_KERNEL);
> +       if (!this)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, this);
> +
> +       this->pdev = pdev;
> +       this->dev  = &pdev->dev;
> +
> +       match = of_match_node(qcom_nandc_of_match, pdev->dev.of_node);
> +       if (!match) {
> +               dev_err(&pdev->dev, "unsupported NANDc module\n");
> +               return -ENODEV;
> +       }
> +
> +       /* match->data will hold a struct pointer once we support more IPs */
> +       this->ecc_modes = (u32) match->data;
> +
> +       this->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       this->base = devm_ioremap_resource(&pdev->dev, this->res);
> +       if (IS_ERR(this->base))
> +               return PTR_ERR(this->base);
> +
> +       this->core_clk = devm_clk_get(&pdev->dev, "core");
> +       if (IS_ERR(this->core_clk))
> +               return PTR_ERR(this->core_clk);
> +
> +       this->aon_clk = devm_clk_get(&pdev->dev, "aon");
> +       if (IS_ERR(this->aon_clk))
> +               return PTR_ERR(this->aon_clk);
> +
> +       r = qcom_nandc_parse_dt(pdev);
> +       if (r)
> +               return r;
> +
> +       r = qcom_nandc_alloc(this);
> +       if (r)
> +               return r;
> +
> +       r = clk_prepare_enable(this->core_clk);
> +       if (r)
> +               goto err_core_clk;
> +
> +       r = clk_prepare_enable(this->aon_clk);
> +       if (r)
> +               goto err_aon_clk;
> +
> +       r = qcom_nandc_init(this);
> +       if (r)
> +               goto err_init;
> +
> +       return 0;
> +
> +err_init:
> +       clk_disable_unprepare(this->aon_clk);
> +err_aon_clk:
> +       clk_disable_unprepare(this->core_clk);
> +err_core_clk:
> +       qcom_nandc_unalloc(this);
> +
> +       return r;
> +}
> +
> +static int qcom_nandc_remove(struct platform_device *pdev)
> +{
> +       struct qcom_nandc_data *this;
> +
> +       this = platform_get_drvdata(pdev);
> +       if (!this)
> +               return -ENODEV;
> +
> +       qcom_nandc_unalloc(this);
> +
> +       clk_disable_unprepare(this->aon_clk);
> +       clk_disable_unprepare(this->core_clk);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver qcom_nandc_driver = {
> +       .driver = {
> +               .name = "qcom-nandc",
> +               .of_match_table = qcom_nandc_of_match,
> +       },
> +       .probe   = qcom_nandc_probe,
> +       .remove  = qcom_nandc_remove,
> +};
> +module_platform_driver(qcom_nandc_driver);
> +
> +MODULE_AUTHOR("Archit Taneja <architt@codeaurora.org>");
> +MODULE_DESCRIPTION("Qualcomm NAND Controller driver");
> +MODULE_LICENSE("GPL");
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
