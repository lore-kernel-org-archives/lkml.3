Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbAEBhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:37:40 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57190 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbAEBhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:37:38 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 1/6] mm/slab: fix gfp flags of percpu allocation at boot phase
Date: Mon,  5 Jan 2015 10:37:26 +0900
Message-Id: <1420421851-3281-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_percpu() passed GFP_KERNEL implicitly to core function of
percpu allocator. At boot phase, it's not valid gfp flag so change it.

Without this change, while implementing new feature, I found that
__alloc_percpu() calls kmalloc() which is not initialized at this time
and the system fail to boot. percpu allocator regards GFP_KERNEL as
the sign of the system fully initialized so aggressively try to make
spare room. With GFP_NOWAIT, it doesn't do that so succeed to boot.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 65b5dcb..1150c8b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1990,9 +1990,12 @@ static struct array_cache __percpu *alloc_kmem_cache_cpus(
 	int cpu;
 	size_t size;
 	struct array_cache __percpu *cpu_cache;
+	gfp_t gfp_flags = GFP_KERNEL;
 
 	size = sizeof(void *) * entries + sizeof(struct array_cache);
-	cpu_cache = __alloc_percpu(size, sizeof(void *));
+	if (slab_state < FULL)
+		gfp_flags = GFP_NOWAIT;
+	cpu_cache = __alloc_percpu_gfp(size, sizeof(void *), gfp_flags);
 
 	if (!cpu_cache)
 		return NULL;
-- 
1.7.9.5

