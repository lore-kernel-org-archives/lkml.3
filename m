Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBSKft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:35:49 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44153 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBSKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:35:46 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v2 1/1] ACPI, PCI, ISA: Call ISA-specific code only for architectures which support ISA.
Date: Wed, 19 Feb 2014 11:35:22 +0100
Message-Id: <1392806122-23318-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit moves ISA-specific code to separate function and makes that
function depend on CONFIG_{E}ISA so that we do not have to maintain
acpi_isa_irq_to_gsi() function for architectures which do not support ISA.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/pci_irq.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 361b40c..0a553a0 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -370,6 +370,30 @@ static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_ISA) || IS_ENABLED(CONFIG_EISA)
+static int acpi_isa_register_gsi(struct pci_dev *dev)
+{
+	u32 dev_gsi;
+
+	/* Interrupt Line values above 0xF are forbidden */
+	if (dev->irq > 0 && (dev->irq <= 0xF) &&
+	    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
+		dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
+			 pin_name(dev->pin), dev->irq);
+		acpi_register_gsi(&dev->dev, dev_gsi,
+				  ACPI_LEVEL_SENSITIVE,
+				  ACPI_ACTIVE_LOW);
+		return 0;
+	}
+	return -EINVAL;
+}
+#else
+static inline int acpi_isa_register_gsi(struct pci_dev *dev)
+{
+	return -ENODEV;
+}
+#endif
+
 int acpi_pci_irq_enable(struct pci_dev *dev)
 {
 	struct acpi_prt_entry *entry;
@@ -416,16 +440,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	 * driver reported one, then use it. Exit in any case.
 	 */
 	if (gsi < 0) {
-		u32 dev_gsi;
-		/* Interrupt Line values above 0xF are forbidden */
-		if (dev->irq > 0 && (dev->irq <= 0xF) &&
-		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
-			dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
-				 pin_name(pin), dev->irq);
-			acpi_register_gsi(&dev->dev, dev_gsi,
-					  ACPI_LEVEL_SENSITIVE,
-					  ACPI_ACTIVE_LOW);
-		} else {
+		if (acpi_isa_register_gsi(dev)) {
 			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
 				 pin_name(pin));
 		}
-- 
1.7.9.5

