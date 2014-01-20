Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaATMYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaATMYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:42 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/24] GFS2: Increase i_writecount during gfs2_setattr_chown
Date: Mon, 20 Jan 2014 12:23:35 +0000
Message-Id: <1390220627-1571-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch calls get_write_access in function gfs2_setattr_chown,
which merely increases inode->i_writecount for the duration of the
function. That will ensure that any file closes won't delete the
inode's multi-block reservation while the function is running.
It also ensures that a multi-block reservation exists when needed
for quota change operations during the chown.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4acc584..51cf10d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1623,10 +1623,22 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
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
@@ -1653,6 +1665,8 @@ out_end_trans:
 	gfs2_trans_end(sdp);
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
+out:
+	put_write_access(inode);
 	return error;
 }
 
-- 
1.8.3.1

