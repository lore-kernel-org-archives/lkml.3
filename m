Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3EUUUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:20:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37499 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3EUUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:20:29 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: misc: usb3503: Add to select the ports to disable
Date: Wed, 22 May 2013 05:20:08 +0900
Message-Id: <1369167613-27282-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to disable the USB ports unconnected to USB3503. In order to
disable the port, 'port_off_mask' must be set.

* Disable PORT1 only
	.port_off_mask = USB3503_OFF_PORT1;

* Disable PORT1 and PORT3 only
	.port_off_mask = USB3503_OFF_PORT1 | USB3503_OFF_PORT3;

* Enables all ports
	.port_off_mask = 0;

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/usb/misc/usb3503.c            |   19 ++++++++++---------
 include/linux/platform_data/usb3503.h |    5 +++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index d3a1cce..ab24bb3 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -42,9 +42,6 @@
 #define USB3503_NRD		0x09
 
 #define USB3503_PDS		0x0a
-#define USB3503_PORT1		(1 << 1)
-#define USB3503_PORT2		(1 << 2)
-#define USB3503_PORT3		(1 << 3)
 
 #define USB3503_SP_ILOCK	0xe7
 #define USB3503_SPILOCK_CONNECT	(1 << 1)
@@ -56,6 +53,7 @@
 struct usb3503 {
 	enum usb3503_mode	mode;
 	struct i2c_client	*client;
+	u8	port_off_mask;
 	int	gpio_intn;
 	int	gpio_reset;
 	int	gpio_connect;
@@ -134,12 +132,14 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
 			goto err_hubmode;
 		}
 
-		/* PDS : Port2,3 Disable For Self Powered Operation */
-		err = usb3503_set_bits(i2c, USB3503_PDS,
-				(USB3503_PORT2 | USB3503_PORT3));
-		if (err < 0) {
-			dev_err(&i2c->dev, "PDS failed (%d)\n", err);
-			goto err_hubmode;
+		/* PDS : Disable For Self Powered Operation */
+		if (hub->port_off_mask) {
+			err = usb3503_set_bits(i2c, USB3503_PDS,
+					hub->port_off_mask);
+			if (err < 0) {
+				dev_err(&i2c->dev, "PDS failed (%d)\n", err);
+				goto err_hubmode;
+			}
 		}
 
 		/* CFG1 : SELF_BUS_PWR -> Self-Powerd operation */
@@ -197,6 +197,7 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	hub->client = i2c;
 
 	if (pdata) {
+		hub->port_off_mask	= pdata->port_off_mask;
 		hub->gpio_intn		= pdata->gpio_intn;
 		hub->gpio_connect	= pdata->gpio_connect;
 		hub->gpio_reset		= pdata->gpio_reset;
diff --git a/include/linux/platform_data/usb3503.h b/include/linux/platform_data/usb3503.h
index 85dcc70..1d1b6ef 100644
--- a/include/linux/platform_data/usb3503.h
+++ b/include/linux/platform_data/usb3503.h
@@ -3,6 +3,10 @@
 
 #define USB3503_I2C_NAME	"usb3503"
 
+#define USB3503_OFF_PORT1	(1 << 1)
+#define USB3503_OFF_PORT2	(1 << 2)
+#define USB3503_OFF_PORT3	(1 << 3)
+
 enum usb3503_mode {
 	USB3503_MODE_UNKNOWN,
 	USB3503_MODE_HUB,
@@ -11,6 +15,7 @@ enum usb3503_mode {
 
 struct usb3503_platform_data {
 	enum usb3503_mode	initial_mode;
+	u8	port_off_mask;
 	int	gpio_intn;
 	int	gpio_connect;
 	int	gpio_reset;
-- 
1.7.9.5

