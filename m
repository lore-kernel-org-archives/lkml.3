Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3BLAsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:48:18 -0500
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57914 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BLAsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:48:16 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] i2c-core: dt: Pick i2c bus number from i2c alias if present
Date: Mon, 11 Feb 2013 16:48:04 -0800
Message-Id: <1360630085-26874-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360630085-26874-1-git-send-email-dianders@chromium.org>
References: <1360630085-26874-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows you to get the equivalent functionality of
i2c_add_numbered_adapter() with all data in the device tree and no
special case code in your driver.  This is a common device tree
technique.

For quick reference, the FDT syntax for using an alias to provide an
ID looks like:
  aliases {
    i2c0 = &i2c_0;
    i2c1 = &i2c_1;
  };

Signed-off-by: Doug Anderson <dianders@chromium.org>

---
Changes in v3:
- Addressed Wolfram's feedback; rebased atop idr-cleanup series.

Changes in v2: None

 drivers/i2c/i2c-core.c | 54 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 0b599f2..5204818 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -921,13 +921,41 @@ out_list:
 }
 
 /**
+ * __i2c_add_numbered_adapter - i2c_add_numbered_adapter where nr is never -1
+ * @adap: the adapter to register (with adap->nr initialized)
+ * Context: can sleep
+ *
+ * See i2c_add_numbered_adapter() for details.
+ */
+static int __i2c_add_numbered_adapter(struct i2c_adapter *adap)
+{
+	int	id;
+
+	/* Handled by wrappers */
+	if (WARN_ON(adap->nr == -1))
+		return -EINVAL;
+
+	if (adap->nr & ~MAX_IDR_MASK)
+		return -EINVAL;
+
+	mutex_lock(&core_lock);
+	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
+		       GFP_KERNEL);
+	mutex_unlock(&core_lock);
+	if (id < 0)
+		return id == -ENOSPC ? -EBUSY : id;
+	return i2c_register_adapter(adap);
+}
+
+/**
  * i2c_add_adapter - declare i2c adapter, use dynamic bus number
  * @adapter: the adapter to add
  * Context: can sleep
  *
  * This routine is used to declare an I2C adapter when its bus number
- * doesn't matter.  Examples: for I2C adapters dynamically added by
- * USB links or PCI plugin cards.
+ * doesn't matter or when its bus number is specified by an dt alias.
+ * Examples of bases when the bus number doesn't matter: I2C adapters
+ * dynamically added by USB links or PCI plugin cards.
  *
  * When this returns zero, a new bus number was allocated and stored
  * in adap->nr, and the specified adapter became available for clients.
@@ -935,8 +963,17 @@ out_list:
  */
 int i2c_add_adapter(struct i2c_adapter *adapter)
 {
+	struct device *dev = &adapter->dev;
 	int res;
 
+	if (dev->of_node) {
+		res = of_alias_get_id(dev->of_node, "i2c");
+		if (res >= 0) {
+			adapter->nr = res;
+			return __i2c_add_numbered_adapter(adapter);
+		}
+	}
+
 	mutex_lock(&core_lock);
 	res = idr_alloc(&i2c_adapter_idr, adapter,
 			__i2c_first_dynamic_bus_num, 0, GFP_KERNEL);
@@ -974,20 +1011,9 @@ EXPORT_SYMBOL(i2c_add_adapter);
  */
 int i2c_add_numbered_adapter(struct i2c_adapter *adap)
 {
-	int	id;
-
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
-
-	mutex_lock(&core_lock);
-	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
-		       GFP_KERNEL);
-	mutex_unlock(&core_lock);
-	if (id < 0)
-		return id == -ENOSPC ? -EBUSY : id;
-	return i2c_register_adapter(adap);
+	return __i2c_add_numbered_adapter(adap);
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
-- 
1.8.1

