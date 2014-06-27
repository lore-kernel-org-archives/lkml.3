Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaF0DFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:05:03 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:7041
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615AbaF0DEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:04:31 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        "Punnaiah Choudary Kalluri" <punnaia@xilinx.com>
Subject: [PATCH RFC v3 1/4] nand: pl353: Add basic driver for arm pl353 smc nand interface
Date: Fri, 27 Jun 2014 08:33:56 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1403838239-4140-1-git-send-email-punnaia@xilinx.com>
References: <1403838239-4140-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <411b5873-6c13-4177-93a0-93b37e1cf1cc@BL2FFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(92726001)(50466002)(50226001)(81542001)(80022001)(93916002)(46102001)(106466001)(81342001)(74662001)(83072002)(92566001)(85852003)(86362001)(48376002)(79102001)(77156001)(31966008)(53416004)(33646001)(74502001)(2201001)(4396001)(21056001)(87286001)(85306003)(62966002)(76482001)(74316001)(70736001)(1496007)(77096002)(95666004)(6806004)(76176999)(50986999)(31696002)(83322001)(77982001)(47776003)(87936001)(102836001)(89996001)(44976005)(20776003)(104166001)(19580395003)(104016002)(99396002)(88136002)(19580405001)(107046002)(1121002)(921003)(2004002)(23106004)(217873001)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for arm pl353 static memory controller nand interface with
HW ECC support. This controller is used in xilinx zynq soc for interfacing
the nand flash memory.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v3:
 - implemented the proper error codes
 - further breakdown this patch to multiple sets
 - added the controller and driver details to Documentation section
 - updated the licenece to GPLv2
 - reorganized the pl353_nand_ecc_init function
Changes in v2:
 - use "depends on" rather than "select" option in kconfig
 - remove unused variable parts
 - remove dummy helper and use writel_relaxed directly
---
 drivers/mtd/nand/Kconfig      |    7 +
 drivers/mtd/nand/Makefile     |    1 +
 drivers/mtd/nand/pl353_nand.c |  855 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 863 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/nand/pl353_nand.c

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index f1cf503..a3462e6 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -492,6 +492,13 @@ config MTD_NAND_NUC900
 	  This enables the driver for the NAND Flash on evaluation board based
 	  on w90p910 / NUC9xx.
 
+config MTD_NAND_PL353
+	tristate "ARM Pl353 NAND flash driver"
+	depends on MTD_NAND && ARM
+	depends on PL353_SMC
+	help
+	  This enables access to the NAND flash device on PL353 SMC controller.
+
 config MTD_NAND_JZ4740
 	tristate "Support for JZ4740 SoC NAND controller"
 	depends on MACH_JZ4740
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 542b568..a4c2679 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -49,5 +49,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
+obj-$(CONFIG_MTD_NAND_PL353)		+= pl353_nand.o
 
 nand-objs := nand_base.o nand_bbt.o
