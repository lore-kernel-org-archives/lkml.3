Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaBGLsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaBGLs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/233] GFS2: Increase i_writecount during gfs2_setattr_chown
Date: Fri,  7 Feb 2014 11:44:18 +0000
Message-Id: <1391773652-25214-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 62e96cf81988101fe9e086b2877307b6adda5197 upstream.

This patch calls get_write_access in function gfs2_setattr_chown,
which merely increases inode->i_writecount for the duration of the
function. That will ensure that any file closes won't delete the
inode's multi-block reservation while the function is running.
It also ensures that a multi-block reservation exists when needed
for quota change operations during the chown.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e4bd52f..94b7068 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1608,10 +1608,22 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (!(attr->ia_valid & ATTR_GID) || gid_eq(ogid, ngid))
 		ogid = ngid = NO_GID_QUOTA_CHANGE;
 
-	error = gfs2_quota_lock(ip, nuid, ngid);
+	error = get_write_access(inode);
 	if (error)
 		return error;
 
+	error = gfs2_rs_alloc(ip);
+	if (error)
+		goto out;
+
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		goto out;
+
+	error = gfs2_quota_lock(ip, nuid, ngid);
+	if (error)
+		goto out;
+
 	if (!uid_eq(ouid, NO_UID_QUOTA_CHANGE) ||
 	    !gid_eq(ogid, NO_GID_QUOTA_CHANGE)) {
 		error = gfs2_quota_check(ip, nuid, ngid);
@@ -1638,6 +1650,8 @@ out_end_trans:
 	gfs2_trans_end(sdp);
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
+out:
+	put_write_access(inode);
 	return error;
 }
 
-- 
1.8.3.2

