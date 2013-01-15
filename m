Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3AOTvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:51:42 -0500
Received: from xes-mad.com ([216.165.139.218]:51727 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3AOTvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:51:40 -0500
X-Greylist: delayed 2589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 14:50:39 EST
Date: Tue, 15 Jan 2013 13:12:15 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] lpc_ich: fix gpio base and control offsets
Message-ID: <a858277c-6164-4d43-abee-a3d34ad8b04c@zimbra>
In-Reply-To: <fe420c78-bf1b-40f0-b3f0-09ea26986de2@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC20 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
properly be enabled (and disabled) for these chipsets.

Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/mfd/lpc_ich.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index d9d9303..f9029b6 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -76,16 +76,21 @@
 #define ACPIBASE_GCS_END	0x3414
 
 #define GPIOBASE		0x48
+#define GPIOBASE_ICH5		0x58
 #define GPIOCTRL		0x4C
+#define GPIOCTRL_ICH5		0x58
 
 #define RCBABASE		0xf0
 
+#define gpio_base() ((lpc_ich_chipset <= LPC_ICH5) ? GPIOBASE_ICH5 : GPIOBASE)
+#define gpio_ctrl() ((lpc_ich_chipset <= LPC_ICH5) ? GPIOCTRL_ICH5 : GPIOCTRL)
 #define wdt_io_res(i) wdt_res(0, i)
 #define wdt_mem_res(i) wdt_res(ICH_RES_MEM_OFF, i)
 #define wdt_res(b, i) (&wdt_ich_res[(b) + (i)])
 
 static int lpc_ich_acpi_save = -1;
 static int lpc_ich_gpio_save = -1;
+static unsigned long lpc_ich_chipset = -1;
 
 static struct resource wdt_ich_res[] = {
 	/* ACPI - TCO */
@@ -667,7 +672,7 @@ static void lpc_ich_restore_config_space(struct pci_dev *dev)
 	}
 
 	if (lpc_ich_gpio_save >= 0) {
-		pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
+		pci_write_config_byte(dev, gpio_ctrl(), lpc_ich_gpio_save);
 		lpc_ich_gpio_save = -1;
 	}
 }
@@ -685,15 +690,14 @@ static void lpc_ich_enable_gpio_space(struct pci_dev *dev)
 {
 	u8 reg_save;
 
-	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
-	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
+	pci_read_config_byte(dev, gpio_ctrl(), &reg_save);
+	pci_write_config_byte(dev, gpio_ctrl(), reg_save | 0x10);
 	lpc_ich_gpio_save = reg_save;
 }
 
-static void lpc_ich_finalize_cell(struct mfd_cell *cell,
-					const struct pci_device_id *id)
+static void lpc_ich_finalize_cell(struct mfd_cell *cell)
 {
-	cell->platform_data = &lpc_chipset_info[id->driver_data];
+	cell->platform_data = &lpc_chipset_info[lpc_ich_chipset];
 	cell->pdata_size = sizeof(struct lpc_ich_info);
 }
 
@@ -721,8 +725,7 @@ static int lpc_ich_check_conflict_gpio(struct resource *res)
 	return use_gpio ? use_gpio : ret;
 }
 
-static int lpc_ich_init_gpio(struct pci_dev *dev,
-				const struct pci_device_id *id)
+static int lpc_ich_init_gpio(struct pci_dev *dev)
 {
 	u32 base_addr_cfg;
 	u32 base_addr;
@@ -757,7 +760,7 @@ static int lpc_ich_init_gpio(struct pci_dev *dev,
 
 gpe0_done:
 	/* Setup GPIO base register */
-	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, gpio_base(), &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for GPIO uninitialized\n");
@@ -768,7 +771,7 @@ gpe0_done:
 	/* Older devices provide fewer GPIO and have a smaller resource size. */
 	res = &gpio_ich_res[ICH_RES_GPIO];
 	res->start = base_addr;
-	switch (lpc_chipset_info[id->driver_data].gpio_version) {
+	switch (lpc_chipset_info[lpc_ich_chipset].gpio_version) {
 	case ICH_V5_GPIO:
 	case ICH_V10CORP_GPIO:
 		res->end = res->start + 128 - 1;
@@ -784,10 +787,10 @@ gpe0_done:
 		acpi_conflict = true;
 		goto gpio_done;
 	}
-	lpc_chipset_info[id->driver_data].use_gpio = ret;
+	lpc_chipset_info[lpc_ich_chipset].use_gpio = ret;
 	lpc_ich_enable_gpio_space(dev);
 
-	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
+	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO]);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_GPIO],
 			      1, NULL, 0, NULL);
 
@@ -798,8 +801,7 @@ gpio_done:
 	return ret;
 }
 
-static int lpc_ich_init_wdt(struct pci_dev *dev,
-				const struct pci_device_id *id)
+static int lpc_ich_init_wdt(struct pci_dev *dev)
 {
 	u32 base_addr_cfg;
 	u32 base_addr;
@@ -830,7 +832,7 @@ static int lpc_ich_init_wdt(struct pci_dev *dev,
 	 * we have to read RCBA from PCI Config space 0xf0 and use
 	 * it as base. GCS = RCBA + ICH6_GCS(0x3410).
 	 */
-	if (lpc_chipset_info[id->driver_data].iTCO_version == 1) {
+	if (lpc_chipset_info[lpc_ich_chipset].iTCO_version == 1) {
 		/* Don't register iomem for TCO ver 1 */
 		lpc_ich_cells[LPC_WDT].num_resources--;
 	} else {
@@ -847,7 +849,7 @@ static int lpc_ich_init_wdt(struct pci_dev *dev,
 		res->end = base_addr + ACPIBASE_GCS_END;
 	}
 
-	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
+	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT]);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_WDT],
 			      1, NULL, 0, NULL);
 
@@ -861,11 +863,13 @@ static int lpc_ich_probe(struct pci_dev *dev,
 	int ret;
 	bool cell_added = false;
 
-	ret = lpc_ich_init_wdt(dev, id);
+	lpc_ich_chipset = id->driver_data;
+
+	ret = lpc_ich_init_wdt(dev);
 	if (!ret)
 		cell_added = true;
 
-	ret = lpc_ich_init_gpio(dev, id);
+	ret = lpc_ich_init_gpio(dev);
 	if (!ret)
 		cell_added = true;
 
-- 
1.7.9.5
