Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaCaIKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:10:01 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:49158
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560AbaCaIJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:09:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/2] regmap: add DT endianness binding support.
Date: Mon, 31 Mar 2014 15:26:37 +0800
Message-ID: <1396250797-17758-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1396250797-17758-1-git-send-email-Li.Xiubo@freescale.com>
References: <1396250797-17758-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many drivers which will support rich endianness of CPU<-->Dev
need define DT properties by itself without the binding support.

The value endianness using regmap-mmio, for example:
Index    CPU       Device     Endianess flag for DT property
------------------------------------------------------------
1        LE        LE         -
2        LE        BE         'little-endian'
3        BE        BE         -
4        BE        LE         'big-endian'

============

Here add DT endianness binding support will define two string
properties of the register and value endiannesses:

'reg-endian' and 'val-endian'.

And the value of them will be:
'LE' : REGMAP_ENDIAN_LITTLE
'BE' : REGMAP_ENDIAN_BIG
'NT' : REGMAP_ENDIAN_NATIVE
Absent : REGMAP_ENDIAN_DEFAULT

The value endianness using regmap-mmio, for example:
Index    CPU       Device     Endianess flag for DT property
------------------------------------------------------------
1        LE        LE         'NT' or absent
2        LE        BE         'LE'
3        BE        BE         'NT' or absent
4        BE        LE         'BE'

Please see the following documetation for detail usage:
    Documentation/devicetree/bindings/regmap/regmap-endianness.txt

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 91 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 80 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8e8cea1..36a96cc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 
@@ -423,6 +424,78 @@ static void regmap_range_exit(struct regmap *map)
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
+	if (!strcmp("LE", endianness))
+		*out_endian = REGMAP_ENDIAN_LITTLE;
+	else if (!strcmp("BE", endianness))
+		*out_endian = REGMAP_ENDIAN_BIG;
+	else if (!strcmp("NT", endianness))
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
+		if (ret)
+			return ret;
+	}
+
+	/* To be compatible with the none DT or the old drivers */
+	if (*out_endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/* Parsing the endianness from driver's config or bus */
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
@@ -518,17 +591,13 @@ struct regmap *regmap_init(struct device *dev,
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
+	ret = of_regmap_get_endian(dev, bus, config, "reg_endian", &reg_endian);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_regmap_get_endian(dev, bus, config, "val_endian", &val_endian);
+	if (ret)
+		return ERR_PTR(ret);
 
 	switch (config->reg_bits + map->reg_shift) {
 	case 2:
-- 
1.8.4