diff --git a/drivers/mtd/nand/pl353_nand.c b/drivers/mtd/nand/pl353_nand.c
new file mode 100644
index 0000000..0be8ca2
--- /dev/null
+++ b/drivers/mtd/nand/pl353_nand.c
@@ -0,0 +1,855 @@
+/*
+ * ARM PL353 NAND Flash Controller Driver
+ *
+ * Copyright (C) 2009 - 2014 Xilinx, Inc.
+ *
+ * This driver is based on plat_nand.c and mxc_nand.c drivers
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/memory/pl353-smc.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/partitions.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_mtd.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PL353_NAND_DRIVER_NAME "pl353-nand"
+
+/* NAND flash driver defines */
+#define PL353_NAND_CMD_PHASE	1	/* End command valid in command phase */
+#define PL353_NAND_DATA_PHASE	2	/* End command valid in data phase */
+#define PL353_NAND_ECC_SIZE	512	/* Size of data for ECC operation */
+
+/* Flash memory controller operating parameters */
+
+#define PL353_NAND_ECC_CONFIG	(BIT(4)  |	/* ECC read at end of page */ \
+				 (0 << 5))	/* No Jumping */
+
+/* AXI Address definitions */
+#define START_CMD_SHIFT		3
+#define END_CMD_SHIFT		11
+#define END_CMD_VALID_SHIFT	20
+#define ADDR_CYCLES_SHIFT	21
+#define CLEAR_CS_SHIFT		21
+#define ECC_LAST_SHIFT		10
+#define COMMAND_PHASE		(0 << 19)
+#define DATA_PHASE		BIT(19)
+
+#define PL353_NAND_ECC_LAST	BIT(ECC_LAST_SHIFT)	/* Set ECC_Last */
+#define PL353_NAND_CLEAR_CS	BIT(CLEAR_CS_SHIFT)	/* Clear chip select */
+
+#define ONDIE_ECC_FEATURE_ADDR	0x90
+#define PL353_NAND_ECC_BUSY_TIMEOUT	(1 * HZ)
+#define PL353_NAND_DEV_BUSY_TIMEOUT	(1 * HZ)
+#define PL353_NAND_LAST_TRANSFER_LENGTH	4
+
+/**
+ * struct pl353_nand_command_format - Defines NAND flash command format
+ * @start_cmd:		First cycle command (Start command)
+ * @end_cmd:		Second cycle command (Last command)
+ * @addr_cycles:	Number of address cycles required to send the address
+ * @end_cmd_valid:	The second cycle command is valid for cmd or data phase
+ */
+struct pl353_nand_command_format {
+	int start_cmd;
+	int end_cmd;
+	u8 addr_cycles;
+	u8 end_cmd_valid;
+};
+
+/**
+ * struct pl353_nand_info - Defines the NAND flash driver instance
+ * @chip:		NAND chip information structure
+ * @mtd:		MTD information structure
+ * @nand_base:		Virtual address of the NAND flash device
+ * @end_cmd_pending:	End command is pending
+ * @end_cmd:		End command
+ * @ecc_mode:		ECC mode
+ */
+struct pl353_nand_info {
+	struct nand_chip chip;
+	struct mtd_info mtd;
+	void __iomem *nand_base;
+	unsigned long end_cmd_pending;
+	unsigned long end_cmd;
+	int ecc_mode;
+};
+
+/*
+ * The NAND flash operations command format
+ */
+static const struct pl353_nand_command_format pl353_nand_commands[] = {
+	{NAND_CMD_READ0, NAND_CMD_READSTART, 5, PL353_NAND_CMD_PHASE},
+	{NAND_CMD_RNDOUT, NAND_CMD_RNDOUTSTART, 2, PL353_NAND_CMD_PHASE},
+	{NAND_CMD_READID, NAND_CMD_NONE, 1, NAND_CMD_NONE},
+	{NAND_CMD_STATUS, NAND_CMD_NONE, 0, NAND_CMD_NONE},
+	{NAND_CMD_SEQIN, NAND_CMD_PAGEPROG, 5, PL353_NAND_DATA_PHASE},
+	{NAND_CMD_RNDIN, NAND_CMD_NONE, 2, NAND_CMD_NONE},
+	{NAND_CMD_ERASE1, NAND_CMD_ERASE2, 3, PL353_NAND_CMD_PHASE},
+	{NAND_CMD_RESET, NAND_CMD_NONE, 0, NAND_CMD_NONE},
+	{NAND_CMD_PARAM, NAND_CMD_NONE, 1, NAND_CMD_NONE},
+	{NAND_CMD_GET_FEATURES, NAND_CMD_NONE, 1, NAND_CMD_NONE},
+	{NAND_CMD_SET_FEATURES, NAND_CMD_NONE, 1, NAND_CMD_NONE},
+	{NAND_CMD_NONE, NAND_CMD_NONE, 0, 0},
+	/* Add all the flash commands supported by the flash device and Linux */
+	/*
+	 * The cache program command is not supported by driver because driver
+	 * cant differentiate between page program and cached page program from
+	 * start command, these commands can be differentiated through end
+	 * command, which doesn't fit in to the driver design. The cache program
+	 * command is not supported by NAND subsystem also, look at 1612 line
+	 * number (in nand_write_page function) of nand_base.c file.
+	 * {NAND_CMD_SEQIN, NAND_CMD_CACHEDPROG, 5, PL353_NAND_YES},
+	 */
+};
+
+/* Define default oob placement schemes for large and small page devices */
+static struct nand_ecclayout nand_oob_16 = {
+	.eccbytes = 3,
+	.eccpos = {0, 1, 2},
+	.oobfree = {
+		{.offset = 8,
+		 . length = 8} }
+};
+
+static struct nand_ecclayout nand_oob_64 = {
+	.eccbytes = 12,
+	.eccpos = {
+		   52, 53, 54, 55, 56, 57,
+		   58, 59, 60, 61, 62, 63},
+	.oobfree = {
+		{.offset = 2,
+		 .length = 50} }
+};
+
+/**
+ * pl353_nand_calculate_hwecc - Calculate Hardware ECC
+ * @mtd:	Pointer to the mtd_info structure
+ * @data:	Pointer to the page data
+ * @ecc_code:	Pointer to the ECC buffer where ECC data needs to be stored
+ *
+ * This function retrieves the Hardware ECC data from the controller and returns
+ * ECC data back to the MTD subsystem.
+ *
+ * Return:	0 on success or error value on failure
+ */
+static int pl353_nand_calculate_hwecc(struct mtd_info *mtd,
+				const u8 *data, u8 *ecc_code)
+{
+	u32 ecc_value, ecc_status;
+	u8 ecc_reg, ecc_byte;
+	unsigned long timeout = jiffies + PL353_NAND_ECC_BUSY_TIMEOUT;
+
+	/* Wait till the ECC operation is complete or timeout */
+	do {
+		if (pl353_smc_ecc_is_busy())
+			cpu_relax();
+		else
+			break;
+	} while (!time_after_eq(jiffies, timeout));
+
+	if (time_after_eq(jiffies, timeout)) {
+		pr_err("%s timed out\n", __func__);
+		return -ETIMEDOUT;
+	}
+
+	for (ecc_reg = 0; ecc_reg < 4; ecc_reg++) {
+		/* Read ECC value for each block */
+		ecc_value = pl353_smc_get_ecc_val(ecc_reg);
+		ecc_status = (ecc_value >> 24) & 0xFF;
+		/* ECC value valid */
+		if (ecc_status & 0x40) {
+			for (ecc_byte = 0; ecc_byte < 3; ecc_byte++) {
+				/* Copy ECC bytes to MTD buffer */
+				*ecc_code = ecc_value & 0xFF;
+				ecc_value = ecc_value >> 8;
+				ecc_code++;
+			}
+		} else {
+			pr_warn("%s status failed\n", __func__);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/**
+ * onehot - onehot function
+ * @value:	Value to check for onehot
+ *
+ * This function checks whether a value is onehot or not.
+ * onehot is if and only if onebit is set.
+ *
+ * Return:	1 if it is onehot else 0
+ */
+static int onehot(unsigned short value)
+{
+	return (value & (value - 1)) == 0;
+}
+
+/**
+ * pl353_nand_correct_data - ECC correction function
+ * @mtd:	Pointer to the mtd_info structure
+ * @buf:	Pointer to the page data
+ * @read_ecc:	Pointer to the ECC value read from spare data area
+ * @calc_ecc:	Pointer to the calculated ECC value
+ *
+ * This function corrects the ECC single bit errors & detects 2-bit errors.
+ *
+ * Return:	0 if no ECC errors found
+ *		1 if single bit error found and corrected.
+ *		-1 if multiple ECC errors found.
+ */
+static int pl353_nand_correct_data(struct mtd_info *mtd, unsigned char *buf,
+				unsigned char *read_ecc,
+				unsigned char *calc_ecc)
+{
+	unsigned char bit_addr;
+	unsigned int byte_addr;
+	unsigned short ecc_odd, ecc_even, read_ecc_lower, read_ecc_upper;
+	unsigned short calc_ecc_lower, calc_ecc_upper;
+
+	read_ecc_lower = (read_ecc[0] | (read_ecc[1] << 8)) & 0xfff;
+	read_ecc_upper = ((read_ecc[1] >> 4) | (read_ecc[2] << 4)) & 0xfff;
+
+	calc_ecc_lower = (calc_ecc[0] | (calc_ecc[1] << 8)) & 0xfff;
+	calc_ecc_upper = ((calc_ecc[1] >> 4) | (calc_ecc[2] << 4)) & 0xfff;
+
+	ecc_odd = read_ecc_lower ^ calc_ecc_lower;
+	ecc_even = read_ecc_upper ^ calc_ecc_upper;
+
+	if ((ecc_odd == 0) && (ecc_even == 0))
+		return 0;       /* no error */
+
+	if (ecc_odd == (~ecc_even & 0xfff)) {
+		/* bits [11:3] of error code is byte offset */
+		byte_addr = (ecc_odd >> 3) & 0x1ff;
+		/* bits [2:0] of error code is bit offset */
+		bit_addr = ecc_odd & 0x7;
+		/* Toggling error bit */
+		buf[byte_addr] ^= (1 << bit_addr);
+		return 1;
+	}
+
+	if (onehot(ecc_odd | ecc_even) == 1)
+		return 1; /* one error in parity */
+
+	return -EBADMSG; /* Uncorrectable error */
+}
+
+/**
+ * pl353_nand_read_oob - [REPLACABLE] the most common OOB data read function
+ * @mtd:	Pointer to the mtd info structure
+ * @chip:	Pointer to the NAND chip info structure
+ * @page:	Page number to read
+ *
+ * Return:	Always return zero
+ */
+static int pl353_nand_read_oob(struct mtd_info *mtd, struct nand_chip *chip,
+			    int page)
+{
+	unsigned long data_phase_addr;
+	uint8_t *p;
+
+	chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
+
+	p = chip->oob_poi;
+	chip->read_buf(mtd, p,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	p += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_R;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+	chip->read_buf(mtd, p, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	return 0;
+}
+
+/**
+ * pl353_nand_write_oob - [REPLACABLE] the most common OOB data write function
+ * @mtd:	Pointer to the mtd info structure
+ * @chip:	Pointer to the NAND chip info structure
+ * @page:	Page number to write
+ *
+ * Return:	Zero on success and EIO on failure
+ */
+static int pl353_nand_write_oob(struct mtd_info *mtd, struct nand_chip *chip,
+			     int page)
+{
+	int status = 0;
+	const uint8_t *buf = chip->oob_poi;
+	unsigned long data_phase_addr;
+
+	chip->cmdfunc(mtd, NAND_CMD_SEQIN, mtd->writesize, page);
+
+	chip->write_buf(mtd, buf,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	buf += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_W;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	data_phase_addr |= (1 << END_CMD_VALID_SHIFT);
+	chip->IO_ADDR_W = (void __iomem * __force)data_phase_addr;
+	chip->write_buf(mtd, buf, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	/* Send command to program the OOB data */
+	chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);
+	status = chip->waitfunc(mtd, chip);
+
+	return status & NAND_STATUS_FAIL ? -EIO : 0;
+}
+
+/**
+ * nand_write_page_hwecc - Hardware ECC based page write function
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the data buffer
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ *
+ * This functions writes data and hardware generated ECC values in to the page.
+ *
+ * Return:	Zero on success and error on failure.
+ */
+static int pl353_nand_write_page_hwecc(struct mtd_info *mtd,
+				    struct nand_chip *chip, const uint8_t *buf,
+				    int oob_required)
+{
+	int i, status, eccsize = chip->ecc.size;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	const uint8_t *p = buf;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	unsigned long data_phase_addr;
+	uint8_t *oob_ptr;
+
+	for ( ; (eccsteps - 1); eccsteps--) {
+		chip->write_buf(mtd, p, eccsize);
+		p += eccsize;
+	}
+	chip->write_buf(mtd, p, (eccsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	p += (eccsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	/* Set ECC Last bit to 1 */
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_W;
+	data_phase_addr |= PL353_NAND_ECC_LAST;
+	chip->IO_ADDR_W = (void __iomem * __force)data_phase_addr;
+	chip->write_buf(mtd, p, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	/* Wait for ECC to be calculated and read the error values */
+	p = buf;
+	status = chip->ecc.calculate(mtd, p, &ecc_calc[0]);
+	if (status)
+		return status;
+
+	for (i = 0; i < chip->ecc.total; i++)
+		chip->oob_poi[eccpos[i]] = ~(ecc_calc[i]);
+
+	/* Clear ECC last bit */
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_W;
+	data_phase_addr &= ~PL353_NAND_ECC_LAST;
+	chip->IO_ADDR_W = (void __iomem * __force)data_phase_addr;
+
+	/* Write the spare area with ECC bytes */
+	oob_ptr = chip->oob_poi;
+	chip->write_buf(mtd, oob_ptr,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_W;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	data_phase_addr |= (1 << END_CMD_VALID_SHIFT);
+	chip->IO_ADDR_W = (void __iomem * __force)data_phase_addr;
+	oob_ptr += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+	chip->write_buf(mtd, oob_ptr, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	return 0;
+}
+
+/**
+ * pl353_nand_read_page_hwecc - Hardware ECC based page read function
+ * @mtd:		Pointer to the mtd info structure
+ * @chip:		Pointer to the NAND chip info structure
+ * @buf:		Pointer to the buffer to store read data
+ * @oob_required:	Caller requires OOB data read to chip->oob_poi
+ * @page:		Page number to read
+ *
+ * This functions reads data and checks the data integrity by comparing hardware
+ * generated ECC values and read ECC values from spare area.
+ *
+ * Return:	0 always and updates ECC operation status in to MTD structure
+ */
+static int pl353_nand_read_page_hwecc(struct mtd_info *mtd,
+				     struct nand_chip *chip,
+				     uint8_t *buf, int oob_required, int page)
+{
+	int i, stat, eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *p = buf;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	unsigned long data_phase_addr;
+	uint8_t *oob_ptr;
+
+	for ( ; (eccsteps - 1); eccsteps--) {
+		chip->read_buf(mtd, p, eccsize);
+		p += eccsize;
+	}
+	chip->read_buf(mtd, p, (eccsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+	p += (eccsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	/* Set ECC Last bit to 1 */
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_R;
+	data_phase_addr |= PL353_NAND_ECC_LAST;
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+	chip->read_buf(mtd, p, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	/* Read the calculated ECC value */
+	p = buf;
+	stat = chip->ecc.calculate(mtd, p, &ecc_calc[0]);
+	if (stat < 0)
+		return stat;
+
+	/* Clear ECC last bit */
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_R;
+	data_phase_addr &= ~PL353_NAND_ECC_LAST;
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+
+	/* Read the stored ECC value */
+	oob_ptr = chip->oob_poi;
+	chip->read_buf(mtd, oob_ptr,
+			(mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH));
+
+	/* de-assert chip select */
+	data_phase_addr = (unsigned long __force)chip->IO_ADDR_R;
+	data_phase_addr |= PL353_NAND_CLEAR_CS;
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+
+	oob_ptr += (mtd->oobsize - PL353_NAND_LAST_TRANSFER_LENGTH);
+	chip->read_buf(mtd, oob_ptr, PL353_NAND_LAST_TRANSFER_LENGTH);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		ecc_code[i] = ~(chip->oob_poi[eccpos[i]]);
+
+	eccsteps = chip->ecc.steps;
+	p = buf;
+
+	/* Check ECC error for all blocks and correct if it is correctable */
+	for (i = 0 ; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
+		stat = chip->ecc.correct(mtd, p, &ecc_code[i], &ecc_calc[i]);
+		if (stat < 0)
+			mtd->ecc_stats.failed++;
+		else
+			mtd->ecc_stats.corrected += stat;
+	}
+	return 0;
+}
+
+/**
+ * pl353_nand_select_chip - Select the flash device
+ * @mtd:	Pointer to the mtd info structure
+ * @chip:	Pointer to the NAND chip info structure
+ *
+ * This function is empty as the NAND controller handles chip select line
+ * internally based on the chip address passed in command and data phase.
+ */
+static void pl353_nand_select_chip(struct mtd_info *mtd, int chip)
+{
+	return;
+}
+
+/**
+ * pl353_nand_cmd_function - Send command to NAND device
+ * @mtd:	Pointer to the mtd_info structure
+ * @command:	The command to be sent to the flash device
+ * @column:	The column address for this command, -1 if none
+ * @page_addr:	The page address for this command, -1 if none
+ */
+static void pl353_nand_cmd_function(struct mtd_info *mtd, unsigned int command,
+				 int column, int page_addr)
+{
+	struct nand_chip *chip = mtd->priv;
+	const struct pl353_nand_command_format *curr_cmd = NULL;
+	struct pl353_nand_info *xnand =
+		container_of(mtd, struct pl353_nand_info, mtd);
+	void __iomem *cmd_addr;
+	unsigned long cmd_data = 0, end_cmd_valid = 0;
+	unsigned long cmd_phase_addr, data_phase_addr, end_cmd, i;
+	unsigned long timeout = jiffies + PL353_NAND_DEV_BUSY_TIMEOUT;
+
+	if (xnand->end_cmd_pending) {
+		/*
+		 * Check for end command if this command request is same as the
+		 * pending command then return
+		 */
+		if (xnand->end_cmd == command) {
+			xnand->end_cmd = 0;
+			xnand->end_cmd_pending = 0;
+			return;
+		}
+	}
+
+	/* Emulate NAND_CMD_READOOB for large page device */
+	if ((mtd->writesize > PL353_NAND_ECC_SIZE) &&
+	    (command == NAND_CMD_READOOB)) {
+		column += mtd->writesize;
+		command = NAND_CMD_READ0;
+	}
+
+	/* Get the command format */
+	for (i = 0; (pl353_nand_commands[i].start_cmd != NAND_CMD_NONE ||
+		     pl353_nand_commands[i].end_cmd != NAND_CMD_NONE); i++)
+		if (command == pl353_nand_commands[i].start_cmd)
+			curr_cmd = &pl353_nand_commands[i];
+
+	if (curr_cmd == NULL)
+		return;
+
+	/* Clear interrupt */
+	pl353_smc_clr_nand_int();
+
+	/* Get the command phase address */
+	if (curr_cmd->end_cmd_valid == PL353_NAND_CMD_PHASE)
+		end_cmd_valid = 1;
+
+	if (curr_cmd->end_cmd == NAND_CMD_NONE)
+		end_cmd = 0x0;
+	else
+		end_cmd = curr_cmd->end_cmd;
+
+	cmd_phase_addr = (unsigned long __force)xnand->nand_base        |
+			 (curr_cmd->addr_cycles << ADDR_CYCLES_SHIFT)    |
+			 (end_cmd_valid << END_CMD_VALID_SHIFT)          |
+			 (COMMAND_PHASE)                                 |
+			 (end_cmd << END_CMD_SHIFT)                      |
+			 (curr_cmd->start_cmd << START_CMD_SHIFT);
+
+	cmd_addr = (void __iomem * __force)cmd_phase_addr;
+
+	/* Get the data phase address */
+	end_cmd_valid = 0;
+
+	data_phase_addr = (unsigned long __force)xnand->nand_base       |
+			  (0x0 << CLEAR_CS_SHIFT)                         |
+			  (end_cmd_valid << END_CMD_VALID_SHIFT)          |
+			  (DATA_PHASE)                                    |
+			  (end_cmd << END_CMD_SHIFT)                      |
+			  (0x0 << ECC_LAST_SHIFT);
+
+	chip->IO_ADDR_R = (void __iomem * __force)data_phase_addr;
+	chip->IO_ADDR_W = chip->IO_ADDR_R;
+
+	/* Command phase AXI write */
+	/* Read & Write */
+	if (column != -1 && page_addr != -1) {
+		/* Adjust columns for 16 bit bus width */
+		if (chip->options & NAND_BUSWIDTH_16)
+			column >>= 1;
+		cmd_data = column;
+		if (mtd->writesize > PL353_NAND_ECC_SIZE) {
+			cmd_data |= page_addr << 16;
+			/* Another address cycle for devices > 128MiB */
+			if (chip->chipsize > (128 << 20)) {
+				writel_relaxed(cmd_data, cmd_addr);
+				cmd_data = (page_addr >> 16);
+			}
+		} else {
+			cmd_data |= page_addr << 8;
+		}
+	} else if (page_addr != -1) {
+		/* Erase */
+		cmd_data = page_addr;
+	} else if (column != -1) {
+		/*
+		 * Change read/write column, read id etc
+		 * Adjust columns for 16 bit bus width
+		 */
+		if ((chip->options & NAND_BUSWIDTH_16) &&
+			((command == NAND_CMD_READ0) ||
+			(command == NAND_CMD_SEQIN) ||
+			(command == NAND_CMD_RNDOUT) ||
+			(command == NAND_CMD_RNDIN)))
+				column >>= 1;
+		cmd_data = column;
+	}
+
+	writel_relaxed(cmd_data, cmd_addr);
+
+	if (curr_cmd->end_cmd_valid) {
+		xnand->end_cmd = curr_cmd->end_cmd;
+		xnand->end_cmd_pending = 1;
+	}
+
+	ndelay(100);
+
+	if ((command == NAND_CMD_READ0) ||
+	    (command == NAND_CMD_RESET) ||
+	    (command == NAND_CMD_PARAM) ||
+	    (command == NAND_CMD_GET_FEATURES)) {
+
+		/* Wait till the device is ready or timeout */
+		do {
+			if (chip->dev_ready(mtd))
+				break;
+			else
+				cpu_relax();
+		} while (!time_after_eq(jiffies, timeout));
+
+		if (time_after_eq(jiffies, timeout))
+			pr_err("%s timed out\n", __func__);
+		return;
+	}
+}
+
+/**
+ * pl353_nand_read_buf - read chip data into buffer
+ * @mtd:	Pointer to the mtd info structure
+ * @buf:	Pointer to the buffer to store read data
+ * @len:	Number of bytes to read
+ */
+static void pl353_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	int i;
+	struct nand_chip *chip = mtd->priv;
+	unsigned long *ptr = (unsigned long *)buf;
+
+	len >>= 2;
+	for (i = 0; i < len; i++)
+		ptr[i] = readl(chip->IO_ADDR_R);
+}
+
+/**
+ * pl353_nand_write_buf - write buffer to chip
+ * @mtd:	Pointer to the mtd info structure
+ * @buf:	Pointer to the buffer to store read data
+ * @len:	Number of bytes to write
+ */
+static void pl353_nand_write_buf(struct mtd_info *mtd, const uint8_t *buf,
+				int len)
+{
+	int i;
+	struct nand_chip *chip = mtd->priv;
+	unsigned long *ptr = (unsigned long *)buf;
+
+	len >>= 2;
+
+	for (i = 0; i < len; i++)
+		writel(ptr[i], chip->IO_ADDR_W);
+}
+
+/**
+ * pl353_nand_device_ready - Check device ready/busy line
+ * @mtd:	Pointer to the mtd_info structure
+ *
+ * Return:	0 on busy or 1 on ready state
+ */
+static int pl353_nand_device_ready(struct mtd_info *mtd)
+{
+	if (pl353_smc_get_nand_int_status_raw()) {
+		pl353_smc_clr_nand_int();
+		return 1;
+	}
+	return 0;
+}
+
+/**
+ * pl353_nand_ecc_init - Initialize the ecc information as per the ecc mode
+ * @mtd:	Pointer to the mtd_info structure
+ *
+ * This function initializes the ecc block and functional pointers as per the
+ * ecc mode
+ *
+ * Return:	Zero on success and error on failure.
+ */
+static int pl353_nand_ecc_init(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = mtd->priv;
+	struct pl353_nand_info *xnand =
+		container_of(mtd, struct pl353_nand_info, mtd);
+
+	nand_chip->ecc.read_oob = pl353_nand_read_oob;
+	nand_chip->ecc.write_oob = pl353_nand_write_oob;
+	nand_chip->ecc.strength = 1;
+
+	switch (xnand->ecc_mode) {
+	case NAND_ECC_HW:
+		if (mtd->writesize > 2048) {
+			pr_warn("hardware ECC not possible\n");
+			return -ENOTSUPP;
+		}
+
+		nand_chip->ecc.mode = NAND_ECC_HW;
+		nand_chip->ecc.calculate = pl353_nand_calculate_hwecc;
+		nand_chip->ecc.correct = pl353_nand_correct_data;
+		nand_chip->ecc.hwctl = NULL;
+		nand_chip->ecc.read_page = pl353_nand_read_page_hwecc;
+		nand_chip->ecc.size = PL353_NAND_ECC_SIZE;
+		nand_chip->ecc.write_page = pl353_nand_write_page_hwecc;
+		pl353_smc_set_ecc_pg_size(mtd->writesize);
+		pl353_smc_set_ecc_mode(PL353_SMC_ECCMODE_APB);
+		/* Hardware ECC generates 3 bytes ECC code for each 512 bytes */
+		nand_chip->ecc.bytes = 3;
+
+		if (mtd->oobsize == 16)
+			nand_chip->ecc.layout = &nand_oob_16;
+		else
+			nand_chip->ecc.layout = &nand_oob_64;
+
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+/**
+ * pl353_nand_probe - Probe method for the NAND driver
+ * @pdev:	Pointer to the platform_device structure
+ *
+ * This function initializes the driver data structures and the hardware.
+ *
+ * Return:	0 on success or error value on failure
+ */
+static int pl353_nand_probe(struct platform_device *pdev)
+{
+	struct pl353_nand_info *xnand;
+	struct mtd_info *mtd;
+	struct nand_chip *nand_chip;
+	struct resource *res;
+	struct mtd_part_parser_data ppdata;
+
+	xnand = devm_kzalloc(&pdev->dev, sizeof(*xnand), GFP_KERNEL);
+	if (!xnand)
+		return -ENOMEM;
+
+	/* Map physical address of NAND flash */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	xnand->nand_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xnand->nand_base))
+		return PTR_ERR(xnand->nand_base);
+
+	/* Link the private data with the MTD structure */
+	mtd = &xnand->mtd;
+	nand_chip = &xnand->chip;
+
+	nand_chip->priv = xnand;
+	mtd->priv = nand_chip;
+	mtd->owner = THIS_MODULE;
+	mtd->name = PL353_NAND_DRIVER_NAME;
+
+	/* Set address of NAND IO lines */
+	nand_chip->IO_ADDR_R = xnand->nand_base;
+	nand_chip->IO_ADDR_W = xnand->nand_base;
+
+	/* Set the driver entry points for MTD */
+	nand_chip->cmdfunc = pl353_nand_cmd_function;
+	nand_chip->dev_ready = pl353_nand_device_ready;
+	nand_chip->select_chip = pl353_nand_select_chip;
+
+	/* If we don't set this delay driver sets 20us by default */
+	nand_chip->chip_delay = 30;
+
+	/* Buffer read/write routines */
+	nand_chip->read_buf = pl353_nand_read_buf;
+	nand_chip->write_buf = pl353_nand_write_buf;
+
+	/* Set the device option and flash width */
+	nand_chip->options = NAND_BUSWIDTH_AUTO;
+	nand_chip->bbt_options = NAND_BBT_USE_FLASH;
+
+	platform_set_drvdata(pdev, xnand);
+
+	/* first scan to find the device and get the page size */
+	if (nand_scan_ident(mtd, 1, NULL)) {
+		dev_err(&pdev->dev, "nand_scan_ident for NAND failed\n");
+		return -ENXIO;
+	}
+
+	xnand->ecc_mode = of_get_nand_ecc_mode(pdev->dev.of_node);
+	if (xnand->ecc_mode < 0)
+		xnand->ecc_mode = NAND_ECC_HW;
+
+	if (pl353_nand_ecc_init(mtd))
+		return -ENOTSUPP;
+
+	if (nand_chip->options & NAND_BUSWIDTH_16)
+		pl353_smc_set_buswidth(PL353_SMC_MEM_WIDTH_16);
+
+	/* second phase scan */
+	if (nand_scan_tail(mtd)) {
+		dev_err(&pdev->dev, "nand_scan_tail for NAND failed\n");
+		return -ENXIO;
+	}
+
+	ppdata.of_node = pdev->dev.of_node;
+
+	mtd_device_parse_register(&xnand->mtd, NULL, &ppdata, NULL, 0);
+
+	return 0;
+}
+
+/**
+ * pl353_nand_remove - Remove method for the NAND driver
+ * @pdev:	Pointer to the platform_device structure
+ *
+ * This function is called if the driver module is being unloaded. It frees all
+ * resources allocated to the device.
+ *
+ * Return:	0 on success or error value on failure
+ */
+static int pl353_nand_remove(struct platform_device *pdev)
+{
+	struct pl353_nand_info *xnand = platform_get_drvdata(pdev);
+
+	/* Release resources, unregister device */
+	nand_release(&xnand->mtd);
+
+	return 0;
+}
+
+/* Match table for device tree binding */
+static const struct of_device_id pl353_nand_of_match[] = {
+	{ .compatible = "arm,pl353-nand-r2p1" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pl353_nand_of_match);
+
+/*
+ * pl353_nand_driver - This structure defines the NAND subsystem platform driver
+ */
+static struct platform_driver pl353_nand_driver = {
+	.probe		= pl353_nand_probe,
+	.remove		= pl353_nand_remove,
+	.driver		= {
+		.name	= PL353_NAND_DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = pl353_nand_of_match,
+	},
+};
+
+module_platform_driver(pl353_nand_driver);
+
+MODULE_AUTHOR("Punnaiah Choudary Kalluri <punnaia@xilinx.com>");
+MODULE_ALIAS("platform:" PL353_NAND_DRIVER_NAME);
+MODULE_DESCRIPTION("ARM PL353 NAND Flash Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4


