Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaDOLcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:32:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:54979 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDOLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:32:19 -0400
Subject: [PATCH 6/7] fuse: clear FUSE_I_CTIME_DIRTY flag on setattr
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:32:17 +0400
Message-ID: <20140415113145.11860.2078.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch addresses two use-cases when the flag may be safely cleared:

1. fuse_do_setattr() is called with ATTR_CTIME flag set in attr->ia_valid.
In this case attr->ia_ctime bears actual value. In-kernel fuse must send it
to the userspace server and then assign the value to inode->i_ctime.

2. fuse_do_setattr() is called with ATTR_SIZE flag set in attr->ia_valid,
whereas ATTR_CTIME is not set (truncate(2)).
In this case in-kernel fuse must sent "now" to the userspace server and then
assign the value to inode->i_ctime.

In both cases fuse can clear FUSE_I_CTIME_DIRTY flag because actual ctime
value was flushed to the server.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2187960..3495aaf 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1518,8 +1518,9 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct inode *inode, struct iattr *iattr,
-			   struct fuse_setattr_in *arg, bool trust_local_mtime)
+static void iattr_to_fattr(struct fuse_conn *fc, struct inode *inode,
+			   struct iattr *iattr, struct fuse_setattr_in *arg,
+			   bool trust_local_mtime, struct timespec *ctime)
 {
 	unsigned ivalid = iattr->ia_valid;
 	struct timespec now = current_fs_time(inode->i_sb);
@@ -1550,6 +1551,19 @@ static void iattr_to_fattr(struct inode *inode, struct iattr *iattr,
 		arg->mtime = now.tv_sec;
 		arg->mtimensec = now.tv_nsec;
 	}
+
+	if ((ivalid & ATTR_CTIME) && trust_local_mtime)
+		*ctime = iattr->ia_ctime;
+	else if ((ivalid & ATTR_SIZE) && trust_local_mtime)
+		*ctime = now;
+	else
+		ctime = NULL;
+
+	if (ctime && fc->minor >= 24) {
+		arg->valid |= FATTR_CTIME;
+		arg->ctime = ctime->tv_sec;
+		arg->ctimensec = ctime->tv_nsec;
+	}
 }
 
 /*
@@ -1688,6 +1702,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	loff_t oldsize;
 	int err;
 	bool trust_local_mtime = is_wb && S_ISREG(inode->i_mode);
+	struct timespec ctime;
 
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		attr->ia_valid |= ATTR_FORCE;
@@ -1716,7 +1731,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(inode, attr, &inarg, trust_local_mtime);
+	iattr_to_fattr(fc, inode, attr, &inarg, trust_local_mtime, &ctime);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
@@ -1744,11 +1759,18 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	}
 
 	spin_lock(&fc->lock);
-	/* the kernel maintains i_mtime locally */
-	if (trust_local_mtime && (attr->ia_valid & (ATTR_MTIME | ATTR_SIZE))) {
-		inode->i_mtime.tv_sec = inarg.mtime;
-		inode->i_mtime.tv_nsec = inarg.mtimensec;
-		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+	/* the kernel maintains i_mtime and i_ctime locally */
+	if (trust_local_mtime) {
+		if (attr->ia_valid & (ATTR_MTIME | ATTR_SIZE)) {
+			inode->i_mtime.tv_sec = inarg.mtime;
+			inode->i_mtime.tv_nsec = inarg.mtimensec;
+			clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+		}
+
+		if (attr->ia_valid & (ATTR_CTIME | ATTR_SIZE)) {
+			inode->i_ctime = ctime;
+			clear_bit(FUSE_I_CTIME_DIRTY, &fi->state);
+		}
 	}
 
 	fuse_change_attributes_common(inode, &outarg.attr,

