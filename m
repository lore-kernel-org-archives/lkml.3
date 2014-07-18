Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbaGRNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:31 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17967 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761530AbaGRNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/170] hwmon: (ina2xx) Cast to s16 on shunt and current regs
Date: Fri, 18 Jul 2014 14:11:40 +0200
Message-Id: <d9f8ab9c7c5e29b630816bd2be3d9c90c98c75ba.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Baltieri <fabio.baltieri@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c0214f98943b1fe43f7be61b7782b0c8f0836f28 upstream.

All devices supported by ina2xx are bidirectional and report the
measured shunt voltage and power values as a signed 16 bit, but the
current driver implementation caches all registers as u16, leading
to an incorrect sign extension when reporting to userspace in
ina2xx_get_value().

This patch fixes the problem by casting the signed registers to s16.
Tested on an INA219.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/ina2xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 70a39a8ac016..554f5c3fe5c4 100644
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
2.0.0

