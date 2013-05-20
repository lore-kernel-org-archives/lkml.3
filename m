Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3ETKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab3ETKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/115] mfd: adp5520: Restore mode bits on resume
Date: Mon, 20 May 2013 11:50:07 +0100
Message-Id: <1369047116-9378-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit c6cc25fda58da8685ecef3f179adc7b99c8253b2 upstream.

The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
cleared. So we need to make sure to restore it during resume if it was set
before suspend.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/adp5520.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 8d816cc..105f820 100644
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
1.8.1.2

