Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaDOSR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:17:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:59594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbaDOSRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,865,1389772800"; 
   d="scan'208";a="493683470"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v6 1/6] devres: introduce API "devm_kmemdup
Date: Tue, 15 Apr 2014 11:21:08 -0700
Message-Id: <1397586073-31507-2-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1397586073-31507-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397586073-31507-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce devm_kmemdup, which uses resource managed kmalloc.
There are several request from maintainers to add this instead
of using kmemdup.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 Documentation/driver-model/devres.txt |  1 +
 drivers/base/devres.c                 | 21 +++++++++++++++++++++
 include/linux/device.h                |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 4f7897e..4999518 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -236,6 +236,7 @@ certainly invest a bit more effort into libata core layer).
 MEM
   devm_kzalloc()
   devm_kfree()
+  devm_kmemdup()
 
 IIO
   devm_iio_device_alloc()
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index db4e264..d0914cb 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -831,3 +831,24 @@ void devm_kfree(struct device *dev, void *p)
 	WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_kfree);
+
+/**
+ * devm_kmemdup - Resource-managed kmemdup
+ * @dev: Device this memory belongs to
+ * @src: Memory region to duplicate
+ * @len: Memory region length
+ * @gfp: GFP mask to use
+ *
+ * Duplicate region of a memory using resource managed kmalloc
+ */
+void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
+{
+	void *p;
+
+	p = devm_kmalloc(dev, len, gfp);
+	if (p)
+		memcpy(p, src, len);
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(devm_kmemdup);
diff --git a/include/linux/device.h b/include/linux/device.h
index 233bbbe..4a37849 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -629,6 +629,8 @@ static inline void *devm_kcalloc(struct device *dev,
 }
 extern void devm_kfree(struct device *dev, void *p);
 extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
+extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
+			  gfp_t gfp);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
 void __iomem *devm_request_and_ioremap(struct device *dev,
-- 
1.7.11.7

