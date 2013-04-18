Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967053Ab3DRJZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:25:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab3DRJSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 52/72] GFS2: Fix unlock of fcntl locks during withdrawn state
Date: Thu, 18 Apr 2013 10:16:37 +0100
Message-Id: <1366276617-3553-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit c2952d202f710d326ac36a8ea6bd216b20615ec8 upstream.

When withdraw occurs, we need to continue to allow unlocks of fcntl
locks to occur, however these will only be local, since the node has
withdrawn from the cluster. This prevents triggering a VFS level
bug trap due to locks remaining when a file is closed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a8a81d7..e756a62 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -900,8 +900,11 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
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
1.8.1.2

