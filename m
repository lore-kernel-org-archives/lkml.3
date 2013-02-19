Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3BSKuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:50:19 -0500
Received: from smtp-out-114.synserver.de ([212.40.185.114]:1033 "EHLO
	smtp-out-114.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3BSKuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:50:17 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16998
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] mfd:adp5520: Restore mode bits on resume
Date: Tue, 19 Feb 2013 11:51:22 +0100
Message-Id: <1361271082-29905-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
cleared. So we need to make sure to restore it during resume if it was set
before suspend.

Cc: stable@vger.kernel.org
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/adp5520.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 210dd03..6b40e0c 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -36,6 +36,7 @@ struct adp5520_chip {
 	struct blocking_notifier_head notifier_list;
 	int irq;
 	unsigned long id;
+	uint8_t mode;
 };
 
 static int __adp5520_read(struct i2c_client *client,
@@ -326,7 +327,10 @@ static int adp5520_suspend(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_read(chip->dev, ADP5520_MODE_STATUS, &chip->mode);
+	/* All other bits are W1C */
+	chip->mode &= ADP5520_BL_EN | ADP5520_DIM_EN | ADP5520_nSTNBY;
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
 	return 0;
 }
 
@@ -335,7 +339,7 @@ static int adp5520_resume(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, chip->mode);
 	return 0;
 }
 #endif
-- 
1.8.0

