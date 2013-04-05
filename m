Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161839Ab3DEKYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175Ab3DEKYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/6] GFS2: Fix unlock of fcntl locks during withdrawn state
Date: Fri,  5 Apr 2013 10:57:14 +0100
Message-Id: <1365155836-3069-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When withdraw occurs, we need to continue to allow unlocks of fcntl
locks to occur, however these will only be local, since the node has
withdrawn from the cluster. This prevents triggering a VFS level
bug trap due to locks remaining when a file is closed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 019f45e..d79c2da 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -923,8 +923,11 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (fl->fl_type == F_UNLCK)
+			posix_lock_file_wait(file, fl);
 		return -EIO;
+	}
 	if (IS_GETLK(cmd))
 		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)
-- 
1.7.4

