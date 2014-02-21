Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaBULya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:54:30 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47405 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbaBULyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:54:25 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv6 3/6] zram: factor out single stream compression
Date: Fri, 21 Feb 2014 14:50:40 +0300
Message-Id: <1392983443-9807-4-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation patch to add multi stream support to zcomp.

Introduce struct zcomp_strm_single and a set of functions to manage zcomp_strm
stream access. zcomp_strm_single implements single compession stream, same way
as current zcomp implementation. This moves zcomp_strm stream control and
locking from zcomp, so compressing backend zcomp is not aware of required
locking (single and multi streams require different locking schemes).

The following set of functions added:
- zcomp_strm_single_get()/zcomp_strm_single_put()
  get and put compression stream, implement required locking
- zcomp_strm_single_create()/zcomp_strm_single_destroy()
  create and destroy zcomp_strm_single

New ->strm_get() and ->strm_put() callbacks added to zcomp, which are set to
zcomp_strm_single_get() and zcomp_strm_single_put() during initialisation.
Instead of direct locking and zcomp_strm access from zcomp_strm_get() and
zcomp_strm_put(), zcomp now calls ->strm_get() and ->strm_put()
correspondingly.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c | 63 ++++++++++++++++++++++++++++++++++++++++------
 drivers/block/zram/zcomp.h |  7 ++++--
 2 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index db72f3d..9661226 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -15,6 +15,14 @@
 
 #include "zcomp.h"
 
+/*
+ * single zcomp_strm backend private part
+ */
+struct zcomp_strm_single {
+	struct mutex strm_lock;
+	struct zcomp_strm *zstrm;
+};
+
 extern struct zcomp_backend zcomp_lzo;
 
 static struct zcomp_backend *find_backend(const char *compress)
@@ -55,17 +63,58 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 	return zstrm;
 }
 
+static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zp = comp->private;
+	mutex_lock(&zp->strm_lock);
+	return zp->zstrm;
+}
+
+static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_single *zp = comp->private;
+	mutex_unlock(&zp->strm_lock);
+}
+
+static void zcomp_strm_single_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zp = comp->private;
+	zcomp_strm_free(comp, zp->zstrm);
+	kfree(zp);
+}
+
+static int zcomp_strm_single_create(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zp;
+
+	comp->destroy = zcomp_strm_single_destroy;
+	comp->strm_get = zcomp_strm_single_get;
+	comp->strm_put = zcomp_strm_single_put;
+	zp = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
+	comp->private = zp;
+	if (!zp)
+		return -ENOMEM;
+
+	mutex_init(&zp->strm_lock);
+	zp->zstrm = zcomp_strm_alloc(comp);
+	if (!zp->zstrm) {
+		zcomp_strm_single_destroy(comp);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
 {
-	mutex_lock(&comp->strm_lock);
-	return comp->zstrm;
+	return comp->strm_get(comp);
 }
 
 void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	mutex_unlock(&comp->strm_lock);
+	comp->strm_put(comp, zstrm);
 }
 
+/* compress page */
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		const unsigned char *src, size_t *dst_len)
 {
@@ -73,6 +122,7 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 			zstrm->private);
 }
 
+/* decompress page */
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst)
 {
@@ -81,7 +131,7 @@ int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 
 void zcomp_destroy(struct zcomp *comp)
 {
-	zcomp_strm_free(comp, comp->zstrm);
+	comp->destroy(comp);
 	kfree(comp);
 }
 
@@ -105,10 +155,7 @@ struct zcomp *zcomp_create(const char *compress)
 		return NULL;
 
 	comp->backend = backend;
-	mutex_init(&comp->strm_lock);
-
-	comp->zstrm = zcomp_strm_alloc(comp);
-	if (!comp->zstrm) {
+	if (zcomp_strm_single_create(comp) != 0) {
 		zcomp_destroy(comp);
 		return NULL;
 	}
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 5106f8e..8dc1d7f 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -34,9 +34,12 @@ struct zcomp_backend {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct mutex strm_lock;
-	struct zcomp_strm *zstrm;
+	void *private;
 	struct zcomp_backend *backend;
+
+	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
+	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	void (*destroy)(struct zcomp *comp);
 };
 
 struct zcomp *zcomp_create(const char *comp);
-- 
1.9.0.291.g027825b

