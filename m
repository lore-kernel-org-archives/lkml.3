Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaBUKRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:17:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaBUKQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:16:58 -0500
X-IronPort-AV: E=Sophos;i="4.97,517,1389715200"; 
   d="scan'208";a="9575570"
Message-ID: <5307259D.7050208@cn.fujitsu.com>
Date: Fri, 21 Feb 2014 18:08:29 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/2] f2fs: introduce help macro on_build_free_nids()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:14:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:14:43,
	Serialize complete at 2014/02/21 18:14:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce help macro on_build_free_nids() which just uses build_lock
to judge whether the building free nid is going, so that we can remove
the on_build_free_nids field from f2fs_sb_info.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |    2 --
 fs/f2fs/node.c |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 91f4c5e..8cc7166 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -48,7 +48,6 @@
 #define ver_after(a, b)	(typecheck(unsigned long long, a) &&		\
 		typecheck(unsigned long long, b) &&			\
 		((long long)((a) - (b)) > 0))
-
 typedef u32 block_t;	/*
 			 * should not change u32, since it is the on-disk block
 			 * address format, __le32.
@@ -417,7 +416,6 @@ struct f2fs_sb_info {
 	struct mutex node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
 	bool por_doing;				/* recovery is doing or not */
-	bool on_build_free_nids;		/* build_free_nids is doing */
 	wait_queue_head_t cp_wait;
 
 	/* for orphan inode management */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d452185..8c5981e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -21,6 +21,8 @@
 #include "segment.h"
 #include <trace/events/f2fs.h>
 
+#define on_build_free_nids(nmi) mutex_is_locked(&nm_i->build_lock)
+
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
 
@@ -1426,7 +1428,7 @@ retry:
 	spin_lock(&nm_i->free_nid_list_lock);
 
 	/* We should not use stale free nids created by build_free_nids */
-	if (nm_i->fcnt && !sbi->on_build_free_nids) {
+	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
 		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
 		list_for_each(this, &nm_i->free_nid_list) {
 			i = list_entry(this, struct free_nid, list);
@@ -1445,9 +1447,7 @@ retry:
 
 	/* Let's scan nat pages and its caches to get free nids */
 	mutex_lock(&nm_i->build_lock);
-	sbi->on_build_free_nids = true;
 	build_free_nids(sbi);
-	sbi->on_build_free_nids = false;
 	mutex_unlock(&nm_i->build_lock);
 	goto retry;
 }
-- 
1.7.7

