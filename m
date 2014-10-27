Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJ0OSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:18:11 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36675 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaJ0ORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:21 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 6/6] rtc: pcf8563 Clear expired alarm at boot time
Date: Mon, 27 Oct 2014 15:17:01 +0100
Message-Id: <1414419421-11098-7-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the card is woken up of the rtc alarm, the devm_rtc_device_register
function detects it as a pending alarm about a month in the future. Fix this
by clearing the alarm in module probe.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 1e14f60..96fb32e 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -396,6 +396,7 @@ static int pcf8563_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *tm)
 
 static int pcf8563_irq_enable(struct device *dev, unsigned int enabled)
 {
+	dev_dbg(dev, "%s: en=%d\n", __func__, enabled);
 	return pcf8563_set_alarm_mode(to_i2c_client(dev), !!enabled);
 }
 
@@ -414,6 +415,7 @@ static int pcf8563_probe(struct i2c_client *client,
 	struct pcf8563 *pcf8563;
 	int err;
 	unsigned char buf;
+	unsigned char alm_pending;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -439,6 +441,14 @@ static int pcf8563_probe(struct i2c_client *client,
 		return err;
 	}
 
+	err = pcf8563_get_alarm_mode(client, NULL, &alm_pending);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return err;
+	}
+	if (alm_pending)
+		pcf8563_set_alarm_mode(client, 0);
+
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
-- 
1.8.4.5

