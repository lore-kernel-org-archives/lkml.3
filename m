Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaFJOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:43:53 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40167 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751964AbaFJOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:43:04 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk, heiko@sntech.de, rob.jones@codethink.co.uk
Subject: [PATCH 2/3] drivers/base: devres.c: Add block copy func. for managed devices
Date: Tue, 10 Jun 2014 15:41:47 +0100
Message-Id: <1402411308-14182-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk>
References: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function devm_kmemdup().
Rationalise with devm_kstrdup() to avoid code duplication.

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/base/devres.c  |   42 ++++++++++++++++++++++++++++++++++--------
 include/linux/device.h |    2 ++
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index db4e264..978bbe2 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -791,6 +791,20 @@ void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kmalloc);
 
 /**
+ * static function to avoid code duplication when duplicating buffers
+ */
+static void *devm_kmemdup_nochecks(struct device *dev, const void *s,
+				    size_t size, gfp_t gfp)
+{
+	void *buf;
+
+	buf = devm_kmalloc(dev, size, gfp);
+	if (buf)
+		memcpy(buf, s, size);
+	return buf;
+}
+
+/**
  * devm_kstrdup - Allocate resource managed space and
  *                copy an existing string into that.
  * @dev: Device to allocate memory for
@@ -802,21 +816,33 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
  */
 char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 {
-	size_t size;
-	char *buf;
-
 	if (!s)
 		return NULL;
 
-	size = strlen(s) + 1;
-	buf = devm_kmalloc(dev, size, gfp);
-	if (buf)
-		memcpy(buf, s, size);
-	return buf;
+	return devm_kmemdup_nochecks(dev, s, (strlen(s)+1), gfp);
 }
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
 /**
+ * devm_kmemdup - Allocate resource managed space and
+ *                copy existing data into that.
+ * @dev: Device to allocate memory for
+ * @s: the memory block to duplicate
+ * @gfp: the GFP mask used in the devm_kmalloc() call when
+ *       allocating memory
+ * RETURNS:
+ * Pointer to allocated string on success, NULL on failure.
+ */
+void *devm_kmemdup(struct device *dev, const void *s, size_t size, gfp_t gfp)
+{
+	if (!s || (size == 0))
+		return NULL;
+
+	return devm_kmemdup_nochecks(dev, s, size, gfp);
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

