Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBZMb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:31:58 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49502 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaBZMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:31:54 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv8 5/6] zram: add set_max_streams knob
Date: Wed, 26 Feb 2014 15:27:58 +0300
Message-Id: <1393417679-13657-6-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
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
multi stream (or vice versa) on already initialised compression backend.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 35 +++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h    |  3 +++
 drivers/block/zram/zram_drv.c |  7 +++----
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 0b790ac..37d72d9 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -137,6 +137,28 @@ static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
 	zcomp_strm_free(comp, zstrm);
 }
 
+/* change max_strm limit */
+static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+
+	spin_lock(&zs->strm_lock);
+	zs->max_strm = num_strm;
+	/*
+	 * if user has lowered the limit and there are idle streams,
+	 * immediately free as much streams (and memory) as we can.
+	 */
+	while (zs->avail_strm > num_strm && !list_empty(&zs->idle_strm)) {
+		struct zcomp_strm *zstrm = list_entry(zs->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+		zs->avail_strm--;
+	}
+	spin_unlock(&zs->strm_lock);
+	return 0;
+}
+
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
@@ -159,6 +181,7 @@ static int zcomp_strm_multi_create(struct zcomp *comp, int max_strm)
 	comp->destroy = zcomp_strm_multi_destroy;
 	comp->strm_get = zcomp_strm_multi_get;
 	comp->strm_put = zcomp_strm_multi_put;
+	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -192,6 +215,12 @@ static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
 	mutex_unlock(&zs->strm_lock);
 }
 
+static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	/* zcomp_strm_single support only max_comp_streams == 1 */
+	return -ENOTSUPP;
+}
+
 static void zcomp_strm_single_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -206,6 +235,7 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	comp->destroy = zcomp_strm_single_destroy;
 	comp->strm_get = zcomp_strm_single_get;
 	comp->strm_put = zcomp_strm_single_put;
+	comp->set_max_streams = zcomp_strm_single_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -220,6 +250,11 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	return 0;
 }
 
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	return comp->set_max_streams(comp, num_strm);
+}
+
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
 {
 	return comp->strm_get(comp);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 9d77cbf..a2a9dc1 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -39,6 +39,7 @@ struct zcomp {
 
 	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
 	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	int (*set_max_streams)(struct zcomp *comp, int num_strm);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -53,4 +54,6 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
+
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 42b9c7f..88b12d8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -132,12 +132,11 @@ static ssize_t max_comp_streams_store(struct device *dev,
 	if (num < 1)
 		return -EINVAL;
 	down_write(&zram->init_lock);
+	zram->max_comp_streams = num;
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
-		pr_info("Can't set max_comp_streams for initialized device\n");
-		return -EBUSY;
+		if (zcomp_set_max_streams(zram->comp, num))
+			pr_info("Cannot change max compression streams\n");
 	}
-	zram->max_comp_streams = num;
 	up_write(&zram->init_lock);
 	return len;
 }
-- 
1.9.0.291.g027825b

