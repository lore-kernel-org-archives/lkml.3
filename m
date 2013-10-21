Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3JUPGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:06:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46810 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3JUPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:06:04 -0400
From: Benson Leung <bleung@chromium.org>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dlaurie@chromium.org, bleung@chromium.org
Subject: [PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
Date: Mon, 21 Oct 2013 08:05:44 -0700
Message-Id: <1382367944-3005-3-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382367944-3005-1-git-send-email-bleung@chromium.org>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382367944-3005-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having the bus names be "i2c-designware-pci--1" because
we have set the .bus_num to -1 to force dynamic allocation, lets have
the busses named "i2c-designware-pci-0" and "i2c-designware-pci-1"
to correspond to the correct names of these busses.

The adapter number will still be dynamically assigned.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
v2: Fixed warning.
v1: Initial
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 816cbd1..0c6771d 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -229,7 +229,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 {
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
-	int r;
+	int r, adapter_num;
 	struct  dw_pci_controller *controller;
 
 	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers)) {
@@ -287,8 +287,18 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	adap->algo = &i2c_dw_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->nr = controller->bus_num;
+
+	switch (id->driver_data) {
+	case haswell_0:
+	case haswell_1:
+		adapter_num = id->driver_data - haswell_0;
+		break;
+	default:
+		adapter_num = adap->nr;
+		break;
+	}
 	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
-		adap->nr);
+		 adapter_num);
 
 	r = devm_request_irq(&pdev->dev, pdev->irq, i2c_dw_isr, IRQF_SHARED,
 			adap->name, dev);
-- 
1.8.3.2

