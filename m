Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaJ0ORX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:23 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61092 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJ0ORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:20 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/6] rtc: pcf8563 Save battery power
Date: Mon, 27 Oct 2014 15:17:00 +0100
Message-Id: <1414419421-11098-6-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Haoyu hym8563 datasheet this saves som power. Might be importat
to battery life. And maybe it works for the NXP part as well.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index ce6a11b..1e14f60 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -42,6 +42,13 @@
 
 #define PCF8563_REG_CLKO	0x0D /* clock out */
 #define PCF8563_REG_TMRC	0x0E /* timer control */
+#define PCF8563_TMRC_ENABLE	BIT(7)
+#define PCF8563_TMRC_4096	0
+#define PCF8563_TMRC_64		1
+#define PCF8563_TMRC_1		2
+#define PCF8563_TMRC_1_60	3
+#define PCF8563_TMRC_MASK	3
+
 #define PCF8563_REG_TMR		0x0F /* timer */
 
 #define PCF8563_SC_LV		0x80 /* low voltage */
@@ -406,6 +413,7 @@ static int pcf8563_probe(struct i2c_client *client,
 {
 	struct pcf8563 *pcf8563;
 	int err;
+	unsigned char buf;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -423,6 +431,14 @@ static int pcf8563_probe(struct i2c_client *client,
 	pcf8563->client = client;
 	device_set_wakeup_capable(&client->dev, 1);
 
+	/* Set timer to lowest frequency to save power (ref Haoyu datasheet) */
+	buf = PCF8563_TMRC_1_60;
+	err = pcf8563_write_block_data(client, PCF8563_REG_TMRC, 1, &buf);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return err;
+	}
+
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
-- 
1.8.4.5

