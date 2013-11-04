Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3KDK1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:27:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3KDK1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:27:15 -0500
X-IronPort-AV: E=Sophos;i="4.93,631,1378828800"; 
   d="scan'208";a="8941638"
Message-ID: <52777511.1020605@cn.fujitsu.com>
Date: Mon, 04 Nov 2013 18:21:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: bpm@sgi.com, elder@kernel.org
CC: xfs@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>,
        guz.fnst@cn.fujitsu.com, Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/04 18:25:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/04 18:25:23,
	Serialize complete at 2013/11/04 18:25:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
in order to avoid the setting to zero step. 
And following Dave's suggestion, make kmem_{zone_}zalloc static inline
into kmem.h as they're now just a simple wrapper.

V2:
  Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/xfs/kmem.c |   22 ----------------------
 fs/xfs/kmem.h |   21 ++++++++++++++++++---
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a02cfb9..66a36be 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -63,17 +63,6 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 }
 
 void *
-kmem_zalloc(size_t size, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	ptr = kmem_alloc(size, flags);
-	if (ptr)
-		memset((char *)ptr, 0, (int)size);
-	return ptr;
-}
-
-void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
 	void	*ptr;
@@ -128,14 +117,3 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
-
-void *
-kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	ptr = kmem_zone_alloc(zone, flags);
-	if (ptr)
-		memset((char *)ptr, 0, kmem_cache_size(zone));
-	return ptr;
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 3a7371c..64db0e5 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -32,6 +32,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
 #define KM_NOSLEEP	((__force xfs_km_flags_t)0x0002u)
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
+#define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -43,7 +44,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));
 
 	if (flags & KM_NOSLEEP) {
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
@@ -52,11 +53,14 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
 			lflags &= ~__GFP_FS;
 	}
+
+	if (flags & KM_ZERO)
+		lflags |= __GFP_ZERO;
+
 	return lflags;
 }
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
-extern void *kmem_zalloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
 extern void  kmem_free(const void *);
@@ -64,6 +68,12 @@ extern void  kmem_free(const void *);
 
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
 
+static inline void *
+kmem_zalloc(size_t size, xfs_km_flags_t flags)
+{
+	return kmem_alloc(size, flags | KM_ZERO);
+}
+
 /*
  * Zone interfaces
  */
@@ -102,6 +112,11 @@ kmem_zone_destroy(kmem_zone_t *zone)
 }
 
 extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
-extern void *kmem_zone_zalloc(kmem_zone_t *, xfs_km_flags_t);
+
+static inline void *
+kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
+{
+	return kmem_zone_alloc(zone, flags | KM_ZERO);
+}
 
 #endif /* __XFS_SUPPORT_KMEM_H__ */
-- 
1.7.7


