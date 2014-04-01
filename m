Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaDAJQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/29] GFS2: Plug on AIL flush
Date: Tue,  1 Apr 2014 10:15:13 +0100
Message-Id: <1396343741-1524-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do a flush of the AIL list, we are writing out what is
likely to be a lot of small I/Os, which are possibly in an order
which is not ideal performance-wise. Since this is done by calling
filemap_fdatatwrite for each individual inode's address space there
is no overall plugging going on.

In addition to that, we do not always wait for AIL i/o when we flush
it, so that it is possible for things to get left behind on the queue.
By adding explicit plugging here, we reduce the chances of this
being an issues. A quick test using the AIL flush tracepoint shows a
small, but measurable improvement.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 9dcb977..1e1bda0 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/bio.h>
+#include <linux/blkdev.h>
 #include <linux/writeback.h>
 #include <linux/list_sort.h>
 
@@ -145,8 +146,10 @@ void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 {
 	struct list_head *head = &sdp->sd_ail1_list;
 	struct gfs2_trans *tr;
+	struct blk_plug plug;
 
 	trace_gfs2_ail_flush(sdp, wbc, 1);
+	blk_start_plug(&plug);
 	spin_lock(&sdp->sd_ail_lock);
 restart:
 	list_for_each_entry_reverse(tr, head, tr_list) {
@@ -156,6 +159,7 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sdp->sd_ail_lock);
+	blk_finish_plug(&plug);
 	trace_gfs2_ail_flush(sdp, wbc, 0);
 }
 
-- 
1.8.3.1

