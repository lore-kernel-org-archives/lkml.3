Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3ANRnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:43:17 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42844 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3ANRnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:43:15 -0500
Date: Mon, 14 Jan 2013 18:42:50 +0100
From: =?ISO-8859-2?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>
To: asierra@xes-inc.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] linux-3.7.2 lpc_ich.c: fix gpio base and control offsets
Message-ID: <20130114184250.5182708e@palee-debian>
X-Mailer: Claws Mail 3.9.0cvs55 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ICH5 and before the GPIOBASE and GPIOCTRL are 0x58 and 0x5C. This
patch updates lpc_ich.c that supports ICH5 and before GPIO. This patch
fix the "I/O space for GPIO uninitialized" message.
Reference: 252516-001, 252517-028: 82801EB (ICH5), 82801ER (ICH5R)
documents from developer.intel.com.

Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>

diffstat :=
 lpc_ich.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-------------------------------------------------------------------
diff -upNr a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
--- a/drivers/mfd/lpc_ich.c	2013-01-11 18:19:28.000000000 +0100
+++ b/drivers/mfd/lpc_ich.c	2013-01-14 18:01:38.000000000 +0100
@@ -76,7 +76,9 @@
 #define ACPIBASE_GCS_END	0x3414
 
 #define GPIOBASE		0x48
+#define GPIOBASE_ICH5		0x58
 #define GPIOCTRL		0x4C
+#define GPIOCTRL_ICH5		0x5C
 
 #define RCBABASE		0xf0
 
@@ -659,6 +661,20 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_i
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
 
+static u8 gpio_base_offset;
+static u8 gpio_ctrl_offset;
+
+static void set_gpio_offsets(const struct pci_device_id *id)
+{
+	gpio_base_offset = GPIOBASE;
+	gpio_ctrl_offset = GPIOCTRL;
+		
+	if(id->driver_data <= LPC_ICH5) {
+		gpio_base_offset = GPIOBASE_ICH5;
+		gpio_ctrl_offset = GPIOCTRL_ICH5;
+	}
+}
+
 static void lpc_ich_restore_config_space(struct pci_dev *dev)
 {
 	if (lpc_ich_acpi_save >= 0) {
@@ -667,7 +683,7 @@ static void lpc_ich_restore_config_space
 	}
 
 	if (lpc_ich_gpio_save >= 0) {
-		pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
+		pci_write_config_byte(dev, gpio_ctrl_offset, lpc_ich_gpio_save);
 		lpc_ich_gpio_save = -1;
 	}
 }
@@ -685,8 +701,8 @@ static void __devinit lpc_ich_enable_gpi
 {
 	u8 reg_save;
 
-	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
-	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
+	pci_read_config_byte(dev, gpio_ctrl_offset, &reg_save);
+	pci_write_config_byte(dev, gpio_ctrl_offset, reg_save | 0x10);
 	lpc_ich_gpio_save = reg_save;
 }
 
@@ -757,7 +773,7 @@ static int __devinit lpc_ich_init_gpio(s
 
 gpe0_done:
 	/* Setup GPIO base register */
-	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	pci_read_config_dword(dev, gpio_base_offset, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
 	if (!base_addr) {
 		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
@@ -857,7 +873,8 @@ static int __devinit lpc_ich_probe(struc
 {
 	int ret;
 	bool cell_added = false;
-
+	set_gpio_offsets(id);
+	
 	ret = lpc_ich_init_wdt(dev, id);
 	if (!ret)
 		cell_added = true;
