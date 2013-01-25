Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3AYRqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:46:42 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57909 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab3AYRqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:46:39 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: zsmalloc: remove unused pool name
Date: Fri, 25 Jan 2013 11:46:16 -0600
Message-Id: <1359135978-15119-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012517-5806-0000-0000-00001EC186E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zs_create_pool() currently takes a name argument which is
never used in any useful way.

This patch removes it.

Acked-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Seth Jennnings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zram/zram_drv.c          |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |   11 +++--------
 drivers/staging/zsmalloc/zsmalloc.h      |    2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 836dccf..2086682 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -565,7 +565,7 @@ int zram_init_device(struct zram *zram)
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
-	zram->mem_pool = zs_create_pool("zram", GFP_KERNEL);
+	zram->mem_pool = zs_create_pool(GFP_KERNEL);
 	if (!zram->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		ret = -ENOMEM;
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index f29f170..711a854 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -798,8 +798,7 @@ fail:
 
 /**
  * zs_create_pool - Creates an allocation pool to work from.
- * @name: name of the pool to be created
- * @flags: allocation flags used when growing pool
+ * @flags: allocation flags used to allocate pool metadata
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
@@ -807,14 +806,11 @@ fail:
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
 	pool = kzalloc(ovhd_size, flags);
 	if (!pool)
@@ -836,8 +832,6 @@ struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
 
 	}
 
-	pool->name = name;
-
 	return pool;
 }
 EXPORT_SYMBOL_GPL(zs_create_pool);
@@ -866,6 +860,7 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
  * @size: size of block to allocate
+ * @flags: gfp flags used when expanding the pool
  *
  * On success, handle to the allocated object is returned,
  * otherwise 0.
diff --git a/drivers/staging/zsmalloc/zsmalloc.h b/drivers/staging/zsmalloc/zsmalloc.h
index 907ff03..25a4b4d 100644
--- a/drivers/staging/zsmalloc/zsmalloc.h
+++ b/drivers/staging/zsmalloc/zsmalloc.h
@@ -28,7 +28,7 @@ enum zs_mapmode {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
+struct zs_pool *zs_create_pool(gfp_t flags);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags);
-- 
1.7.9.5

