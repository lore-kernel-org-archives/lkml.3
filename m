Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161670AbaDPOon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:44:43 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62946 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161145AbaDPOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:39 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/6] mfd: stmpe: add optional regulators
Date: Wed, 16 Apr 2014 16:44:11 +0200
Message-Id: <1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STMPE has VCC and VIO supply lines, and sometimes (as on
Ux500) this comes from a software-controlled regulator. Make
it possible to supply the STMPE with power from these
regulators.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c       | 18 ++++++++++++++++++
 include/linux/mfd/stmpe.h |  5 +++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 6155230ae29c..692452442ead 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
 #include <linux/delay.h>
+#include <linux/regulator/consumer.h>
 #include "stmpe.h"
 
 static int __stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
@@ -1172,6 +1173,18 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	stmpe->variant = stmpe_variant_info[partnum];
 	stmpe->regs = stmpe->variant->regs;
 	stmpe->num_gpios = stmpe->variant->num_gpios;
+	stmpe->vcc = devm_regulator_get_optional(ci->dev, "vcc");
+	if (!IS_ERR(stmpe->vcc)) {
+		ret = regulator_enable(stmpe->vcc);
+		if (ret)
+			dev_warn(ci->dev, "failed to enable VCC supply\n");
+	}
+	stmpe->vio = devm_regulator_get_optional(ci->dev, "vio");
+	if (!IS_ERR(stmpe->vio)) {
+		ret = regulator_enable(stmpe->vio);
+		if (ret)
+			dev_warn(ci->dev, "failed to enable VIO supply\n");
+	}
 	dev_set_drvdata(stmpe->dev, stmpe);
 
 	if (ci->init)
@@ -1238,6 +1251,11 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 
 int stmpe_remove(struct stmpe *stmpe)
 {
+	if (!IS_ERR(stmpe->vio))
+		regulator_disable(stmpe->vio);
+	if (!IS_ERR(stmpe->vcc))
+		regulator_disable(stmpe->vcc);
+
 	mfd_remove_devices(stmpe->dev);
 
 	return 0;
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 3f8798e4a87d..575a86c7fcbd 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -11,6 +11,7 @@
 #include <linux/mutex.h>
 
 struct device;
+struct regulator;
 
 enum stmpe_block {
 	STMPE_BLOCK_GPIO	= 1 << 0,
@@ -62,6 +63,8 @@ struct stmpe_client_info;
 
 /**
  * struct stmpe - STMPE MFD structure
+ * @vcc: optional VCC regulator
+ * @vio: optional VIO regulator
  * @lock: lock protecting I/O operations
  * @irq_lock: IRQ bus lock
  * @dev: device, mostly for dev_dbg()
@@ -79,6 +82,8 @@ struct stmpe_client_info;
  * @pdata: platform data
  */
 struct stmpe {
+	struct regulator *vcc;
+	struct regulator *vio;
 	struct mutex lock;
 	struct mutex irq_lock;
 	struct device *dev;
-- 
1.9.0

