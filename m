Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaBYLi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:38:27 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49522 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaBYLiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:38:21 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv7 6/7] zram: add set_max_streams knob
Date: Tue, 25 Feb 2014 14:34:32 +0300
Message-Id: <1393328073-12313-7-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to change max_comp_streams on initialised zcomp.

Introduce zcomp set_max_streams() knob, zcomp_strm_multi_set_max_streams()
and zcomp_strm_single_set_max_streams() callbacks to change streams limit
for zcomp_strm_multi and zcomp_strm_single, accordingly. set_max_streams
for single steam zcomp does nothing.

If user has lowered the limit, then zcomp_strm_multi_set_max_streams()
attempts to immediately free extra streams (as much as it can, depending
on idle streams availability).

Note, this patch does not allow to change stream 'policy' from single to
multi stream (or vice versa) on already initialised compression backend,
this will be introduced later.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h    |  3 +++
 drivers/block/zram/zram_drv.c |  7 ++-----
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 1bcb70e..adfbfee 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -135,6 +135,32 @@ static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
 	wake_up(&zs->strm_wait);
 }
 
+/* change max_strm limit */
+static void zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+
+	/* single stream handled as a special case by zcomp_strm_single */
+	if (num_strm < 2)
+		return;
+
+	spin_lock(&zs->strm_lock);
+	zs->max_strm = num_strm;
+	/*
+	 * if user has lowered the limit and there are idle streams,
+	 * immediately free as much streams (and memory) as we can.
+	 */
+	while (atomic_read(&zs->avail_strm) > num_strm &&
+			!list_empty(&zs->idle_strm)) {
+		struct zcomp_strm *zstrm = list_entry(zs->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+		atomic_dec(&zs->avail_strm);
+	}
+	spin_unlock(&zs->strm_lock);
+}
+
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
@@ -158,6 +184,7 @@ static int zcomp_strm_multi_create(struct zcomp *comp, int num_strm)
 	comp->destroy = zcomp_strm_multi_destroy;
 	comp->strm_get = zcomp_strm_multi_get;
 	comp->strm_put = zcomp_strm_multi_put;
+	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
 	comp->stream = zs;
 	if (!zs)
@@ -193,6 +220,12 @@ static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
 	mutex_unlock(&zs->strm_lock);
 }
 
+static void zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	/* zcomp_strm_single support only max_comp_streams == 1 */
+	return;
+}
+
 static void zcomp_strm_single_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -207,6 +240,7 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	comp->destroy = zcomp_strm_single_destroy;
 	comp->strm_get = zcomp_strm_single_get;
 	comp->strm_put = zcomp_strm_single_put;
+	comp->set_max_streams = zcomp_strm_single_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
 	comp->stream = zs;
 	if (!zs)
@@ -221,6 +255,11 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	return 0;
 }
 
+void zcomp_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	comp->set_max_streams(comp, num_strm);
+}
+
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
 {
 	return comp->strm_get(comp);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 5514509..9645e16 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -39,6 +39,7 @@ struct zcomp {
 
 	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
 	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	void (*set_max_streams)(struct zcomp *comp, int num_strm);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -53,4 +54,6 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
+
+void zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 42b9c7f..34a0921 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -132,12 +132,9 @@ static ssize_t max_comp_streams_store(struct device *dev,
 	if (num < 1)
 		return -EINVAL;
 	down_write(&zram->init_lock);
-	if (init_done(zram)) {
-		up_write(&zram->init_lock);
-		pr_info("Can't set max_comp_streams for initialized device\n");
-		return -EBUSY;
-	}
 	zram->max_comp_streams = num;
+	if (init_done(zram))
+		zcomp_set_max_streams(zram->comp, num);
 	up_write(&zram->init_lock);
 	return len;
 }
-- 
1.9.0.291.g027825b

