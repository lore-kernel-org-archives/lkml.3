Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaEXTIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 15:08:07 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:63508 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaEXTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 15:08:02 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>, Nitin Gupta <ngupta@vflare.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] mm/zpool: prevent zbud/zsmalloc from unloading when used
Date: Sat, 24 May 2014 15:06:09 -0400
Message-Id: <1400958369-3588-7-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
References: <1399499496-3216-1-git-send-email-ddstreet@ieee.org>
 <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add try_module_get() to pool creation functions for zbud and zsmalloc,
and module_put() to pool destruction functions, since they now can be
modules used via zpool.  Without usage counting, they could be unloaded
while pool(s) were active, resulting in an oops.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
---

New for this patch set.

 mm/zbud.c     | 5 +++++
 mm/zsmalloc.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/mm/zbud.c b/mm/zbud.c
index 8a72cb1..2b3689c 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -282,6 +282,10 @@ struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
 	pool = kmalloc(sizeof(struct zbud_pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
+	if (!try_module_get(THIS_MODULE)) {
+		kfree(pool);
+		return NULL;
+	}
 	spin_lock_init(&pool->lock);
 	for_each_unbuddied_list(i, 0)
 		INIT_LIST_HEAD(&pool->unbuddied[i]);
@@ -302,6 +306,7 @@ struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops)
 void zbud_destroy_pool(struct zbud_pool *pool)
 {
 	kfree(pool);
+	module_put(THIS_MODULE);
 }
 
 /**
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 07c3130..2cc2647 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -946,6 +946,10 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 	pool = kzalloc(ovhd_size, GFP_KERNEL);
 	if (!pool)
 		return NULL;
+	if (!try_module_get(THIS_MODULE)) {
+		kfree(pool);
+		return NULL;
+	}
 
 	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
 		int size;
@@ -985,6 +989,7 @@ void zs_destroy_pool(struct zs_pool *pool)
 		}
 	}
 	kfree(pool);
+	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
-- 
1.8.3.1

