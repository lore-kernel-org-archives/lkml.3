Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3ERDHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:07:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab3ERDA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:26 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aqyYB4cJgfEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aXVauKmVCREA:10 a=VwQbUJbxAAAA:8 a=gAnH3GRIAAAA:8 a=QyXUC8HyAAAA:8 a=uCZktWHDQ6yKDXGXcpUA:9 a=8NEP1B8RWw4A:10 a=rPGc2HzQRbAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.266080689@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 084/136 ] mfd: adp5520: Restore mode bits on resume
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0084-mfd-adp5520-Restore-mode-bits-on-resume.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit c6cc25fda58da8685ecef3f179adc7b99c8253b2 ]

The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
cleared. So we need to make sure to restore it during resume if it was set
before suspend.

Cc: stable@vger.kernel.org
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mfd/adp5520.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index ea8b947..7e41d54 100644
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
1.7.10.4


