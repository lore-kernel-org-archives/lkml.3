Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaATMYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaATMY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:29 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/24] GFS2: Clean up releasepage
Date: Mon, 20 Jan 2014 12:23:27 +0000
Message-Id: <1390220627-1571-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For historical reasons, we drop and retake the log lock in ->releasepage()
however, since there is no reason why we cannot hold the log lock over
the whole function, this allows some simplification. In particular,
pinning a buffer is only ever done under the log lock, so it is possible
here to remove the test for pinned buffers in the second loop, since it
is impossible for that to happen (it is also tested in the first loop).

As a result, two tests made later in the second loop become constants
and can also be reduced to the only possible branch. So the net result
is to remove various bits of unreachable code and make this more
readable.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 73f3e4e..cf858da 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1080,30 +1080,22 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		bh = bh->b_this_page;
 	} while(bh != head);
 	spin_unlock(&sdp->sd_ail_lock);
-	gfs2_log_unlock(sdp);
 
 	head = bh = page_buffers(page);
 	do {
-		gfs2_log_lock(sdp);
 		bd = bh->b_private;
 		if (bd) {
 			gfs2_assert_warn(sdp, bd->bd_bh == bh);
-			if (!list_empty(&bd->bd_list)) {
-				if (!buffer_pinned(bh))
-					list_del_init(&bd->bd_list);
-				else
-					bd = NULL;
-			}
-			if (bd)
-				bd->bd_bh = NULL;
+			if (!list_empty(&bd->bd_list))
+				list_del_init(&bd->bd_list);
+			bd->bd_bh = NULL;
 			bh->b_private = NULL;
-		}
-		gfs2_log_unlock(sdp);
-		if (bd)
 			kmem_cache_free(gfs2_bufdata_cachep, bd);
+		}
 
 		bh = bh->b_this_page;
 	} while (bh != head);
+	gfs2_log_unlock(sdp);
 
 	return try_to_free_buffers(page);
 
-- 
1.8.3.1

