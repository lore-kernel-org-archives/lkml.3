Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaABM3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:29:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaABM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:42 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/6] GFS2: Fix slab memory leak in gfs2_bufdata
Date: Thu,  2 Jan 2014 12:28:11 +0000
Message-Id: <1388665694-1639-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
References: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a slab memory leak that sometimes can occur
for files with a very short lifespan. The problem occurs when
a dinode is deleted before it has gotten to the journal properly.
In the leak scenario, the bd object is pinned for journal
committment (queued to the metadata buffers queue: sd_log_le_buf)
but is subsequently unpinned and dequeued before it finds its way
to the ail or the revoke queue. In this rare circumstance, the bd
object needs to be freed from slab memory, or it is forgotten.
We have to be very careful how we do it, though, because
multiple processes can call gfs2_remove_from_journal. In order to
avoid double-frees, only the process that does the unpinning is
allowed to free the bd.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 9324150..52f177b 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -258,6 +258,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	struct address_space *mapping = bh->b_page->mapping;
 	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct gfs2_bufdata *bd = bh->b_private;
+	int was_pinned = 0;
 
 	if (test_clear_buffer_pinned(bh)) {
 		trace_gfs2_pin(bd, 0);
@@ -273,12 +274,16 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 			tr->tr_num_databuf_rm++;
 		}
 		tr->tr_touched = 1;
+		was_pinned = 1;
 		brelse(bh);
 	}
 	if (bd) {
 		spin_lock(&sdp->sd_ail_lock);
 		if (bd->bd_tr) {
 			gfs2_trans_add_revoke(sdp, bd);
+		} else if (was_pinned) {
+			bh->b_private = NULL;
+			kmem_cache_free(gfs2_bufdata_cachep, bd);
 		}
 		spin_unlock(&sdp->sd_ail_lock);
 	}
-- 
1.8.3.1

