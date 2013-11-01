Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3KAKbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:31:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3KAKbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:31:14 -0400
X-IronPort-AV: E=Sophos;i="4.93,616,1378828800"; 
   d="scan'208";a="8921486"
Message-ID: <52738187.1000807@cn.fujitsu.com>
Date: Fri, 01 Nov 2013 18:25:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: bpm@sgi.com, elder@kernel.org
CC: xfs@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>,
        guz.fnst@cn.fujitsu.com
Subject: [PATCH] xfs: simplify kmem_{zone_}zalloc
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:29:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:29:26,
	Serialize complete at 2013/11/01 18:29:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
in order to avoid the setting to zero step.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/xfs/kmem.c |   14 ++------------
 fs/xfs/kmem.h |    7 ++++++-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a02cfb9..d56fcc9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 void *
 kmem_zalloc(size_t size, xfs_km_flags_t flags)
 {
-	void	*ptr;
-
-	ptr = kmem_alloc(size, flags);
-	if (ptr)
-		memset((char *)ptr, 0, (int)size);
-	return ptr;
+	return kmem_alloc(size, flags | KM_ZERO);
 }
 
 void *
@@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 void *
 kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 {
-	void	*ptr;
-
-	ptr = kmem_zone_alloc(zone, flags);
-	if (ptr)
-		memset((char *)ptr, 0, kmem_cache_size(zone));
-	return ptr;
+	return kmem_zone_alloc(zone, flags | KM_ZERO);
 }
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 3a7371c..8ea21fd 100644
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
@@ -52,6 +53,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
 			lflags &= ~__GFP_FS;
 	}
+
+	if (flags & KM_ZERO)
+		lflags |= __GFP_ZERO;
+
 	return lflags;
 }
 
-- 
1.7.7


