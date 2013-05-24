Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3EXLYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:24:03 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:57690 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3EXLYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:24:00 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub40Q/uAHDKmDv/0PG1rtp0=
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] misc: Add Lattice XP2 FPGA internal flash programming via SPI
Date: Fri, 24 May 2013 13:17:47 +0200
Message-Id: <1369394267-8504-1-git-send-email-sr@denx.de>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option enables support for programming of the FPGA's internal
flash of the Lattice XP2 FPGA family via SPI. The newly programmed
bitstream will also be loaded into the internal SRAM (refresh).

Note: The XP2 needs at least 3 clocks to be sent to the FPGA with
inactive CS for some commands. Since the MPC5200 PSC SPI
controller does not support de-activating the CS, we need
to re-configure the PSC port from SPI to GPIO and generate
the clocks with inactive CS this way. After generating these
clocks, the PSC is configured to SPI controller again. So this
current implementation is very SPI controller specific and this
driver will only work on the MPC5200 PSC SPI controller.

Here an example on my custom MPC5200 based board:

$ echo 1 > /sys/class/firmware/lattice-xp2.bit/loading
$ cat a3m071-fpga.jed > /sys/class/firmware/lattice-xp2.bit/data
$ echo 0 > /sys/class/firmware/lattice-xp2.bit/loading

leads to these messages:

lattice-xp2 spi1.0: Security fuse will be set!
lattice-xp2 spi1.0: FPGA Lattice XP2-17 detected
lattice-xp2 spi1.0: FPGA data verified!
lattice-xp2 spi1.0: FPGA security fuse programmed
lattice-xp2 spi1.0: FPGA DONE fuse programmed
lattice-xp2 spi1.0: FPGA successfully refreshed!

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
I know that the re-configuration of the pins (SPI vs GPIO) as described
above could/should be done in a "clean way" via pinctrl. But currently there
is no pinctrl support for MPC52xx and the scope of this project doesn't
really allow me to implement this infrastructure. Perhaps somebody else
will find the time to do this later. But I'm pretty sure that this driver
is "as-is" helpful for other users/developers.

  Stefan

 drivers/misc/Kconfig              |  12 +
 drivers/misc/Makefile             |   1 +
 drivers/misc/lattice-xp2-config.c | 827 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 840 insertions(+)
 create mode 100644 drivers/misc/lattice-xp2-config.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c002d86..dea2ed3 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -518,6 +518,18 @@ config LATTICE_ECP3_CONFIG
 
 	  If unsure, say N.
 
