Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaEHQiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:38:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaEHQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:38:12 -0400
X-AuditID: cbfee61b-b7f766d00000646c-ba-536bb2f2271d
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: robh+dt@kernel.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] of: Add of_device_destroy_children() function
Date: Thu, 08 May 2014 18:37:49 +0200
Message-id: <1399567069-3174-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t9jAd1Pm7KDDU72C1jMP3KO1eLAnx2M
	FpseX2O1uLxrDptF694j7BaH37SzOrB5bFrVyeZx59oeNo/NS+o9+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK6Pj/CeWgs0iFReP3GNpYJwm2MXIySEhYCLx4stVZghbTOLCvfVsXYxcHEIC
	ixgl3q45wQzhdDBJnGvZClbFJmAo0Xu0jxHEFhHQl5jecYUVpIhZYCKjxKfHS8ASwgJ2Eiv7
	frOD2CwCqhKnJ2wCGsvBwSvgKrGoOwnElBBQkJgzyWYCI/cCRoZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMGB8Ux6B+OqBotDjAIcjEo8vC+mZAcLsSaWFVfmHmKU4GBWEuF9sQwoxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTH9lvWh89PVWz2/
	p++dGPTj1ZRHcgdcJK9PrCl6YREYVbvrmp0cr/nUnDQO2ZIbBSExjgaZ9Reu//7oaHjUwTZh
	dfXi208/9W97lzdb8/Cjdacusq17dW7y/GTfp91NUQ4MV/Z+dW71Vf5rVzDh4J/edob8CSac
	mkmf9VmDTM4djvuw+3XW814lluKMREMt5qLiRADQUESYCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function to unregister devices which
were created by an of_platform_populate() call. The pattern
used here can already be found in multiple drivers. This helper
can now be used instead of repeating similar code in drivers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---

This patch has been tested on ARM only (on Exynos4412 Trats2 board).

 drivers/of/device.c       |   24 ++++++++++++++++++++++++
 include/linux/of_device.h |    3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index dafb973..9303197 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -190,3 +190,27 @@ int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)

 	return 0;
 }
+
+static int __remove_child_device(struct device *dev, void *unused)
+{
+	if (of_match_node(of_default_bus_match_table, dev->of_node))
+		of_device_destroy_children(dev);
+
+	device_unregister(dev);
+	return 0;
+}
+
+/**
+ * of_device_destroy_children - unregister @parent's child devices
+ * @parent: the parent device to start with
+ *
+ * Destroy all child devices of the @parent device, any grandchildren
+ * compatible with values listed in the of_default_bus_match_table will
+ * also be unregistered recursively.  This function can be used to
+ * destroy devices created by an of_platform_populate() call.
+ */
+void of_device_destroy_children(struct device *parent)
+{
+	device_for_each_child(parent, NULL, __remove_child_device);
+}
+EXPORT_SYMBOL(of_device_destroy_children);
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index ef37021..0c41e0b 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -32,6 +32,7 @@ extern void of_dev_put(struct platform_device *dev);
 extern int of_device_add(struct platform_device *pdev);
 extern int of_device_register(struct platform_device *ofdev);
 extern void of_device_unregister(struct platform_device *ofdev);
+extern void of_device_destroy_children(struct device *parent);

 extern ssize_t of_device_get_modalias(struct device *dev,
 					char *str, ssize_t len);
@@ -64,6 +65,8 @@ static inline int of_driver_match_device(struct device *dev,
 static inline void of_device_uevent(struct device *dev,
 			struct kobj_uevent_env *env) { }

+static inline void of_device_destroy_children(struct device *parent) { }
+
 static inline int of_device_get_modalias(struct device *dev,
 				   char *str, ssize_t len)
 {
--
1.7.9.5

