Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3E1ESG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:18:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52613 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758921Ab3E1Dy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Michael Hennerich" <michael.hennerich@analog.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.774163749@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/94] mfd: adp5520: Restore mode bits on resume
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit c6cc25fda58da8685ecef3f179adc7b99c8253b2 upstream.

The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
cleared. So we need to make sure to restore it during resume if it was set
before suspend.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/adp5520.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -36,6 +36,7 @@ struct adp5520_chip {
 	struct blocking_notifier_head notifier_list;
 	int irq;
 	unsigned long id;
+	uint8_t mode;
 };
 
 static int __adp5520_read(struct i2c_client *client,
@@ -326,7 +327,10 @@ static int adp5520_suspend(struct device
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_read(chip->dev, ADP5520_MODE_STATUS, &chip->mode);
+	/* All other bits are W1C */
+	chip->mode &= ADP5520_BL_EN | ADP5520_DIM_EN | ADP5520_nSTNBY;
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
 	return 0;
 }
 
@@ -335,7 +339,7 @@ static int adp5520_resume(struct device
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, chip->mode);
 	return 0;
 }
 #endif

