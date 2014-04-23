Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaDWHaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:30:55 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:47940
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755821AbaDWHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:30:52 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <rob@landley.net>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 3/3] regmap: add DT endianness binding support.
Date: Wed, 23 Apr 2014 14:46:35 +0800
Message-ID: <1398235595-13370-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(50226001)(77982001)(74502001)(79102001)(44976005)(85852003)(4396001)(6806004)(74662001)(31966008)(80022001)(47776003)(20776003)(76482001)(92566001)(87936001)(88136002)(83072002)(83322001)(89996001)(87286001)(76176999)(36756003)(92726001)(77096999)(86362001)(46102001)(81342001)(48376002)(19580405001)(77156001)(50466002)(50986999)(99396002)(80976001)(81542001)(19580395003)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:az84smr01.freescale.net;FPR:2974DD.24D4E290.3BD1AB70.44E5B332.20347;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many drivers which will support rich endianness of CPU<-->Dev
need define DT properties by itself without the binding support.

The value endianness using regmap-mmio, for example:
Index    CPU       Device     Endianess flag for DT property
------------------------------------------------------------
1        LE        LE         -
2        LE        BE         'big-endian'
3        BE        BE         -
4        BE        LE         'little-endian'

============

Here add DT endianness binding support will define two string
properties of the register and value endiannesses:

'regmap-reg-endian' and 'regmap-val-endian'.

And the value of them will be:
'le' : REGMAP_ENDIAN_LITTLE
'be' : REGMAP_ENDIAN_BIG
'native' : REGMAP_ENDIAN_NATIVE
Absent : REGMAP_ENDIAN_DEFAULT

The value endianness for regmap-mmio, for example:
Index    CPU       Device     Endianess flag for DT property
------------------------------------------------------------
1        LE        LE         'native' or absent
2        LE        BE         'be'
3        BE        BE         'native' or absent
4        BE        LE         'le'

Please see the following documetation for detail usage:
    Documentation/devicetree/bindings/regmap/regmap-endianness.txt

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 96 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8e8cea1..cfc9302 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 
@@ -423,6 +424,81 @@ static void regmap_range_exit(struct regmap *map)
 }
 
 /**
+ * of_regmap_endian_get_by_name() - Parse and lookup the endianness referenced
+ * by a device node
+ * @np: pointer to clock consumer node
+ * @name: name of consumer's endianness input
+ *
+ * This function parses the device endianness property, and uses them to
+ * determine the endianness of the registers and values.
+ */
+static int of_regmap_endian_get_by_name(struct device_node *np,
+					const char *endian_name,
+					enum regmap_endian *out_endian)
+{
+	const char *endianness;
+	int ret;
+
+	if (!out_endian)
+		return -EINVAL;
+
+	/* Set the default endianness */
+	*out_endian = REGMAP_ENDIAN_DEFAULT;
+
+	/* Absent or being to use the flag from config of the drivers */
+	if (!of_find_property(np, endian_name, NULL))
+		return 0;
+
+	ret = of_property_read_string(np, endian_name, &endianness);
+	if (ret)
+		return ret;
+
+	if (!strcmp("le", endianness))
+		*out_endian = REGMAP_ENDIAN_LITTLE;
+	else if (!strcmp("be", endianness))
+		*out_endian = REGMAP_ENDIAN_BIG;
+	else if (!strcmp("native", endianness))
+		*out_endian = REGMAP_ENDIAN_NATIVE;
+
+	return 0;
+}
+
+static int of_regmap_get_endian(struct device *dev,
+				const struct regmap_bus *bus,
+				const struct regmap_config *config,
+				const char *endian_name,
+				enum regmap_endian *out_endian)
+{
+	int ret;
+
+	if (!out_endian)
+		return -EINVAL;
+
+	if (dev) {
+		ret = of_regmap_endian_get_by_name(dev->of_node, endian_name,
+						   out_endian);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (*out_endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/*
+	 * Parsing the endianness from driver's config
+	 * or bus, this is to be compatible with the
+	 * none DT and the old drivers.
+	 */
+	*out_endian = config->reg_format_endian;
+	if (*out_endian == REGMAP_ENDIAN_DEFAULT)
+		*out_endian = bus->reg_format_endian_default;
+	if (*out_endian == REGMAP_ENDIAN_DEFAULT)
+		*out_endian = REGMAP_ENDIAN_BIG;
+
+	return 0;
+}
+
+/**
  * regmap_init(): Initialise register map
  *
  * @dev: Device that will be interacted with
@@ -518,17 +594,15 @@ struct regmap *regmap_init(struct device *dev,
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
+	ret = of_regmap_get_endian(dev, bus, config, "regmap-reg-endian",
+				   &reg_endian);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_regmap_get_endian(dev, bus, config, "regmap-val-endian",
+				   &val_endian);
+	if (ret)
+		return ERR_PTR(ret);
 
 	switch (config->reg_bits + map->reg_shift) {
 	case 2:
-- 
1.8.4

