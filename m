Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162338Ab3LFNcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:32:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161729Ab3LFNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 174/272] [media] tuners: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:43 +0000
Message-Id: <1386334761-25517-175-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/tuners/e4000.c    | 25 +++++++++++++++++++++----
 drivers/media/tuners/fc2580.c   | 25 +++++++++++++++++++++----
 drivers/media/tuners/tda18212.c | 25 +++++++++++++++++++++----
 drivers/media/tuners/tda18218.c | 23 ++++++++++++++++++++---
 4 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 1b33ed3..c4ce450 100644
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
 
@@ -52,7 +62,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -62,11 +72,18 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
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
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 81f38aa..3aecaf4 100644
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
 
@@ -69,7 +79,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -79,11 +89,18 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
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
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index e4a84ee..abe256e 100644
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
@@ -32,16 +35,23 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
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
 
@@ -61,7 +71,7 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -71,11 +81,18 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
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
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 2d31aeb..9300e93 100644
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
@@ -33,6 +36,13 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
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
@@ -63,7 +73,7 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret;
-	u8 buf[reg+len]; /* we must start read always from reg 0x00 */
+	u8 buf[MAX_XFER_SIZE]; /* we must start read always from reg 0x00 */
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -73,11 +83,18 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
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
-- 
1.8.3.2

