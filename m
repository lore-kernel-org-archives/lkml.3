Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaDRMs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:48:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61818 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754257AbaDRMrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:47:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29445306"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 7/8] idr: don't need to shink the free list when idr_remove()
Date: Fri, 18 Apr 2014 20:49:54 +0800
Message-ID: <1397825404-12039-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After idr subsystem is changed to RCU-awared, the free layer will not go to
the free list. The free list will not be filled up when idr_remove().
So we don't need to shink it too.

"#ifndef TEST" can't work for user space test now, just remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index be0b6ff..314ea5f 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -18,19 +18,11 @@
  * pointer or what ever, we treat it as a (void *).  You can pass this
  * id to a user for him to pass back at a later time.  You then pass
  * that id to this code and it returns your pointer.
-
- * You can release ids at any time. When all ids are released, most of
- * the memory is returned (we keep MAX_IDR_FREE) in a local pool so we
- * don't need to go to the memory "store" during an id allocate, just
- * so you don't need to be too concerned about locking and conflicts
- * with the slab allocator.
  */
 
-#ifndef TEST                        // to test in user space...
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/export.h>
-#endif
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
@@ -584,15 +576,6 @@ void idr_remove(struct idr *idp, int id)
 		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
 		free_layer(idp, to_free);
 	}
-	while (idp->id_free_cnt >= MAX_IDR_FREE) {
-		p = get_from_free_list(idp);
-		/*
-		 * Note: we don't call the rcu callback here, since the only
-		 * layers that fall into the freelist are those that have been
-		 * preallocated.
-		 */
-		kmem_cache_free(idr_layer_cache, p);
-	}
 	return;
 }
 EXPORT_SYMBOL(idr_remove);
-- 
1.7.4.4

