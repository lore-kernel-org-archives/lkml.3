Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaA0UQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaA0UQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.13 01/10] GFS2: Increase i_writecount during gfs2_setattr_chown
Date: Mon, 27 Jan 2014 12:17:04 -0800
Message-Id: <20140127201535.454532256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1607,10 +1607,22 @@ static int setattr_chown(struct inode *i
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
@@ -1637,6 +1649,8 @@ out_end_trans:
 	gfs2_trans_end(sdp);
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
+out:
+	put_write_access(inode);
 	return error;
 }
 


