Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaGUXVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:21:18 -0400
Received: from mout.gmx.net ([212.227.17.22]:60139 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaGUXVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:21:17 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use devm_ioremap_resource to reserve resource
Date: Tue, 22 Jul 2014 01:26:05 +0200
Message-Id: <1405985165-9631-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.5.5
X-Provags-ID: V03:K0:qExm4ptIR7nm5t8lKTTB2EShVg4+H+irCyTNP9dPjfAltbT/l72
 VW6WCBJKy4jrvreVXWbrpX0jhBRBOQoARnku1TVO+wJ73/0lhR1Adx7Bbf+SSXMI5Rr2fsA
 XzgjAMopEOvxX06CPaAGHzSJOpzr2m32aukyWByqfvnQF40GLDixcM8E6azIZrJztkZBTFP
 EpSAMSenaYOWOA4DUEpXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately the tpm_tis driver did never call request_region for its
adress space - now since we've got devm_ioremap_resource we can simply
remove all the stuff and do everything in one call.

Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_tis.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..a79be26 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -534,13 +534,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
+	struct resource res = DEFINE_RES_MEM_NAMED(start, len, "tpm_tis");
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
 
-	chip->vendor.iobase = ioremap(start, len);
-	if (!chip->vendor.iobase) {
-		rc = -EIO;
+	chip->vendor.iobase = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(chip->vendor.iobase)) {
+		rc = PTR_ERR(chip->vendor.iobase);
 		goto out_err;
 	}
 
@@ -727,8 +728,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 
 	return 0;
 out_err:
-	if (chip->vendor.iobase)
-		iounmap(chip->vendor.iobase);
 	tpm_remove_hardware(chip->dev);
 	return rc;
 }
@@ -891,7 +890,6 @@ static void __exit cleanup_tis(void)
 		release_locality(chip, chip->vendor.locality, 1);
 		if (chip->vendor.irq)
 			free_irq(chip->vendor.irq, chip);
-		iounmap(i->iobase);
 		list_del(&i->list);
 	}
 	mutex_unlock(&tis_lock);
-- 
1.8.5.5

