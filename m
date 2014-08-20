Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaHTN0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:26:48 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51692 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaHTN0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:26:38 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] devres: Improve devm_kasprintf()/kvasprintf() support
Date: Wed, 20 Aug 2014 15:26:35 +0200
Message-Id: <1408541195-20455-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408541195-20455-1-git-send-email-geert+renesas@glider.be>
References: <1408541195-20455-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Add devm_kasprintf()/kvasprintf(), introduced by commit
    75f2a4ead5d5890ada9c2663a70fb58613c0d9f2 ("devres: Add
    devm_kasprintf and devm_kvasprintf API"), to
    Documentation/driver-model/devres.txt,
  - Improve kernel doc: the string is not an existing formatted string,
    but is formatted into the newly-allocated buffer,
  - Add a __printf() annotation to devm_kasprintf(), so the compiler
    will verify the format string argument types.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/driver-model/devres.txt |  2 ++
 drivers/base/devres.c                 | 15 ++++++++-------
 include/linux/device.h                |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 62582434282e..fc93a40f6358 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -291,12 +291,14 @@ MDIO
 MEM
   devm_free_pages()
   devm_get_free_pages()
+  devm_kasprintf()
   devm_kcalloc()
   devm_kfree()
   devm_kmalloc()
   devm_kmalloc_array()
   devm_kmemdup()
   devm_kstrdup()
+  devm_kvasprintf()
   devm_kzalloc()
 
 PCI
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 69d9b0c89a01..c8a53d1e019f 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -817,13 +817,13 @@ char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
 /**
- * devm_kvasprintf - Allocate resource managed space
- *			for the formatted string.
+ * devm_kvasprintf - Allocate resource managed space and format a string
+ *		     into that.
  * @dev: Device to allocate memory for
  * @gfp: the GFP mask used in the devm_kmalloc() call when
  *       allocating memory
- * @fmt: the formatted string to duplicate
- * @ap: the list of tokens to be placed in the formatted string
+ * @fmt: The printf()-style format string
+ * @ap: Arguments for the format string
  * RETURNS:
  * Pointer to allocated string on success, NULL on failure.
  */
@@ -849,12 +849,13 @@ char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
 EXPORT_SYMBOL(devm_kvasprintf);
 
 /**
- * devm_kasprintf - Allocate resource managed space
- *		and copy an existing formatted string into that
+ * devm_kasprintf - Allocate resource managed space and format a string
+ *		    into that.
  * @dev: Device to allocate memory for
  * @gfp: the GFP mask used in the devm_kmalloc() call when
  *       allocating memory
- * @fmt: the string to duplicate
+ * @fmt: The printf()-style format string
+ * @...: Arguments for the format string
  * RETURNS:
  * Pointer to allocated string on success, NULL on failure.
  */
diff --git a/include/linux/device.h b/include/linux/device.h
index 43d183aeb25b..a608e237f0a8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -607,8 +607,8 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
 extern char *devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt,
 			     va_list ap);
-extern char *devm_kasprintf(struct device *dev, gfp_t gfp,
-			    const char *fmt, ...);
+extern __printf(3, 4)
+char *devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...);
 static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
-- 
1.9.1

