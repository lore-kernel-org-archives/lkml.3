Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaDDMqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:46:35 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36056 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaDDMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:44:28 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v4 4/8] OF: platform: Add overlay bus handler
Date: Fri,  4 Apr 2014 15:43:57 +0300
Message-Id: <1396615441-29630-5-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the bus handler registration needed for performing overlays
containing platform devices.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/base/platform.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e714709..bf5b429 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -922,6 +922,86 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+#ifdef CONFIG_OF_OVERLAY
+
+static int platform_handler_create(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct platform_device *pdev_parent, *pdev;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	/* verify that the parent is a bus */
+	if (!of_match_node(of_default_bus_match_table, dn->parent))
+		return -ENOTSUPP;
+
+	/* pdev_parent may be NULL when there is no bus platform device */
+	pdev_parent = of_find_device_by_node(dn->parent);
+	pdev = of_platform_device_create(dn, NULL,
+			pdev_parent ? &pdev_parent->dev : NULL);
+	of_dev_put(pdev_parent);
+
+	if (pdev == NULL) {
+		pr_err("%s: failed to create platform device "
+				"for '%s'\n",
+				__func__, dn->full_name);
+		/* of_platform_device_create tosses the real error code */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int platform_handler_remove(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct platform_device *pdev;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	pdev = of_find_device_by_node(dn);
+	if (pdev == NULL)
+		return -ENOTSUPP;
+
+	/* unregister takes one ref away */
+	platform_device_unregister(pdev);
+
+	/* and put the reference of the find */
+	of_dev_put(pdev);
+
+	return 0;
+}
+
+static const struct of_overlay_handler_ops platform_handler_ops = {
+	.create	= platform_handler_create,
+	.remove = platform_handler_remove,
+};
+
+static struct of_overlay_handler platform_handler = {
+	.name = "platform",
+	.ops = &platform_handler_ops,
+};
+
+static int __init platform_bus_handler_register(void)
+{
+	return of_overlay_handler_register(&platform_handler);
+}
+
+#else
+static inline int platform_bus_handler_register(void)
+{
+	return 0;
+}
+#endif
+
 int __init platform_bus_init(void)
 {
 	int error;
@@ -930,10 +1010,22 @@ int __init platform_bus_init(void)
 
 	error = device_register(&platform_bus);
 	if (error)
-		return error;
-	error =  bus_register(&platform_bus_type);
+		goto err_out;
+
+	error = bus_register(&platform_bus_type);
 	if (error)
-		device_unregister(&platform_bus);
+		goto err_unreg_dev;
+
+	error = platform_bus_handler_register();
+	if (error)
+		goto err_unreg_bus;
+
+	return 0;
+err_unreg_bus:
+	bus_unregister(&platform_bus_type);
+err_unreg_dev:
+	device_unregister(&platform_bus);
+err_out:
 	return error;
 }
 
-- 
1.7.12

