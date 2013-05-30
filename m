Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967412Ab3E3DEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:04:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:20732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967381Ab3E3DDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312637"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 06/13] intel_mid: Refactored sfi_parse_devs() function
Date: Wed, 29 May 2013 19:45:16 -0700
Message-Id: <1369881923-27067-7-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SFI device_id[] table parsing code is duplicated in every SFI
device handler. This patch removes this code duplication, by
adding a seperate function get_device_id() to parse through the
device table. Also this patch moves the SPI, I2C, IPC info code from
sfi_parse_devs() to respective device handlers.

Change-Id: I995bcf6ab872272d4a08a900231ddc5f3110c8a6
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/platform/intel-mid/intel-mid.c |  141 ++++++++++++++++---------------
 1 file changed, 71 insertions(+), 70 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 38071c1..ef94c7d 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -831,20 +831,15 @@ static void __init install_irq_resource(struct platform_device *pdev, int irq)
 	platform_device_add_resources(pdev, &res, 1);
 }
 
-static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *entry)
+static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
 {
-	const struct devs_id *dev = device_ids;
 	struct platform_device *pdev;
 	void *pdata = NULL;
 
-	while (dev->name[0]) {
-		if (dev->type == SFI_DEV_TYPE_IPC &&
-			!strncmp(dev->name, entry->name, SFI_NAME_LEN)) {
-			pdata = dev->get_platform_data(entry);
-			break;
-		}
-		dev++;
-	}
+	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
+		pentry->name, pentry->irq);
+	pdata = dev->get_platform_data(pentry);
 
 	/*
 	 * On Medfield the platform device creation is handled by the MSIC
@@ -853,68 +848,94 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *entry)
 	if (intel_mid_has_msic())
 		return;
 
-	pdev = platform_device_alloc(entry->name, 0);
+	pdev = platform_device_alloc(pentry->name, 0);
 	if (pdev == NULL) {
 		pr_err("out of memory for SFI platform device '%s'.\n",
-			entry->name);
+			pentry->name);
 		return;
 	}
-	install_irq_resource(pdev, entry->irq);
+	install_irq_resource(pdev, pentry->irq);
 
 	pdev->dev.platform_data = pdata;
 	intel_scu_device_register(pdev);
 }
 
-static void __init sfi_handle_spi_dev(struct spi_board_info *spi_info)
+static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
 {
-	const struct devs_id *dev = device_ids;
+	struct spi_board_info spi_info;
 	void *pdata = NULL;
 
-	while (dev->name[0]) {
-		if (dev->type == SFI_DEV_TYPE_SPI &&
-			!strncmp(dev->name, spi_info->modalias,
-						SFI_NAME_LEN)) {
-			pdata = dev->get_platform_data(spi_info);
-			break;
-		}
-		dev++;
-	}
-	spi_info->platform_data = pdata;
+	memset(&spi_info, 0, sizeof(spi_info));
+	strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
+	spi_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
+	spi_info.bus_num = pentry->host_num;
+	spi_info.chip_select = pentry->addr;
+	spi_info.max_speed_hz = pentry->max_freq;
+	pr_debug("SPI bus=%d, name=%16.16s, irq=0x%2x, max_freq=%d, cs=%d\n",
+		spi_info.bus_num,
+		spi_info.modalias,
+		spi_info.irq,
+		spi_info.max_speed_hz,
+		spi_info.chip_select);
+
+	pdata = dev->get_platform_data(&spi_info);
+
+	spi_info.platform_data = pdata;
 	if (dev->delay)
-		intel_scu_spi_device_register(spi_info);
+		intel_scu_spi_device_register(&spi_info);
 	else
-		spi_register_board_info(spi_info, 1);
+		spi_register_board_info(&spi_info, 1);
 }
 
-static void __init sfi_handle_i2c_dev(int bus, struct i2c_board_info *i2c_info)
+static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
+					struct devs_id *dev)
 {
-	const struct devs_id *dev = device_ids;
+	struct i2c_board_info i2c_info;
 	void *pdata = NULL;
 
+	memset(&i2c_info, 0, sizeof(i2c_info));
+	strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
+	i2c_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
+	i2c_info.addr = pentry->addr;
+	pr_debug("I2C bus = %d, name = %16.16s, irq = 0x%2x, addr = 0x%x\n",
+		pentry->host_num,
+		i2c_info.type,
+		i2c_info.irq,
+		i2c_info.addr);
+	pdata = dev->get_platform_data(&i2c_info);
+	i2c_info.platform_data = pdata;
+
+	if (dev->delay)
+		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
+	else
+		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
+}
+
+static struct devs_id __init *get_device_id(u8 type, char *name)
+{
+	struct devs_id *dev = device_ids;
+
+	if (device_ids == NULL)
+		return NULL;
+
 	while (dev->name[0]) {
-		if (dev->type == SFI_DEV_TYPE_I2C &&
-			!strncmp(dev->name, i2c_info->type, SFI_NAME_LEN)) {
-			pdata = dev->get_platform_data(i2c_info);
-			break;
+		if (dev->type == type &&
+			!strncmp(dev->name, name, SFI_NAME_LEN)) {
+			return dev;
 		}
 		dev++;
 	}
-	i2c_info->platform_data = pdata;
 
-	if (dev->delay)
-		intel_scu_i2c_device_register(bus, i2c_info);
-	else
-		i2c_register_board_info(bus, i2c_info, 1);
+	return NULL;
 }
 
-
 static int __init sfi_parse_devs(struct sfi_table_header *table)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_device_table_entry *pentry;
-	struct spi_board_info spi_info;
-	struct i2c_board_info i2c_info;
-	int num, i, bus;
+	struct devs_id *dev = NULL;
+	int num, i;
 	int ioapic;
 	struct io_apic_irq_attr irq_attr;
 
@@ -939,40 +960,20 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 		} else
 			irq = 0; /* No irq */
 
