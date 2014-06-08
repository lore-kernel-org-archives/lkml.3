Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbaFHVGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 17:06:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50767 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586AbaFHVGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 17:06:34 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v2] hwmon: (ina2xx) Cast to s16 on shunt and current regs
Date: Sun,  8 Jun 2014 22:06:24 +0100
Message-Id: <1402261584-5301-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All devices supported by ina2xx are bidirectional and reports the
measured shunt voltage and power values as a signed 16 bit, but the
current driver implementation caches all registers as u16, leading to an
incorrect sign extension when reporting to the userspace in
ina2xx_get_value().

This patch fixes the problem by casting the signed registers to s16.
Tested on an INA219.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/hwmon/ina2xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 93d26e8..bfd3f3e 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -148,7 +148,8 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
 
 	switch (reg) {
 	case INA2XX_SHUNT_VOLTAGE:
-		val = DIV_ROUND_CLOSEST(data->regs[reg],
+		/* signed register */
+		val = DIV_ROUND_CLOSEST((s16)data->regs[reg],
 					data->config->shunt_div);
 		break;
 	case INA2XX_BUS_VOLTAGE:
@@ -160,8 +161,8 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
 		val = data->regs[reg] * data->config->power_lsb;
 		break;
 	case INA2XX_CURRENT:
-		/* LSB=1mA (selected). Is in mA */
-		val = data->regs[reg];
+		/* signed register, LSB=1mA (selected), in mA */
+		val = (s16)data->regs[reg];
 		break;
 	default:
 		/* programmer goofed */
-- 
1.8.4