+config LATTICE_XP2_CONFIG
+	tristate "Lattice XP2 FPGA internal flash programming via SPI"
+	depends on SPI && SYSFS && PPC_MPC52xx
+	select FW_LOADER
+	default	n
+	help
+	  This option enables support for programming of the FPGA's internal
+	  flash of the Lattice XP2 FPGA family via SPI. The newly programmed
+	  bitstream will also be loaded into the internal SRAM (refresh).
+
+	  If unsure, say N.
+
 config SRAM
 	bool "Generic on-chip SRAM driver"
 	depends on HAS_IOMEM
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..4fb82cf 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -52,4 +52,5 @@ obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
+obj-$(CONFIG_LATTICE_XP2_CONFIG)	+= lattice-xp2-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
diff --git a/drivers/misc/lattice-xp2-config.c b/drivers/misc/lattice-xp2-config.c
new file mode 100644
index 0000000..ff8130a
--- /dev/null
+++ b/drivers/misc/lattice-xp2-config.c
@@ -0,0 +1,827 @@
+/*
+ * linux/drivers/firmware/lattice-xp2-config.c
+ *
+ * Copyright (C) 2013 Stefan Roese <sr@denx.de>
+ *
+ * Based on code provided by Martin Mittelberger <martin@mittelberger.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+#define DRIVER_NAME		"lattice-xp2"
+#define DRIVER_VER		"1.1"
+#define FIRMWARE_NAME		"lattice-xp2.bit"
+
+#define JEDEC_DATA_START	"L0000000"
+#define JEDEC_SECURITY		"G1*"
+
+/* FPGA commands */
+#define FPGA_CMD_READ_ID		0x98
+#define FPGA_CMD_READ_DEVICE_STATUS	0x4d
+#define FPGA_CMD_READ_PROGRAM_STATUS	0x4a
+#define FPGA_CMD_READ_SED_CRC		0x22
+#define FPGA_CMD_X_PROGRAM_EN		0xac
+#define FPGA_CMD_X_SRAM_READ_EN		0xae
+#define FPGA_CMD_PROGRAM_DIS		0x78
+#define FPGA_CMD_DISABLE_DONE		0x24
+#define FPGA_CMD_ERASE			0xc0
+#define FPGA_CMD_INIT_ADDRESS		0x84
+#define FPGA_CMD_REFRESH		0xc4
+#define FPGA_CMD_PROGRAM_INC		0xe6
+#define FPGA_CMD_VERIFY_INC		0x56
+#define FPGA_CMD_PROGRAM_TAG		0x8e
+#define FPGA_CMD_READ_TAG		0x4e
+#define FPGA_CMD_PROGRAM_DONE		0xf4
+#define FPGA_CMD_PROGRAM_SECURITY	0x90
+
+/* Program status flags (whole byte is really only one flag) */
+#define FPGA_PROG_STATUS_ERASED	0xff
+
+/*
+ * The status register is 8bit revered (LSB first read),
+ * so lets define the bits just in reverse order
+ */
+/* Device status flags */
+#define FPGA_STATUS_ERASE_COMPLETED_N		0x80
+#define FPGA_STATUS_DONE_FUSE_PROGRAMMED	0x40
+#define FPGA_STATUS_FLASH_PROTECT_KEY		0x20
+#define FPGA_STATUS_SED_CRC			0x10
+#define FPGA_STATUS_OTP_FUSE			0x08
+#define FPGA_STATUS_FLASH_PROTECT_ENABLED	0x04
+#define FPGA_STATUS_ENCRYPTION_ENABLED		0x02
+#define FPGA_STATUS_SECURITY_FUSE_PROGRAMMED	0x01
+
+#define FPGA_ERASE_TIMEOUT	240000	/* max. 240 seconds for FPGA erase */
+#define FPGA_ERASE_MSLEEP	100
+#define FPGA_ERASE_LOOP_COUNT	(FPGA_ERASE_TIMEOUT / FPGA_ERASE_MSLEEP)
+
+#define FPGA_PROG_TIMEOUT	10	/* max. 10 ms per row */
+#define FPGA_PROG_MSLEEP	1
+#define FPGA_PROG_LOOP_COUNT	(FPGA_PROG_TIMEOUT / FPGA_PROG_MSLEEP)
+
+#define FPGA_PROG_DONE_TIMEOUT	25	/* max. 25 ms */
+#define FPGA_PROG_DONE_MSLEEP	1
+#define FPGA_PROG_DONE_LOOP_COUNT (FPGA_PROG_DONE_TIMEOUT / FPGA_PROG_DONE_MSLEEP)
+
+#define FPGA_REFRESH_TIMEOUT	2	/* max. 2 ms */
+#define FPGA_REFRESH_MSLEEP	1
+#define FPGA_REFRESH_LOOP_COUNT	(FPGA_REFRESH_TIMEOUT / FPGA_REFRESH_MSLEEP)
+
+/*
+ * The JTAG ID's of the supported FPGA's. The ID is 32bit wide
+ * reversed as noted in the manual.
+ */
+#define ID_XP2_17	0xc20d9480
+
+struct xp2_dev {
+	u32 jedec_id;
+	char *name;
+	int rows;
+	int columns;
+	int padding_bits;
+	int tag_bits;
+};
+
+static const struct xp2_dev xp2_dev[] = {
+	{
+		.jedec_id = ID_XP2_17,
+		.name = "Lattice XP2-17",
+		.rows = 1658,
+		.columns = 2188,
+		.padding_bits = 4,
+		.tag_bits = 2184,
+	},
+};
+
+struct fpga_data {
+	struct completion fw_loaded;
+	int device_loaded;
+};
+
+#ifdef CONFIG_PPC_MPC52xx
+/*
+ * The XP2 needs at least 3 clocks to be sent to the FPGA with
+ * inactive CS for some commands. Since the MPC5200 PSC SPI
+ * controller does not support de-activating the CS, we need
+ * to re-configure the PSC port from SPI to GPIO and generate
+ * the clocks with inactive CS this way. After generating these
+ * clocks, the PSC is configured to SPI controller again.
+ */
+
+#include <asm/mpc52xx.h>
+
+static struct mpc52xx_gpio __iomem *gpio;
+
+static struct of_device_id mpc5200_gpio_ids[] = {
+	{ .compatible = "fsl,mpc5200-gpio", },
+	{ .compatible = "mpc5200-gpio", },
+	{}
+};
+
+static int mpc5200_map_gpio(struct spi_device *spi)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, mpc5200_gpio_ids);
+	if (!np) {
+		dev_err(&spi->dev, "Can't map MPC5200 GPIO node\n");
+		return -ENODEV;
+	}
+	gpio = of_iomap(np, 0);
+	of_node_put(np);
+	if (!gpio) {
+		dev_err(&spi->dev, "Can't map MPC5200 GPIO node\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void spi_send_clocks(int clocks)
+{
+	u32 val;
+	int i;
+
+	/* Set port config to GPIO mode */
+	out_be32(&gpio->port_config, in_be32(&gpio->port_config) & ~0x000000f0);
+
+	/* Set all PSC2 pins to high */
+	val = in_be32(&gpio->simple_dvo);
+	val |= 0x000000f0;
+	out_be32(&gpio->simple_dvo, val);
+
+	/* Set direction */
+	val = in_be32(&gpio->simple_ddr);
+	val |= 0x000000f0;
+	out_be32(&gpio->simple_ddr, val);
+
+	/* Enable GPIOs */
+	out_be32(&gpio->simple_gpioe, 0x000000f0);
+
+	/* Clock in n clocks with CS disabled */
+	for (i = 0; i < clocks; i++) {
+		out_be32(&gpio->simple_dvo,
+			 in_be32(&gpio->simple_dvo) | 0x00000080);
+		udelay(10);
+		out_be32(&gpio->simple_dvo,
+			 in_be32(&gpio->simple_dvo) & ~0x00000080);
+		udelay(10);
+	}
+
+	/* Set port config back to SPI mode */
+	out_be32(&gpio->port_config, in_be32(&gpio->port_config) | 0x00000060);
+}
+#else
+static void spi_send_clocks(int clocks)
+{
+	/*
+	 * Currently, only MPC5200 PSC SPI is tested with this
+	 * FPGA programming via SPI. Other SPI controllers might
+	 * need to add some code here to toggle the SPI clock
+	 * with inactive CS.
+	 */
+}
+#endif /* CONFIG_PPC_MPC52xx */
+
+/*
+ * Helper function to transfer one message (command and reply) full-duplex
+ * to and from the FPGA
+ */
+static int xp2_spi_write_read(struct spi_device *spi, u8 *txbuf, u8 *rxbuf,
+			      int len)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+
+	spi_message_init(&m);
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = txbuf;
+	t.rx_buf = rxbuf;
+	t.len = len;
+
+	spi_message_add_tail(&t, &m);
+	return spi_sync(spi, &m);
+}
+
+static u8 fpga_read_device_status(struct spi_device *spi)
+{
+	u8 txbuf[8];
+	u8 rxbuf[8];
+	int ret;
+
+	/* Fill dummy data (24 stuffing bits for commands) */
+	memset(txbuf, 0, sizeof(txbuf));
+
+	txbuf[0] = FPGA_CMD_READ_DEVICE_STATUS;
+	ret = xp2_spi_write_read(spi, txbuf, rxbuf, 8);
+
+	return *(u8 *)&rxbuf[4];
+}
+
+static u8 fpga_read_program_status(struct spi_device *spi)
+{
+	u8 txbuf[8];
+	u8 rxbuf[8];
+	int ret;
+
+	/* Fill dummy data (24 stuffing bits for commands) */
+	memset(txbuf, 0, sizeof(txbuf));
+
+	txbuf[0] = FPGA_CMD_READ_PROGRAM_STATUS;
+	ret = xp2_spi_write_read(spi, txbuf, rxbuf, 8);
+
+	return *(u8 *)&rxbuf[4];
+}
+
+static int fpga_send_cmd(struct spi_device *spi, u8 cmd)
+{
+	u8 txbuf[8];
+
+	/* Fill dummy data (24 stuffing bits for commands) */
+	memset(txbuf, 0, sizeof(txbuf));
+	txbuf[0] = cmd;
+
+	return spi_write(spi, txbuf, 4);
+}
+
+static int get_next_bit(char *ptr)
+{
+	if (*ptr == '1')
+		return 1;
+	if (*ptr == '0')
+		return 0;
+	if (*ptr == '*')
+		return -1;
+
+	return -2;
+}
+
+enum {
+	FPGA_WAITING,
+	FPGA_LOADING,
+	FPGA_SUCCESS,
+	FPGA_FAILED,
+};
+
+static DEFINE_MUTEX(sysfs_lock);
+
+static ssize_t fpga_config_status_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct fpga_data *data = dev_get_drvdata(dev);
+	ssize_t ret = 0;
+
+	mutex_lock(&sysfs_lock);
+
+	switch (data->device_loaded) {
+	case FPGA_WAITING:
+		ret = sprintf(buf, "waiting\n");
+		break;
+	case FPGA_LOADING:
+		ret = sprintf(buf, "loading\n");
+		break;
+	case FPGA_SUCCESS:
+		ret = sprintf(buf, "success\n");
+		break;
+	case FPGA_FAILED:
+		ret = sprintf(buf, "failed\n");
+		break;
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+	return ret;
+}
+
+static DEVICE_ATTR(fpga_config_status, S_IRUGO,
+		   fpga_config_status_show, NULL);
+
+static void firmware_load(const struct firmware *fw, void *context)
+{
+	struct spi_device *spi = (struct spi_device *)context;
+	struct fpga_data *data = spi_get_drvdata(spi);
+	char *start;
+	char *start_save;
+	int column_bytes;
+	int tag_bytes;
+	int byte;
+	u8 *row_data;
+	int ret;
+	u8 txbuf[8];
+	u8 rxbuf[8];
+	int i;
+	int device;
+	u32 jedec_id;
+	int row;
+	int col;
+	int data_bits;
+	u8 *txbuf2;
+	int security = 0;
+
+	data->device_loaded = FPGA_LOADING;
+
+	if (fw->size == 0) {
+		dev_err(&spi->dev, "Error: Firmware size is 0!\n");
+		goto out;
+	}
+
+	/*
+	 * Search for encryption/protection setting in JEDEC file
+	 */
+	start = (char *)fw->data;
+	for (i = 0; i < fw->size - strlen(JEDEC_SECURITY); i++) {
+		if (strncmp(start, JEDEC_SECURITY,
+			    strlen(JEDEC_SECURITY)) == 0) {
+			security = 1;
+			dev_info(&spi->dev, "Security fuse will be set!\n");
+			break;
+		}
+		start++;
+	}
+
+	/*
+	 * Search for bitstream start in JEDEC file
+	 */
+	start = (char *)fw->data;
+	for (i = 0; i < fw->size - strlen(JEDEC_DATA_START); i++) {
+		if (strncmp(start, JEDEC_DATA_START,
+			    strlen(JEDEC_DATA_START)) == 0)
+			break;
+		start++;
+	}
+	if (i == fw->size - strlen(JEDEC_DATA_START)) {
+		dev_err(&spi->dev,
+			"Error: JEDEC header incorrect, %s not fount!\n",
+			JEDEC_DATA_START);
+		goto out;
+	}
+	start += strlen(JEDEC_DATA_START) + 1;
+	start_save = start;
+
+	/* Fill dummy data (24 stuffing bits for commands) */
+	memset(txbuf, 0, sizeof(txbuf));
+
+	/* Trying to speak with the FPGA via SPI... */
+	txbuf[0] = FPGA_CMD_READ_ID;
+	ret = xp2_spi_write_read(spi, txbuf, rxbuf, 8);
+	dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
+	jedec_id = *(u32 *)&rxbuf[4];
+
+	for (i = 0; i < ARRAY_SIZE(xp2_dev); i++) {
+		if (jedec_id == xp2_dev[i].jedec_id)
+			break;
+	}
+	if (i == ARRAY_SIZE(xp2_dev)) {
+		dev_err(&spi->dev,
+			"Error: No supported FPGA detected (JEDEC_ID=%08x)!\n",
+			jedec_id);
+		goto out;
+	}
+
+	device = i;
+	column_bytes = (xp2_dev[device].columns +
+			xp2_dev[device].padding_bits) / 8;
+	tag_bytes = xp2_dev[device].tag_bits / 8;
+	dev_info(&spi->dev, "FPGA %s detected\n", xp2_dev[device].name);
+	dev_dbg(&spi->dev, "column_bytes=%d\n", column_bytes);
+	dev_dbg(&spi->dev, "tag_bytes=%d\n", tag_bytes);
+	dev_dbg(&spi->dev, "FPGA Device Status=%02x\n",
+		fpga_read_device_status(spi));
+	dev_dbg(&spi->dev, "FPGA Program Status=%02x\n",
+		fpga_read_program_status(spi));
+
+	/*
+	 * Check if firmware is big enough
+	 */
+	if (fw->size < (xp2_dev[device].rows * xp2_dev[device].columns)) {
+		dev_err(&spi->dev, "Error: Firmware image too small (jedec?)\n");
+		goto out;
+	}
+
+	/*
+	 * Allocate some bigger buffers for the SPI communication
+	 */
+	row_data = devm_kzalloc(&spi->dev, column_bytes + 64, GFP_KERNEL);
+	if (!row_data) {
+		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
+		goto out;
+	}
+
+	txbuf2 = devm_kzalloc(&spi->dev, column_bytes + 64, GFP_KERNEL);
+	if (!txbuf2) {
+		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
+		goto out;
+	}
+
+	/*
+	 * Erase FPGA flash
+	 * Step 1: Set device into background programming mode
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_X_PROGRAM_EN);
+
+	/*
+	 * Step 2: DISABLE_DONE command
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_DISABLE_DONE);
+	msleep(10);
+
+	/*
+	 * Step 3: Clock in erase command
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_ERASE);
+
+	/*
+	 * Wait for erase status completed
+	 */
+	for (i = 0; i < FPGA_ERASE_LOOP_COUNT; i++) {
+		msleep(FPGA_ERASE_MSLEEP);
+
+		if (fpga_read_program_status(spi) == FPGA_PROG_STATUS_ERASED)
+			break;
+	}
+
+	/*
+	 * Check device status
+	 */
+	if (fpga_read_device_status(spi) & FPGA_STATUS_ERASE_COMPLETED_N) {
+		dev_err(&spi->dev,
+			"Error: Erase failed (status=%02x)!\n",
+			fpga_read_device_status(spi));
+		goto out;
+	}
+
+	dev_dbg(&spi->dev, "FPGA successfully erased\n");
+
+	/*
+	 * Disable programming mode
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_PROGRAM_DIS);
+	msleep(10);
+
+	/*
+	 * Refresh configuration
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_REFRESH);
+	msleep(10);
+
+	/*
+	 * Set device into background programming mode (again)
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_X_PROGRAM_EN);
+	msleep(10);
+
+	/*
+	 * Double check if erase and refresh worked
+	 */
+	if (fpga_read_device_status(spi) & FPGA_STATUS_DONE_FUSE_PROGRAMMED) {
+		dev_err(&spi->dev,
+			"Error: Erase/Refresh failed (status=%02x)!\n",
+			fpga_read_device_status(spi));
+		goto out;
+	}
+
+	dev_dbg(&spi->dev, "FPGA successfully erased (2nd check)\n");
+
+	/*
+	 * Program JEDEC bitstream
+	 */
+
+	/*
+	 * Init first row address
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_INIT_ADDRESS);
+	msleep(10);
+
+	/*
+	 * Loop over all rows (program one row with column data bits
+	 * (plus padding)
+	 */
+	data_bits = 0;
+	for (row = 0; row < xp2_dev[device].rows; row++) {
+		/*
+		 * Start data in 4th byte, the 1st 4 bytes are filled with the
+		 * command
+		 */
+		memset(row_data, 0, column_bytes + 4);
+		row_data[0] = FPGA_CMD_PROGRAM_INC;
+		byte = 4;
+
+		/*
+		 * Generate one row of data
+		 */
+		for (col = xp2_dev[device].padding_bits;
+		     col < (xp2_dev[device].columns +
+			    xp2_dev[device].padding_bits);) {
+			int val = get_next_bit(start++);
+
+			if (val >= 0) {
+				row_data[byte] <<= 1;
+				if (val == 1)
+					row_data[byte] |= 0x01;
+
+				col++;
+				data_bits++;
+				if ((col % 8) == 0)
+					byte++;
+			}
+		}
+
+		if (byte != column_bytes + 4) {
+			dev_err(&spi->dev,
+				"Error: problem in bitstream (byte=%d column_bytes=%d\n",
+				byte, column_bytes);
+		}
+
+		/*
+		 * Program one row
+		 */
+		ret = spi_write(spi, row_data, byte);
+
+		/*
+		 * Add at least 3 clocks with CS inactive
+		 */
+		spi_send_clocks(8);
+
+		/*
+		 * Wait for program status completed
+		 */
+		for (i = 0; i < FPGA_PROG_LOOP_COUNT; i++) {
+			msleep(FPGA_PROG_MSLEEP);
+
+			if (fpga_read_program_status(spi) ==
+			    FPGA_PROG_STATUS_ERASED)
+				break;
+		}
+	}
+
+	/*
+	 * Verify the programmed data by reading back from FPGA and
+	 * comparing with bitstream data from jedec file
+	 */
+
+	/*
+	 * Init first row address
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_INIT_ADDRESS);
+	msleep(10);
+
+	txbuf2[0] = FPGA_CMD_VERIFY_INC;
+	txbuf2[1] = 0x00;
+	txbuf2[2] = 0x00;
+	txbuf2[3] = 0x00;
+
+	start = start_save;
+
+	for (row = 0; row < xp2_dev[device].rows; row++) {
+		/*
+		 * Read one row from FPGA FLASH
+		 */
+		ret = xp2_spi_write_read(spi, txbuf2, row_data,
+					 column_bytes + 4);
+
+		/*
+		 * Add at least 3 clocks with CS inactive
+		 */
+		spi_send_clocks(8);
+
+		/*
+		 * Mask padding bits in last byte read from FPGA
+		 */
+		for (i = 0; i < xp2_dev[device].padding_bits; i++)
+			row_data[column_bytes + 3] &= ~(1 << i);
+
+		/*
+		 * Generate one row of data from JEDEC file
+		 */
+		byte = 4;
+		for (col = 0; col < xp2_dev[device].columns; ) {
+			int val = get_next_bit(start++);
+
+			if (val >= 0) {
+				txbuf2[byte] <<= 1;
+				if (val == 1)
+					txbuf2[byte] |= 0x01;
+
+				col++;
+				data_bits++;
+				if ((col % 8) == 0)
+					byte++;
+			}
+		}
+		for (col = 0; col < xp2_dev[device].padding_bits; col++)
+			txbuf2[byte] <<= 1;
+
+		/*
+		 * Now compare this row
+		 */
+		for (col = 4; col < column_bytes + 4; col++) {
+			if (row_data[col] != txbuf2[col]) {
+				dev_err(&spi->dev,
+					"Error: Verify failed!\n");
+				goto out;
+			}
+		}
+	}
+
+	dev_info(&spi->dev, "FPGA data verified!\n");
+
+	if (security) {
+		/*
+		 * Program security fuse
+		 */
+		ret = fpga_send_cmd(spi, FPGA_CMD_PROGRAM_SECURITY);
+		msleep(10);
+
+		/*
+		 * Wait for program status completed
+		 */
+		for (i = 0; i < FPGA_PROG_LOOP_COUNT; i++) {
+			msleep(FPGA_PROG_MSLEEP);
+
+			if (fpga_read_program_status(spi) ==
+			    FPGA_PROG_STATUS_ERASED)
+				break;
+		}
+
+		dev_info(&spi->dev, "FPGA security fuse programmed\n");
+	}
+
+	/*
+	 * Program DONE fuse
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_PROGRAM_DONE);
+
+	/*
+	 * Wait for status completed
+	 */
+	for (i = 0; i < FPGA_PROG_DONE_LOOP_COUNT; i++) {
+		msleep(FPGA_PROG_DONE_MSLEEP);
+
+		if (fpga_read_program_status(spi) == FPGA_PROG_STATUS_ERASED)
+			break;
+	}
+
+	/*
+	 * Check device status
+	 */
+	if (fpga_read_device_status(spi) & FPGA_STATUS_ERASE_COMPLETED_N) {
+		dev_err(&spi->dev,
+			"Error: Program DONE failed (status=%02x)!\n",
+			fpga_read_device_status(spi));
+		goto out;
+	}
+
+	dev_info(&spi->dev, "FPGA DONE fuse programmed\n");
+
+	/*
+	 * Refresh: load new configuration from FPGA flash
+	 * to RAM and activate it
+	 */
+	ret = fpga_send_cmd(spi, FPGA_CMD_PROGRAM_DIS);
+	msleep(10);
+
+	ret = fpga_send_cmd(spi, FPGA_CMD_REFRESH);
+	msleep(10);
+
+	/*
+	 * Wait for status completed
+	 */
+	for (i = 0; i < FPGA_REFRESH_LOOP_COUNT; i++) {
+		msleep(FPGA_REFRESH_MSLEEP);
+
+		if (fpga_read_device_status(spi) &
+		    FPGA_STATUS_DONE_FUSE_PROGRAMMED)
+			break;
+	}
+
+	if (!(fpga_read_device_status(spi) & FPGA_STATUS_DONE_FUSE_PROGRAMMED)) {
+		dev_err(&spi->dev,
+			"Error: Refresh failed (status=%02x)!\n",
+			fpga_read_device_status(spi));
+		goto out;
+	}
+
+	dev_info(&spi->dev, "FPGA successfully refreshed!\n");
+	dev_dbg(&spi->dev, "FPGA Device Status=%02x\n",
+		fpga_read_device_status(spi));
+	dev_dbg(&spi->dev, "FPGA Program Status=%02x\n",
+		fpga_read_program_status(spi));
+	data->device_loaded = FPGA_SUCCESS;
+
+	/*
+	 * Don't forget to release the firmware again
+	 */
+	release_firmware(fw);
+	complete(&data->fw_loaded);
+	return;
+
+out:
+	data->device_loaded = FPGA_FAILED;
+
+	/*
+	 * Don't forget to release the firmware again
+	 */
+	release_firmware(fw);
+	complete(&data->fw_loaded);
+}
+
+static int lattice_xp2_probe(struct spi_device *spi)
+{
+	struct fpga_data *data;
+	int err = 0;
+
+#ifdef CONFIG_PPC_MPC52xx
+	err = mpc5200_map_gpio(spi);
+	if (err)
+		return err;
+#endif
+
+	data = devm_kzalloc(&spi->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&spi->dev, "Memory allocation for fpga_data failed\n");
+		return -ENOMEM;
+	}
+	spi_set_drvdata(spi, data);
+
+	data->device_loaded = FPGA_WAITING;
+	init_completion(&data->fw_loaded);
+
+	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				      FIRMWARE_NAME, &spi->dev, GFP_KERNEL,
+				      spi, firmware_load);
+	if (err) {
+		dev_err(&spi->dev, "Firmware loading failed with %d!\n", err);
+		goto err;
+	}
+
+	/*
+	 * Create sysfs file for userspace communication (FPGA configuration
+	 * status)
+	 */
+	err = device_create_file(&spi->dev, &dev_attr_fpga_config_status);
+	if (err) {
+		dev_err(&spi->dev, "Cannot create sysfs file");
+		goto err;
+	}
+
+	dev_info(&spi->dev, "FPGA bitstream configuration driver registered (ver %s)\n",
+		DRIVER_VER);
+
+	return 0;
+
+err:
+	return err;
+}
+
+static int lattice_xp2_remove(struct spi_device *spi)
+{
+	struct fpga_data *data = spi_get_drvdata(spi);
+
+	wait_for_completion(&data->fw_loaded);
+
+#ifdef CONFIG_PPC_MPC52xx
+	iounmap(gpio);
+#endif
+
+	device_remove_file(&spi->dev, &dev_attr_fpga_config_status);
+
+	return 0;
+}
+
+static const struct spi_device_id lattice_xp2_id[] = {
+	{ "xp2-17", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, lattice_xp2_id);
+
+static struct spi_driver lattice_xp2_driver = {
+	.driver = {
+		.name = "lattice-xp2",
+		.owner = THIS_MODULE,
+	},
+	.probe = lattice_xp2_probe,
+	.remove = lattice_xp2_remove,
+	.id_table = lattice_xp2_id,
+};
+
+module_spi_driver(lattice_xp2_driver);
+
+MODULE_AUTHOR("Stefan Roese <sr@denx.de>");
+MODULE_DESCRIPTION("Lattice XP FPGA configuration via SPI driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:xp2");
-- 
1.8.2.3

