Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3EJHSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:18:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39758 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3EJHS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:18:29 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] power: lp8727: support the device tree feature
Thread-Topic: [PATCH] power: lp8727: support the device tree feature
Thread-Index: Ac5NTnsTDLNuPgydRsi3PasmLKKIQA==
Date: Fri, 10 May 2013 07:17:51 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5CF45@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt and charging parameters are configurable in the device tree
structure. In the board test, a GPIO is used for handling LP8727 interrupts.
The device tree binding documentation is added also.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 .../bindings/power_supply/lp8727_charger.txt       |   44 +++++++++++++
 drivers/power/lp8727_charger.c                     |   68 ++++++++++++++++++++
 2 files changed, 112 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/lp8727_charger.txt

diff --git a/Documentation/devicetree/bindings/power_supply/lp8727_charger.txt b/Documentation/devicetree/bindings/power_supply/lp8727_charger.txt
new file mode 100644
index 0000000..2246bc5
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/lp8727_charger.txt
@@ -0,0 +1,44 @@
+Binding for TI/National Semiconductor LP8727 Charger
+
+Required properties:
+- compatible: "ti,lp8727"
+- reg: I2C slave address 27h
+
+Optional properties:
+- interrupt-parent: interrupt controller node (see interrupt binding[0])
+- interrupts: interrupt specifier (see interrupt binding[0])
+- debounce-ms: interrupt debounce time. (u32)
+
+AC and USB charging parameters
+- charger-type: "ac" or "usb" (string)
+- eoc-level: value of 'enum lp8727_eoc_level' (u8)
+- charging-current: value of 'enum lp8727_ichg' (u8)
+
+[0]: Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+
+Example)
+
+lp8727@27 {
+	compatible = "ti,lp8727";
+	reg = <0x27>;
+
+	/* GPIO 134 is used for LP8728 interrupt pin */
+	interrupt-parent = <&gpio5>; 	/* base = 128 */
+	interrupts = <6 0x2>;		/* offset = 6, falling edge type */
+
+	debounce-ms = <300>;
+
+	/* AC charger: 5% EOC and 500mA charging current */
+	ac {
+		charger-type = "ac";
+		eoc-level = /bits/ 8 <0>;
+		charging-current = /bits/ 8 <4>;
+	};
+
+	/* USB charger: 10% EOC and 400mA charging current */
+	usb {
+		charger-type = "usb";
+		eoc-level = /bits/ 8 <1>;
+		charging-current = /bits/ 8 <2>;
+	};
+};
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 5ef41b8..32de636 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/power_supply.h>
 #include <linux/platform_data/lp8727.h>
+#include <linux/of.h>
 
 #define LP8788_NUM_INTREGS	2
 #define DEFAULT_DEBOUNCE_MSEC	270
@@ -481,6 +482,60 @@ static void lp8727_unregister_psy(struct lp8727_chg *pchg)
 	power_supply_unregister(&psy->batt);
 }
 
+#ifdef CONFIG_OF
+static struct lp8727_chg_param
+*lp8727_parse_charge_pdata(struct device *dev, struct device_node *np)
+{
+	struct lp8727_chg_param *param;
+
+	param = devm_kzalloc(dev, sizeof(*param), GFP_KERNEL);
+	if (!param)
+		goto out;
+
+	of_property_read_u8(np, "eoc-level", (u8 *)&param->eoc_level);
+	of_property_read_u8(np, "charging-current", (u8 *)&param->ichg);
+out:
+	return param;
+}
+
+static int lp8727_parse_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *child;
+	struct lp8727_platform_data *pdata;
+	const char *type;
+
+	/* If charging parameter is not defined, just skip parsing the dt */
+	if (of_get_child_count(np) == 0)
+		goto out;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	of_property_read_u32(np, "debounce-ms", &pdata->debounce_msec);
+
+	for_each_child_of_node(np, child) {
+		of_property_read_string(child, "charger-type", &type);
+
+		if (!strcmp(type, "ac"))
+			pdata->ac = lp8727_parse_charge_pdata(dev, child);
+
+		if (!strcmp(type, "usb"))
+			pdata->usb = lp8727_parse_charge_pdata(dev, child);
+	}
+
+	dev->platform_data = pdata;
+out:
+	return 0;
+}
+#else
+static int lp8727_parse_dt(struct device *dev)
+{
+	return 0;
+}
+#endif
+
 static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp8727_chg *pchg;
@@ -489,6 +544,12 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
+	if (cl->dev.of_node) {
+		ret = lp8727_parse_dt(&cl->dev);
+		if (ret)
+			return ret;
+	}
+
 	pchg = devm_kzalloc(&cl->dev, sizeof(*pchg), GFP_KERNEL);
 	if (!pchg)
 		return -ENOMEM;
@@ -531,6 +592,12 @@ static int lp8727_remove(struct i2c_client *cl)
 	return 0;
 }
 
+static const struct of_device_id lp8727_dt_ids[] = {
+	{ .compatible = "ti,lp8727", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp8727_dt_ids);
+
 static const struct i2c_device_id lp8727_ids[] = {
 	{"lp8727", 0},
 	{ }
@@ -540,6 +607,7 @@ MODULE_DEVICE_TABLE(i2c, lp8727_ids);
 static struct i2c_driver lp8727_driver = {
 	.driver = {
 		   .name = "lp8727",
+		   .of_match_table = of_match_ptr(lp8727_dt_ids),
 		   },
 	.probe = lp8727_probe,
 	.remove = lp8727_remove,
-- 
1.7.9.5


Best Regards,
Milo