+		dev = get_device_id(pentry->type, pentry->name);
+
+		if ((dev == NULL) || (dev->get_platform_data == NULL))
+			continue;
+
 		switch (pentry->type) {
 		case SFI_DEV_TYPE_IPC:
-			pr_debug("info[%2d]: IPC bus, name = %16.16s, "
-				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
-			sfi_handle_ipc_dev(pentry);
+			sfi_handle_ipc_dev(pentry, dev);
 			break;
 		case SFI_DEV_TYPE_SPI:
-			memset(&spi_info, 0, sizeof(spi_info));
-			strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
-			spi_info.irq = irq;
-			spi_info.bus_num = pentry->host_num;
-			spi_info.chip_select = pentry->addr;
-			spi_info.max_speed_hz = pentry->max_freq;
-			pr_debug("info[%2d]: SPI bus = %d, name = %16.16s, "
-				"irq = 0x%2x, max_freq = %d, cs = %d\n", i,
-				spi_info.bus_num,
-				spi_info.modalias,
-				spi_info.irq,
-				spi_info.max_speed_hz,
-				spi_info.chip_select);
-			sfi_handle_spi_dev(&spi_info);
+			sfi_handle_spi_dev(pentry, dev);
 			break;
 		case SFI_DEV_TYPE_I2C:
-			memset(&i2c_info, 0, sizeof(i2c_info));
-			bus = pentry->host_num;
-			strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
-			i2c_info.irq = irq;
-			i2c_info.addr = pentry->addr;
-			pr_debug("info[%2d]: I2C bus = %d, name = %16.16s, "
-				"irq = 0x%2x, addr = 0x%x\n", i, bus,
-				i2c_info.type,
-				i2c_info.irq,
-				i2c_info.addr);
-			sfi_handle_i2c_dev(bus, &i2c_info);
+			sfi_handle_i2c_dev(pentry, dev);
 			break;
 		case SFI_DEV_TYPE_UART:
 		case SFI_DEV_TYPE_HSI:
-- 
1.7.9.5

