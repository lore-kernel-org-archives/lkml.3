Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3IWSQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59862 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab3IWSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:08 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 06/13] tpm: Remove redundant dev_set_drvdata
Date: Mon, 23 Sep 2013 12:14:36 -0600
Message-Id: <1379960083-8942-7-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPM drivers should not call dev_set_drvdata (or aliases), only the core
code is allowed to call dev_set_drvdata, and it does it during
tpm_register_hardware.

These extra sets are harmless, but are an anti-pattern that many drivers
have copied.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 2 --
 drivers/char/tpm/tpm_i2c_stm_st33.c | 2 --
 drivers/char/tpm/tpm_spi_stm_st33.c | 1 -
 drivers/char/tpm/xen-tpmfront.c     | 2 --
 4 files changed, 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index b8735de..e33d8e5 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -685,7 +685,6 @@ out_vendor:
 	chip->dev->release = NULL;
 	chip->release = NULL;
 	tpm_dev.client = NULL;
-	dev_set_drvdata(chip->dev, chip);
 out_err:
 	return rc;
 }
@@ -766,7 +765,6 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
 	chip->dev->release = NULL;
 	chip->release = NULL;
 	tpm_dev.client = NULL;
-	dev_set_drvdata(chip->dev, chip);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 5bb8e2d..1c68d93 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -746,8 +746,6 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	tpm_get_timeouts(chip);
 
-	i2c_set_clientdata(client, chip);
-
 	dev_info(chip->dev, "TPM I2C Initialized\n");
 	return 0;
 _irq_set:
diff --git a/drivers/char/tpm/tpm_spi_stm_st33.c b/drivers/char/tpm/tpm_spi_stm_st33.c
index 8d3e8e2..f5e3cd6 100644
--- a/drivers/char/tpm/tpm_spi_stm_st33.c
+++ b/drivers/char/tpm/tpm_spi_stm_st33.c
@@ -779,7 +779,6 @@ tpm_st33_spi_probe(struct spi_device *dev)
 	tpm_get_timeouts(chip);
 
 	/* attach chip datas to client */
-	spi_set_drvdata(dev, chip);
 	platform_data->bchipf = false;
 
 	pr_info("TPM SPI Initialized\n");
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 6f2fe2b..7711928 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -379,8 +379,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
 
 	tpm_get_timeouts(priv->chip);
 
-	dev_set_drvdata(&dev->dev, priv->chip);
-
 	return rv;
 }
 
-- 
1.8.1.2

