Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaAFWjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbaAFWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.12 127/144] GFS2: Fix slab memory leak in gfs2_bufdata
Date: Mon,  6 Jan 2014 14:38:08 -0800
Message-Id: <20140106223748.989385032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 502be2a32f09f388e4ff34ef2e3ebcabbbb261da upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/meta_io.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -258,6 +258,7 @@ void gfs2_remove_from_journal(struct buf
 	struct address_space *mapping = bh->b_page->mapping;
 	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct gfs2_bufdata *bd = bh->b_private;
+	int was_pinned = 0;
 
 	if (test_clear_buffer_pinned(bh)) {
 		trace_gfs2_pin(bd, 0);
@@ -273,12 +274,16 @@ void gfs2_remove_from_journal(struct buf
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


