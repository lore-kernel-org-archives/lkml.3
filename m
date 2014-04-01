Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaDAJTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaDAJQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/29] GFS2: Re-add a call to log_flush_wait when flushing the journal
Date: Tue,  1 Apr 2014 10:15:35 +0100
Message-Id: <1396343741-1524-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Upstream commit 34cc178 changed a line of code from calling function
log_flush_commit to calling log_write_header. This had the effect of
eliminating a call to function log_flush_wait. That causes the journal
to skip over log headers, which results in multiple wrap points,
which itself leads to infinite loops in journal replay, both in the
kernel code and fsck.gfs2 code. This patch re-adds that call.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index edbd461..4a14d50 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -702,6 +702,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	gfs2_log_flush_bio(sdp, WRITE);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
+		log_flush_wait(sdp);
 		log_write_header(sdp, 0);
 	} else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
-- 
1.8.3.1

