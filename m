Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaHBWKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:10:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57261 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbaHBWKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:10:25 -0400
Date: Sun, 3 Aug 2014 03:40:22 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] net: phy: spi_ks8995: Introduce the use of devm_kzalloc
Message-ID: <20140802221021.GA18205@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc and does away with the
kfrees in the probe and remove functions. Also, a label is removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/phy/spi_ks8995.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index 22b047f..eab57fc 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -277,7 +277,7 @@ static int ks8995_probe(struct spi_device *spi)
 	/* Chip description */
 	pdata = spi->dev.platform_data;
 
-	ks = kzalloc(sizeof(*ks), GFP_KERNEL);
+	ks = devm_kzalloc(&spi->dev, sizeof(*ks), GFP_KERNEL);
 	if (!ks)
 		return -ENOMEM;
 
@@ -291,14 +291,14 @@ static int ks8995_probe(struct spi_device *spi)
 	err = spi_setup(spi);
 	if (err) {
 		dev_err(&spi->dev, "spi_setup failed, err=%d\n", err);
-		goto err_drvdata;
+		return err;
 	}
 
 	err = ks8995_read(ks, ids, KS8995_REG_ID0, sizeof(ids));
 	if (err < 0) {
 		dev_err(&spi->dev, "unable to read id registers, err=%d\n",
 				err);
-		goto err_drvdata;
+		return err;
 	}
 
 	switch (ids[0]) {
@@ -306,8 +306,7 @@ static int ks8995_probe(struct spi_device *spi)
 		break;
 	default:
 		dev_err(&spi->dev, "unknown family id:%02x\n", ids[0]);
-		err = -ENODEV;
-		goto err_drvdata;
+		return -ENODEV;
 	}
 
 	memcpy(&ks->regs_attr, &ks8995_registers_attr, sizeof(ks->regs_attr));
@@ -320,24 +319,24 @@ static int ks8995_probe(struct spi_device *spi)
 			dev_err(&spi->dev,
 				"unable to read chip id register, err=%d\n",
 				err);
-			goto err_drvdata;
+			return err;
 		}
 		if ((val & 0x80) == 0) {
 			dev_err(&spi->dev, "unknown chip:%02x,0\n", ids[1]);
-			goto err_drvdata;
+			return err;
 		}
 		ks->regs_attr.size = KSZ8864_REGS_SIZE;
 	}
 
 	err = ks8995_reset(ks);
 	if (err)
-		goto err_drvdata;
+		return err;
 
 	err = sysfs_create_bin_file(&spi->dev.kobj, &ks->regs_attr);
 	if (err) {
 		dev_err(&spi->dev, "unable to create sysfs file, err=%d\n",
 				    err);
-		goto err_drvdata;
+		return err;
 	}
 
 	if (get_chip_id(ids[1]) == CHIPID_M) {
@@ -350,21 +349,12 @@ static int ks8995_probe(struct spi_device *spi)
 	}
 
 	return 0;
-
-err_drvdata:
-	kfree(ks);
-	return err;
 }
 
 static int ks8995_remove(struct spi_device *spi)
 {
-	struct ks8995_data      *ks8995;
-
-	ks8995 = spi_get_drvdata(spi);
 	sysfs_remove_bin_file(&spi->dev.kobj, &ks8995_registers_attr);
 
-	kfree(ks8995);
-
 	return 0;
 }
 
-- 
1.9.1

