Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab3BHBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:05:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3BHA6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Luebbe <jlu@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 11/26] drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler
Date: Thu,  7 Feb 2013 16:57:39 -0800
Message-Id: <20130208004629.213635217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-isl1208.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -494,6 +494,7 @@ isl1208_rtc_interrupt(int irq, void *dat
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct i2c_client *client = data;
+	struct rtc_device *rtc = i2c_get_clientdata(client);
 	int handled = 0, sr, err;
 
 	/*
@@ -516,6 +517,8 @@ isl1208_rtc_interrupt(int irq, void *dat
 	if (sr & ISL1208_REG_SR_ALM) {
 		dev_dbg(&client->dev, "alarm!\n");
 
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
 		/* Clear the alarm */
 		sr &= ~ISL1208_REG_SR_ALM;
 		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);


