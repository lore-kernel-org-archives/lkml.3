Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaKUBfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:35:40 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33066 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaKUBfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:35:33 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 6/8] of/platform: Add OF_DYNAMIC notifier handler
Date: Fri, 21 Nov 2014 01:35:13 +0000
Message-Id: <1416533715-9758-7-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
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
 drivers/of/platform.c       | 78 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_platform.h | 10 ++++++
 3 files changed, 89 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b2afc29403f9..c4c02c0e42b6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1006,6 +1006,7 @@ int __init platform_bus_init(void)
 	error =  bus_register(&platform_bus_type);
 	if (error)
 		device_unregister(&platform_bus);
+	WARN_ON(of_platform_register_reconfig_notifier() != 0);
 	return error;
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 656cccf0e680..b6d9a406a75d 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -550,4 +550,82 @@ void of_platform_depopulate(struct device *parent)
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
+		if (!of_node_check_flag(dn->parent, OF_POPULATED_BUS))
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
index c2b0627a2317..01fe5d6345fb 100644
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
1.9.1

