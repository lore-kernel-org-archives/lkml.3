Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbaCEUAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:00:39 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49926 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbaCEUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:00:38 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: return error-valued pointer from zcomp_create()
Date: Wed,  5 Mar 2014 22:56:55 +0300
Message-Id: <1394049415-11759-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.382.g7f3562c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning just NULL, return ERR_PTR from zcomp_create()
if compressing backend creation has failed. ERR_PTR(-EINVAL) for
unsupported compression algorithm request, ERR_PTR(-ENOMEM) for
allocation (zcomp or compression stream) error.

Perform IS_ERR() check of returned from zcomp_create() value in
disksize_store() and set return code to PTR_ERR().

Change suggested by Jerome Marchand.

Reported-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 13 +++++++------
 drivers/block/zram/zram_drv.c |  8 ++++----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index d591903..92a83df 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -319,9 +319,10 @@ void zcomp_destroy(struct zcomp *comp)
 
 /*
  * search available compressors for requested algorithm.
- * allocate new zcomp and initialize it. return NULL
- * if requested algorithm is not supported or in case
- * of init error
+ * allocate new zcomp and initialize it. return compressing
+ * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
+ * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
+ * case of allocation error.
  */
 struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
@@ -330,11 +331,11 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 
 	backend = find_backend(compress);
 	if (!backend)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	comp->backend = backend;
 	if (max_strm > 1)
@@ -343,7 +344,7 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 		zcomp_strm_single_create(comp);
 	if (!comp->stream) {
 		kfree(comp);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	return comp;
 }
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e4d536b..9585957 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -583,7 +583,7 @@ static ssize_t disksize_store(struct device *dev,
 	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err = -EINVAL;
+	int err = -EBUSY;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -595,9 +595,10 @@ static ssize_t disksize_store(struct device *dev,
 		return -ENOMEM;
 
 	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!comp) {
+	if (IS_ERR(comp)) {
 		pr_info("Cannot initialise %s compressing backend\n",
 				zram->compressor);
+		err = PTR_ERR(comp);
 		goto out_cleanup;
 	}
 
@@ -605,7 +606,6 @@ static ssize_t disksize_store(struct device *dev,
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		err = -EBUSY;
 		goto out_cleanup;
 	}
 
@@ -618,7 +618,7 @@ static ssize_t disksize_store(struct device *dev,
 	return len;
 
 out_cleanup:
-	if (comp)
+	if (!IS_ERR(comp))
 		zcomp_destroy(comp);
 	zram_meta_free(meta);
 	return err;
-- 
1.9.0.382.g7f3562c

