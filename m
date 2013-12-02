Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3LBUfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:35:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3LBTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3.10 151/173] media: tuners: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:14 -0800
Message-Id: <20131202191200.691635122@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit f1baab870f6e93b668af7b34d6f6ba49f1b0e982 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/tuners/e4000.c:50:1: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/e4000.c:83:1: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/fc2580.c:66:1: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/fc2580.c:98:1: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18212.c:57:1: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18212.c:90:1: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18218.c:60:1: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18218.c:92:1: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 64 bytes for	the control URBs.
So, it seem safe to use 64 bytes as the hard limit for all those devices.
 On most cases, the limit is a way lower than that, but	this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/e4000.c    |   25 +++++++++++++++++++++----
 drivers/media/tuners/fc2580.c   |   25 +++++++++++++++++++++----
 drivers/media/tuners/tda18212.c |   25 +++++++++++++++++++++----
 drivers/media/tuners/tda18218.c |   23 ++++++++++++++++++++---
 4 files changed, 83 insertions(+), 15 deletions(-)

--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -20,20 +20,30 @@
 
 #include "e4000_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple registers */
 static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = 1 + len,
 			.buf = buf,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -52,7 +62,7 @@ static int e4000_wr_regs(struct e4000_pr
 static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -62,11 +72,18 @@ static int e4000_rd_regs(struct e4000_pr
 		}, {
 			.addr = priv->cfg->i2c_addr,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -20,6 +20,9 @@
 
 #include "fc2580_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /*
  * TODO:
  * I2C write and read works only for one single register. Multiple registers
@@ -41,16 +44,23 @@
 static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = 1 + len,
 			.buf = buf,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -69,7 +79,7 @@ static int fc2580_wr_regs(struct fc2580_
 static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -79,11 +89,18 @@ static int fc2580_rd_regs(struct fc2580_
 		}, {
 			.addr = priv->cfg->i2c_addr,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -20,6 +20,9 @@
 
 #include "tda18212.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct tda18212_priv {
 	struct tda18212_config *cfg;
 	struct i2c_adapter *i2c;
@@ -32,16 +35,23 @@ static int tda18212_wr_regs(struct tda18
 	int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = 1 + len,
 			.buf = buf,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -61,7 +71,7 @@ static int tda18212_rd_regs(struct tda18
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -71,11 +81,18 @@ static int tda18212_rd_regs(struct tda18
 		}, {
 			.addr = priv->cfg->i2c_address,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -20,11 +20,14 @@
 
 #include "tda18218_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple registers */
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret = 0, len2, remaining;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -33,6 +36,13 @@ static int tda18218_wr_regs(struct tda18
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	for (remaining = len; remaining > 0;
 			remaining -= (priv->cfg->i2c_wr_max - 1)) {
 		len2 = remaining;
@@ -63,7 +73,7 @@ static int tda18218_wr_regs(struct tda18
 static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret;
-	u8 buf[reg+len]; /* we must start read always from reg 0x00 */
+	u8 buf[MAX_XFER_SIZE]; /* we must start read always from reg 0x00 */
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -73,11 +83,18 @@ static int tda18218_rd_regs(struct tda18
 		}, {
 			.addr = priv->cfg->i2c_address,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = reg + len,
 			.buf = buf,
 		}
 	};
 
+	if (reg + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, &buf[reg], len);


