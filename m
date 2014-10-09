Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaJIMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:18:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47532 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaJIMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:18:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-27-54367cfea7e0
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
Subject: [PATCH v3] drivers: of: add return value to of_reserved_mem_device_init
Date: Thu, 09 Oct 2014 14:18:00 +0200
Message-id: <1412857080-5100-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xK7r/asxCDC402FrMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gd
	eDx+/5rE6HG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP2/8eM3us+/OKyaNvyypGj8+b5AK4
	orhsUlJzMstSi/TtErgyPp1azVxwXaTiz9zdjA2MSwS7GDk5JARMJNatb2aHsMUkLtxbzwZi
	CwksZZRov2DZxcgFZPcxSRycuBCsiE3AUKLrbRdYkYiAm8S/dYfYQIqYBSYzS1xbuIepi5GD
	Q1ggQOLmIwOQGhYBVYntV66C1fMKuEscaTzACrFMTuL/yxVMIDangIdE+49mFojF7hIXlvxk
	ncDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSNh+2cG4+JjVIUYBDkYlHt4H/0xD
	hFgTy4orcw8xSnAwK4nwvskyCxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAWLGm1/ambbNjiJ6q
	7OUe8YdVdgEaE3oyfzSISO0q6l5sF6NqGiBtpDO/aL9rwJ/G6vdPti+5FRnyKkdnz+P4yxW9
	cgxqNiV6RX0HywqbWCYcFu17F/vAV6vwRgmjsOwB35TuWSdO6tu+XnElL1pcv+4ge90mAfFG
	hpZ2hfA7L1cf0t62WkWJpTgj0VCLuag4EQAYArL5OQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    | 7 ++++---
 include/linux/of_reserved_mem.h | 9 ++++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 59fb12e..70780ad 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -243,23 +243,24 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
 
 	np = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!np)
-		return;
+		return -ENODEV;
 
 	rmem = __find_rmem(np);
 	of_node_put(np);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -EINVAL;
 
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

