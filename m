Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaAFWjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaAFWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.12 126/144] GFS2: Fix use-after-free race when calling gfs2_remove_from_ail
Date: Mon,  6 Jan 2014 14:38:07 -0800
Message-Id: <20140106223748.961639944@linuxfoundation.org>
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

commit 9290a9a7c0bcf5400e8dbfbf9707fa68ea3fb338 upstream.

Function gfs2_remove_from_ail drops the reference on the bh via
brelse. This patch fixes a race condition whereby bh is deferenced
after the brelse when setting bd->bd_blkno = bh->b_blocknr;
Under certain rare circumstances, bh might be gone or reused,
and bd->bd_blkno is set to whatever that memory happens to be,
which is often 0. Later, in gfs2_trans_add_unrevoke, that bd fails
the test "bd->bd_blkno >= blkno" which causes it to never be freed.
The end result is that the bd is never freed from the bufdata cache,
which results in this error:
slab error in kmem_cache_destroy(): cache `gfs2_bufdata': Can't free all objects

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -551,10 +551,10 @@ void gfs2_add_revoke(struct gfs2_sbd *sd
 	struct buffer_head *bh = bd->bd_bh;
 	struct gfs2_glock *gl = bd->bd_gl;
 
-	gfs2_remove_from_ail(bd);
-	bd->bd_bh = NULL;
 	bh->b_private = NULL;
 	bd->bd_blkno = bh->b_blocknr;
+	gfs2_remove_from_ail(bd); /* drops ref on bh */
+	bd->bd_bh = NULL;
 	bd->bd_ops = &gfs2_revoke_lops;
 	sdp->sd_log_num_revoke++;
 	atomic_inc(&gl->gl_revokes);


