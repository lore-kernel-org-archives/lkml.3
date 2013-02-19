Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3BSSw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3BSSwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Luebbe <jlu@pengutronix.de>, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 37/81] drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler
Date: Tue, 19 Feb 2013 15:49:00 -0300
Message-Id: <1361299784-8830-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Luebbe <jlu@pengutronix.de>

commit 72fca4a4b32dc778b5b885c3498700e42b610d49 upstream.

Previously the alarm event was not propagated into the RTC subsystem.
By adding a call to rtc_update_irq, this fixes a timeout problem with
the hwclock utility.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/rtc/rtc-isl1208.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index dd2aeee..8f8c8ae 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -494,6 +494,7 @@ isl1208_rtc_interrupt(int irq, void *data)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct i2c_client *client = data;
+	struct rtc_device *rtc = i2c_get_clientdata(client);
 	int handled = 0, sr, err;
 
 	/*
@@ -516,6 +517,8 @@ isl1208_rtc_interrupt(int irq, void *data)
 	if (sr & ISL1208_REG_SR_ALM) {
 		dev_dbg(&client->dev, "alarm!\n");
 
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
 		/* Clear the alarm */
 		sr &= ~ISL1208_REG_SR_ALM;
 		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
-- 
1.7.9.5

