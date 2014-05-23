Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaEWE1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaEWE0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:24 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: clean up use of dev_err
Date: Thu, 22 May 2014 21:25:47 -0700
Message-Id: <1400819147-14236-8-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, don't print pci device information or driver prefixes, this
is already printed by dev_err. Next, don't report error messages
via dev_err when the failing function already reports all errors
via dev_err.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 0165899..1278de8 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -395,7 +395,7 @@ static int slic_card_download_gbrcv(struct adapter *adapter)
 	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
 	if (ret) {
 		dev_err(&adapter->pcidev->dev,
-			"SLICOSS: Failed to load firmware %s\n", file);
+			"Failed to load firmware %s\n", file);
 		return ret;
 	}
 
@@ -473,7 +473,7 @@ static int slic_card_download(struct adapter *adapter)
 	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
 	if (ret) {
 		dev_err(&adapter->pcidev->dev,
-			"SLICOSS: Failed to load firmware %s\n", file);
+			"Failed to load firmware %s\n", file);
 		return ret;
 	}
 	numsects = *(u32 *)(fw->data + index);
@@ -2783,13 +2783,8 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 
 	/* Download the microcode */
 	status = slic_card_download(adapter);
-
-	if (status != 0) {
-		dev_err(&adapter->pcidev->dev,
-			"download failed bus %d slot %d\n",
-			adapter->busnumber, adapter->slotnumber);
+	if (status)
 		return status;
-	}
 
 	if (!card->config_set) {
 		peeprom = pci_alloc_consistent(adapter->pcidev,
@@ -2801,8 +2796,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 
 		if (!peeprom) {
 			dev_err(&adapter->pcidev->dev,
-				"eeprom read failed to get memory bus %d slot %d\n", adapter->busnumber,
-				adapter->slotnumber);
+				"Failed to allocate DMA memory for EEPROM.\n");
 			return -ENOMEM;
 		} else {
 			memset(peeprom, 0, sizeof(struct slic_eeprom));
@@ -2846,8 +2840,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 				i++;
 				if (i > 5000) {
 					dev_err(&adapter->pcidev->dev,
-						"%d config data fetch timed out!\n",
-						adapter->port);
+						"Fetch of config data timed out.\n");
 					slic_reg64_write(adapter,
 						&slic_regs->slic_isp, 0,
 						&slic_regs->slic_addr_upper,
@@ -2931,19 +2924,16 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 			slic_reg64_write(adapter, &slic_regs->slic_isp, 0,
 					 &slic_regs->slic_addr_upper,
 					 0, FLUSH);
-			dev_err(&adapter->pcidev->dev,
-				"unsupported CONFIGURATION EEPROM invalid\n");
+			dev_err(&adapter->pcidev->dev, "EEPROM invalid.\n");
 			return -EINVAL;
 		}
 
 		card->config_set = 1;
 	}
 
-	if (slic_card_download_gbrcv(adapter)) {
-		dev_err(&adapter->pcidev->dev,
-			"unable to download GB receive microcode\n");
-		return -EINVAL;
-	}
+	status = slic_card_download_gbrcv(adapter);
+	if (status)
+		return status;
 
 	if (slic_global.dynamic_intagg)
 		slic_intagg_set(adapter, 0);
-- 
1.9.2

