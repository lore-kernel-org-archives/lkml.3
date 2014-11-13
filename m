Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbaKMTZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:38 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:49300 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939AbaKMTZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:33 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org (open list:SLAB ALLOCATOR),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 14/16] slab: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:20 -0500
Message-Id: <1415906662-4576-15-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 mm/slab.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 3347fd7..1cf40054 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -209,15 +209,15 @@ cache_from_memcg_idx(struct kmem_cache *s, int idx)
 
 	rcu_read_lock();
 	params = rcu_dereference(s->memcg_params);
-	cachep = params->memcg_caches[idx];
-	rcu_read_unlock();
 
 	/*
 	 * Make sure we will access the up-to-date value. The code updating
 	 * memcg_caches issues a write barrier to match this (see
 	 * memcg_register_cache()).
 	 */
-	smp_read_barrier_depends();
+	cachep = lockless_dereference(params->memcg_caches[idx]);
+	rcu_read_unlock();
+
 	return cachep;
 }
 
-- 
1.9.1

