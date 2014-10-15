Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJOUkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOUkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:40:00 -0400
Date: Wed, 15 Oct 2014 13:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] base: dma-coherent: fix device_init initialization
Message-Id: <20141015133959.dd2814e196eaa3fc3bcb7b93@linux-foundation.org>
In-Reply-To: <1413405140-17777-1-git-send-email-balbi@ti.com>
References: <1413405140-17777-1-git-send-email-balbi@ti.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 15:32:20 -0500 Felipe Balbi <balbi@ti.com> wrote:

> commit 7bfa5ab (drivers: dma-coherent: add initialization
> from device tree) added support for dma coherent pool for
> DeviceTree. Unfortunately that commit introduced a new
> build warning because of a wrong type on the definition
> of ->device_init(). This patch fixes it.

Guys, when fixing a warning please always always always quote that
warning in the changelog.

Presumably your patch addresses the same mystery warning as did Marek's.


From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: drivers: of: add return value to of_reserved_mem_device_init()

Driver calling of_reserved_mem_device_init() might be interested if the
initialization has been successful or not, so add support for returning
error code.

This fixes a build warining caused by 7bfa5ab6fa1b ("drivers:
dma-coherent: add initialization from device tree"), which has been merged
without this change and without fixing function return value.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c   |    3 ++-
 drivers/of/of_reserved_mem.c    |   14 +++++++++-----
 include/linux/of_reserved_mem.h |    9 ++++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff -puN drivers/base/dma-contiguous.c~drivers-of-add-return-value-to-of_reserved_mem_device_init drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/drivers/base/dma-contiguous.c
@@ -223,9 +223,10 @@ bool dma_release_from_contiguous(struct
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	dev_set_cma_area(dev, rmem->priv);
+	return 0;
 }
 
 static void rmem_cma_device_release(struct reserved_mem *rmem,
diff -puN drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init drivers/of/of_reserved_mem.c
--- a/drivers/of/of_reserved_mem.c~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/drivers/of/of_reserved_mem.c
@@ -243,23 +243,27 @@ static inline struct reserved_mem *__fin
  * This function assign memory region pointed by "memory-region" device tree
  * property to the given device.
  */
-void of_reserved_mem_device_init(struct device *dev)
+int of_reserved_mem_device_init(struct device *dev)
 {
 	struct reserved_mem *rmem;
 	struct device_node *np;
+	int ret;
 
 	np = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!np)
-		return;
+		return -ENODEV;
 
 	rmem = __find_rmem(np);
 	of_node_put(np);
 
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -EINVAL;
 
-	rmem->ops->device_init(rmem, dev);
-	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+	ret = rmem->ops->device_init(rmem, dev);
+	if (ret == 0)
+		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
+
+	return ret;
 }
 
 /**
diff -puN include/linux/of_reserved_mem.h~drivers-of-add-return-value-to-of_reserved_mem_device_init include/linux/of_reserved_mem.h
--- a/include/linux/of_reserved_mem.h~drivers-of-add-return-value-to-of_reserved_mem_device_init
+++ a/include/linux/of_reserved_mem.h
@@ -16,7 +16,7 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
-	void	(*device_init)(struct reserved_mem *rmem,
+	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
 	void	(*device_release)(struct reserved_mem *rmem,
 				  struct device *dev);
@@ -28,14 +28,17 @@ typedef int (*reservedmem_of_init_fn)(st
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
_


