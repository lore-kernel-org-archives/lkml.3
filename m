Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaCZU32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:29:28 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:47413 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbaCZU30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:29:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwGAO43M1NXQ457/2dsb2JhbABZgwbEBYEdF3SCUxMcIxiBAiQTh30B0VWOcYQ/BJhMAZIzgy88
Date: Wed, 26 Mar 2014 21:29:23 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sfrench <sfrench@samba.org>
Subject: [PATCH 1/1] fs/cifs/dir.c: Error management clean-up
Message-Id: <20140326212923.da7b50d5e44168998855a908@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Don't kfree NULL values.
-Return immediately where possible.
-Normalize label names.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/dir.c | 57 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 3db0c5f..7de6ee0 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -212,10 +212,8 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		*oplock = REQ_OPLOCK;
 
 	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (full_path == NULL)
+		return -ENOMEM;
 
 	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
@@ -269,7 +267,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 			break;
 
 		default:
-			goto out;
+			goto cifs_create_free_full_path;
 		}
 		/*
 		 * fallthrough to retry, using older open call, this is case
@@ -302,13 +300,13 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 
 	if (!server->ops->open) {
 		rc = -ENOSYS;
-		goto out;
+		goto cifs_create_free_full_path;
 	}
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
-		goto out;
+		goto cifs_create_free_full_path;
 	}
 
 	/*
@@ -333,7 +331,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
-		goto out;
+		goto cifs_create_free_buf;
 	}
 
 	/*
@@ -401,13 +399,15 @@ cifs_create_set_dentry:
 			 rc);
 		if (server->ops->close)
 			server->ops->close(xid, tcon, fid);
-		goto out;
+		goto cifs_create_free_buf;
 	}
 	d_drop(direntry);
 	d_add(direntry, newinode);
 
-out:
+cifs_create_free_buf:
 	kfree(buf);
+
+cifs_create_free_full_path:
 	kfree(full_path);
 	return rc;
 }
@@ -467,7 +467,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	if (IS_ERR(tlink)) {
 		rc = PTR_ERR(tlink);
-		goto out_free_xid;
+		goto cifs_ao_free_xid;
 	}
 
 	tcon = tlink_tcon(tlink);
@@ -483,7 +483,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	if (rc) {
 		cifs_del_pending_open(&open);
-		goto out;
+		goto cifs_ao_put_tlink;
 	}
 
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
@@ -494,7 +494,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
-		goto out;
+		goto cifs_ao_put_tlink;
 	}
 
 	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
@@ -506,9 +506,10 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		rc = -ENOMEM;
 	}
 
-out:
+cifs_ao_put_tlink:
 	cifs_put_tlink(tlink);
-out_free_xid:
+
+cifs_ao_free_xid:
 	free_xid(xid);
 	return rc;
 }
@@ -538,7 +539,7 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
 	if (IS_ERR(tlink))
-		goto out_free_xid;
+		goto cifs_create_free_xid;
 
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
@@ -552,7 +553,8 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 		server->ops->close(xid, tcon, &fid);
 
 	cifs_put_tlink(tlink);
-out_free_xid:
+
+cifs_create_free_xid:
 	free_xid(xid);
 	return rc;
 }
@@ -591,7 +593,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto mknod_out;
+		goto cifs_mknod_free_xid;
 	}
 
 	if (tcon->unix_ext) {
@@ -614,18 +616,18 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 					    cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if (rc)
-			goto mknod_out;
+			goto cifs_mknod_free_full_path;
 
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 						inode->i_sb, xid);
 
 		if (rc == 0)
 			d_instantiate(direntry, newinode);
-		goto mknod_out;
+		goto cifs_mknod_free_full_path;
 	}
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		goto mknod_out;
+		goto cifs_mknod_free_full_path;
 
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
@@ -652,7 +654,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 
 	rc = CIFS_open(xid, &oparms, &oplock, buf);
 	if (rc)
-		goto mknod_out;
+		goto cifs_mknod_free_full_path;
 
 	/*
 	 * BB Do not bother to decode buf since no local inode yet to put
@@ -683,9 +685,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 
 	/* FIXME: add code here to set EAs */
 
-mknod_out:
+cifs_mknod_free_full_path:
 	kfree(full_path);
 	kfree(buf);
+
+cifs_mknod_free_xid:
 	free_xid(xid);
 	cifs_put_tlink(tlink);
 	return rc;
@@ -720,7 +724,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	rc = check_name(direntry);
 	if (rc)
-		goto lookup_out;
+		goto cifs_lookup_put_tlink;
 
 	/* can not grab the rename sem here since it would
 	deadlock in the cases (beginning of sys_rename itself)
@@ -728,7 +732,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto lookup_out;
+		goto cifs_lookup_put_tlink;
 	}
 
 	if (direntry->d_inode != NULL) {
@@ -765,8 +769,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		is a common return code */
 	}
 
-lookup_out:
 	kfree(full_path);
+
+cifs_lookup_put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return ERR_PTR(rc);
