Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3AXUw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:52:59 -0500
Received: from xes-mad.com ([216.165.139.218]:52819 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3AXUwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:52:49 -0500
Date: Thu, 24 Jan 2013 14:52:39 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] lpc_ich: fix gpio base and control offsets
Message-ID: <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
In-Reply-To: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
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
 drivers/mfd/lpc_ich.c |  109 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 76 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index d9d9303..a0cfdf9 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -75,8 +75,10 @@
 #define ACPIBASE_GCS_OFF	0x3410
 #define ACPIBASE_GCS_END	0x3414
 
-#define GPIOBASE		0x48
-#define GPIOCTRL		0x4C
+#define GPIOBASE_ICH0		0x58
+#define GPIOCTRL_ICH0		0x5C
+#define GPIOBASE_ICH6		0x48
+#define GPIOCTRL_ICH6		0x4C
 
 #define RCBABASE		0xf0
 
@@ -84,8 +86,17 @@
 #define wdt_mem_res(i) wdt_res(ICH_RES_MEM_OFF, i)
 #define wdt_res(b, i) (&wdt_ich_res[(b) + (i)])
 
-static int lpc_ich_acpi_save = -1;
-static int lpc_ich_gpio_save = -1;
+struct lpc_ich_cfg {
+	int base;
+	int ctrl;
+	int save;
+};
+
+struct lpc_ich_priv {
+	int chipset;
+	struct lpc_ich_cfg acpi;
+	struct lpc_ich_cfg gpio;
+};
 
 static struct resource wdt_ich_res[] = {
 	/* ACPI - TCO */
@@ -661,39 +672,44 @@ MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
 
 static void lpc_ich_restore_config_space(struct pci_dev *dev)
 {
-	if (lpc_ich_acpi_save >= 0) {
-		pci_write_config_byte(dev, ACPICTRL, lpc_ich_acpi_save);
-		lpc_ich_acpi_save = -1;
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
+
+	if (priv->acpi.save >= 0) {
+		pci_write_config_byte(dev, priv->acpi.ctrl, priv->acpi.save);
+		priv->acpi.save = -1;
 	}
 
-	if (lpc_ich_gpio_save >= 0) {
-		pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
-		lpc_ich_gpio_save = -1;
+	if (priv->gpio.save >= 0) {
+		pci_write_config_byte(dev, priv->gpio.ctrl, priv->gpio.save);
+		priv->gpio.save = -1;
 	}
 }
 
 static void lpc_ich_enable_acpi_space(struct pci_dev *dev)
 {
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u8 reg_save;
 
-	pci_read_config_byte(dev, ACPICTRL, &reg_save);
-	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
-	lpc_ich_acpi_save = reg_save;
+	pci_read_config_byte(dev, priv->acpi.ctrl, &reg_save);
+	pci_write_config_byte(dev, priv->acpi.ctrl, reg_save | 0x10);
+	priv->acpi.save = reg_save;
 }
 
 static void lpc_ich_enable_gpio_space(struct pci_dev *dev)
 {
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u8 reg_save;
 
-	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
-	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
-	lpc_ich_gpio_save = reg_save;
+	pci_read_config_byte(dev, priv->gpio.ctrl, &reg_save);
+	pci_write_config_byte(dev, priv->gpio.ctrl, reg_save | 0x10);
+	priv->gpio.save = reg_save;
 }
 
-static void lpc_ich_finalize_cell(struct mfd_cell *cell,
-					const struct pci_device_id *id)
+static void lpc_ich_finalize_cell(struct pci_dev *dev, struct mfd_cell *cell)
 {
-	cell->platform_data = &lpc_chipset_info[id->driver_data];
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
+
+	cell->platform_data = &lpc_chipset_info[priv->chipset];
 	cell->pdata_size = sizeof(struct lpc_ich_info);
 }
 
@@ -721,9 +737,9 @@ static int lpc_ich_check_conflict_gpio(struct resource *res)
 	return use_gpio ? use_gpio : ret;
 }
 
-static int lpc_ich_init_gpio(struct pci_dev *dev,
-				const struct pci_device_id *id)
+static int lpc_ich_init_gpio(struct pci_dev *dev)
 {
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u32 base_addr_cfg;
 	u32 base_addr;
 	int ret;
@@ -731,7 +747,7 @@ static int lpc_ich_init_gpio(struct pci_dev *dev,
 	struct resource *res;
 
 	/* Setup power management base register */
-	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->acpi.base, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
@@ -757,7 +773,7 @@ static int lpc_ich_init_gpio(struct pci_dev *dev,
 
 gpe0_done:
 	/* Setup GPIO base register */
-	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->gpio.base, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for GPIO uninitialized\n");
@@ -768,7 +784,7 @@ gpe0_done:
 	/* Older devices provide fewer GPIO and have a smaller resource size. */
 	res = &gpio_ich_res[ICH_RES_GPIO];
 	res->start = base_addr;
-	switch (lpc_chipset_info[id->driver_data].gpio_version) {
+	switch (lpc_chipset_info[priv->chipset].gpio_version) {
 	case ICH_V5_GPIO:
 	case ICH_V10CORP_GPIO:
 		res->end = res->start + 128 - 1;
@@ -784,10 +800,10 @@ gpe0_done:
 		acpi_conflict = true;
 		goto gpio_done;
 	}
-	lpc_chipset_info[id->driver_data].use_gpio = ret;
+	lpc_chipset_info[priv->chipset].use_gpio = ret;
 	lpc_ich_enable_gpio_space(dev);
 
-	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
+	lpc_ich_finalize_cell(dev, &lpc_ich_cells[LPC_GPIO]);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_GPIO],
 			      1, NULL, 0, NULL);
 
@@ -798,16 +814,16 @@ gpio_done:
 	return ret;
 }
 
-static int lpc_ich_init_wdt(struct pci_dev *dev,
-				const struct pci_device_id *id)
+static int lpc_ich_init_wdt(struct pci_dev *dev)
 {
+	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u32 base_addr_cfg;
 	u32 base_addr;
 	int ret;
 	struct resource *res;
 
 	/* Setup power management base register */
-	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->acpi.base, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
@@ -830,7 +846,7 @@ static int lpc_ich_init_wdt(struct pci_dev *dev,
 	 * we have to read RCBA from PCI Config space 0xf0 and use
 	 * it as base. GCS = RCBA + ICH6_GCS(0x3410).
 	 */
-	if (lpc_chipset_info[id->driver_data].iTCO_version == 1) {
+	if (lpc_chipset_info[priv->chipset].iTCO_version == 1) {
 		/* Don't register iomem for TCO ver 1 */
 		lpc_ich_cells[LPC_WDT].num_resources--;
 	} else {
@@ -847,7 +863,7 @@ static int lpc_ich_init_wdt(struct pci_dev *dev,
 		res->end = base_addr + ACPIBASE_GCS_END;
 	}
 
-	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
+	lpc_ich_finalize_cell(dev, &lpc_ich_cells[LPC_WDT]);
 	ret = mfd_add_devices(&dev->dev, -1, &lpc_ich_cells[LPC_WDT],
 			      1, NULL, 0, NULL);
 
@@ -858,14 +874,35 @@ wdt_done:
 static int lpc_ich_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
 {
+	struct lpc_ich_priv *priv;
 	int ret;
 	bool cell_added = false;
 
-	ret = lpc_ich_init_wdt(dev, id);
+	priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->chipset = id->driver_data;
+	priv->acpi.save = -1;
+	priv->acpi.base = ACPIBASE;
+	priv->acpi.ctrl = ACPICTRL;
+
+	priv->gpio.save = -1;
+	if (priv->chipset <= LPC_ICH5) {
+		priv->gpio.base = GPIOBASE_ICH0;
+		priv->gpio.ctrl = GPIOCTRL_ICH0;
+	} else {
+		priv->gpio.base = GPIOBASE_ICH6;
+		priv->gpio.ctrl = GPIOCTRL_ICH6;
+	}
+
+	pci_set_drvdata(dev, priv);
+
+	ret = lpc_ich_init_wdt(dev);
 	if (!ret)
 		cell_added = true;
 
-	ret = lpc_ich_init_gpio(dev, id);
+	ret = lpc_ich_init_gpio(dev);
 	if (!ret)
 		cell_added = true;
 
@@ -876,6 +913,8 @@ static int lpc_ich_probe(struct pci_dev *dev,
 	if (!cell_added) {
 		dev_warn(&dev->dev, "No MFD cells added\n");
 		lpc_ich_restore_config_space(dev);
+		pci_set_drvdata(dev, NULL);
+		kfree(priv);
 		return -ENODEV;
 	}
 
@@ -884,8 +923,12 @@ static int lpc_ich_probe(struct pci_dev *dev,
 
 static void lpc_ich_remove(struct pci_dev *dev)
 {
+	void *priv = pci_get_drvdata(dev);
+
 	mfd_remove_devices(&dev->dev);
 	lpc_ich_restore_config_space(dev);
+	pci_set_drvdata(dev, NULL);
+	kfree(priv);
 }
 
 static struct pci_driver lpc_ich_driver = {
-- 
1.7.9.5
