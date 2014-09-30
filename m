Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaI3Vdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:33:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaI3VcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/103] CIFS: Fix SMB2 readdir error handling
Date: Tue, 30 Sep 2014 14:30:23 -0700
Message-Id: <1412112708-27356-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 52755808d4525f4d5b86d112d36ffc7a46f3fb48 upstream.

SMB2 servers indicates the end of a directory search with
STATUS_NO_MORE_FILE error code that is not processed now.
This causes generic/257 xfstest to fail. Fix this by triggering
the end of search by this error code in SMB2_query_directory.

Also when negotiating CIFS protocol we tell the server to close
the search automatically at the end and there is no need to do
it itself. In the case of SMB2 protocol, we need to close it
explicitly - separate close directory checks for different
protocols.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifsglob.h     | 2 ++
 fs/cifs/file.c         | 2 +-
 fs/cifs/readdir.c      | 2 +-
 fs/cifs/smb1ops.c      | 7 +++++++
 fs/cifs/smb2maperror.c | 2 +-
 fs/cifs/smb2ops.c      | 9 +++++++++
 fs/cifs/smb2pdu.c      | 9 ++++-----
 7 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dce9208..292a62f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -397,6 +397,8 @@ struct smb_version_operations {
 			const char *, u32 *);
 	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
 			int);
+	/* check if we need to issue closedir */
+	bool (*dir_needs_close)(struct cifsFileInfo *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dd4aaca..e157583 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -762,7 +762,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 
 	cifs_dbg(FYI, "Freeing private data in close dir\n");
 	spin_lock(&cifs_file_list_lock);
-	if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+	if (server->ops->dir_needs_close(cfile)) {
 		cfile->invalidHandle = true;
 		spin_unlock(&cifs_file_list_lock);
 		if (server->ops->close_dir)
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5940eca..b2d1430 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -593,7 +593,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		/* close and restart search */
 		cifs_dbg(FYI, "search backing up - close and restart search\n");
 		spin_lock(&cifs_file_list_lock);
-		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+		if (server->ops->dir_needs_close(cfile)) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
 			if (server->ops->close)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index e936e26..c66a726 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -954,6 +954,12 @@ cifs_is_read_op(__u32 oplock)
 	return oplock == OPLOCK_READ;
 }
 
+static bool
+cifs_dir_needs_close(struct cifsFileInfo *cfile)
+{
+	return !cfile->srch_inf.endOfSearch && !cfile->invalidHandle;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -1022,6 +1028,7 @@ struct smb_version_operations smb1_operations = {
 	.push_mand_locks = cifs_push_mandatory_locks,
 	.query_mf_symlink = open_query_close_cifs_symlink,
 	.is_read_op = cifs_is_read_op,
+	.dir_needs_close = cifs_dir_needs_close,
 #ifdef CONFIG_CIFS_XATTR
 	.query_all_EAs = CIFSSMBQAllEAs,
 	.set_EA = CIFSSMBSetEA,
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index e31a9df..a689514 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -214,7 +214,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_BREAKPOINT, -EIO, "STATUS_BREAKPOINT"},
 	{STATUS_SINGLE_STEP, -EIO, "STATUS_SINGLE_STEP"},
 	{STATUS_BUFFER_OVERFLOW, -EIO, "STATUS_BUFFER_OVERFLOW"},
-	{STATUS_NO_MORE_FILES, -EIO, "STATUS_NO_MORE_FILES"},
+	{STATUS_NO_MORE_FILES, -ENODATA, "STATUS_NO_MORE_FILES"},
 	{STATUS_WAKE_SYSTEM_DEBUGGER, -EIO, "STATUS_WAKE_SYSTEM_DEBUGGER"},
 	{STATUS_HANDLES_CLOSED, -EIO, "STATUS_HANDLES_CLOSED"},
 	{STATUS_NO_INHERITANCE, -EIO, "STATUS_NO_INHERITANCE"},
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 35ddc3e..a628cf8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1102,6 +1102,12 @@ smb3_parse_lease_buf(void *buf, unsigned int *epoch)
 	return le32_to_cpu(lc->lcontext.LeaseState);
 }
 
+static bool
+smb2_dir_needs_close(struct cifsFileInfo *cfile)
+{
+	return !cfile->invalidHandle;
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -1175,6 +1181,7 @@ struct smb_version_operations smb20_operations = {
 	.create_lease_buf = smb2_create_lease_buf,
 	.parse_lease_buf = smb2_parse_lease_buf,
 	.clone_range = smb2_clone_range,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -1250,6 +1257,7 @@ struct smb_version_operations smb21_operations = {
 	.create_lease_buf = smb2_create_lease_buf,
 	.parse_lease_buf = smb2_parse_lease_buf,
 	.clone_range = smb2_clone_range,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -1328,6 +1336,7 @@ struct smb_version_operations smb30_operations = {
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.clone_range = smb2_clone_range,
 	.validate_negotiate = smb3_validate_negotiate,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ec2c0ac..2c4bb71 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2135,6 +2135,10 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
 
 	if (rc) {
+		if (rc == -ENODATA && rsp->hdr.Status == STATUS_NO_MORE_FILES) {
+			srch_inf->endOfSearch = true;
+			rc = 0;
+		}
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
 		goto qdir_exit;
 	}
@@ -2172,11 +2176,6 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifs_dbg(VFS, "illegal search buffer type\n");
 
-	if (rsp->hdr.Status == STATUS_NO_MORE_FILES)
-		srch_inf->endOfSearch = 1;
-	else
-		srch_inf->endOfSearch = 0;
-
 	return rc;
 
 qdir_exit:
-- 
1.9.1

