Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBSLEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:04:21 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54664 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBSLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:04:19 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/2] mfd: syscon: Support early initialization
Date: Wed, 19 Feb 2014 12:04:04 +0100
Message-Id: <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392807832.git.michal.simek@xilinx.com>
References: <cover.1392807832.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392807832.git.michal.simek@xilinx.com>
References: <cover.1392807832.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32452-1392807855-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32452-1392807855-0001

Some platforms need to get system controller
ready as soon as possible.
The patch provides early_syscon_initialization
which create early mapping for all syscon compatible
devices in early_syscon_probe.
Regmap is get via syscon_early_regmap_lookup_by_phandle()

Regular device probes attach device to regmap
via regmap_attach_dev().

For early syscon initialization is necessary to extend
struct syscon and provide remove function
which unmap all early init structures.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
- Fix bad logic in early_syscon_probe
- Fix compilation failure for x86_64 reported by zero day testing system
- Regmap change available here
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev

 drivers/mfd/syscon.c       | 128 +++++++++++++++++++++++++++++++++++++++------
 include/linux/mfd/syscon.h |  11 ++++
 2 files changed, 122 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 71841f9..8e6c611 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -20,12 +20,15 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/slab.h>
 #include <linux/mfd/syscon.h>

 static struct platform_driver syscon_driver;

 struct syscon {
+	void __iomem *base;
 	struct regmap *regmap;
+	struct resource res;
 };

 static int syscon_match_node(struct device *dev, void *data)
@@ -95,6 +98,24 @@ struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);

+struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_node *np,
+						     const char *property)
+{
+	struct device_node *syscon_np;
+	struct syscon *syscon;
+
+	syscon_np = of_parse_phandle(np, property, 0);
+	if (!syscon_np)
+		return ERR_PTR(-ENODEV);
+
+	syscon = syscon_np->data;
+
+	of_node_put(syscon_np);
+
+	return syscon->regmap;
+}
+EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);
+
 struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 					const char *property)
 {
@@ -128,40 +149,112 @@ static int syscon_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct syscon *syscon;
 	struct resource *res;
-	void __iomem *base;

-	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
+	/* Early syscon init */
+	if (pdev->dev.of_node && pdev->dev.of_node->data) {
+		syscon = pdev->dev.of_node->data;
+		res = &syscon->res;
+		regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);
+	} else {
+
+		syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
+		if (!syscon)
+			return -ENOMEM;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			return -ENOENT;
+
+		syscon->base = devm_ioremap(dev, res->start,
+					    resource_size(res));
+		if (!syscon->base)
+			return -ENOMEM;
+
+		syscon_regmap_config.max_register = res->end - res->start - 3;
+		syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
+						&syscon_regmap_config);
+		if (IS_ERR(syscon->regmap)) {
+			dev_err(dev, "regmap init failed\n");
+			return PTR_ERR(syscon->regmap);
+		}
+	}
+
+	platform_set_drvdata(pdev, syscon);
+
+	dev_info(dev, "regmap %pR registered\n", res);
+
+	return 0;
+}
+
+static const struct platform_device_id syscon_ids[] = {
+	{ "syscon", },
+	{ }
+};
+
+static int syscon_remove(struct platform_device *pdev)
+{
+	struct syscon *syscon = platform_get_drvdata(pdev);
+
+	if (pdev->dev.of_node && pdev->dev.of_node->data) {
+		iounmap(syscon->base);
+		kfree(syscon);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static int early_syscon_probe(struct device_node *np)
+{
+	struct syscon *syscon;
+
+	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
 	if (!syscon)
 		return -ENOMEM;

-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
+	if (of_address_to_resource(np, 0, &syscon->res))
+		return -EINVAL;

-	base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!base)
-		return -ENOMEM;
+	syscon->base = ioremap(syscon->res.start, resource_size(&syscon->res));
+	if (!syscon->base) {
+		pr_err("%s: Unable to map I/O memory\n", __func__);
+		return PTR_ERR(syscon->base);
+	}

-	syscon_regmap_config.max_register = res->end - res->start - 3;
-	syscon->regmap = devm_regmap_init_mmio(dev, base,
-					&syscon_regmap_config);
+	syscon_regmap_config.max_register = syscon->res.end -
+					    syscon->res.start - 3;
+	syscon->regmap = regmap_init_mmio(NULL, syscon->base,
+					  &syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
-		dev_err(dev, "regmap init failed\n");
+		pr_err("regmap init failed\n");
 		return PTR_ERR(syscon->regmap);
 	}

-	platform_set_drvdata(pdev, syscon);
+	np->data = syscon;

-	dev_info(dev, "regmap %pR registered\n", res);
+	of_node_put(np);
+
+	pr_info("%s: regmap %pR registered\n", np->full_name, &syscon->res);

 	return 0;
 }

-static const struct platform_device_id syscon_ids[] = {
-	{ "syscon", },
-	{ }
+static struct of_device_id of_syscon_ids[] = {
+	{ .compatible = "syscon" },
+	{},
 };

+void __init early_syscon_init(void)
+{
+	struct device_node *np;
+
+	for_each_matching_node_and_match(np, of_syscon_ids, NULL) {
+		if (early_syscon_probe(np))
+			BUG();
+	}
+}
+#endif
+
 static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
@@ -169,6 +262,7 @@ static struct platform_driver syscon_driver = {
 		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
+	.remove		= syscon_remove,
 	.id_table	= syscon_ids,
 };

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 8789fa3..465c092 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -24,6 +24,10 @@ extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
+extern struct regmap *syscon_early_regmap_lookup_by_phandle(
+					struct device_node *np,
+					const char *property);
+extern void early_syscon_init(void);
 #else
 static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
 {
@@ -46,6 +50,13 @@ static inline struct regmap *syscon_regmap_lookup_by_phandle(
 {
 	return ERR_PTR(-ENOSYS);
 }
+
+static struct regmap *syscon_early_regmap_lookup_by_phandle(
+					struct device_node *np,
+					const char *property)
+{
+	return ERR_PTR(-ENOSYS);
+}
 #endif

 #endif /* __LINUX_MFD_SYSCON_H__ */
--
1.8.2.3


--=_mimegpg-monstr-desktop-32452-1392807855-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMEj68ACgkQykllyylKDCFpcACfTGo29APxsAkuv3xVBESvtU/N
ORkAnRHd2iSluL9VyuJpXW13C8ssiZQs
=DiF8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32452-1392807855-0001--
