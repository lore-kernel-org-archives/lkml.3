Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJXTLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:11:17 -0400
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:54274
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754674AbaJXTLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:11:13 -0400
From: Graham Moore <grmoore@opensource.altera.com>
To: <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: [RFC 2/2] This is a kernel driver for the Cadence QSPI Flash Controller.  It uses the spi-nor framework.
Date: Fri, 24 Oct 2014 13:34:21 -0500
Message-ID: <1414175661-9249-3-git-send-email-grmoore@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414175661-9249-1-git-send-email-grmoore@opensource.altera.com>
References: <1414175661-9249-1-git-send-email-grmoore@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0031.eurprd04.prod.outlook.com (10.242.87.149) To
 BL2PR03MB435.namprd03.prod.outlook.com (10.141.92.24)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB435;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(104166001)(86362001)(575784001)(15202345003)(93916002)(50466002)(92566001)(66066001)(92726001)(21056001)(102836001)(48376002)(76176999)(50986999)(101416001)(64706001)(20776003)(47776003)(69596002)(19580395003)(19580405001)(50226001)(62966002)(4396001)(15975445006)(85852003)(89996001)(31966008)(87976001)(88136002)(87286001)(76482002)(33646002)(53416004)(2351001)(107046002)(105586002)(95666004)(110136001)(99396003)(77096002)(106356001)(97736003)(85306004)(81156004)(40100003)(42186005)(80022003)(229853001)(46102003)(122386002)(120916001)(77156001)(2004002)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB435;H:lava-test-server.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
---
 drivers/mtd/spi-nor/Kconfig           |    6 +
 drivers/mtd/spi-nor/Makefile          |    1 +
 drivers/mtd/spi-nor/cadence-quadspi.c | 1349 +++++++++++++++++++++++++++++++++
 3 files changed, 1356 insertions(+)
 create mode 100644 drivers/mtd/spi-nor/cadence-quadspi.c

diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
index 64a4f0e..9485481 100644
--- a/drivers/mtd/spi-nor/Kconfig
+++ b/drivers/mtd/spi-nor/Kconfig
@@ -28,4 +28,10 @@ config SPI_FSL_QUADSPI
 	  This enables support for the Quad SPI controller in master mode.
 	  We only connect the NOR to this controller now.
 
+config SPI_CADENCE_QUADSPI
+	tristate "Cadence Quad SPI controller"
+	depends on ARCH_SOCFPGA
+	help
+	  This enables support for the Cadence Quad SPI controller and NOR flash.
+
 endif # MTD_SPI_NOR
diff --git a/drivers/mtd/spi-nor/Makefile b/drivers/mtd/spi-nor/Makefile
index 6a7ce14..372628c 100644
--- a/drivers/mtd/spi-nor/Makefile
+++ b/drivers/mtd/spi-nor/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_MTD_SPI_NOR)	+= spi-nor.o
+obj-$(CONFIG_SPI_CADENCE_QUADSPI)	+= cadence-quadspi.o
 obj-$(CONFIG_SPI_FSL_QUADSPI)	+= fsl-quadspi.o
diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
new file mode 100644
index 0000000..51c65de
--- /dev/null
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -0,0 +1,1349 @@
+/*
+ * Driver for Cadence QSPI Controller
+ *
+ * Copyright Altera Corporation (C) 2012-2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/spi/spi.h>
+#include <linux/mtd/spi-nor.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+
+#define CQSPI_NAME			"cadence-qspi"
+#define CQSPI_MAX_TRANS				(2)
+#define CQSPI_MAX_CHIP_SELECT			(16)
+
+struct cqspi_flash_pdata {
+	struct mtd_info mtd;
+	struct spi_nor nor;
+	unsigned int page_size;
+	unsigned int block_size;
+	unsigned int read_delay;
+	unsigned int tshsl_ns;
+	unsigned int tsd2d_ns;
+	unsigned int tchsh_ns;
+	unsigned int tslch_ns;
+};
+
+struct cqspi_st {
+	struct platform_device *pdev;
+	struct device *dev;
+
+	u32 clk_rate;
+	struct clk *clk;
+	unsigned int sclk;
+
+	void __iomem *iobase;
+	void __iomem *ahb_base;
+	struct completion transfer_complete;
+	int irq;
+	unsigned int irq_status;
+	unsigned int irq_mask;
+	int current_cs;
+	unsigned int bus_num;
+	unsigned int num_chipselect;
+	unsigned int ahb_phy_addr;
+	unsigned int master_ref_clk_hz;
+	unsigned int ext_decoder;
+	unsigned int fifo_depth;
+	unsigned int num_chipselects_used;
+	struct cqspi_flash_pdata f_pdata[CQSPI_MAX_CHIP_SELECT];
+};
+
+static struct of_device_id cqspi_dt_ids[] = {
+	{ .compatible = "cdns,qspi-nor",},
+	{ /* end of table */}
+};
+MODULE_DEVICE_TABLE(of, cqspi_dt_ids);
+
+#define CQSPI_WRITEL		__raw_writel
+#define CQSPI_READL		__raw_readl
+
+/* Operation timeout value */
+#define CQSPI_TIMEOUT_MS			(5000)
+#define CQSPI_POLL_IDLE_RETRY			(3)
+
+#define CQSPI_FIFO_WIDTH			(4)
+
+/* Controller sram size in word */
+#define CQSPI_REG_SRAM_RESV_WORDS		(2)
+#define CQSPI_REG_SRAM_PARTITION_WR		(1)
+
+#define CQSPI_REG_SRAM_THRESHOLD_BYTES		(50)
+
+/* Instruction type */
+#define CQSPI_INST_TYPE_SINGLE			(0)
+#define CQSPI_INST_TYPE_DUAL			(1)
+#define CQSPI_INST_TYPE_QUAD			(2)
+
+#define CQSPI_DUMMY_CLKS_PER_BYTE		(8)
+#define CQSPI_DUMMY_BYTES_MAX			(4)
+
+#define CQSPI_STIG_DATA_LEN_MAX			(8)
+
+#define CQSPI_INDIRECTTRIGGER_ADDR_MASK		(0xFFFFF)
+
+/* Register map */
+#define CQSPI_REG_CONFIG			0x00
+#define CQSPI_REG_CONFIG_ENABLE_MASK		(1 << 0)
+#define CQSPI_REG_CONFIG_DECODE_MASK		(1 << 9)
+#define CQSPI_REG_CONFIG_CHIPSELECT_LSB		10
+#define CQSPI_REG_CONFIG_DMA_MASK		(1 << 15)
+#define CQSPI_REG_CONFIG_BAUD_LSB		19
+#define CQSPI_REG_CONFIG_IDLE_LSB		31
+#define CQSPI_REG_CONFIG_CHIPSELECT_MASK	0xF
+#define CQSPI_REG_CONFIG_BAUD_MASK		0xF
+
+#define CQSPI_REG_RD_INSTR			0x04
+#define CQSPI_REG_RD_INSTR_OPCODE_LSB		0
+#define CQSPI_REG_RD_INSTR_TYPE_INSTR_LSB	8
+#define CQSPI_REG_RD_INSTR_TYPE_ADDR_LSB	12
+#define CQSPI_REG_RD_INSTR_TYPE_DATA_LSB	16
+#define CQSPI_REG_RD_INSTR_MODE_EN_LSB		20
+#define CQSPI_REG_RD_INSTR_DUMMY_LSB		24
+#define CQSPI_REG_RD_INSTR_TYPE_INSTR_MASK	0x3
+#define CQSPI_REG_RD_INSTR_TYPE_ADDR_MASK	0x3
+#define CQSPI_REG_RD_INSTR_TYPE_DATA_MASK	0x3
+#define CQSPI_REG_RD_INSTR_DUMMY_MASK		0x1F
+
+#define CQSPI_REG_WR_INSTR			0x08
+#define CQSPI_REG_WR_INSTR_OPCODE_LSB		0
+
+#define CQSPI_REG_DELAY				0x0C
+#define CQSPI_REG_DELAY_TSLCH_LSB		0
+#define CQSPI_REG_DELAY_TCHSH_LSB		8
+#define CQSPI_REG_DELAY_TSD2D_LSB		16
+#define CQSPI_REG_DELAY_TSHSL_LSB		24
+#define CQSPI_REG_DELAY_TSLCH_MASK		0xFF
+#define CQSPI_REG_DELAY_TCHSH_MASK		0xFF
+#define CQSPI_REG_DELAY_TSD2D_MASK		0xFF
+#define CQSPI_REG_DELAY_TSHSL_MASK		0xFF
+
+#define CQSPI_REG_READCAPTURE			0x10
+#define CQSPI_REG_READCAPTURE_BYPASS_LSB	0
+#define CQSPI_REG_READCAPTURE_DELAY_LSB		1
+#define CQSPI_REG_READCAPTURE_DELAY_MASK	0xF
+
+#define CQSPI_REG_SIZE				0x14
+#define CQSPI_REG_SIZE_ADDRESS_LSB		0
+#define CQSPI_REG_SIZE_PAGE_LSB			4
+#define CQSPI_REG_SIZE_BLOCK_LSB		16
+#define CQSPI_REG_SIZE_ADDRESS_MASK		0xF
+#define CQSPI_REG_SIZE_PAGE_MASK		0xFFF
+#define CQSPI_REG_SIZE_BLOCK_MASK		0x3F
+
+#define CQSPI_REG_SRAMPARTITION			0x18
+#define CQSPI_REG_INDIRECTTRIGGER		0x1C
+
+#define CQSPI_REG_DMA				0x20
+#define CQSPI_REG_DMA_SINGLE_LSB		0
+#define CQSPI_REG_DMA_BURST_LSB			8
+#define CQSPI_REG_DMA_SINGLE_MASK		0xFF
+#define CQSPI_REG_DMA_BURST_MASK		0xFF
+
+#define CQSPI_REG_REMAP				0x24
+#define CQSPI_REG_MODE_BIT			0x28
+
+#define CQSPI_REG_SDRAMLEVEL			0x2C
+#define CQSPI_REG_SDRAMLEVEL_RD_LSB		0
+#define CQSPI_REG_SDRAMLEVEL_WR_LSB		16
+#define CQSPI_REG_SDRAMLEVEL_RD_MASK		0xFFFF
+#define CQSPI_REG_SDRAMLEVEL_WR_MASK		0xFFFF
+
+#define CQSPI_REG_IRQSTATUS			0x40
+#define CQSPI_REG_IRQMASK			0x44
+
+#define CQSPI_REG_INDIRECTRD			0x60
+#define CQSPI_REG_INDIRECTRD_START_MASK		(1 << 0)
+#define CQSPI_REG_INDIRECTRD_CANCEL_MASK	(1 << 1)
+#define CQSPI_REG_INDIRECTRD_DONE_MASK		(1 << 5)
+
+#define CQSPI_REG_INDIRECTRDWATERMARK		0x64
+#define CQSPI_REG_INDIRECTRDSTARTADDR		0x68
+#define CQSPI_REG_INDIRECTRDBYTES		0x6C
+
+#define CQSPI_REG_CMDCTRL			0x90
+#define CQSPI_REG_CMDCTRL_EXECUTE_MASK		(1 << 0)
+#define CQSPI_REG_CMDCTRL_INPROGRESS_MASK	(1 << 1)
+#define CQSPI_REG_CMDCTRL_WR_BYTES_LSB		12
+#define CQSPI_REG_CMDCTRL_WR_EN_LSB		15
+#define CQSPI_REG_CMDCTRL_ADD_BYTES_LSB		16
+#define CQSPI_REG_CMDCTRL_ADDR_EN_LSB		19
+#define CQSPI_REG_CMDCTRL_RD_BYTES_LSB		20
+#define CQSPI_REG_CMDCTRL_RD_EN_LSB		23
+#define CQSPI_REG_CMDCTRL_OPCODE_LSB		24
+#define CQSPI_REG_CMDCTRL_WR_BYTES_MASK		0x7
+#define CQSPI_REG_CMDCTRL_ADD_BYTES_MASK	0x3
+#define CQSPI_REG_CMDCTRL_RD_BYTES_MASK		0x7
+
+#define CQSPI_REG_INDIRECTWR			0x70
+#define CQSPI_REG_INDIRECTWR_START_MASK		(1 << 0)
+#define CQSPI_REG_INDIRECTWR_CANCEL_MASK	(1 << 1)
+#define CQSPI_REG_INDIRECTWR_DONE_MASK		(1 << 5)
+
+#define CQSPI_REG_INDIRECTWRWATERMARK		0x74
+#define CQSPI_REG_INDIRECTWRSTARTADDR		0x78
+#define CQSPI_REG_INDIRECTWRBYTES		0x7C
+
+#define CQSPI_REG_CMDADDRESS			0x94
+#define CQSPI_REG_CMDREADDATALOWER		0xA0
+#define CQSPI_REG_CMDREADDATAUPPER		0xA4
+#define CQSPI_REG_CMDWRITEDATALOWER		0xA8
+#define CQSPI_REG_CMDWRITEDATAUPPER		0xAC
+
+/* Interrupt status bits */
+#define CQSPI_REG_IRQ_MODE_ERR			(1 << 0)
+#define CQSPI_REG_IRQ_UNDERFLOW			(1 << 1)
+#define CQSPI_REG_IRQ_IND_COMP			(1 << 2)
+#define CQSPI_REG_IRQ_IND_RD_REJECT		(1 << 3)
+#define CQSPI_REG_IRQ_WR_PROTECTED_ERR		(1 << 4)
+#define CQSPI_REG_IRQ_ILLEGAL_AHB_ERR		(1 << 5)
+#define CQSPI_REG_IRQ_WATERMARK			(1 << 6)
+#define CQSPI_REG_IRQ_IND_RD_OVERFLOW		(1 << 12)
+
+#define CQSPI_IRQ_STATUS_ERR		(CQSPI_REG_IRQ_MODE_ERR		| \
+					 CQSPI_REG_IRQ_IND_RD_REJECT	| \
+					 CQSPI_REG_IRQ_WR_PROTECTED_ERR	| \
+					 CQSPI_REG_IRQ_ILLEGAL_AHB_ERR)
+
+#define CQSPI_IRQ_MASK_RD		(CQSPI_REG_IRQ_WATERMARK	| \
+					 CQSPI_REG_IRQ_IND_RD_OVERFLOW	| \
+					 CQSPI_REG_IRQ_IND_COMP)
+
+#define CQSPI_IRQ_MASK_WR		(CQSPI_REG_IRQ_IND_COMP		| \
+					 CQSPI_REG_IRQ_WATERMARK	| \
+					 CQSPI_REG_IRQ_UNDERFLOW)
+
+#define CQSPI_IRQ_STATUS_MASK		(0xFFFFFFFF)
+
+#define CQSPI_REG_IS_IDLE(base)						\
+		((CQSPI_READL(base + CQSPI_REG_CONFIG) >>		\
+			CQSPI_REG_CONFIG_IDLE_LSB) & 0x1)
+
+#define CQSPI_CAL_DELAY(tdelay_ns, tref_ns, tsclk_ns)			\
+		((((tdelay_ns) - (tsclk_ns)) / (tref_ns)))
+
+#define CQSPI_GET_RD_SRAM_LEVEL(reg_base)				\
+		(((CQSPI_READL(reg_base + CQSPI_REG_SDRAMLEVEL)) >>	\
+		CQSPI_REG_SDRAMLEVEL_RD_LSB) & CQSPI_REG_SDRAMLEVEL_RD_MASK)
+
+#define CQSPI_READ_IRQ_STATUS(reg_base)					\
+		CQSPI_READL(reg_base + CQSPI_REG_IRQSTATUS)
+
+#define CQSPI_CLEAR_IRQ(reg_base, status)				\
+		CQSPI_WRITEL(status, reg_base + CQSPI_REG_IRQSTATUS)
+
+/* forward declarations */
+static void cqspi_switch_cs(struct cqspi_st *cqspi,
+	unsigned int cs);
+static void cqspi_controller_enable(struct cqspi_st *cqspi);
+static void cqspi_controller_disable(struct cqspi_st *cqspi);
+static void cqspi_config_baudrate_div(struct cqspi_st *cqspi,
+		unsigned int ref_clk_hz, unsigned int sclk_hz);
+static void cqspi_delay(struct cqspi_st *cqspi,
+	unsigned int ref_clk, unsigned int sclk_hz);
+static void cqspi_readdata_capture(struct cqspi_st *cqspi,
+			unsigned int bypass, unsigned int delay);
+static int cqspi_prep(struct spi_nor *nor, enum spi_nor_ops ops);
+static unsigned int cqspi_wait_idle(struct cqspi_st *cqspi);
+
+static unsigned int cqspi_init_timeout(const unsigned long timeout_in_ms)
+{
+	return jiffies + msecs_to_jiffies(timeout_in_ms);
+}
+
+static unsigned int cqspi_check_timeout(const unsigned long timeout)
+{
+	return time_before(jiffies, timeout);
+}
+
+static void cqspi_fifo_read(void *dest, const void *src_ahb_addr,
+			 unsigned int bytes)
+{
+	unsigned int temp;
+	int remaining = bytes;
+	unsigned int *dest_ptr = (unsigned int *)dest;
+	unsigned int *src_ptr = (unsigned int *)src_ahb_addr;
+
+	while (remaining > 0) {
+		if (remaining >= CQSPI_FIFO_WIDTH) {
+			*dest_ptr = CQSPI_READL(src_ptr);
+			remaining -= CQSPI_FIFO_WIDTH;
+		} else {
+			/* dangling bytes */
+			temp = CQSPI_READL(src_ptr);
+			memcpy(dest_ptr, &temp, remaining);
+			break;
+		}
+		dest_ptr++;
+	}
+}
+
+static void cqspi_fifo_write(void *dest_ahb_addr,
+					const void *src, unsigned int bytes)
+{
+	unsigned int temp;
+	int remaining = bytes;
+	unsigned int *dest_ptr = (unsigned int *)dest_ahb_addr;
+	unsigned int *src_ptr = (unsigned int *)src;
+
+	while (remaining > 0) {
+		if (remaining >= CQSPI_FIFO_WIDTH) {
+			CQSPI_WRITEL(*src_ptr, dest_ptr);
+			remaining -= CQSPI_FIFO_WIDTH;
+		} else {
+			/* dangling bytes */
+			memcpy(&temp, src_ptr, remaining);
+			CQSPI_WRITEL(temp, dest_ptr);
+			break;
+		}
+		src_ptr++;
+	}
+}
+
+static irqreturn_t cqspi_irq_handler(int this_irq, void *dev)
+{
+	struct cqspi_st *cqspi = dev;
+
+	/* Read interrupt status */
+	cqspi->irq_status = CQSPI_READ_IRQ_STATUS(cqspi->iobase);
+
+	/* Clear interrupt */
+	CQSPI_CLEAR_IRQ(cqspi->iobase, cqspi->irq_status);
+
+	if (cqspi->irq_status & cqspi->irq_mask)
+		complete(&cqspi->transfer_complete);
+
+	return IRQ_HANDLED;
+}
+
+static int cqspi_find_chipselect(struct spi_nor *nor)
+{
+	int cs;
+	struct cqspi_st *cqspi = nor->priv;
+
+	for (cs = 0; cs < cqspi->num_chipselects_used; cs++)
+		if (nor == &cqspi->f_pdata[cs].nor)
+			break;
+	return cs;
+}
+
+static int cqspi_exec_flash_cmd(struct cqspi_st *cqspi, unsigned int reg)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int timeout;
+
+	/* Write the CMDCTRL without start execution. */
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CMDCTRL);
+	/* Start execute */
+	reg |= CQSPI_REG_CMDCTRL_EXECUTE_MASK;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CMDCTRL);
+
+	/* Polling for completion. */
+	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
+	while (cqspi_check_timeout(timeout)) {
+		reg = CQSPI_READL(reg_base + CQSPI_REG_CMDCTRL) &
+			CQSPI_REG_CMDCTRL_INPROGRESS_MASK;
+		if (!reg)
+			break;
+	}
+
+	if (reg != 0) {
+		dev_err(cqspi->dev, "flash cmd execute time out\n");
+		return -EIO;
+	}
+
+	/* Polling QSPI idle status. */
+	if (!cqspi_wait_idle(cqspi))
+		return -EIO;
+
+	return 0;
+}
+
+static int cqspi_command_read(struct spi_nor *nor,
+	const u8 *txbuf, unsigned n_tx,
+	u8 *rxbuf, unsigned n_rx)
+{
+	unsigned int reg;
+	unsigned int read_len;
+	int status;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+
+	if (!n_rx || n_rx > CQSPI_STIG_DATA_LEN_MAX || rxbuf == NULL) {
+		dev_err(cqspi->dev, "Invalid input argument, len %d rxbuf 0x%08x\n",
+			n_rx, (unsigned int)rxbuf);
+		return -EINVAL;
+	}
+
+	reg = txbuf[0] << CQSPI_REG_CMDCTRL_OPCODE_LSB;
+
+	reg |= (0x1 << CQSPI_REG_CMDCTRL_RD_EN_LSB);
+
+	/* 0 means 1 byte. */
+	reg |= (((n_rx - 1) & CQSPI_REG_CMDCTRL_RD_BYTES_MASK)
+		<< CQSPI_REG_CMDCTRL_RD_BYTES_LSB);
+	status = cqspi_exec_flash_cmd(cqspi, reg);
+	if (status != 0)
+		return status;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_CMDREADDATALOWER);
+
+	/* Put the read value into rx_buf */
+	read_len = (n_rx > 4) ? 4 : n_rx;
+	memcpy(rxbuf, &reg, read_len);
+	rxbuf += read_len;
+
+	if (n_rx > 4) {
+		reg = CQSPI_READL(reg_base + CQSPI_REG_CMDREADDATAUPPER);
+
+		read_len = n_rx - read_len;
+		memcpy(rxbuf, &reg, read_len);
+	}
+
+	return 0;
+}
+
+static int cqspi_command_write(struct spi_nor *nor,
+	u8 opcode, const u8 *txbuf, unsigned n_tx)
+{
+	unsigned int reg;
+	unsigned int data;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+
+	if (n_tx > 4 || (n_tx && txbuf == NULL)) {
+		dev_err(cqspi->dev, "Invalid input argument, cmdlen %d txbuf 0x%08x\n",
+			n_tx, (unsigned int)txbuf);
+		return -EINVAL;
+	}
+
+	reg = opcode << CQSPI_REG_CMDCTRL_OPCODE_LSB;
+	if (n_tx) {
+		reg |= (0x1 << CQSPI_REG_CMDCTRL_WR_EN_LSB);
+		reg |= (n_tx & CQSPI_REG_CMDCTRL_WR_BYTES_MASK)
+			<< CQSPI_REG_CMDCTRL_WR_BYTES_LSB;
+		memcpy(&data, txbuf, n_tx);
+		CQSPI_WRITEL(data, reg_base + CQSPI_REG_CMDWRITEDATALOWER);
+	}
+
+	return cqspi_exec_flash_cmd(cqspi, reg);
+}
+
+static int cqspi_command_write_addr(struct spi_nor *nor,
+	u8 opcode, unsigned int addr)
+{
+	unsigned int reg;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+
+	reg = opcode << CQSPI_REG_CMDCTRL_OPCODE_LSB;
+	/* Command with address */
+	reg |= (0x1 << CQSPI_REG_CMDCTRL_ADDR_EN_LSB);
+	/* Number of bytes to write. */
+	reg |= ((nor->addr_width-1) & CQSPI_REG_CMDCTRL_ADD_BYTES_MASK)
+		<< CQSPI_REG_CMDCTRL_ADD_BYTES_LSB;
+
+	CQSPI_WRITEL(addr, reg_base + CQSPI_REG_CMDADDRESS);
+
+	return cqspi_exec_flash_cmd(cqspi, reg);
+}
+
+static int cqspi_indirect_read_setup(struct spi_nor *nor,
+	unsigned int from_addr)
+{
+	unsigned int reg;
+	unsigned int dummy_clk;
+	unsigned int dummy_bytes;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int ahb_phy_addr = cqspi->ahb_phy_addr;
+
+	CQSPI_WRITEL((ahb_phy_addr & CQSPI_INDIRECTTRIGGER_ADDR_MASK),
+		reg_base + CQSPI_REG_INDIRECTTRIGGER);
+
+	reg = nor->read_opcode << CQSPI_REG_RD_INSTR_OPCODE_LSB;
+
+	if (nor->flash_read == SPI_NOR_QUAD)
+		reg |= (CQSPI_INST_TYPE_QUAD
+			<< CQSPI_REG_RD_INSTR_TYPE_DATA_LSB);
+
+	CQSPI_WRITEL(from_addr, reg_base + CQSPI_REG_INDIRECTRDSTARTADDR);
+
+	/* The remaining length is dummy bytes. */
+	dummy_bytes = nor->read_dummy;
+
+	/* Setup dummy clock cycles */
+	if (dummy_bytes) {
+		if (dummy_bytes > CQSPI_DUMMY_BYTES_MAX)
+			dummy_bytes = CQSPI_DUMMY_BYTES_MAX;
+
+		reg |= (1 << CQSPI_REG_RD_INSTR_MODE_EN_LSB);
+		/* Set all high to ensure chip doesn't enter XIP */
+		CQSPI_WRITEL(0xFF, reg_base + CQSPI_REG_MODE_BIT);
+
+		/* Convert to clock cycles. */
+		dummy_clk = dummy_bytes * CQSPI_DUMMY_CLKS_PER_BYTE;
+		/* Need to minus the mode byte (8 clocks). */
+		dummy_clk -= CQSPI_DUMMY_CLKS_PER_BYTE;
+		if (dummy_clk)
+			reg |= (dummy_clk & CQSPI_REG_RD_INSTR_DUMMY_MASK)
+				<< CQSPI_REG_RD_INSTR_DUMMY_LSB;
+	}
+
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_RD_INSTR);
+
+	/* Set device size */
+	reg = CQSPI_READL(reg_base + CQSPI_REG_SIZE);
+	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
+	reg |= (nor->addr_width - 1);
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_SIZE);
+	return 0;
+}
+
+static int cqspi_indirect_read_execute(struct spi_nor *nor,
+	u8 *rxbuf, unsigned n_rx)
+{
+	int ret = 0;
+	unsigned int reg = 0;
+	unsigned int bytes_to_read = 0;
+	unsigned int timeout;
+	unsigned int watermark = CQSPI_REG_SRAM_THRESHOLD_BYTES;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+	void __iomem *ahb_base = cqspi->ahb_base;
+	int remaining = (int)n_rx;
+
+	if (remaining < watermark)
+		watermark = remaining;
+
+	CQSPI_WRITEL(watermark, reg_base + CQSPI_REG_INDIRECTRDWATERMARK);
+	CQSPI_WRITEL(remaining, reg_base + CQSPI_REG_INDIRECTRDBYTES);
+	CQSPI_WRITEL(cqspi->fifo_depth - CQSPI_REG_SRAM_RESV_WORDS,
+		reg_base + CQSPI_REG_SRAMPARTITION);
+
+	/* Clear all interrupts. */
+	CQSPI_WRITEL(CQSPI_IRQ_STATUS_MASK, reg_base + CQSPI_REG_IRQSTATUS);
+
+	cqspi->irq_mask = CQSPI_IRQ_MASK_RD;
+	CQSPI_WRITEL(cqspi->irq_mask, reg_base + CQSPI_REG_IRQMASK);
+
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTRD_START_MASK,
+			reg_base + CQSPI_REG_INDIRECTRD);
+
+	while (remaining > 0) {
+		bytes_to_read = CQSPI_GET_RD_SRAM_LEVEL(reg_base);
+		if (bytes_to_read != 0) {
+			bytes_to_read *= CQSPI_FIFO_WIDTH;
+			bytes_to_read = bytes_to_read > remaining
+					? remaining : bytes_to_read;
+			cqspi_fifo_read(rxbuf, ahb_base, bytes_to_read);
+			rxbuf += bytes_to_read;
+			remaining -= bytes_to_read;
+		} else {
+			ret = wait_for_completion_timeout(&cqspi->transfer_complete,
+				CQSPI_TIMEOUT_MS);
+			if (!ret) {
+				dev_err(cqspi->dev, "Indirect read timeout\n");
+				ret = -ETIMEDOUT;
+				goto failrd;
+			}
+		}
+	}
+
+	/* Check indirect done status */
+	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
+	while (cqspi_check_timeout(timeout)) {
+		reg = CQSPI_READL(reg_base + CQSPI_REG_INDIRECTRD);
+		if (reg & CQSPI_REG_INDIRECTRD_DONE_MASK)
+			break;
+	}
+
+	if (!(reg & CQSPI_REG_INDIRECTRD_DONE_MASK)) {
+		dev_err(cqspi->dev,
+			"Indirect read completion error 0x%08x\n", reg);
+		ret = -ETIMEDOUT;
+		goto failrd;
+	}
+
+	/* Disable interrupt */
+	CQSPI_WRITEL(0, reg_base + CQSPI_REG_IRQMASK);
+
+	/* Clear indirect completion status */
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTRD_DONE_MASK,
+		reg_base + CQSPI_REG_INDIRECTRD);
+
+	return 0;
+
+failrd:
+	/* Disable interrupt */
+	CQSPI_WRITEL(0, reg_base + CQSPI_REG_IRQMASK);
+
+	/* Cancel the indirect read */
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTWR_CANCEL_MASK,
+			reg_base + CQSPI_REG_INDIRECTRD);
+	return ret;
+}
+
+static int cqspi_indirect_write_setup(struct spi_nor *nor,
+	unsigned int to_addr)
+{
+	unsigned int reg;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+
+	/* Set opcode. */
+	reg = nor->program_opcode << CQSPI_REG_WR_INSTR_OPCODE_LSB;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_WR_INSTR);
+
+	CQSPI_WRITEL(to_addr, reg_base + CQSPI_REG_INDIRECTWRSTARTADDR);
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_SIZE);
+	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
+	reg |= (nor->addr_width - 1);
+	CQSPI_WRITEL(reg, reg_base +  CQSPI_REG_SIZE);
+	return 0;
+}
+
+static int cqspi_indirect_write_execute(struct spi_nor *nor,
+	const u8 *txbuf, unsigned n_tx)
+{
+	int ret;
+	unsigned int timeout;
+	unsigned int reg = 0;
+	struct cqspi_st *cqspi = nor->priv;
+	void __iomem *reg_base = cqspi->iobase;
+	void __iomem *ahb_base = cqspi->ahb_base;
+	struct cqspi_flash_pdata *f_pdata =
+		&cqspi->f_pdata[cqspi->current_cs];
+
+	unsigned int page_size = f_pdata->page_size;
+	int remaining = (int)n_tx;
+	unsigned int write_bytes;
+
+	CQSPI_WRITEL(remaining, reg_base + CQSPI_REG_INDIRECTWRBYTES);
+
+	CQSPI_WRITEL(CQSPI_REG_SRAM_THRESHOLD_BYTES, reg_base +
+			CQSPI_REG_INDIRECTWRWATERMARK);
+
+	CQSPI_WRITEL(CQSPI_REG_SRAM_PARTITION_WR,
+			reg_base + CQSPI_REG_SRAMPARTITION);
+
+	/* Clear all interrupts. */
+	CQSPI_WRITEL(CQSPI_IRQ_STATUS_MASK, reg_base + CQSPI_REG_IRQSTATUS);
+
+	cqspi->irq_mask = CQSPI_IRQ_MASK_WR;
+	CQSPI_WRITEL(cqspi->irq_mask, reg_base + CQSPI_REG_IRQMASK);
+
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTWR_START_MASK,
+			reg_base + CQSPI_REG_INDIRECTWR);
+
+	/* Write a page or remaining bytes. */
+	write_bytes = remaining > page_size ? page_size : remaining;
+	/* Fill up the data at the beginning */
+	cqspi_fifo_write(ahb_base, txbuf, write_bytes);
+	txbuf += write_bytes;
+	remaining -= write_bytes;
+
+	while (remaining > 0) {
+		ret = wait_for_completion_timeout(&cqspi->transfer_complete,
+			CQSPI_TIMEOUT_MS);
+		if (!ret) {
+			dev_err(cqspi->dev, "Indirect write timeout\n");
+			ret = -ETIMEDOUT;
+			goto failwr;
+		}
+
+		write_bytes = remaining > page_size ?
+			page_size : remaining;
+		cqspi_fifo_write(ahb_base, txbuf,
+			write_bytes);
+		txbuf  += write_bytes;
+		remaining -= write_bytes;
+	}
+
+	ret = wait_for_completion_timeout(&cqspi->transfer_complete,
+		CQSPI_TIMEOUT_MS);
+	if (!ret) {
+		dev_err(cqspi->dev, "Indirect write timeout\n");
+		ret = -ETIMEDOUT;
+		goto failwr;
+	}
+
+	/* Check indirect done status */
+	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
+	while (cqspi_check_timeout(timeout)) {
+		reg = CQSPI_READL(reg_base + CQSPI_REG_INDIRECTWR);
+		if (reg & CQSPI_REG_INDIRECTWR_DONE_MASK)
+			break;
+	}
+
+	if (!(reg & CQSPI_REG_INDIRECTWR_DONE_MASK)) {
+		dev_err(cqspi->dev,
+			"Indirect write completion error 0x%08x\n", reg);
+		ret = -ETIMEDOUT;
+		goto failwr;
+	}
+
+	/* Disable interrupt. */
+	CQSPI_WRITEL(0, reg_base + CQSPI_REG_IRQMASK);
+
+	/* Clear indirect completion status */
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTWR_DONE_MASK,
+		reg_base + CQSPI_REG_INDIRECTWR);
+
+	cqspi_wait_idle(cqspi);
+
+	if (nor->wait_till_ready(nor))
+		goto failwr;
+
+	return 0;
+
+failwr:
+	/* Disable interrupt. */
+	CQSPI_WRITEL(0, reg_base + CQSPI_REG_IRQMASK);
+
+	/* Cancel the indirect write */
+	CQSPI_WRITEL(CQSPI_REG_INDIRECTWR_CANCEL_MASK,
+		reg_base + CQSPI_REG_INDIRECTWR);
+	return ret;
+}
+
+static int cqspi_read_reg(struct spi_nor *nor, u8 opcode, u8 *buf, int len)
+{
+	int ret;
+
+	ret = cqspi_command_read(nor,
+		&opcode, 1, buf, len);
+	return ret;
+}
+
+static int cqspi_write_reg(struct spi_nor *nor, u8 opcode, u8 *buf, int len,
+			int write_enable)
+{
+	int ret = 0;
+
+	ret = cqspi_command_write(nor,
+		opcode, buf, len);
+	return ret;
+}
+
+static void cqspi_write(struct spi_nor *nor, loff_t to,
+		size_t len, size_t *retlen, const u_char *buf)
+{
+	int ret;
+
+	ret = cqspi_indirect_write_setup(nor, to);
+	if (ret == 0) {
+		ret = cqspi_indirect_write_execute(nor, buf, len);
+		if (ret == 0)
+			*retlen += len;
+	}
+}
+
+static int cqspi_read(struct spi_nor *nor, loff_t from,
+		size_t len, size_t *retlen, u_char *buf)
+{
+	int ret;
+
+	ret = cqspi_indirect_read_setup(nor, from);
+	if (ret == 0) {
+		ret = cqspi_indirect_read_execute(nor, buf, len);
+		if (ret == 0)
+			*retlen += len;
+	}
+	return ret;
+}
+
+static int cqspi_erase(struct spi_nor *nor, loff_t offs)
+{
+	int ret;
+
+	/* Send write enable, then erase commands. */
+	ret = cqspi_write_reg(nor, SPINOR_OP_WREN, NULL, 0, 0);
+	if (ret)
+		return ret;
+
+	/* Set up command buffer. */
+	ret = cqspi_command_write_addr(nor, nor->erase_opcode, offs);
+	if (ret)
+		return ret;
+
+	ret = nor->wait_till_ready(nor);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int cqspi_prep(struct spi_nor *nor, enum spi_nor_ops ops)
+{
+	struct cqspi_st *cqspi = nor->priv;
+	int cs = cqspi_find_chipselect(nor);
+	struct cqspi_flash_pdata *f_pdata;
+	unsigned int sclk;
+
+	/* Switch chip select. */
+	if (cqspi->current_cs != cs) {
+		cqspi->current_cs = cs;
+		cqspi_switch_cs(cqspi, cs);
+	}
+
+	/* Setup baudrate divisor and delays */
+	f_pdata = &cqspi->f_pdata[cqspi->current_cs];
+	sclk = cqspi->clk_rate;
+	if (cqspi->sclk != sclk) {
+		cqspi->sclk = sclk;
+		cqspi_controller_disable(cqspi);
+		cqspi_config_baudrate_div(cqspi,
+			cqspi->master_ref_clk_hz, sclk);
+		cqspi_delay(cqspi,
+			cqspi->master_ref_clk_hz, sclk);
+		cqspi_readdata_capture(cqspi, 1,
+			f_pdata->read_delay);
+		cqspi_controller_enable(cqspi);
+	}
+	return 0;
+}
+
+static void cqspi_unprep(struct spi_nor *nor, enum spi_nor_ops ops)
+{
+}
+
+static int cqspi_of_get_pdata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *nc;
+	struct cqspi_st *cqspi = dev_get_platdata(&pdev->dev);
+	struct cqspi_flash_pdata *f_pdata;
+	unsigned int cs;
+	unsigned int prop;
+
+	if (of_property_read_u32(np, "bus-num", &prop)) {
+		dev_err(&pdev->dev, "couldn't determine bus-num\n");
+		return -ENXIO;
+	}
+	cqspi->bus_num = prop;
+
+	if (of_property_read_u32(np, "num-chipselect", &prop)) {
+		dev_err(&pdev->dev, "couldn't determine num-chipselect\n");
+		return -ENXIO;
+	}
+	cqspi->num_chipselect = prop;
+
+	if (of_property_read_u32(np, "ext-decoder", &prop)) {
+		dev_err(&pdev->dev, "couldn't determine ext-decoder\n");
+		return -ENXIO;
+	}
+	cqspi->ext_decoder = prop;
+
+	if (of_property_read_u32(np, "fifo-depth", &prop)) {
+		dev_err(&pdev->dev, "couldn't determine fifo-depth\n");
+		return -ENXIO;
+	}
+	cqspi->fifo_depth = prop;
+
+	/* Get flash devices platform data */
+	cqspi->num_chipselects_used = 0;
+	for_each_child_of_node(np, nc) {
+		if (of_property_read_u32(nc, "reg", &cs)) {
+			dev_err(&pdev->dev, "couldn't determine reg\n");
+			return -ENXIO;
+		}
+
+		f_pdata = &cqspi->f_pdata[cs];
+
+		if (of_property_read_u32(nc, "page-size", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine page-size\n");
+			return -ENXIO;
+		}
+		f_pdata->page_size = prop;
+
+		if (of_property_read_u32(nc, "block-size", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine block-size\n");
+			return -ENXIO;
+		}
+		f_pdata->block_size = prop;
+
+		if (of_property_read_u32(nc, "read-delay", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine read-delay\n");
+			return -ENXIO;
+		}
+		f_pdata->read_delay = prop;
+
+		if (of_property_read_u32(nc, "tshsl-ns", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine tshsl-ns\n");
+			return -ENXIO;
+		}
+		f_pdata->tshsl_ns = prop;
+
+		if (of_property_read_u32(nc, "tsd2d-ns", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine tsd2d-ns\n");
+			return -ENXIO;
+		}
+		f_pdata->tsd2d_ns = prop;
+
+		if (of_property_read_u32(nc, "tchsh-ns", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine tchsh-ns\n");
+			return -ENXIO;
+		}
+		f_pdata->tchsh_ns = prop;
+
+		if (of_property_read_u32(nc, "tslch-ns", &prop)) {
+			dev_err(&pdev->dev, "couldn't determine tslch-ns\n");
+			return -ENXIO;
+		}
+		f_pdata->tslch_ns = prop;
+
+		cqspi->num_chipselects_used++;
+	}
+	return 0;
+}
+
+static void cqspi_readdata_capture(struct cqspi_st *cqspi,
+			unsigned int bypass, unsigned int delay)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int reg;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_READCAPTURE);
+
+	if (bypass)
+		reg |= (1 << CQSPI_REG_READCAPTURE_BYPASS_LSB);
+	else
+		reg &= ~(1 << CQSPI_REG_READCAPTURE_BYPASS_LSB);
+
+	reg &= ~(CQSPI_REG_READCAPTURE_DELAY_MASK
+		<< CQSPI_REG_READCAPTURE_DELAY_LSB);
+
+	reg |= ((delay & CQSPI_REG_READCAPTURE_DELAY_MASK)
+		<< CQSPI_REG_READCAPTURE_DELAY_LSB);
+
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_READCAPTURE);
+}
+
+static void cqspi_config_baudrate_div(struct cqspi_st *cqspi,
+		unsigned int ref_clk_hz, unsigned int sclk_hz)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int reg;
+	unsigned int div;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_CONFIG);
+	reg &= ~(CQSPI_REG_CONFIG_BAUD_MASK << CQSPI_REG_CONFIG_BAUD_LSB);
+
+	div = ref_clk_hz / sclk_hz;
+
+	/* Recalculate the baudrate divisor based on QSPI specification. */
+	if (div > 32)
+		div = 32;
+
+	/* Check if even number. */
+	if (div & 1)
+		div = (div / 2);
+	else
+		div = (div / 2) - 1;
+
+	div = (div & CQSPI_REG_CONFIG_BAUD_MASK) << CQSPI_REG_CONFIG_BAUD_LSB;
+	reg |= div;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CONFIG);
+}
+
+static void cqspi_chipselect(struct cqspi_st *cqspi,
+	unsigned int chip_select, unsigned int decoder_enable)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int reg;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_CONFIG);
+	/* docoder */
+	if (decoder_enable) {
+		reg |= CQSPI_REG_CONFIG_DECODE_MASK;
+	} else {
+		reg &= ~CQSPI_REG_CONFIG_DECODE_MASK;
+
+		/* Convert CS if without decoder.
+		 * CS0 to 4b'1110
+		 * CS1 to 4b'1101
+		 * CS2 to 4b'1011
+		 * CS3 to 4b'0111
+		 */
+		chip_select = 0xF & ~(1 << chip_select);
+	}
+
+	reg &= ~(CQSPI_REG_CONFIG_CHIPSELECT_MASK
+			<< CQSPI_REG_CONFIG_CHIPSELECT_LSB);
+	reg |= (chip_select & CQSPI_REG_CONFIG_CHIPSELECT_MASK)
+			<< CQSPI_REG_CONFIG_CHIPSELECT_LSB;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CONFIG);
+}
+
+static unsigned int calculate_ticks_for_ns(unsigned int ref_clk_hz,
+	unsigned int ns_val)
+{
+	unsigned int ticks;
+
+	ticks = ref_clk_hz;
+	ticks /= 1000;
+	ticks *= ns_val;
+	ticks +=  999999;
+	ticks /= 1000000;
+	return ticks;
+}
+
+static void cqspi_delay(struct cqspi_st *cqspi,
+	unsigned int ref_clk, unsigned int sclk_hz)
+{
+	void __iomem *iobase = cqspi->iobase;
+	struct cqspi_flash_pdata *f_pdata =
+		&cqspi->f_pdata[cqspi->current_cs];
+	unsigned int ref_clk_ns;
+	unsigned int sclk_ns;
+	unsigned int tshsl, tchsh, tslch, tsd2d;
+	unsigned int reg;
+	unsigned int tsclk;
+
+	/* Convert to ns. */
+	ref_clk_ns = (1000000000) / cqspi->master_ref_clk_hz;
+
+	/* Convert to ns. */
+	sclk_ns = (1000000000) / sclk_hz;
+
+	/* calculate the number of ref ticks for one sclk tick */
+	tsclk = (cqspi->master_ref_clk_hz + sclk_hz - 1) / sclk_hz;
+
+	tshsl = calculate_ticks_for_ns(cqspi->master_ref_clk_hz,
+		f_pdata->tshsl_ns);
+	/* this particular value must be at least one sclk */
+	if (tshsl < tsclk)
+		tshsl = tsclk;
+
+	tchsh = calculate_ticks_for_ns(cqspi->master_ref_clk_hz,
+		f_pdata->tchsh_ns);
+	tslch = calculate_ticks_for_ns(cqspi->master_ref_clk_hz,
+					f_pdata->tslch_ns);
+	tsd2d = calculate_ticks_for_ns(cqspi->master_ref_clk_hz,
+		f_pdata->tsd2d_ns);
+
+	reg = ((tshsl & CQSPI_REG_DELAY_TSHSL_MASK)
+			<< CQSPI_REG_DELAY_TSHSL_LSB);
+	reg |= ((tchsh & CQSPI_REG_DELAY_TCHSH_MASK)
+			<< CQSPI_REG_DELAY_TCHSH_LSB);
+	reg |= ((tslch & CQSPI_REG_DELAY_TSLCH_MASK)
+			<< CQSPI_REG_DELAY_TSLCH_LSB);
+	reg |= ((tsd2d & CQSPI_REG_DELAY_TSD2D_MASK)
+			<< CQSPI_REG_DELAY_TSD2D_LSB);
+	CQSPI_WRITEL(reg, iobase + CQSPI_REG_DELAY);
+}
+
+static void cqspi_switch_cs(struct cqspi_st *cqspi,
+	unsigned int cs)
+{
+	unsigned int reg;
+	struct cqspi_flash_pdata *f_pdata = &cqspi->f_pdata[cs];
+	void __iomem *iobase = cqspi->iobase;
+
+	cqspi_controller_disable(cqspi);
+
+	/* Configure page size and block size. */
+	reg = CQSPI_READL(iobase + CQSPI_REG_SIZE);
+	/* clear the previous value */
+	reg &= ~(CQSPI_REG_SIZE_PAGE_MASK << CQSPI_REG_SIZE_PAGE_LSB);
+	reg &= ~(CQSPI_REG_SIZE_BLOCK_MASK << CQSPI_REG_SIZE_BLOCK_LSB);
+	reg |= (f_pdata->page_size << CQSPI_REG_SIZE_PAGE_LSB);
+	reg |= (f_pdata->block_size << CQSPI_REG_SIZE_BLOCK_LSB);
+	CQSPI_WRITEL(reg, iobase + CQSPI_REG_SIZE);
+
+	/* configure the chip select */
+	cqspi_chipselect(cqspi, cs, cqspi->ext_decoder);
+	cqspi_controller_enable(cqspi);
+}
+
+static void cqspi_controller_enable(struct cqspi_st *cqspi)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int reg;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_CONFIG);
+	reg |= CQSPI_REG_CONFIG_ENABLE_MASK;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CONFIG);
+}
+
+static void cqspi_controller_disable(struct cqspi_st *cqspi)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int reg;
+
+	reg = CQSPI_READL(reg_base + CQSPI_REG_CONFIG);
+	reg &= ~CQSPI_REG_CONFIG_ENABLE_MASK;
+	CQSPI_WRITEL(reg, reg_base + CQSPI_REG_CONFIG);
+}
+
+static unsigned int cqspi_wait_idle(struct cqspi_st *cqspi)
+{
+	void __iomem *reg_base = cqspi->iobase;
+	unsigned int count = 0;
+	unsigned timeout;
+
+	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
+	while (cqspi_check_timeout(timeout)) {
+		if (CQSPI_REG_IS_IDLE(reg_base)) {
+			/* Read few times in succession to ensure it does
+			not transition low again */
+			count++;
+			if (count >= CQSPI_POLL_IDLE_RETRY)
+				return 1;
+		} else {
+			count = 0;
+		}
+	}
+
+	/* Timeout, in busy mode. */
+	dev_err(cqspi->dev, "QSPI is still busy after %dms timeout.\n",
+		CQSPI_TIMEOUT_MS);
+	return 0;
+}
+
+static void cqspi_controller_init(struct cqspi_st *cqspi)
+{
+	cqspi_controller_disable(cqspi);
+
+	/* Configure the remap address register, no remap */
+	CQSPI_WRITEL(0, cqspi->iobase + CQSPI_REG_REMAP);
+
+	/* Disable all interrupts. */
+	CQSPI_WRITEL(0, cqspi->iobase + CQSPI_REG_IRQMASK);
+
+	cqspi_controller_enable(cqspi);
+}
+
+static int cqspi_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct mtd_part_parser_data ppdata;
+	struct device *dev = &pdev->dev;
+	struct cqspi_st *cqspi;
+	struct spi_nor *nor;
+	struct mtd_info *mtd;
+	struct resource *res;
+	struct resource *res_ahb;
+	int ret;
+	int i;
+
+	cqspi = devm_kzalloc(dev, sizeof(*cqspi), GFP_KERNEL);
+	if (!cqspi)
+		return -ENOMEM;
+	pdev->dev.platform_data = cqspi;
+
+	ret = cqspi_of_get_pdata(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Get platform data failed.\n");
+		return -ENODEV;
+	}
+
+	cqspi->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(cqspi->clk)) {
+		dev_err(&pdev->dev, "cannot get qspi clk\n");
+		ret = PTR_ERR(cqspi->clk);
+		goto probe_failed;
+	}
+	cqspi->master_ref_clk_hz = clk_get_rate(cqspi->clk);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	cqspi->iobase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cqspi->iobase)) {
+		dev_err(&pdev->dev, "devm_ioremap_resource res 0 failed\n");
+		ret = PTR_ERR(cqspi->iobase);
+		goto probe_failed;
+	}
+
+	res_ahb = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	cqspi->ahb_phy_addr = res_ahb->start;
+	cqspi->ahb_base = devm_ioremap_resource(&pdev->dev, res_ahb);
+	if (IS_ERR(cqspi->ahb_base)) {
+		dev_err(&pdev->dev, "devm_ioremap_resource res 1 failed\n");
+		ret = PTR_ERR(cqspi->ahb_base);
+		goto probe_failed;
+	}
+
+	init_completion(&cqspi->transfer_complete);
+
+	cqspi->irq = platform_get_irq(pdev, 0);
+	if (cqspi->irq < 0) {
+		dev_err(&pdev->dev, "platform_get_irq failed\n");
+		ret = -ENXIO;
+		goto probe_failed;
+	}
+	ret = devm_request_irq(&pdev->dev, cqspi->irq,
+				cqspi_irq_handler,
+				0, pdev->name, cqspi);
+	if (ret) {
+		dev_err(&pdev->dev, "devm_request_irq failed\n");
+		goto probe_failed;
+	}
+
+	cqspi_wait_idle(cqspi);
+	cqspi_controller_init(cqspi);
+	cqspi->current_cs = -1;
+	cqspi->sclk = 0;
+
+	/* iterate the subnodes. */
+	i = 0;
+	for_each_available_child_of_node(dev->of_node, np) {
+		char modalias[40];
+
+		nor = &cqspi->f_pdata[i].nor;
+		mtd = &cqspi->f_pdata[i].mtd;
+
+		nor->mtd = mtd;
+		nor->dev = dev;
+		nor->priv = cqspi;
+		mtd->priv = nor;
+
+		/* fill the hooks */
+		nor->read_reg = cqspi_read_reg;
+		nor->write_reg = cqspi_write_reg;
+		nor->read = cqspi_read;
+		nor->write = cqspi_write;
+		nor->erase = cqspi_erase;
+
+		nor->prepare = cqspi_prep;
+		nor->unprepare = cqspi_unprep;
+
+		if (of_modalias_node(np, modalias, sizeof(modalias)) < 0)
+			goto probe_failed;
+
+		ret = spi_nor_scan(nor, modalias, SPI_NOR_QUAD);
+		if (ret)
+			goto probe_failed;
+
+		ret = of_property_read_u32(np, "spi-max-frequency",
+			&cqspi->clk_rate);
+		if (ret < 0)
+			goto probe_failed;
+
+		ppdata.of_node = np;
+		ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
+		if (ret)
+			goto probe_failed;
+
+		i++;
+		if (i == CQSPI_MAX_CHIP_SELECT)
+			break;
+	}
+	dev_info(dev, "Cadence QSPI NOR flash driver\n");
+	return 0;
+
+probe_failed:
+	dev_err(dev, "Cadence QSPI probe failed\n");
+	return ret;
+}
+
+static void set_all_into_3byte_mode(struct cqspi_st *cqspi)
+{
+	int i;
+
+	/* set all devices into 3-byte address mode */
+	for (i = 0; i < cqspi->num_chipselects_used; i++) {
+		struct spi_nor *nor = &cqspi->f_pdata[i].nor;
+
+		nor->write_reg(nor, SPINOR_OP_WREN, NULL, 0, 0);
+		nor->write_reg(nor, SPINOR_OP_EX4B, NULL, 0, 0);
+		nor->write_reg(nor, SPINOR_OP_WRDI, NULL, 0, 0);
+	}
+}
+
+static int cqspi_remove(struct platform_device *pdev)
+{
+	struct cqspi_st *cqspi = dev_get_platdata(&pdev->dev);
+	int i;
+
+	set_all_into_3byte_mode(cqspi);
+
+	cqspi_controller_disable(cqspi);
+
+	for (i = 0; i < cqspi->num_chipselects_used; i++)
+		mtd_device_unregister(&cqspi->f_pdata[i].mtd);
+
+	return 0;
+}
+
+static void cqspi_shutdown(struct platform_device *pdev)
+{
+	struct cqspi_st *cqspi = dev_get_platdata(&pdev->dev);
+
+	set_all_into_3byte_mode(cqspi);
+}
+
+#ifdef CONFIG_PM
+static int cqspi_suspend(struct device *dev)
+{
+	struct cqspi_st *cqspi = dev_get_platdata(dev);
+
+	cqspi_controller_disable(cqspi);
+	return 0;
+}
+
+static int cqspi_resume(struct device *dev)
+{
+	struct cqspi_st *cqspi = dev_get_platdata(dev);
+
+	cqspi_controller_enable(cqspi);
+	return 0;
+}
+
+static const struct dev_pm_ops cqspi__dev_pm_ops = {
+	.suspend	= cqspi_suspend,
+	.resume		= cqspi_resume,
+};
+
+#define CQSPI_DEV_PM_OPS	(&cqspi__dev_pm_ops)
+#else
+#define CQSPI_DEV_PM_OPS	NULL
+#endif
+
+static struct platform_driver cqspi_platform_driver = {
+	.probe		= cqspi_probe,
+	.remove		= cqspi_remove,
+	.shutdown	= cqspi_shutdown,
+	.driver = {
+		.name	= CQSPI_NAME,
+		.owner	= THIS_MODULE,
+		.bus	= &platform_bus_type,
+		.pm	= CQSPI_DEV_PM_OPS,
+		.of_match_table = cqspi_dt_ids,
+	},
+};
+module_platform_driver(cqspi_platform_driver);
+
+MODULE_DESCRIPTION("Cadence QSPI Controller Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" CQSPI_NAME);
+MODULE_AUTHOR("Ley Foon Tan <lftan@altera.com>");
+MODULE_AUTHOR("Graham Moore <grmoore@opensource.altera.com>");
-- 
1.7.9.5

