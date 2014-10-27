Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaJ0ORS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:18 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44540 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaJ0ORQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:16 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/6] rtc: pcf8563 Fix write of invalid bits to ST2 reg
Date: Mon, 27 Oct 2014 15:16:57 +0100
Message-Id: <1414419421-11098-3-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the NXP datasheet:
"Bits labeled as N should always be written with logic 0."

At least one of those bits is sometime read as a 1, therfore violating
this rule. To fix this we mask away those bits.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 1a865c9..8c23606 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -28,6 +28,7 @@
 #define PCF8563_REG_ST2		0x01
 #define PCF8563_BIT_AIE		(1 << 1)
 #define PCF8563_BIT_AF		(1 << 3)
+#define PCF8563_BITS_ST2_N	(7 << 5)
 
 #define PCF8563_REG_SC		0x02 /* datetime */
 #define PCF8563_REG_MN		0x03
@@ -130,7 +131,7 @@ static int pcf8563_set_alarm_mode(struct i2c_client *client, bool on)
 	else
 		buf &= ~PCF8563_BIT_AIE;
 
-	buf &= ~PCF8563_BIT_AF;
+	buf &= ~(PCF8563_BIT_AF | PCF8563_BITS_ST2_N);
 
 	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0) {
-- 
1.8.4.5

