Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbaHZMP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:15:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33892 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaHZMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:54 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7c-53fc79fe7225
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/7] drivers: of: add return value to
 of_reserved_mem_device_init
Date: Tue, 26 Aug 2014 14:09:42 +0200
Message-id: <1409054988-32758-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7r/Kv8EGzSf1bD4O+kYu8WBPzsY
	LVZ2N7NZ7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaLy7vmsFn0bNjKajHj/D4mi7VH7rJb
	LDjewmqxfsZrFgc+j9+/JjF6XO7rZfLoenuFyePOtT1sHpuX1Hvc/veY2WPdn1dMHn1bVjF6
	fN4kF8AZxWWTkpqTWZZapG+XwJUxs28Hc8F24Ypnc5exNjBuE+hi5OSQEDCRmHHxEiuELSZx
	4d56ti5GLg4hgaWMEhcbpjJDOH1MEn/W3mcCqWITMJToetvFBmKLCGRL/Pg2mQXEZhZYyiwx
	b5YUiC0sECxx9MokZhCbRUBV4m7bdbB6XgEPiRUvnjFCbJOT+P9yBdBMDg5OAU+Jc1OqQcJC
	QCUbp79nmcDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSAB/2cG4+JjVIUYBDkYl
	Ht4PJb+DhVgTy4orcw8xSnAwK4nw/kj6EyzEm5JYWZValB9fVJqTWnyIkYmDU6qBcfXT1l7P
	zNu3G3Wj/z+sm/vDXTHmLE/aCZH1rFN1d762q0rque68nMXy1Kljh9XeP5uy9tu38t0RbnuT
	Fx2fGrDgeMAdxcSAva9vr+4OSs2LUDLrCpmjcML6vsNCEXYvRU/JPd8uChx2jpwZu3/SvMgy
	p58MbxN+PO2q5tmf4ftyv13BXA+2D0osxRmJhlrMRcWJAPm1ivE+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    | 3 ++-
 include/linux/of_reserved_mem.h | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 59fb12e84e6b..7e7de03585f9 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -243,7 +243,7 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
@@ -260,6 +260,7 @@ void of_reserved_mem_device_init(struct device *dev)
 
 	rmem->ops->device_init(rmem, dev);
 	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	return 0;
 }
 
 /**
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 5b5efae09135..ad2f67054372 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -16,7 +16,7 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
-	void	(*device_init)(struct reserved_mem *rmem,
+	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
 	void	(*device_release)(struct reserved_mem *rmem,
 				  struct device *dev);
@@ -28,14 +28,17 @@ typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
 	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
 
 #ifdef CONFIG_OF_RESERVED_MEM
-void of_reserved_mem_device_init(struct device *dev);
+int of_reserved_mem_device_init(struct device *dev);
 void of_reserved_mem_device_release(struct device *dev);
 
 void fdt_init_reserved_mem(void);
 void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
 			       phys_addr_t base, phys_addr_t size);
 #else
-static inline void of_reserved_mem_device_init(struct device *dev) { }
+static inline int of_reserved_mem_device_init(struct device *dev)
+{
+	return -ENOSYS;
+}
 static inline void of_reserved_mem_device_release(struct device *pdev) { }
 
 static inline void fdt_init_reserved_mem(void) { }
-- 
1.9.2

