Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaEKKHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:07:47 -0400
Received: from ns.horizon.com ([71.41.210.147]:33188 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757719AbaEKKHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:07:45 -0400
Date: 11 May 2014 06:07:43 -0400
Message-ID: <20140511100743.1712.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, pavel@ucw.cz
Subject: [PATCH 3/3] drivers/net/wireless/ti/wl*/spi.c: Simplify CRC computation
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
In-Reply-To: <20140511100211.1334.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These devices require commands stored in buffers in an odd order,
different from that in which the CRC is computed.

Rather than make two copies of the commands in two different orders,
form the commands in logical (CRC) order, append the CRC, then byte-swap
in place to the desired order.

The old code worked fine, I'm just scratching an "ugh, that's ugly"
itch.

Signed-off-by: George Spelvin <linux@horizon.com>
---
I spotted this while making the previous crc7 change.

This looks straightforward, but I don't actually have either of these devices to test.
At least one other careful desk-check is solicited.

 drivers/net/wireless/ti/wl1251/spi.c | 43 +++++++++++++++++-----------------
 drivers/net/wireless/ti/wlcore/spi.c | 45 ++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index e94b57cd5a..a0aa8fa723 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/swab.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
@@ -83,46 +84,44 @@ static void wl1251_spi_reset(struct wl1251 *wl)
 
 static void wl1251_spi_wake(struct wl1251 *wl)
 {
-	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
 	struct spi_message m;
+	u8 *cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 
-	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
 		wl1251_error("could not allocate cmd for spi init");
 		return;
 	}
 
-	memset(crc, 0, sizeof(crc));
 	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 
 	/* Set WSPI_INIT_COMMAND
 	 * the data is being send from the MSB to LSB
 	 */
-	cmd[2] = 0xff;
-	cmd[3] = 0xff;
-	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
-	cmd[0] = 0;
-	cmd[7] = 0;
-	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
-	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+	cmd[0] = 0xff;
+	cmd[1] = 0xff;
+	cmd[2] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
+	cmd[3] = 0;
+	cmd[4] = 0;
+	cmd[5] = HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
+	cmd[5] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+
+	cmd[6] = WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
 
 	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
-		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+		cmd[6] |= WSPI_INIT_CMD_DIS_FIXEDBUSY;
 	else
-		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
-
-	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
-		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
-
-	crc[0] = cmd[1];
-	crc[1] = cmd[0];
-	crc[2] = cmd[7];
-	crc[3] = cmd[6];
-	crc[4] = cmd[5];
+		cmd[6] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
 
-	cmd[4] = crc7_be(0, crc, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
+	cmd[7] = crc7_be(0, cmd+2, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
+	/*
+	 * The above is the logical order; it must actually be stored
+	 * in the buffer byte-swapped.
+	 */
+	__swab32s((u32 *)cmd);
+	__swab32s((u32 *)cmd+1);
 
 	t.tx_buf = cmd;
 	t.len = WSPI_INIT_CMD_LEN;
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 0497353c4a..955861af35 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -24,11 +24,12 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/swab.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_device.h>
-#include <linux/slab.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -110,18 +111,16 @@ static void wl12xx_spi_reset(struct device *child)
 static void wl12xx_spi_init(struct device *child)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
-	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
 	struct spi_message m;
+	u8 *cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 
-	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
 		dev_err(child->parent,
 			"could not allocate cmd for spi init\n");
 		return;
 	}
 
-	memset(crc, 0, sizeof(crc));
 	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 
@@ -129,29 +128,29 @@ static void wl12xx_spi_init(struct device *child)
 	 * Set WSPI_INIT_COMMAND
 	 * the data is being send from the MSB to LSB
 	 */
-	cmd[2] = 0xff;
-	cmd[3] = 0xff;
-	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
-	cmd[0] = 0;
-	cmd[7] = 0;
-	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
-	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+	cmd[0] = 0xff;
+	cmd[1] = 0xff;
+	cmd[2] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
+	cmd[3] = 0;
+	cmd[4] = 0;
+	cmd[5] = HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
+	cmd[5] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+
+	cmd[6] = WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
 
 	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
-		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+		cmd[6] |= WSPI_INIT_CMD_DIS_FIXEDBUSY;
 	else
-		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
+		cmd[6] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
 
-	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
-		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
-
-	crc[0] = cmd[1];
-	crc[1] = cmd[0];
-	crc[2] = cmd[7];
-	crc[3] = cmd[6];
-	crc[4] = cmd[5];
-
-	cmd[4] = crc7_be(0, crc, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
+	cmd[7] = crc7_be(0, cmd+2, WSPI_INIT_CMD_CRC_LEN) | WSPI_INIT_CMD_END;
+	/*
+	 * The above is the logical order; it must actually be stored
+	 * in the buffer byte-swapped.
+	 */
+	__swab32s((u32 *)cmd);
+	__swab32s((u32 *)cmd+1);
 
 	t.tx_buf = cmd;
 	t.len = WSPI_INIT_CMD_LEN;
-- 
1.9.2

