Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbbAGK5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:57:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbAGK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:57:52 -0500
Message-ID: <1420628264.3191.27.camel@pengutronix.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>, kernel@pengutronix.de,
        Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Heiko Stuebner <heiko@sntech.de>
Date: Wed, 07 Jan 2015 11:57:44 +0100
In-Reply-To: <35536202.10QfWIDQqq@wuerfel>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
	 <35536202.10QfWIDQqq@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 06.01.2015, 20:36 +0100 schrieb Arnd Bergmann:
> On Tuesday 06 January 2015 16:30:36 Philipp Zabel wrote:
> > Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
> > breaks probing pure syscon devices from device tree, such as anatop and
> > iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
> > "syscon" compatible device tree nodes.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> 
> I don't understand it. Why is this required?

The debugfs entries vanished and I'd like to have a device to register
platform device children to. I guess for i.MX iomuxc it could be argued
that the iomuxc-gpr syscon should be merged into the iomuxc pinctrl
device instead of probing iomuxc-gpr as a platform device by itself.
How about allowing to register a syscon for a given device:

----8<----
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index d2280d6..2633b27 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -42,13 +42,14 @@ static struct regmap_config syscon_regmap_config = {
 	.reg_stride = 4,
 };
 
-static struct syscon *of_syscon_register(struct device_node *np)
+struct syscon *syscon_register(struct device *dev, struct device_node *np)
 {
 	struct syscon *syscon;
 	struct regmap *regmap;
 	void __iomem *base;
 	int ret;
 	struct regmap_config syscon_config = syscon_regmap_config;
+	struct resource res;
 
 	if (!of_device_is_compatible(np, "syscon"))
 		return ERR_PTR(-EINVAL);
@@ -57,7 +58,12 @@ static struct syscon *of_syscon_register(struct device_node *np)
 	if (!syscon)
 		return ERR_PTR(-ENOMEM);
 
-	base = of_iomap(np, 0);
+	if (of_address_to_resource(np, 0, &res)) {
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	base = ioremap(res.start, resource_size(&res));
 	if (!base) {
 		ret = -ENOMEM;
 		goto err_map;
@@ -69,7 +75,8 @@ static struct syscon *of_syscon_register(struct device_node *np)
 	 else if (of_property_read_bool(np, "little-endian"))
 		syscon_config.val_format_endian = REGMAP_ENDIAN_LITTLE;
 
-	regmap = regmap_init_mmio(NULL, base, &syscon_config);
+	syscon_regmap_config.max_register = res.end - res.start - 3;
+	regmap = regmap_init_mmio(dev, base, &syscon_config);
 	if (IS_ERR(regmap)) {
 		pr_err("regmap init failed\n");
 		ret = PTR_ERR(regmap);
@@ -91,6 +98,12 @@ err_map:
 	kfree(syscon);
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(syscon_register);
+
+static struct syscon *of_syscon_register(struct device_node *np)
+{
+	return syscon_register(NULL, np);
+}
 
 struct regmap *syscon_node_to_regmap(struct device_node *np)
 {
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 75e543b..e0c4a86 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -17,10 +17,14 @@
 
 #include <linux/err.h>
 
+struct device;
 struct device_node;
+struct syscon;
 
 #ifdef CONFIG_MFD_SYSCON
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
+extern struct syscon *syscon_register(struct device *dev,
+				      struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
@@ -32,6 +36,12 @@ static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
 	return ERR_PTR(-ENOSYS);
 }
 
+static struct syscon *syscon_register(struct device *dev,
+				      struct device_node *np)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 {
 	return ERR_PTR(-ENOSYS);
--
---->8----

That way the syscon could be registered from iomuxc (pinctrl-imx6q):

----8<----
diff --git a/drivers/pinctrl/freescale/pinctrl-imx6q.c b/drivers/pinctrl/freescale/pinctrl-imx6q.c
index 4d1fcb8..74a68ec 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx6q.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx6q.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -473,6 +474,12 @@ static const struct of_device_id imx6q_pinctrl_of_match[] = {
 
 static int imx6q_pinctrl_probe(struct platform_device *pdev)
 {
+	struct device_node *syscon_np;
+
+	syscon_np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-iomuxc-gpr");
+	if (syscon_np)
+		syscon_register(&pdev->dev, syscon_np);
+
 	return imx_pinctrl_probe(pdev, &imx6q_pinctrl_info);
 }
 
---->8----

which makes the regmap debugfs entry return
as /sys/kernel/debug/regmap/20e0000.iomuxc
and allows to register children to the iomuxc-gpr node.

regards
Philipp

