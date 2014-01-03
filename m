Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaACN2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53432 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaACN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:10 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] MFD: twl-core: API to set the regcache bypass for a given regmap in twl
Date: Fri, 3 Jan 2014 15:27:47 +0200
Message-ID: <1388755676-16036-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regcache is enabled on the regmap module drivers might need to access
to HW register(s) in certain cases in cache bypass mode.
As an example of this is the audio block's ANAMICL register. In normal
operation the content can be cached but during initialization one bit from
the register need to be monitored. With the twl_set_regcache_bypass() the
client driver can switch regcache bypass on and off when it is needed so
we can utilize the regcache for more registers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  | 21 +++++++++++++++++++++
 include/linux/i2c/twl.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index c91cb4367b9b..f0abca79ff34 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -383,6 +383,27 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 }
 EXPORT_SYMBOL(twl_i2c_read);
 
+/**
+ * twl_regcache_bypass - Configure the regcache bypass for the regmap associated
+ *			 with the module
+ * @mod_no: module number
+ * @enable: Regcache bypass state
+ *
+ * Returns 0 else failure.
+ */
+int twl_set_regcache_bypass(u8 mod_no, bool enable)
+{
+	struct regmap *regmap = twl_get_regmap(mod_no);
+
+	if (!regmap)
+		return -EPERM;
+
+	regcache_cache_bypass(regmap, enable);
+
+	return 0;
+}
+EXPORT_SYMBOL(twl_set_regcache_bypass);
+
 /*----------------------------------------------------------------------*/
 
 /**
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 673a3ce67f31..a09da0910339 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -175,6 +175,9 @@ static inline int twl_class_is_ ##class(void)	\
 TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
 
+/* Set the regcache bypass for the regmap associated with the nodule */
+int twl_set_regcache_bypass(u8 mod_no, bool enable);
+
 /*
  * Read and write several 8-bit registers at once.
  */
-- 
1.8.5.2

