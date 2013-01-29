Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3A2KHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:07:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3A2KHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:07:06 -0500
From: Jan Luebbe <jlu@pengutronix.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] rtc-isl1208: call rtc_update_irq from the alarm irq handler
Date: Tue, 29 Jan 2013 11:07:02 +0100
Message-Id: <1359454022-7339-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the alarm event was not propagated into the RTC subsystem.
By adding a call to rtc_update_irq, this fixes a timeout problem with
the hwclock utility.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/rtc/rtc-isl1208.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index afb7cfa..c016ad8 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -506,6 +506,7 @@ isl1208_rtc_interrupt(int irq, void *data)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct i2c_client *client = data;
+	struct rtc_device *rtc = i2c_get_clientdata(client);
 	int handled = 0, sr, err;
 
 	/*
@@ -528,6 +529,8 @@ isl1208_rtc_interrupt(int irq, void *data)
 	if (sr & ISL1208_REG_SR_ALM) {
 		dev_dbg(&client->dev, "alarm!\n");
 
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
 		/* Clear the alarm */
 		sr &= ~ISL1208_REG_SR_ALM;
 		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
-- 
1.7.10.4

