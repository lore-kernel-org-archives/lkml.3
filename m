Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaEICu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:50:56 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:2959
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756132AbaEICuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:50:39 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <gregkh@linuxfoundation.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCHv4 2/2] regmap: add DT endianness binding support.
Date: Fri, 9 May 2014 10:04:33 +0800
Message-ID: <1399601073-19278-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
References: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(64706001)(77982001)(76176999)(50226001)(47776003)(20776003)(36756003)(50986999)(88136002)(87936001)(81542001)(81342001)(62966002)(80022001)(21056001)(77096999)(87286001)(76482001)(19580395003)(31966008)(2009001)(93916002)(85852003)(575784001)(86362001)(50466002)(74662001)(74502001)(92566001)(83072002)(2201001)(4396001)(92726001)(48376002)(46102001)(19580405001)(44976005)(83322001)(99396002)(6806004)(77156001)(89996001)(68736004)(69596002)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 02065A9E77
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
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
 drivers/base/regmap/regmap.c     | 148 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 141 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index ebd1895..9b0fbf9 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -95,6 +95,8 @@ static struct regmap_bus regmap_i2c = {
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 };
 
 /**
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 0eb3097..53d1148 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -109,6 +109,8 @@ static struct regmap_bus regmap_spi = {
 	.async_alloc = regmap_spi_async_alloc,
 	.read = regmap_spi_read,
 	.read_flag_mask = 0x80,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 };
 
 /**
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 63e30ef..4805246 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 
@@ -402,6 +403,133 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
+enum regmap_endian_type {
+	REGMAP_ENDIAN_REG,
+	REGMAP_ENDIAN_VAL,
+};
+
+/**
+ * of_regmap_endian_by_type() - Parses and lookups the endianness referenced
+ * by a device node
+ * @np: pointer to the consumer device node
+ * @type: endianness type for values or registers
+ *
+ * This function parses the device endianness properties, and uses them to
+ * determine the endianness of the device's registers and values.
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
+	 * Firstly, try to parse the endianness from driver's config,
+	 * this is to be compatible with the none DT or the old drivers.
+	 * From the driver's config the endianness value maybe:
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
+	 * If the endianness parsed from driver config is
+	 * REGMAP_ENDIAN_DEFAULT, that means maybe we are using the DT
+	 * node to specify the endianness information.
+	 */
+	if (*endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/*
+	 * Secondly, try to parse the endianness from DT node if the
+	 * driver config does not specify it.
+	 * From the DT node the endianness value maybe:
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
+	 * If the endianness parsed from DT node is REGMAP_ENDIAN_NATIVE, that
+	 * maybe means the DT does not care the endianness or it should use
+	 * the regmap bus's default endianness, then we should try to check
+	 * whether the regmap bus has specified the default endianness.
+	 */
+	if (*endian != REGMAP_ENDIAN_NATIVE)
+		return 0;
+
+	/*
+	 * Finally, try to parse the endianness from regmap bus config
+	 * if in device's DT node the endianness property is absent.
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
@@ -499,17 +627,15 @@ struct regmap *regmap_init(struct device *dev,
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

