Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaAWSjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:39:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaAWSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.10 04/23] GFS2: Increase i_writecount during gfs2_setattr_chown
Date: Thu, 23 Jan 2014 10:39:37 -0800
Message-Id: <20140123183900.335602751@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1536,10 +1536,22 @@ static int setattr_chown(struct inode *i
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
@@ -1566,6 +1578,8 @@ out_end_trans:
 	gfs2_trans_end(sdp);
 out_gunlock_q:
 	gfs2_quota_unlock(ip);
+out:
+	put_write_access(inode);
 	return error;
 }
 


