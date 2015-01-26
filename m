Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbbAZRAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:00:16 -0500
Received: from gn237.zone.eu ([217.146.67.237]:24537 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbbAZRAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:00:09 -0500
From: Priit Laes <plaes@plaes.org>
Cc: linux-sunxi@googlegroups.com, Priit Laes <plaes@plaes.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
	A1X...),
        linux-kernel@vger.kernel.org (open list),
        linux-input@vger.kernel.org (open list:SUN4I LOW RES ADC...)
Subject: [PATCH] arm: sunxi: input: RFC: Add sysfs voltage for sun4i-lradc driver
Date: Mon, 26 Jan 2015 18:58:32 +0200
Message-Id: <1422291516-24895-1-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
 drivers/input/keyboard/sun4i-lradc-keys.c          | 49 +++++++++++++++++-----
 2 files changed, 43 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc

diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
new file mode 100644
index 0000000..e4e6448
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
@@ -0,0 +1,4 @@
+What:		/sys/class/input/input(x)/device/voltage
+Date:		February 2015
+Contact:	Priit Laes <plaes@plaes.org>
+Description:	ADC output voltage in microvolts or 0 if device is not opened.
diff --git a/drivers/input/keyboard/sun4i-lradc-keys.c b/drivers/input/keyboard/sun4i-lradc-keys.c
index cc8f7dd..c0ab8ec 100644
--- a/drivers/input/keyboard/sun4i-lradc-keys.c
+++ b/drivers/input/keyboard/sun4i-lradc-keys.c
@@ -79,10 +79,27 @@ struct sun4i_lradc_data {
 	u32 vref;
 };
 
+static u32 sun4i_lradc_read_voltage(struct sun4i_lradc_data *lradc)
+{
+	u32 val = readl(lradc->base + LRADC_DATA0) & 0x3f;
+	return val * lradc->vref / 63;
+};
+
+static ssize_t
+sun4i_lradc_dev_voltage_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct sun4i_lradc_data *lradc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", sun4i_lradc_read_voltage(lradc));
+}
+
+static const DEVICE_ATTR(voltage, S_IRUGO, sun4i_lradc_dev_voltage_show, NULL);
+
 static irqreturn_t sun4i_lradc_irq(int irq, void *dev_id)
 {
 	struct sun4i_lradc_data *lradc = dev_id;
-	u32 i, ints, val, voltage, diff, keycode = 0, closest = 0xffffffff;
+	u32 i, ints, voltage, diff, keycode = 0, closest = 0xffffffff;
 
 	ints  = readl(lradc->base + LRADC_INTS);
 
@@ -97,8 +114,7 @@ static irqreturn_t sun4i_lradc_irq(int irq, void *dev_id)
 	}
 
 	if ((ints & CHAN0_KEYDOWN_IRQ) && lradc->chan0_keycode == 0) {
-		val = readl(lradc->base + LRADC_DATA0) & 0x3f;
-		voltage = val * lradc->vref / 63;
+		voltage = sun4i_lradc_read_voltage(lradc);
 
 		for (i = 0; i < lradc->chan0_map_count; i++) {
 			diff = abs(lradc->chan0_map[i].voltage - voltage);
@@ -156,7 +172,7 @@ static void sun4i_lradc_close(struct input_dev *dev)
 }
 
 static int sun4i_lradc_load_dt_keymap(struct device *dev,
-				      struct sun4i_lradc_data *lradc)
+				    struct sun4i_lradc_data *lradc)
 {
 	struct device_node *np, *pp;
 	int i;
@@ -168,8 +184,8 @@ static int sun4i_lradc_load_dt_keymap(struct device *dev,
 
 	lradc->chan0_map_count = of_get_child_count(np);
 	if (lradc->chan0_map_count == 0) {
-		dev_err(dev, "keymap is missing in device tree\n");
-		return -EINVAL;
+		dev_info(dev, "keymap is missing in device tree\n");
+		return 0;
 	}
 
 	lradc->chan0_map = devm_kmalloc_array(dev, lradc->chan0_map_count,
@@ -185,19 +201,19 @@ static int sun4i_lradc_load_dt_keymap(struct device *dev,
 
 		error = of_property_read_u32(pp, "channel", &channel);
 		if (error || channel != 0) {
-			dev_err(dev, "%s: Inval channel prop\n", pp->name);
+			dev_err(dev, "%s: Invalid 'channel' property\n", pp->name);
 			return -EINVAL;
 		}
 
 		error = of_property_read_u32(pp, "voltage", &map->voltage);
 		if (error) {
-			dev_err(dev, "%s: Inval voltage prop\n", pp->name);
+			dev_err(dev, "%s: Invalid 'voltage' property\n", pp->name);
 			return -EINVAL;
 		}
 
 		error = of_property_read_u32(pp, "linux,code", &map->keycode);
 		if (error) {
-			dev_err(dev, "%s: Inval linux,code prop\n", pp->name);
+			dev_err(dev, "%s: Invalid 'linux,code' property\n", pp->name);
 			return -EINVAL;
 		}
 
@@ -257,14 +273,26 @@ static int sun4i_lradc_probe(struct platform_device *pdev)
 	if (error)
 		return error;
 
-	error = input_register_device(lradc->input);
+	error = device_create_file(dev, &dev_attr_voltage);
 	if (error)
 		return error;
 
+	error = input_register_device(lradc->input);
+	if (error) {
+		device_remove_file(&pdev->dev, &dev_attr_voltage);
+		return error;
+	}
+
 	platform_set_drvdata(pdev, lradc);
 	return 0;
 }
 
+static int sun4i_lradc_remove(struct platform_device *pdev)
+{
+	device_remove_file(&pdev->dev, &dev_attr_voltage);
+	return 0;
+}
+
 static const struct of_device_id sun4i_lradc_of_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-lradc-keys", },
 	{ /* sentinel */ }
@@ -277,6 +305,7 @@ static struct platform_driver sun4i_lradc_driver = {
 		.of_match_table = of_match_ptr(sun4i_lradc_of_match),
 	},
 	.probe	= sun4i_lradc_probe,
+	.remove = sun4i_lradc_remove,
 };
 
 module_platform_driver(sun4i_lradc_driver);
-- 
2.2.2

