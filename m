Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab3E1ESA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:18:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52467 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758762Ab3E1Dy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alasdair G Kergon" <agk@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.915886107@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [25/94] dm bufio: avoid a possible __vmalloc deadlock
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2 as recommended]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-bufio.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -322,6 +322,9 @@ static void __cache_size_refresh(void)
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 			       enum data_mode *data_mode)
 {
+	unsigned noio_flag;
+	void *ptr;
+
 	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_SLAB_LIMIT) {
 		*data_mode = DATA_MODE_SLAB;
 		return kmem_cache_alloc(DM_BUFIO_CACHE(c), gfp_mask);
@@ -335,7 +338,28 @@ static void *alloc_buffer_data(struct dm
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

