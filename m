Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3LRVOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3LRVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Trevor Cordes <trevor@tecnopolis.ca>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.12 094/118] exportfs: fix 32-bit nfsd handling of 64-bit inode numbers
Date: Wed, 18 Dec 2013 13:12:11 -0800
Message-Id: <20131218211222.114496733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 950ee9566a5b6cc45d15f5fe044bab4f1e8b62cb upstream.

Symptoms were spurious -ENOENTs on stat of an NFS filesystem from a
32-bit NFS server exporting a very large XFS filesystem, when the
server's cache is cold (so the inodes in question are not in cache).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Trevor Cordes <trevor@tecnopolis.ca>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exportfs/expfs.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -215,7 +215,7 @@ struct getdents_callback {
 	struct dir_context ctx;
 	char *name;		/* name that was found. It already points to a
 				   buffer NAME_MAX+1 is size */
-	unsigned long ino;	/* the inum we are looking for */
+	u64 ino;		/* the inum we are looking for */
 	int found;		/* inode matched? */
 	int sequence;		/* sequence counter */
 };
@@ -255,10 +255,14 @@ static int get_name(const struct path *p
 	struct inode *dir = path->dentry->d_inode;
 	int error;
 	struct file *file;
+	struct kstat stat;
+	struct path child_path = {
+		.mnt = path->mnt,
+		.dentry = child,
+	};
 	struct getdents_callback buffer = {
 		.ctx.actor = filldir_one,
 		.name = name,
-		.ino = child->d_inode->i_ino
 	};
 
 	error = -ENOTDIR;
@@ -268,6 +272,16 @@ static int get_name(const struct path *p
 	if (!dir->i_fop)
 		goto out;
 	/*
+	 * inode->i_ino is unsigned long, kstat->ino is u64, so the
+	 * former would be insufficient on 32-bit hosts when the
+	 * filesystem supports 64-bit inode numbers.  So we need to
+	 * actually call ->getattr, not just read i_ino:
+	 */
+	error = vfs_getattr_nosec(&child_path, &stat);
+	if (error)
+		return error;
+	buffer.ino = stat.ino;
+	/*
 	 * Open the directory ...
 	 */
 	file = dentry_open(path, O_RDONLY, cred);


