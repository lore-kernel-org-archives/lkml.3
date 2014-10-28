Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaJ1UiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:38:22 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53446 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaJ1Uge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:36:34 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v8 4/8] OF: platform: Add OF notifier handler
Date: Tue, 28 Oct 2014 22:36:01 +0200
Message-Id: <1414528565-10907-5-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF notifier handler needed for creating/destroying platform devices
according to dynamic runtime changes in the DT live tree.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/base/platform.c     | 18 +++++++++--
 drivers/of/platform.c       | 78 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_platform.h | 10 ++++++
 3 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b2afc29..282bfec 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1002,10 +1002,22 @@ int __init platform_bus_init(void)
 
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
+	error = of_platform_register_reconfig_notifier();
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
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0b..aa8db92 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -546,4 +546,82 @@ void of_platform_depopulate(struct device *parent)
 }
 EXPORT_SYMBOL_GPL(of_platform_depopulate);
 
+#ifdef CONFIG_OF_DYNAMIC
+
+static struct notifier_block platform_of_notifier;
+
+static int of_platform_notify(struct notifier_block *nb,
+				unsigned long action, void *arg)
+{
+	struct platform_device *pdev_parent, *pdev;
+	struct device_node *dn;
+	int state;
+	bool children_left;
+
+	state = of_reconfig_get_state_change(action, arg);
+
+	/* no change? */
+	if (state == -1)
+		return NOTIFY_OK;
+
+	switch (action) {
+	case OF_RECONFIG_ATTACH_NODE:
+	case OF_RECONFIG_DETACH_NODE:
+		dn = arg;
+		break;
+	case OF_RECONFIG_ADD_PROPERTY:
+	case OF_RECONFIG_REMOVE_PROPERTY:
+	case OF_RECONFIG_UPDATE_PROPERTY:
+		dn = ((struct of_prop_reconfig *)arg)->dn;
+		break;
+	default:
+		return NOTIFY_OK;
+	}
+
+	if (state) {
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
+	} else {
+
+		/* find our device by node */
+		pdev = of_find_device_by_node(dn);
+		if (pdev == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		of_platform_device_destroy(&pdev->dev, &children_left);
+
+		/* and put the reference of the find */
+		of_dev_put(pdev);
+
+	}
+
+	return NOTIFY_OK;
+}
+
+int of_platform_register_reconfig_notifier(void)
+{
+	platform_of_notifier.notifier_call = of_platform_notify;
+	return of_reconfig_notifier_register(&platform_of_notifier);
+}
+EXPORT_SYMBOL_GPL(of_platform_register_reconfig_notifier);
+
+#endif
+
 #endif /* CONFIG_OF_ADDRESS */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index c2b0627..01fe5d6 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -84,4 +84,14 @@ static inline int of_platform_populate(struct device_node *root,
 static inline void of_platform_depopulate(struct device *parent) { }
 #endif
 
+#ifdef CONFIG_OF_DYNAMIC
+extern int of_platform_register_reconfig_notifier(void);
+#else
+static inline int of_platform_register_reconfig_notifier(void)
+{
+	return 0;
+}
+#endif
+
+
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.7.12

