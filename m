Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3FDOTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:19:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3FDOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 41/70] dm bufio: avoid a possible __vmalloc deadlock
Date: Tue,  4 Jun 2013 15:06:57 +0100
Message-Id: <1370354846-14213-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backport to 3.5 as suggested:
  - inlined functions memalloc_noio_save and memalloc_noio_restore
  - replaced PF_MEMALLOC_NOIO by PF_MEMALLOC ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-bufio.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c0fc827..e9097af 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -321,6 +321,9 @@ static void __cache_size_refresh(void)
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 			       enum data_mode *data_mode)
 {
+	unsigned noio_flag;
+	void *ptr;
+
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
 		*data_mode = DATA_MODE_SLAB;
 		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
@@ -334,7 +337,28 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
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
+	if (gfp_mask & __GFP_NORETRY) {
+		noio_flag = current->flags & PF_MEMALLOC;
+		current->flags |= PF_MEMALLOC;
+	}
+
+	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+
+	if (gfp_mask & __GFP_NORETRY)
+		current->flags = (current->flags & ~PF_MEMALLOC) | noio_flag;
+
+	return ptr;
 }
 
 /*
-- 
1.8.1.2

