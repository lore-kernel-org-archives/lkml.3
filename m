Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbaFSPqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:46:40 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:56706 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757652AbaFSPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:46:29 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH 2/4] drivers/base: devres.c: Add block copy func. for managed devices
Date: Thu, 19 Jun 2014 16:46:03 +0100
Message-Id: <1403192765-3258-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function devm_kmemdup().

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/base/devres.c  |   27 ++++++++++++++++++++++++++-
 include/linux/device.h |    2 ++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index db4e264..9d0f64c 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -793,7 +793,7 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
 /**
  * devm_kstrdup - Allocate resource managed space and
  *                copy an existing string into that.
- * @dev: Device to allocate memory for
+ * @dev:Device to allocate memory for
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the devm_kmalloc() call when
  *       allocating memory
@@ -817,6 +817,31 @@ char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
 /**
+ * devm_kmemdup - Allocate resource managed space and
+ *                copy existing data into that.
+ * @dev:	Device to allocate memory for
+ * @s: 		The memory block to duplicate
+ * @gfp: 	The GFP mask used in the devm_kmalloc() call when
+ *		allocating memory
+ * RETURNS:
+ * Pointer to allocated string on success, NULL on failure.
+ */
+void *devm_kmemdup(struct device *dev, const void *s, size_t size, gfp_t gfp)
+{
+	void *buf;
+
+	if (!s || (size == 0))
+		return NULL;
+
+	buf = devm_kmalloc(dev, size, gfp);
+	if (buf)
+		memcpy(buf, s, size);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(devm_kmemdup);
+
+/**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
diff --git a/include/linux/device.h b/include/linux/device.h
index d1d1c05..7ace116 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -623,6 +623,8 @@ static inline void *devm_kcalloc(struct device *dev,
 }
 extern void devm_kfree(struct device *dev, void *p);
 extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
+extern void *devm_kmemdup(struct device *dev,
+			  const void *s, size_t size, gfp_t gfp);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
 void __iomem *devm_request_and_ioremap(struct device *dev,
-- 
1.7.10.4

