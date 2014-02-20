Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaBUBAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:00:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaBTXu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>
Subject: [PATCH 3.10 07/66] Add protocol specific operation for CIFS xattrs
Date: Thu, 20 Feb 2014 15:51:06 -0800
Message-Id: <20140220234909.697866347@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit d979f3b0a1f0b5499ab85e68cdf02b56852918b6 upstream.

Changeset 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 added protocol
operations for get/setxattr to avoid calling cifs operations
on smb2/smb3 mounts for xattr operations and this changeset
adds the calls to cifs specific protocol operations for xattrs
(in order to reenable cifs support for xattrs which was
temporarily disabled by the previous changeset.  We do not
have SMB2/SMB3 worker function for setting xattrs yet so
this only enables it for cifs.

CCing stable since without these two small changsets (its
small coreq 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 is
also needed) calling getfattr/setfattr on smb2/smb3 mounts
causes problems.

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c   |   13 +++++++++----
 fs/cifs/smb1ops.c |    4 ++++
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -490,10 +490,15 @@ static int cifs_sfu_mode(struct cifs_fat
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	rc = CIFSSMBQAllEAs(xid, tcon, path, "SETFILEBITS",
-			    ea_value, 4 /* size of buf */, cifs_sb->local_nls,
-			    cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (tcon->ses->server->ops->query_all_EAs == NULL) {
+		cifs_put_tlink(tlink);
+		return -EOPNOTSUPP;
+	}
+
+	rc = tcon->ses->server->ops->query_all_EAs(xid, tcon, path,
+			"SETFILEBITS", ea_value, 4 /* size of buf */,
+			cifs_sb->local_nls,
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	cifs_put_tlink(tlink);
 	if (rc < 0)
 		return (int)rc;
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -948,6 +948,10 @@ struct smb_version_operations smb1_opera
 	.mand_lock = cifs_mand_lock,
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
+#ifdef CONFIG_CIFS_XATTR
+	.query_all_EAs = CIFSSMBQAllEAs,
+	.set_EA = CIFSSMBSetEA,
+#endif /* CIFS_XATTR */
 };
 
 struct smb_version_values smb1_values = {


