Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3APQGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3APQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 135/222] cifs: don't compare uniqueids in cifs_prime_dcache unless server inode numbers are in use
Date: Wed, 16 Jan 2013 13:55:35 -0200
Message-Id: <1358351822-7675-136-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 2f2591a34db6c9361faa316c91a6e320cb4e6aee upstream.

Oliver reported that commit cd60042c caused his cifs mounts to
continually thrash through new inodes on readdir. His servers are not
sending inode numbers (or he's not using them), and the new test in
that function doesn't account for that sort of setup correctly.

If we're not using server inode numbers, then assume that the inode
attached to the dentry hasn't changed. Go ahead and update the
attributes in place, but keep the same inode number.

Reported-and-Tested-by: Oliver MÃ¶ssinger <Oliver.Moessinger@ichaus.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
[ herton: function was still named cifs_readdir_lookup on 3.5, adjusted
  to also return dentry ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/cifs/readdir.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index a4217f0..6cb83b9 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -76,6 +76,7 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	struct dentry *dentry, *alias;
 	struct inode *inode;
 	struct super_block *sb = parent->d_inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
 	cFYI(1, "For %s", name->name);
 
@@ -87,10 +88,20 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	dentry = d_lookup(parent, name);
 	if (dentry) {
 		inode = dentry->d_inode;
-		/* update inode in place if i_ino didn't change */
-		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
-			cifs_fattr_to_inode(inode, fattr);
-			return dentry;
+		if (inode) {
+			/*
+			 * If we're generating inode numbers, then we don't
+			 * want to clobber the existing one with the one that
+			 * the readdir code created.
+			 */
+			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
+
+			/* update inode in place if i_ino didn't change */
+			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+				cifs_fattr_to_inode(inode, fattr);
+				return dentry;
+			}
 		}
 		d_drop(dentry);
 		dput(dentry);
-- 
1.7.9.5

