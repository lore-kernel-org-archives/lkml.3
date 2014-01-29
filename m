Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaA2EDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:03:43 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58006 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaA2EDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:03:06 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, broonie@kernel.org, lgirdwood@gmail.com,
        badarkhe.manish@gmail.com
Subject: [PATCH V3 1/2] devres: introduce API "devm_kstrdup"
Date: Wed, 29 Jan 2014 09:33:00 +0530
Message-Id: <1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces "devm_kstrdup" API so that the
device's driver can allocate memory and copy string.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 545c4de... 6e88a3d... M	drivers/base/devres.c
:100644 100644 952b010... 8fee649... M	include/linux/device.h
 drivers/base/devres.c  |   26 ++++++++++++++++++++++++++
 include/linux/device.h |    2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 545c4de..6e88a3d 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -791,6 +791,32 @@ void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kmalloc);
 
 /**
+ * devm_kstrdup - Allocate resource managed space and
+ *                and copy an existing string
+ * @dev: Device to allocate memory for
+ * @s: the string to duplicate
+ * @size: Allocation size
+ * @gfp: the GFP mask used in the devm_kzalloc() call when
+ *       allocating memory
+ * RETURNS:
+ * Pointer to allocated string on success, NULL on failure.
+ */
+char *devm_kstrdup(struct device *dev,
+		   const char *s, size_t size, gfp_t gfp)
+{
+	char *buf;
+
+	if (!s)
+		return NULL;
+
+	buf = devm_kzalloc(dev, size, gfp);
+	if (buf)
+		memcpy(buf, s, size);
+	return buf;
+}
+EXPORT_SYMBOL_GPL(devm_kstrdup);
+
+/**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..8fee649 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -626,6 +626,8 @@ static inline void *devm_kcalloc(struct device *dev,
 	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
 }
 extern void devm_kfree(struct device *dev, void *p);
+extern char *devm_kstrdup(struct device *dev, const char *s, size_t size,
+			gfp_t gfp);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
 void __iomem *devm_request_and_ioremap(struct device *dev,
-- 
1.7.10.4

