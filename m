Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaJUEYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:24:21 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33636 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaJUENr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:47 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 14/47] mfd: tps80031: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:30 -0700
Message-Id: <1413864783-3271-15-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD7A.00C1,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 84
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with low priority to reflect that the original code
only sets pm_power_off if it was not already set.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/mfd/tps80031.c       | 30 ++++++++++++++++++------------
 include/linux/mfd/tps80031.h |  2 ++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index ed6c5b0..926c62a 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -147,7 +147,6 @@ static const struct tps80031_pupd_data tps80031_pupds[] = {
 	[TPS80031_CTLI2C_SCL]		= PUPD_DATA(4, 0,	BIT(2)),
 	[TPS80031_CTLI2C_SDA]		= PUPD_DATA(4, 0,	BIT(3)),
 };
-static struct tps80031 *tps80031_power_off_dev;
 
 int tps80031_ext_power_req_config(struct device *dev,
 		unsigned long ext_ctrl_flag, int preq_bit,
@@ -209,11 +208,17 @@ int tps80031_ext_power_req_config(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(tps80031_ext_power_req_config);
 
-static void tps80031_power_off(void)
+static int tps80031_power_off(struct notifier_block *this,
+			      unsigned long unused1, void *unused2)
 {
-	dev_info(tps80031_power_off_dev->dev, "switching off PMU\n");
-	tps80031_write(tps80031_power_off_dev->dev, TPS80031_SLAVE_ID1,
-				TPS80031_PHOENIX_DEV_ON, TPS80031_DEVOFF);
+	struct tps80031 *tps80031 = container_of(this, struct tps80031,
+						 poweroff_nb);
+
+	dev_info(tps80031->dev, "switching off PMU\n");
+	tps80031_write(tps80031->dev, TPS80031_SLAVE_ID1,
+		       TPS80031_PHOENIX_DEV_ON, TPS80031_DEVOFF);
+
+	return NOTIFY_DONE;
 }
 
 static void tps80031_pupd_init(struct tps80031 *tps80031,
@@ -501,9 +506,13 @@ static int tps80031_probe(struct i2c_client *client,
 		goto fail_mfd_add;
 	}
 
-	if (pdata->use_power_off && !pm_power_off) {
-		tps80031_power_off_dev = tps80031;
-		pm_power_off = tps80031_power_off;
+	if (pdata->use_power_off) {
+		tps80031->poweroff_nb.notifier_call = tps80031_power_off;
+		tps80031->poweroff_nb.priority = POWEROFF_PRIORITY_LOW;
+		ret = register_power_off_handler(&tps80031->poweroff_nb);
+		if (ret)
+			dev_warn(&client->dev,
+				 "Failed to register poweroff handler\n");
 	}
 	return 0;
 
@@ -523,10 +532,7 @@ static int tps80031_remove(struct i2c_client *client)
 	struct tps80031 *tps80031 = i2c_get_clientdata(client);
 	int i;
 
-	if (tps80031_power_off_dev == tps80031) {
-		tps80031_power_off_dev = NULL;
-		pm_power_off = NULL;
-	}
+	unregister_power_off_handler(&tps80031->poweroff_nb);
 
 	mfd_remove_devices(tps80031->dev);
 
diff --git a/include/linux/mfd/tps80031.h b/include/linux/mfd/tps80031.h
index 2c75c9c..49bc006 100644
--- a/include/linux/mfd/tps80031.h
+++ b/include/linux/mfd/tps80031.h
@@ -24,6 +24,7 @@
 #define __LINUX_MFD_TPS80031_H
 
 #include <linux/device.h>
+#include <linux/notifier.h>
 #include <linux/regmap.h>
 
 /* Pull-ups/Pull-downs */
@@ -513,6 +514,7 @@ struct tps80031 {
 	struct i2c_client	*clients[TPS80031_NUM_SLAVES];
 	struct regmap		*regmap[TPS80031_NUM_SLAVES];
 	struct regmap_irq_chip_data *irq_data;
+	struct notifier_block	poweroff_nb;
 };
 
 struct tps80031_pupd_init_data {
-- 
1.9.1

