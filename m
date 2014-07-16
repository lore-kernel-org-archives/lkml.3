Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaGPU6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:58:06 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49165 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaGPU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:58:01 -0400
Date: Thu, 17 Jul 2014 02:27:52 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] devres: Add devm_kasprintf and devm_kvasprintf API
Message-ID: <20140716205752.GA3109@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kasprintf() and devm_kvasprintf() are the managed counterparts
for kasprintf() and kvasprintf().

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/base/devres.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  4 ++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 5230294..69d9b0c 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -817,6 +817,61 @@ char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
 /**
+ * devm_kvasprintf - Allocate resource managed space
+ *			for the formatted string.
+ * @dev: Device to allocate memory for
+ * @gfp: the GFP mask used in the devm_kmalloc() call when
+ *       allocating memory
+ * @fmt: the formatted string to duplicate
+ * @ap: the list of tokens to be placed in the formatted string
+ * RETURNS:
+ * Pointer to allocated string on success, NULL on failure.
+ */
+char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
+		      va_list ap)
+{
+	unsigned int len;
+	char *p;
+	va_list aq;
+
+	va_copy(aq, ap);
+	len = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
+
+	p = devm_kmalloc(dev, len+1, gfp);
+	if (!p)
+		return NULL;
+
+	vsnprintf(p, len+1, fmt, ap);
+
+	return p;
+}
+EXPORT_SYMBOL(devm_kvasprintf);
+
+/**
+ * devm_kasprintf - Allocate resource managed space
+ *		and copy an existing formatted string into that
+ * @dev: Device to allocate memory for
+ * @gfp: the GFP mask used in the devm_kmalloc() call when
+ *       allocating memory
+ * @fmt: the string to duplicate
+ * RETURNS:
+ * Pointer to allocated string on success, NULL on failure.
+ */
+char *devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = devm_kvasprintf(dev, gfp, fmt, ap);
+	va_end(ap);
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(devm_kasprintf);
+
+/**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
diff --git a/include/linux/device.h b/include/linux/device.h
index 28113885..43d183a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -605,6 +605,10 @@ extern int devres_release_group(struct device *dev, void *id);
 
 /* managed devm_k.alloc/kfree for device drivers */
 extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
+extern char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
+			     va_list ap);
+extern char *devm_kasprintf(struct device *dev, gfp_t gfp,
+			    const char *fmt, ...);
 static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
-- 
1.9.1

