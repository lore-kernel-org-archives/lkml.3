Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaDAJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaDAJQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/29] GFS2: Remove extra "if" in gfs2_log_flush()
Date: Tue,  1 Apr 2014 10:15:24 +0100
Message-Id: <1396343741-1524-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reordering some of the assignments in gfs2_log_flush() it
is possible to remove one of the "if" statements as it can be
merged with one higher up the function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index c1c9a29..edbd461 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -684,21 +684,19 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	}
 	trace_gfs2_log_flush(sdp, 1);
 
+	sdp->sd_log_flush_head = sdp->sd_log_head;
+	sdp->sd_log_flush_wrapped = 0;
 	tr = sdp->sd_log_tr;
 	if (tr) {
 		sdp->sd_log_tr = NULL;
 		INIT_LIST_HEAD(&tr->tr_ail1_list);
 		INIT_LIST_HEAD(&tr->tr_ail2_list);
+		tr->tr_first = sdp->sd_log_flush_head;
 	}
 
 	gfs2_assert_withdraw(sdp,
 			sdp->sd_log_num_revoke == sdp->sd_log_commited_revoke);
 
-	sdp->sd_log_flush_head = sdp->sd_log_head;
-	sdp->sd_log_flush_wrapped = 0;
-	if (tr)
-		tr->tr_first = sdp->sd_log_flush_head;
-
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp, tr);
 	gfs2_log_flush_bio(sdp, WRITE);
-- 
1.8.3.1

