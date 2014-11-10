Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKJHNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:13:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45184 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaKJHM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:12:59 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <cl@linux.com>, <penberg@kernel.org>, <rientjes@google.com>,
        <iamjoonsoo.kim@lge.com>, <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <vdavydov@parallels.com>
Subject: [PATCH] slab: Fix compilation error in case of !CONFIG_NUMA
Date: Mon, 10 Nov 2014 09:11:57 +0200
Message-ID: <1415603517-9527-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of slab_free() outside of #ifdef CONFIG_NUMA since it
is used by code which is not NUMA specific. Fixes the following error
introduced by the following commit:
5da1c3c725ab slab: recharge slab pages to the allocating memory cgroup

  CC      mm/slab.o
/home/ZZZZZ/linux/mm/slab.c: In function ‘slab_alloc’:
/home/ZZZZZ/linux/mm/slab.c:3260:4: error: implicit declaration of function ‘slab_free’ [-Werror=implicit-function-declaration]
    slab_free(cachep, objp);
    ^
/home/ZZZZZ/linux/mm/slab.c: At top level:
/home/ZZZZZ/linux/mm/slab.c:3534:29: warning: conflicting types for ‘slab_free’ [enabled by default]
 static __always_inline void slab_free(struct kmem_cache *cachep, void *objp)
                             ^
/home/ZZZZZ/linux/mm/slab.c:3534:29: error: static declaration of ‘slab_free’ follows non-static declaration
/home/ZZZZZ/linux/mm/slab.c:3260:4: note: previous implicit declaration of ‘slab_free’ was here
    slab_free(cachep, objp);
    ^
cc1: some warnings being treated as errors
/home/ZZZZZ/linux/scripts/Makefile.build:257: recipe for target 'mm/slab.o' failed
make[2]: *** [mm/slab.o] Error 1
/home/ZZZZZ/linux/Makefile:953: recipe for target 'mm' failed
make[1]: *** [mm] Error 2
make[1]: *** Waiting for unfinished jobs....
  CHK     kernel/config_data.h

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 mm/slab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 61b01c2ae1d9..301ede1c6784 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3133,8 +3133,6 @@ done:
 	return obj;
 }
 
-static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
-
 static __always_inline void *
 slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 		   unsigned long caller)
@@ -3228,6 +3226,8 @@ __do_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 
 #endif /* CONFIG_NUMA */
 
+static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
+
 static __always_inline void *
 slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 {
-- 
2.1.3

