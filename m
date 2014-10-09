Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaJIVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaJIVGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 145/163] mm, slab: initialize object alignment on cache creation
Date: Thu,  9 Oct 2014 14:02:50 -0700
Message-Id: <1412888588-26755-146-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit d4a5fca592b9ab52b90bb261a90af3c8f53be011 upstream.

Since commit 4590685546a3 ("mm/sl[aou]b: Common alignment code"), the
"ralign" automatic variable in __kmem_cache_create() may be used as
uninitialized.

The proper alignment defaults to BYTES_PER_WORD and can be overridden by
SLAB_RED_ZONE or the alignment specified by the caller.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=85031

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Andrei Elovikov <a.elovikov@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/slab.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index eb043bf..f985e8f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2139,7 +2139,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 int
 __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 {
-	size_t left_over, freelist_size, ralign;
+	size_t left_over, freelist_size;
+	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
 	int err;
 	size_t size = cachep->size;
@@ -2172,14 +2173,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		size &= ~(BYTES_PER_WORD - 1);
 	}
 
-	/*
-	 * Redzoning and user store require word alignment or possibly larger.
-	 * Note this will be overridden by architecture or caller mandated
-	 * alignment if either is greater than BYTES_PER_WORD.
-	 */
-	if (flags & SLAB_STORE_USER)
-		ralign = BYTES_PER_WORD;
-
 	if (flags & SLAB_RED_ZONE) {
 		ralign = REDZONE_ALIGN;
 		/* If redzoning, ensure that the second redzone is suitably
-- 
1.9.1

