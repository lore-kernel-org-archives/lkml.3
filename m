Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaB1Rz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:55:59 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51732 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaB1Rzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:55:54 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv9 5/7] zram: add set_max_streams knob
Date: Fri, 28 Feb 2014 20:52:05 +0300
Message-Id: <1393609927-22090-6-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.359.g5e34a15
In-Reply-To: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
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
 drivers/block/zram/zcomp.c    | 36 ++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h    |  3 +++
 drivers/block/zram/zram_drv.c |  5 ++---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index c06f75f..ac276f7 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -136,6 +136,29 @@ static void zcomp_strm_multi_release(struct zcomp *comp, struct zcomp_strm *zstr
 	zcomp_strm_free(comp, zstrm);
 }
 
+/* change max_strm limit */
+static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	spin_lock(&zs->strm_lock);
+	zs->max_strm = num_strm;
+	/*
+	 * if user has lowered the limit and there are idle streams,
+	 * immediately free as much streams (and memory) as we can.
+	 */
+	while (zs->avail_strm > num_strm && !list_empty(&zs->idle_strm)) {
+		zstrm = list_entry(zs->idle_strm.next,
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
@@ -158,6 +181,7 @@ static int zcomp_strm_multi_create(struct zcomp *comp, int max_strm)
 	comp->destroy = zcomp_strm_multi_destroy;
 	comp->strm_find = zcomp_strm_multi_find;
 	comp->strm_release = zcomp_strm_multi_release;
+	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -192,6 +216,12 @@ static void zcomp_strm_single_release(struct zcomp *comp,
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
@@ -206,6 +236,7 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	comp->destroy = zcomp_strm_single_destroy;
 	comp->strm_find = zcomp_strm_single_find;
 	comp->strm_release = zcomp_strm_single_release;
+	comp->set_max_streams = zcomp_strm_single_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -220,6 +251,11 @@ static int zcomp_strm_single_create(struct zcomp *comp)
 	return 0;
 }
 
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	return comp->set_max_streams(comp, num_strm);
+}
+
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
 	return comp->strm_find(comp);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 2a36844..bd11d59 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -46,6 +46,7 @@ struct zcomp {
 
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
 	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	int (*set_max_streams)(struct zcomp *comp, int num_strm);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -60,4 +61,6 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
+
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 75bbc37..2de17f6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -133,9 +133,8 @@ static ssize_t max_comp_streams_store(struct device *dev,
 		return -EINVAL;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
-		pr_info("Can't set max_comp_streams for initialized device\n");
-		return -EBUSY;
+		if (zcomp_set_max_streams(zram->comp, num))
+			pr_info("Cannot change max compression streams\n");
 	}
 	zram->max_comp_streams = num;
 	up_write(&zram->init_lock);
-- 
1.9.0.359.g5e34a15

