Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaB1Rzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:55:53 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52365 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaB1Rzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:55:50 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv9 3/7] zram: factor out single stream compression
Date: Fri, 28 Feb 2014 20:52:03 +0300
Message-Id: <1393609927-22090-4-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.359.g5e34a15
In-Reply-To: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation patch to add multi stream support to zcomp.

Introduce struct zcomp_strm_single and a set of functions to manage zcomp_strm
stream access. zcomp_strm_single implements single compession stream, same way
as current zcomp implementation. This moves zcomp_strm stream control and
locking from zcomp, so compressing backend zcomp is not aware of required
locking.

Single and multi streams require different locking schemes. Minchan Kim
reported that spinlock-based locking scheme (which is used in multi stream
implementation) has demonstrated a severe perfomance regression for single
compression stream case, comparing to mutex-based.
see https://lkml.org/lkml/2014/2/18/16

The following set of functions added:
- zcomp_strm_single_find()/zcomp_strm_single_release()
  find and release a compression stream, implement required locking
- zcomp_strm_single_create()/zcomp_strm_single_destroy()
  create and destroy zcomp_strm_single

New ->strm_find() and ->strm_release() callbacks added to zcomp, which are set to
zcomp_strm_single_find() and zcomp_strm_single_release() during initialisation.
Instead of direct locking and zcomp_strm access from zcomp_strm_find() and
zcomp_strm_release(), zcomp now calls ->strm_find() and ->strm_release()
correspondingly.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c | 62 ++++++++++++++++++++++++++++++++++++++++------
 drivers/block/zram/zcomp.h |  7 ++++--
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 22f4ae2..72e8071 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -16,6 +16,14 @@
 #include "zcomp.h"
 #include "zcomp_lzo.h"
 
+/*
+ * single zcomp_strm backend
+ */
+struct zcomp_strm_single {
+	struct mutex strm_lock;
+	struct zcomp_strm *zstrm;
+};
+
 static struct zcomp_backend *find_backend(const char *compress)
 {
 	if (strncmp(compress, "lzo", 3) == 0)
@@ -54,15 +62,56 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 	return zstrm;
 }
 
+static struct zcomp_strm *zcomp_strm_single_find(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	mutex_lock(&zs->strm_lock);
+	return zs->zstrm;
+}
+
+static void zcomp_strm_single_release(struct zcomp *comp,
+		struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	mutex_unlock(&zs->strm_lock);
+}
+
+static void zcomp_strm_single_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs = comp->stream;
+	zcomp_strm_free(comp, zs->zstrm);
+	kfree(zs);
+}
+
+static int zcomp_strm_single_create(struct zcomp *comp)
+{
+	struct zcomp_strm_single *zs;
+
+	comp->destroy = zcomp_strm_single_destroy;
+	comp->strm_find = zcomp_strm_single_find;
+	comp->strm_release = zcomp_strm_single_release;
+	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
+	if (!zs)
+		return -ENOMEM;
+
+	comp->stream = zs;
+	mutex_init(&zs->strm_lock);
+	zs->zstrm = zcomp_strm_alloc(comp);
+	if (!zs->zstrm) {
+		kfree(zs);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
-	mutex_lock(&comp->strm_lock);
-	return comp->zstrm;
+	return comp->strm_find(comp);
 }
 
 void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	mutex_unlock(&comp->strm_lock);
+	comp->strm_release(comp, zstrm);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
@@ -80,7 +129,7 @@ int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 
 void zcomp_destroy(struct zcomp *comp)
 {
-	zcomp_strm_free(comp, comp->zstrm);
+	comp->destroy(comp);
 	kfree(comp);
 }
 
@@ -104,10 +153,7 @@ struct zcomp *zcomp_create(const char *compress)
 		return NULL;
 
 	comp->backend = backend;
-	mutex_init(&comp->strm_lock);
-
-	comp->zstrm = zcomp_strm_alloc(comp);
-	if (!comp->zstrm) {
+	if (zcomp_strm_single_create(comp) != 0) {
 		kfree(comp);
 		return NULL;
 	}
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index c9a98e1..dc3500d 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -39,9 +39,12 @@ struct zcomp_backend {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct mutex strm_lock;
-	struct zcomp_strm *zstrm;
+	void *stream;
 	struct zcomp_backend *backend;
+
+	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
+	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	void (*destroy)(struct zcomp *comp);
 };
 
 struct zcomp *zcomp_create(const char *comp);
-- 
1.9.0.359.g5e34a15

