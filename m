Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaDOL2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:28:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:54542 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaDOL2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:28:53 -0400
Subject: [PATCH 2/7] fuse: update mtime on truncate(2)
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:28:52 +0400
Message-ID: <20140415112815.11860.25738.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling truncate(2), VFS doesn't set ATTR_MTIME bit in iattr structure; only
ATTR_SIZE bit is set. In-kernel fuse must handle the case by setting mtime
fields of struct fuse_setattr_in to "now" and set FATTR_MTIME bit even
though ATTR_MTIME was not set.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5b4e035..c7cb41c 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1503,10 +1503,11 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
-			   bool trust_local_mtime)
+static void iattr_to_fattr(struct inode *inode, struct iattr *iattr,
+			   struct fuse_setattr_in *arg, bool trust_local_mtime)
 {
 	unsigned ivalid = iattr->ia_valid;
+	struct timespec now = current_fs_time(inode->i_sb);
 
 	if (ivalid & ATTR_MODE)
 		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
@@ -1529,6 +1530,10 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
 		arg->mtimensec = iattr->ia_mtime.tv_nsec;
 		if (!(ivalid & ATTR_MTIME_SET) && !trust_local_mtime)
 			arg->valid |= FATTR_MTIME_NOW;
+	} else if ((ivalid & ATTR_SIZE) && trust_local_mtime) {
+		arg->valid |= FATTR_MTIME;
+		arg->mtime = now.tv_sec;
+		arg->mtimensec = now.tv_nsec;
 	}
 }
 
@@ -1682,7 +1687,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg, trust_local_mtime);
+	iattr_to_fattr(inode, attr, &inarg, trust_local_mtime);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
@@ -1711,8 +1716,9 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	spin_lock(&fc->lock);
 	/* the kernel maintains i_mtime locally */
-	if (trust_local_mtime && (attr->ia_valid & ATTR_MTIME)) {
-		inode->i_mtime = attr->ia_mtime;
+	if (trust_local_mtime && (attr->ia_valid & (ATTR_MTIME | ATTR_SIZE))) {
+		inode->i_mtime.tv_sec = inarg.mtime;
+		inode->i_mtime.tv_nsec = inarg.mtimensec;
 		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
 	}
 

