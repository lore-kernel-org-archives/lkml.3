Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbaD3JhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:37:06 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:45551
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758692AbaD3JhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:37:00 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <mark.rutland@arm.com>, <broonie@kernel.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <richardcochran@gmail.com>
CC: <gregkh@linuxfoundation.org>, <mpa@pengutronix.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 resend 2/2] regmap: add DT endianness binding support.
Date: Wed, 30 Apr 2014 16:52:01 +0800
Message-ID: <1398847921-9322-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398847921-9322-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398847921-9322-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(189002)(199002)(80976001)(19580405001)(50986999)(77096999)(2201001)(92726001)(62966002)(74502001)(4396001)(6806004)(80022001)(87936001)(50466002)(88136002)(19580395003)(92566001)(87286001)(83322001)(101416001)(76176999)(44976005)(93916002)(99396002)(89996001)(81542001)(81342001)(50226001)(47776003)(48376002)(83072002)(77156001)(77982001)(79102001)(46102001)(74662001)(31966008)(86362001)(76482001)(20776003)(85852003)(36756003)(2101003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB504;H:tx30smr01.am.freescale.net;FPR:C223D4DD.1414D610.BBD36A73.84D7D032.203F1;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many drivers which will support rich endianness of CPU<-->Dev
need define DT properties by itself without the binding support.

The endianness using regmap:
Index    CPU       Device     Endianess flag for DT bool property
------------------------------------------------------------
1        LE        LE         -
2        LE        BE         'big-endian-{val,reg}'
3        BE        BE         -
4        BE        LE         'little-endian-{val,reg}'

Please see the following documetation for detail:
    Documentation/devicetree/bindings/endianness/endianness.txt

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-i2c.c |   2 +
 drivers/base/regmap/regmap-spi.c |   2 +
 drivers/base/regmap/regmap.c     | 147 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 140 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index fa6bf52..1f603a6 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -96,6 +96,8 @@ static struct regmap_bus regmap_i2c = {
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 };
 
 /**
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 37f12ae..377fa29 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -110,6 +110,8 @@ static struct regmap_bus regmap_spi = {
 	.async_alloc = regmap_spi_async_alloc,
 	.read = regmap_spi_read,
 	.read_flag_mask = 0x80,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 };
 
 /**
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8e8cea1..91faf7d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 
@@ -422,6 +423,132 @@ static void regmap_range_exit(struct regmap *map)
 	kfree(map->selector_work_buf);
 }
 
+enum regmap_endian_type {
+	REGMAP_ENDIAN_REG,
+	REGMAP_ENDIAN_VAL,
+};
+
+/**
+ * of_regmap_endian_by_type() - Parse and lookup the endian referenced
+ * by a device node
+ * @np: pointer to clock consumer node
+ * @type: type of endian for values or registers
+ *
+ * This function parses the device endian property, and uses them to
+ * determine the endian of the registers and values.
+ */
+static int of_regmap_endian_by_type(struct device_node *np,
+					enum regmap_endian_type type,
+					enum regmap_endian *endian)
+{
+	if (!endian)
+		return -EINVAL;
+
+	switch (type) {
+	case REGMAP_ENDIAN_REG:
+		if (of_property_read_bool(np, "big-endian-reg"))
+			*endian = REGMAP_ENDIAN_BIG;
+		else if (of_property_read_bool(np, "little-endian-reg"))
+			*endian = REGMAP_ENDIAN_LITTLE;
+		else
+			*endian = REGMAP_ENDIAN_NATIVE;
+		break;
+	case REGMAP_ENDIAN_VAL:
+		if (of_property_read_bool(np, "big-endian-val"))
+			*endian = REGMAP_ENDIAN_BIG;
+		else if (of_property_read_bool(np, "little-endian-val"))
+			*endian = REGMAP_ENDIAN_LITTLE;
+		else
+			*endian = REGMAP_ENDIAN_NATIVE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int of_regmap_get_endian(struct device *dev,
+				const struct regmap_bus *bus,
+				const struct regmap_config *config,
+				enum regmap_endian_type type,
+				enum regmap_endian *endian)
+{
+	int ret;
+
+	if (!endian || !config)
+		return -EINVAL;
+
+	/*
+	 * Firstly, try to parse the endian from driver's config,
+	 * this is to be compatible with the none DT or the old drivers.
+	 * From the driver's config the endian value maybe:
+	 *   REGMAP_ENDIAN_BIG,
+	 *   REGMAP_ENDIAN_LITTLE,
+	 *   REGMAP_ENDIAN_NATIVE,
+	 *   REGMAP_ENDIAN_DEFAULT.
+	 */
+	switch (type) {
+	case REGMAP_ENDIAN_REG:
+		*endian = config->reg_format_endian;
+		break;
+	case REGMAP_ENDIAN_VAL:
+		*endian = config->val_format_endian;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * If the endian parsing from driver's config is REGMAP_ENDIAN_DEFAULT,
+	 * that means maybe we are using the DT node to specify the endianness.
+	 */
+	if (*endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/*
+	 * Secondly, try to parse the endian from DT node if the
+	 * driver config does not specify it.
+	 * From the DT node the endian value maybe:
+	 *   REGMAP_ENDIAN_BIG,
+	 *   REGMAP_ENDIAN_LITTLE,
+	 *   REGMAP_ENDIAN_NATIVE,
+	 */
+	if (dev) {
+		ret = of_regmap_endian_by_type(dev->of_node, type, endian);
+		if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * If the endian parsing from DT node is REGMAP_ENDIAN_NATIVE, that
+	 * maybe means the DT does not care the endianness or it should use
+	 * the regmap bus's default endianness, then we should try to check
+	 * whether the regmap bus has specified the default endianess.
+	 */
+	if (*endian != REGMAP_ENDIAN_NATIVE)
+		return 0;
+
+	/*
+	 * Finally, try to parse the endian from regmap bus config
+	 * if in device's DT node the endian property is absent.
+	 */
+	switch (type) {
+	case REGMAP_ENDIAN_REG:
+		if (bus && bus->reg_format_endian_default)
+			*endian = bus->reg_format_endian_default;
+		break;
+	case REGMAP_ENDIAN_VAL:
+		if (bus && bus->val_format_endian_default)
+			*endian = bus->val_format_endian_default;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -518,17 +645,15 @@ struct regmap *regmap_init(struct device *dev,
 		map->reg_read  = _regmap_bus_read;
 	}
 
-	reg_endian = config->reg_format_endian;
-	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
-		reg_endian = bus->reg_format_endian_default;
-	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
-		reg_endian = REGMAP_ENDIAN_BIG;
-
-	val_endian = config->val_format_endian;
-	if (val_endian == REGMAP_ENDIAN_DEFAULT)
-		val_endian = bus->val_format_endian_default;
-	if (val_endian == REGMAP_ENDIAN_DEFAULT)
-		val_endian = REGMAP_ENDIAN_BIG;
+	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
+				   &reg_endian);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
+				   &val_endian);
+	if (ret)
+		return ERR_PTR(ret);
 
 	switch (config->reg_bits + map->reg_shift) {
 	case 2:
-- 
1.8.4

