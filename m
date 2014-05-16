Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaEPIiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:38:21 -0400
Received: from ar-005-i193.relay.mailchannels.net ([162.253.144.75]:9279 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754353AbaEPIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:38:19 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
X-MC-Relay: Neutral
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 1/5] devres: Add devm_get_free_pages API
Date: Fri, 16 May 2014 11:26:35 +0300
Message-Id: <1400228799-8832-2-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_get_free_pages() and devm_free_pages() are the managed counterparts
for __get_free_pages() and free_pages().

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 +
 drivers/base/devres.c                 |   76 +++++++++++++++++++++++++++++++++
 include/linux/device.h                |    4 ++
 3 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 4999518..e1a2707 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -237,6 +237,8 @@ MEM
   devm_kzalloc()
   devm_kfree()
   devm_kmemdup()
+  devm_get_free_pages()
+  devm_free_pages()
 
 IIO
   devm_iio_device_alloc()
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index d0914cb..5230294 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -852,3 +852,79 @@ void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
 	return p;
 }
 EXPORT_SYMBOL_GPL(devm_kmemdup);
+
+struct pages_devres {
+	unsigned long addr;
+	unsigned int order;
+};
+
+static int devm_pages_match(struct device *dev, void *res, void *p)
+{
+	struct pages_devres *devres = res;
+	struct pages_devres *target = p;
+
+	return devres->addr == target->addr;
+}
+
+static void devm_pages_release(struct device *dev, void *res)
+{
+	struct pages_devres *devres = res;
+
+	free_pages(devres->addr, devres->order);
+}
+
+/**
+ * devm_get_free_pages - Resource-managed __get_free_pages
+ * @dev: Device to allocate memory for
+ * @gfp_mask: Allocation gfp flags
+ * @order: Allocation size is (1 << order) pages
+ *
+ * Managed get_free_pages.  Memory allocated with this function is
+ * automatically freed on driver detach.
+ *
+ * RETURNS:
+ * Address of allocated memory on success, 0 on failure.
+ */
+
+unsigned long devm_get_free_pages(struct device *dev,
+				  gfp_t gfp_mask, unsigned int order)
+{
+	struct pages_devres *devres;
+	unsigned long addr;
+
+	addr = __get_free_pages(gfp_mask, order);
+
+	if (unlikely(!addr))
+		return 0;
+
+	devres = devres_alloc(devm_pages_release,
+			      sizeof(struct pages_devres), GFP_KERNEL);
+	if (unlikely(!devres)) {
+		free_pages(addr, order);
+		return 0;
+	}
+
+	devres->addr = addr;
+	devres->order = order;
+
+	devres_add(dev, devres);
+	return addr;
+}
+EXPORT_SYMBOL_GPL(devm_get_free_pages);
+
+/**
+ * devm_free_pages - Resource-managed free_pages
+ * @dev: Device this memory belongs to
+ * @addr: Memory to free
+ *
+ * Free memory allocated with devm_get_free_pages(). Unlike free_pages,
+ * there is no need to supply the @order.
+ */
+void devm_free_pages(struct device *dev, unsigned long addr)
+{
+	struct pages_devres devres = { .addr = addr };
+
+	WARN_ON(devres_release(dev, devm_pages_release, devm_pages_match,
+			       &devres));
+}
+EXPORT_SYMBOL_GPL(devm_free_pages);
diff --git a/include/linux/device.h b/include/linux/device.h
index ab87158..3dc69a2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -626,6 +626,10 @@ extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
 extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
 			  gfp_t gfp);
 
+extern unsigned long devm_get_free_pages(struct device *dev,
+					 gfp_t gfp_mask, unsigned int order);
+extern void devm_free_pages(struct device *dev, unsigned long addr);
+
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
 void __iomem *devm_request_and_ioremap(struct device *dev,
 			struct resource *res);
-- 
1.7.2.3

