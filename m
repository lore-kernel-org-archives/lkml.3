Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaGOE1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:27:14 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:16249
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751659AbaGOE0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:26:48 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv6 1/2] regmap: add DT endianness binding support.
Date: Tue, 15 Jul 2014 12:23:02 +0800
Message-ID: <1405398183-31345-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(74662001)(84676001)(87286001)(79102001)(64706001)(87936001)(36756003)(6806004)(105606002)(85852003)(85306003)(83072002)(74502001)(48376002)(26826002)(99396002)(95666004)(81342001)(89996001)(81542001)(50986999)(76176999)(88136002)(92566001)(77156001)(92726001)(106466001)(19580395003)(46102001)(50466002)(83322001)(19580405001)(86362001)(107046002)(229853001)(4396001)(21056001)(50226001)(31966008)(104016003)(44976005)(80022001)(97736001)(104166001)(68736004)(77982001)(102836001)(47776003)(76482001)(93916002)(62966002)(20776003)(69596002)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0619;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many drivers which will support rich endianness of Devices
need define DT properties by itself with the binding support.

The endianness using regmap:
Index      Device     Properties if needs bytes-swap,
                      or just ignore it
-------------------------------------------------------------
1          BE         'big-endian'
2          LE         'little-endian'

The properties include all the register values and the buffers.
And these properties are very usful for the MMIO devices:

Such as: a memory-mapped device, on one SoC is in BE mode, while
in another SoC will be in LE mode, and the CPU will always in LE
mode.

For the first case, we must use cpu_to_be32/be32_to_cpu for
32-bit registers accessing, so the 'big-endian' property is needed.

For the second case, we can just ignore the bytes-swap
functions like cpu_to_le32/le32_to_cpu, so the 'little-endian'
property could be abscent.

And vice versa...

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-i2c.c |   2 +
 drivers/base/regmap/regmap-spi.c |   2 +
 drivers/base/regmap/regmap.c     | 117 +++++++++++++++++++++++++++++++++++----
 3 files changed, 110 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index ca193d1..053150a 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -168,6 +168,8 @@ static struct regmap_bus regmap_i2c = {
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 };
 
 static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
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
index 74d8c06..c033766 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 
@@ -448,6 +449,102 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
+enum regmap_endian_type {
+	REGMAP_ENDIAN_REG,
+	REGMAP_ENDIAN_VAL,
+};
+
+static int of_regmap_get_endian(struct device *dev,
+				const struct regmap_bus *bus,
+				const struct regmap_config *config,
+				enum regmap_endian_type type,
+				enum regmap_endian *endian)
+{
+	struct device_node *np = dev->of_node;
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
+	switch (type) {
+	case REGMAP_ENDIAN_VAL:
+		if (of_property_read_bool(np, "big-endian"))
+			*endian = REGMAP_ENDIAN_BIG;
+		else if (of_property_read_bool(np, "little-endian"))
+			*endian = REGMAP_ENDIAN_LITTLE;
+		else
+			*endian = REGMAP_ENDIAN_NATIVE;
+		break;
+	case REGMAP_ENDIAN_REG:
+		break;
+	default:
+		return -EINVAL;
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
@@ -551,17 +648,15 @@ struct regmap *regmap_init(struct device *dev,
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
1.8.5

