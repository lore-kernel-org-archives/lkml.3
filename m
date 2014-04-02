Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaDBSEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbaDBSET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:04:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@fb.com
Cc: linux-kernel@vger.kernel.org, mpatocka@redhat.com, dm-devel@redhat.com
Subject: [PATCH] block: use kmalloc alignment for bio slab
Date: Wed,  2 Apr 2014 14:04:16 -0400
Message-Id: <1396461856-27243-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Various subsystems can ask the bio subsystem to create a bio slab cache
with some free space before the bio.  This free space can be used for any
purpose.  Device mapper uses this per-bio-data feature to place some
target-specific and device-mapper specific data before the bio, so that
the target-specific data doesn't have to be allocated separately.

This per-bio-data mechanism is used in place of kmalloc, so we need the
allocated slab to have the same memory alignment as memory allocated
with kmalloc.

Change bio_find_or_create_slab() so that it uses ARCH_KMALLOC_MINALIGN
alignment when creating the slab cache.  This is needed so that dm-crypt
can use per-bio-data for encryption - the crypto subsystem assumes this
data will have the same alignment as kmalloc'ed memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 fs/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index b2dd42e..6c94ba6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -112,7 +112,8 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 	bslab = &bio_slabs[entry];
 
 	snprintf(bslab->name, sizeof(bslab->name), "bio-%d", entry);
-	slab = kmem_cache_create(bslab->name, sz, 0, SLAB_HWCACHE_ALIGN, NULL);
+	slab = kmem_cache_create(bslab->name, sz, ARCH_KMALLOC_MINALIGN,
+				 SLAB_HWCACHE_ALIGN, NULL);
 	if (!slab)
 		goto out_unlock;
 
-- 
1.8.1.4

