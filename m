Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaIKLXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:23:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaIKLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:22:51 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3c-54118608e664
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/3] drivers: of: add return value to
 of_reserved_mem_device_init
Date: Thu, 11 Sep 2014 13:22:39 +0200
Message-id: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7ocbYIhBj/OyVvMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gd
	eDx+/5rE6HG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP2/8eM3us+/OKyaNvyypGj8+b5AK4
	orhsUlJzMstSi/TtErgyrh+9w1iwWLii69dhlgbGRQJdjJwcEgImEpcaPrFC2GISF+6tZ+ti
	5OIQEljKKPH85iEop49J4tujD+wgVWwChhJdb7vYQGwRATeJf+sgipgFJjNLXFu4hwkkISwQ
	JrHq2B0wm0VAVWL11wssXYwcHLwC7hJXT0pDbJOT+P9yBVgJp4CHxORvk8DmCwGVXNy9gW0C
	I+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGB+2UH4+JjVocYBTgYlXh4Cy/yhwix
	JpYVV+YeYpTgYFYS4S0tFAwR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLjsZM9F3SYm6ct1OTH/
	7k+/EW/btn1b6vK82lxj9t1rpC+zFLQ+LVAoTL6rtGei2v9tL7yaTpg03bDVdQuO7nN8orn3
	4Ip5Am3qEWnBWzcGzd1hMzWoYcfR6KiOtmPHsgqr5yz7Kq/p+ix/ffTFs4occzdte3RGvuj0
	KfEjS9bOMLlue98wXkmJpTgj0VCLuag4EQDVQPmiOgIAAA==
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
index 59fb12e..7e7de03 100644
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
index 5b5efae..ad2f670 100644
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

