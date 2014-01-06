Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaAFXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:40:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaAFWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [PATCH 3.12 103/144] cifs: set FILE_CREATED
Date: Mon,  6 Jan 2014 14:37:44 -0800
Message-Id: <20140106223748.306174882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit f1e3268126a35b9d3cb8bf67487fcc6cd13991d8 upstream.

Set FILE_CREATED on O_CREAT|O_EXCL.

cifs code didn't change during commit 116cc0225381415b96551f725455d067f63a76a0

Kernel bugzilla 66251

Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -193,7 +193,7 @@ check_name(struct dentry *direntry)
 static int
 cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
-	       __u32 *oplock, struct cifs_fid *fid, int *created)
+	       __u32 *oplock, struct cifs_fid *fid)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -349,7 +349,6 @@ cifs_do_create(struct inode *inode, stru
 				.device	= 0,
 		};
 
-		*created |= FILE_CREATED;
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
@@ -480,13 +479,16 @@ cifs_atomic_open(struct inode *inode, st
 	cifs_add_pending_open(&fid, tlink, &open);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, opened);
+			    &oplock, &fid);
 
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
+	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+		*opened |= FILE_CREATED;
+
 	rc = finish_open(file, direntry, generic_file_open, opened);
 	if (rc) {
 		if (server->ops->close)
@@ -529,7 +531,6 @@ int cifs_create(struct inode *inode, str
 	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
 	__u32 oplock;
-	int created = FILE_CREATED;
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p\n",
 		 inode, direntry->d_name.name, direntry);
@@ -546,7 +547,7 @@ int cifs_create(struct inode *inode, str
 		server->ops->new_lease_key(&fid);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &created);
+			    &oplock, &fid);
 	if (!rc && server->ops->close)
 		server->ops->close(xid, tcon, &fid);
 


