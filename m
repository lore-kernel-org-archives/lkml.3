Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaCJVg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:36:59 -0400
Received: from xes-mad.com ([216.165.139.218]:21682 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbaCJVfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:19 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] mfd: lpc_ich: Remove lpc_ich_cfg struct use
Date: Mon, 10 Mar 2014 16:34:53 -0500
Message-Id: <1394487298-14459-3-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
In-Reply-To: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Future chipsets will use different register layouts that don't map
cleanly to the lpc_ich_cfg fields.  Remove the lpc_ich_cfg struct and
add explicit fields to the higher level lpc_ich_priv structure.

This change should have no functional impact.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Tested-by: Rajat Jain <rajatjain@juniper.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lpc_ich.c |   63 +++++++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index e247e7e..2cc052a 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -90,16 +90,16 @@
 #define wdt_mem_res(i) wdt_res(ICH_RES_MEM_OFF, i)
 #define wdt_res(b, i) (&wdt_ich_res[(b) + (i)])
 
-struct lpc_ich_cfg {
-	int base;
-	int ctrl;
-	int save;
-};
-
 struct lpc_ich_priv {
 	int chipset;
-	struct lpc_ich_cfg acpi;
-	struct lpc_ich_cfg gpio;
+
+	int abase;		/* ACPI base */
+	int actrl;		/* ACPI control or PMC base */
+	int gbase;		/* GPIO base */
+	int gctrl;		/* GPIO control */
+
+	int actrl_save;		/* Cached ACPI control base value */
+	int gctrl_save;		/* Cached GPIO control value */
 };
 
 static struct resource wdt_ich_res[] = {
@@ -742,14 +742,14 @@ static void lpc_ich_restore_config_space(struct pci_dev *dev)
 {
 	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 
-	if (priv->acpi.save >= 0) {
-		pci_write_config_byte(dev, priv->acpi.ctrl, priv->acpi.save);
-		priv->acpi.save = -1;
+	if (priv->actrl_save >= 0) {
+		pci_write_config_byte(dev, priv->actrl, priv->actrl_save);
+		priv->actrl_save = -1;
 	}
 
-	if (priv->gpio.save >= 0) {
-		pci_write_config_byte(dev, priv->gpio.ctrl, priv->gpio.save);
-		priv->gpio.save = -1;
+	if (priv->gctrl_save >= 0) {
+		pci_write_config_byte(dev, priv->gctrl, priv->gctrl_save);
+		priv->gctrl_save = -1;
 	}
 }
 
@@ -758,9 +758,9 @@ static void lpc_ich_enable_acpi_space(struct pci_dev *dev)
 	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u8 reg_save;
 
-	pci_read_config_byte(dev, priv->acpi.ctrl, &reg_save);
-	pci_write_config_byte(dev, priv->acpi.ctrl, reg_save | 0x80);
-	priv->acpi.save = reg_save;
+	pci_read_config_byte(dev, priv->actrl, &reg_save);
+	pci_write_config_byte(dev, priv->actrl, reg_save | 0x80);
+	priv->actrl_save = reg_save;
 }
 
 static void lpc_ich_enable_gpio_space(struct pci_dev *dev)
@@ -768,9 +768,9 @@ static void lpc_ich_enable_gpio_space(struct pci_dev *dev)
 	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	u8 reg_save;
 
-	pci_read_config_byte(dev, priv->gpio.ctrl, &reg_save);
-	pci_write_config_byte(dev, priv->gpio.ctrl, reg_save | 0x10);
-	priv->gpio.save = reg_save;
+	pci_read_config_byte(dev, priv->gctrl, &reg_save);
+	pci_write_config_byte(dev, priv->gctrl, reg_save | 0x10);
+	priv->gctrl_save = reg_save;
 }
 
 static void lpc_ich_finalize_cell(struct pci_dev *dev, struct mfd_cell *cell)
@@ -815,7 +815,7 @@ static int lpc_ich_init_gpio(struct pci_dev *dev)
 	struct resource *res;
 
 	/* Setup power management base register */
-	pci_read_config_dword(dev, priv->acpi.base, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->abase, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
@@ -841,7 +841,7 @@ static int lpc_ich_init_gpio(struct pci_dev *dev)
 
 gpe0_done:
 	/* Setup GPIO base register */
-	pci_read_config_dword(dev, priv->gpio.base, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->gbase, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for GPIO uninitialized\n");
@@ -891,7 +891,7 @@ static int lpc_ich_init_wdt(struct pci_dev *dev)
 	struct resource *res;
 
 	/* Setup power management base register */
-	pci_read_config_dword(dev, priv->acpi.base, &base_addr_cfg);
+	pci_read_config_dword(dev, priv->abase, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_notice(&dev->dev, "I/O space for ACPI uninitialized\n");
@@ -952,17 +952,18 @@ static int lpc_ich_probe(struct pci_dev *dev,
 		return -ENOMEM;
 
 	priv->chipset = id->driver_data;
-	priv->acpi.save = -1;
-	priv->acpi.base = ACPIBASE;
-	priv->acpi.ctrl = ACPICTRL;
 
-	priv->gpio.save = -1;
+	priv->actrl_save = -1;
+	priv->abase = ACPIBASE;
+	priv->actrl = ACPICTRL;
+
+	priv->gctrl_save = -1;
 	if (priv->chipset <= LPC_ICH5) {
-		priv->gpio.base = GPIOBASE_ICH0;
-		priv->gpio.ctrl = GPIOCTRL_ICH0;
+		priv->gbase = GPIOBASE_ICH0;
+		priv->gctrl = GPIOCTRL_ICH0;
 	} else {
-		priv->gpio.base = GPIOBASE_ICH6;
-		priv->gpio.ctrl = GPIOCTRL_ICH6;
+		priv->gbase = GPIOBASE_ICH6;
+		priv->gctrl = GPIOCTRL_ICH6;
 	}
 
 	pci_set_drvdata(dev, priv);
-- 
1.7.7.GIT

