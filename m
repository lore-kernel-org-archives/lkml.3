Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaGBKHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:07:37 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40900 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751044AbaGBKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:07:36 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH V2 1/3] base: Add block copy func. for managed devices
Date: Wed,  2 Jul 2014 11:05:49 +0100
Message-Id: <1404295551-13470-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
References: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function devm_kmemdup() which is exactly analogous to the
non-managed device function kmemdup().

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/base/devres.c  |   25 +++++++++++++++++++++++++
 include/linux/device.h |    2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index db4e264..77a6ce7 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -817,6 +817,31 @@ char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
 /**
+ * devm_kmemdup - Allocate resource managed space and
+ *                copy existing data into that.
+ * @dev:	Device to allocate memory for
+ * @s:		The memory block to duplicate
+ * @gfp:	The GFP mask used in the devm_kmalloc() call when
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

