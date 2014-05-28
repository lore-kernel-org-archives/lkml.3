Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaE1MrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:47:01 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61386 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaE1MrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:47:00 -0400
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
Subject: [PATCH v5 4/9] OF: platform: Add OF notifier handler
Date: Wed, 28 May 2014 15:46:28 +0300
Message-Id: <1401281193-27146-5-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF notifier handler needed for creating/destroying platform devices
according to dynamic runtime changes in the DT live tree.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/base/platform.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9e9227e..8d64605 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -930,6 +930,56 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
+static struct notifier_block platform_of_notifier;
+
+static int of_platform_notify(struct notifier_block *nb,
+				unsigned long action, void *arg)
+{
+	struct device_node *dn;
+	struct platform_device *pdev_parent, *pdev;
+
+	if (action == OF_RECONFIG_DYNAMIC_CREATE_DEV) {
+
+		dn = arg;
+
+		/* verify that the parent is a bus */
+		if (!of_match_node(of_default_bus_match_table, dn->parent))
+			return NOTIFY_OK;	/* not for us */
+
+		/* pdev_parent may be NULL when no bus platform device */
+		pdev_parent = of_find_device_by_node(dn->parent);
+		pdev = of_platform_device_create(dn, NULL,
+				pdev_parent ? &pdev_parent->dev : NULL);
+		of_dev_put(pdev_parent);
+
+		if (pdev == NULL) {
+			pr_err("%s: failed to create for '%s'\n",
+					__func__, dn->full_name);
+			/* of_platform_device_create tosses the error code */
+			return notifier_from_errno(-EINVAL);
+		}
+
+	} else if (action == OF_RECONFIG_DYNAMIC_DESTROY_DEV) {
+
+		dn = arg;
+
+		/* find our device by node */
+		pdev = of_find_device_by_node(dn);
+		if (pdev == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		platform_device_unregister(pdev);
+
+		/* and put the reference of the find */
+		of_dev_put(pdev);
+
+	} else
+		return NOTIFY_OK;
+
+	return NOTIFY_STOP;
+}
+
 int __init platform_bus_init(void)
 {
 	int error;
@@ -938,10 +988,23 @@ int __init platform_bus_init(void)
 
 	error = device_register(&platform_bus);
 	if (error)
-		return error;
-	error =  bus_register(&platform_bus_type);
+		goto err_out;
+
+	error = bus_register(&platform_bus_type);
+	if (error)
+		goto err_unreg_dev;
+
+	platform_of_notifier.notifier_call = of_platform_notify;
+	error = of_reconfig_notifier_register(&platform_of_notifier);
 	if (error)
-		device_unregister(&platform_bus);
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

