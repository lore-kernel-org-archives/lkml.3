Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794Ab3JPOIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:08:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934296Ab3JPOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:08:36 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] bq2415x_charger: fix max battery regulation voltage
Date: Wed, 16 Oct 2013 16:08:31 +0200
Message-Id: <1381932511-31719-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the datasheets, maximum battery regulation voltage is 4440mV.

The formula is (voltage - offset) / step, so the maximum value is:
(4440 - 3500) / 20 = 47

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/power/bq2415x_charger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..df893dd 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -605,9 +605,13 @@ static int bq2415x_set_battery_regulation_voltage(struct bq2415x_device *bq,
 {
 	int val = (mV/10 - 350) / 2;
 
+	/*
+	 * According to datasheet, maximum battery regulation voltage is
+	 * 4440mV which is b101111 = 47.
+	 */
 	if (val < 0)
 		val = 0;
-	else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max value ? */
+	else if (val > 47)
 		return -EINVAL;
 
 	return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,
-- 
1.8.1.2

