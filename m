Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaKXWg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:36:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64473 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaKXWeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:13 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 08/14] of/reconfig: Add OF_DYNAMIC notifier for platform_bus_type
Date: Mon, 24 Nov 2014 22:33:36 +0000
Message-Id: <1416868422-22103-9-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Add OF notifier handler needed for creating/destroying platform devices
according to dynamic runtime changes in the DT live tree.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/base/platform.c     |  1 +
 drivers/of/platform.c       | 55 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_platform.h |  6 +++++
 3 files changed, 62 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b2afc29403f9..233ececd15a3 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1006,6 +1006,7 @@ int __init platform_bus_init(void)
 	error =  bus_register(&platform_bus_type);
 	if (error)
 		device_unregister(&platform_bus);
+	of_platform_register_reconfig_notifier();
 	return error;
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 656cccf0e680..cd87a36495be 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -550,4 +550,59 @@ void of_platform_depopulate(struct device *parent)
 }
 EXPORT_SYMBOL_GPL(of_platform_depopulate);
 
+#ifdef CONFIG_OF_DYNAMIC
+static int of_platform_notify(struct notifier_block *nb,
+				unsigned long action, void *arg)
+{
+	struct of_reconfig_data *rd = arg;
+	struct platform_device *pdev_parent, *pdev;
+	bool children_left;
+
+	switch (of_reconfig_get_state_change(action, rd)) {
+	case OF_RECONFIG_CHANGE_ADD:
+		/* verify that the parent is a bus */
+		if (!of_node_check_flag(rd->dn->parent, OF_POPULATED_BUS))
+			return NOTIFY_OK;	/* not for us */
+
+		/* pdev_parent may be NULL when no bus platform device */
+		pdev_parent = of_find_device_by_node(rd->dn->parent);
+		pdev = of_platform_device_create(rd->dn, NULL,
+				pdev_parent ? &pdev_parent->dev : NULL);
+		of_dev_put(pdev_parent);
+
+		if (pdev == NULL) {
+			pr_err("%s: failed to create for '%s'\n",
+					__func__, rd->dn->full_name);
+			/* of_platform_device_create tosses the error code */
+			return notifier_from_errno(-EINVAL);
+		}
+		break;
+
+	case OF_RECONFIG_CHANGE_REMOVE:
+		/* find our device by node */
+		pdev = of_find_device_by_node(rd->dn);
+		if (pdev == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		of_platform_device_destroy(&pdev->dev, &children_left);
+
+		/* and put the reference of the find */
+		of_dev_put(pdev);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block platform_of_notifier = {
+	.notifier_call = of_platform_notify,
+};
+
+void of_platform_register_reconfig_notifier(void)
+{
+	WARN_ON(of_reconfig_notifier_register(&platform_of_notifier));
+}
+#endif /* CONFIG_OF_DYNAMIC */
+
 #endif /* CONFIG_OF_ADDRESS */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index c2b0627a2317..8a860f096c35 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -84,4 +84,10 @@ static inline int of_platform_populate(struct device_node *root,
 static inline void of_platform_depopulate(struct device *parent) { }
 #endif
 
+#ifdef CONFIG_OF_DYNAMIC
+extern void of_platform_register_reconfig_notifier(void);
+#else
+static inline void of_platform_register_reconfig_notifier(void) { }
+#endif
+
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.9.1

