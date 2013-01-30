Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3A3PhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:37:12 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42687 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3A3PhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:37:09 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zsmalloc: remove unused pool name
Date: Wed, 30 Jan 2013 09:36:52 -0600
Message-Id: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <20130130041630.GA18809@kroah.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013015-9360-0000-0000-00000FE84AD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zs_create_pool() currently takes a name argument which is
never used in any useful way.

This patch removes it.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
Greg, this patch is 2/4 that didn't apply before. It is rebased
on your staging tree as of this morning.

 drivers/staging/zram/zram_drv.c          |  2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c | 10 ++--------
 drivers/staging/zsmalloc/zsmalloc.h      |  2 +-
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 77a3f0d..941b7c6 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -575,7 +575,7 @@ int zram_init_device(struct zram *zram)
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
-	zram->mem_pool = zs_create_pool("zram", GFP_NOIO | __GFP_HIGHMEM);
+	zram->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
 	if (!zram->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		ret = -ENOMEM;
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 4666609..06f73a9 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -207,7 +207,6 @@ struct zs_pool {
 	struct size_class size_class[ZS_SIZE_CLASSES];
 
 	gfp_t flags;	/* allocation flags used when growing pool */
-	const char *name;
 };
 
 /*
@@ -798,8 +797,7 @@ fail:
 
 /**
  * zs_create_pool - Creates an allocation pool to work from.
- * @name: name of the pool to be created
- * @flags: allocation flags used when growing pool
+ * @flags: allocation flags used to allocate pool metadata
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
@@ -807,14 +805,11 @@ fail:
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
+struct zs_pool *zs_create_pool(gfp_t flags)
 {
 	int i, ovhd_size;
 	struct zs_pool *pool;
 
-	if (!name)
-		return NULL;
-
 	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
 	pool = kzalloc(ovhd_size, GFP_KERNEL);
 	if (!pool)
@@ -837,7 +832,6 @@ struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
 	}
 
 	pool->flags = flags;
-	pool->name = name;
 
 	return pool;
 }
diff --git a/drivers/staging/zsmalloc/zsmalloc.h b/drivers/staging/zsmalloc/zsmalloc.h
index de2e8bf..46dbd05 100644
--- a/drivers/staging/zsmalloc/zsmalloc.h
+++ b/drivers/staging/zsmalloc/zsmalloc.h
@@ -28,7 +28,7 @@ enum zs_mapmode {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
+struct zs_pool *zs_create_pool(gfp_t flags);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size);
-- 
1.8.1.1

