Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3E1Vhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:37:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab3E1VYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 35/78] dm bufio: avoid a possible __vmalloc deadlock
Date: Tue, 28 May 2013 14:19:44 -0700
Message-Id: <1369776027-17859-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 502624bdad3dba45dfaacaf36b7d83e39e74b2d2 upstream.

This patch uses memalloc_noio_save to avoid a possible deadlock in
dm-bufio.  (it could happen only with large block size, at most
PAGE_SIZE << MAX_ORDER (typically 8MiB).

__vmalloc doesn't fully respect gfp flags. The specified gfp flags are
used for allocation of requested pages, structures vmap_area, vmap_block
and vm_struct and the radix tree nodes.

However, the kernel pagetables are allocated always with GFP_KERNEL.
Thus the allocation of pagetables can recurse back to the I/O layer and
cause a deadlock.

This patch uses the function memalloc_noio_save to set per-process
PF_MEMALLOC_NOIO flag and the function memalloc_noio_restore to restore
it. When this flag is set, all allocations in the process are done with
implied GFP_NOIO flag, thus the deadlock can't happen.

This should be backported to stable kernels, but they don't have the
PF_MEMALLOC_NOIO flag and memalloc_noio_save/memalloc_noio_restore
functions. So, PF_MEMALLOC should be set and restored instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-bufio.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 64eff90..5d2c26e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -319,6 +319,9 @@ static void __cache_size_refresh(void)
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 			       enum data_mode *data_mode)
 {
+	unsigned noio_flag;
+	void *ptr;
+
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
 		*data_mode = DATA_MODE_SLAB;
 		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
@@ -332,7 +335,26 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
-	return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	/*
+	 * __vmalloc allocates the data pages and auxiliary structures with
+	 * gfp_flags that were specified, but pagetables are always allocated
+	 * with GFP_KERNEL, no matter what was specified as gfp_mask.
+	 *
+	 * Consequently, we must set per-process flag PF_MEMALLOC_NOIO so that
+	 * all allocations done by this process (including pagetables) are done
+	 * as if GFP_NOIO was specified.
+	 */
+
+	if (gfp_mask & __GFP_NORETRY)
+		noio_flag = memalloc_noio_save();
+
+	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	if (gfp_mask & __GFP_NORETRY)
+		memalloc_noio_restore(noio_flag);
+
+	return ptr;
 }
 
 /*
-- 
1.8.1.2

