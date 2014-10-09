Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaJIVEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/163] CIFS: Fix wrong filename length for SMB2
Date: Thu,  9 Oct 2014 14:00:36 -0700
Message-Id: <1412888588-26755-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 1bbe4997b13de903c421c1cc78440e544b5f9064 upstream.

The existing code uses the old MAX_NAME constant. This causes
XFS test generic/013 to fail. Fix it by replacing MAX_NAME with
PATH_MAX that SMB1 uses. Also remove an unused MAX_NAME constant
definition.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifsglob.h  | 5 -----
 fs/cifs/smb2file.c  | 2 +-
 fs/cifs/smb2inode.c | 2 +-
 fs/cifs/smb2ops.c   | 2 +-
 fs/cifs/smb2pdu.c   | 2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 292a62f..60aa9b9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -70,11 +70,6 @@
 #define SERVER_NAME_LENGTH 40
 #define SERVER_NAME_LEN_WITH_NULL     (SERVER_NAME_LENGTH + 1)
 
-/* used to define string lengths for reversing unicode strings */
-/*         (256+1)*2 = 514                                     */
-/*           (max path length + 1 for null) * 2 for unicode    */
-#define MAX_NAME 514
-
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3f17b45..4599294 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -50,7 +50,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		goto out;
 	}
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL) {
 		rc = -ENOMEM;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 84c012a..215f8d3 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -131,7 +131,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	*adjust_tz = false;
 	*symlink = false;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a628cf8..34a17d4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -339,7 +339,7 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c4bb71..3adcb22 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1540,7 +1540,7 @@ SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  FILE_ALL_INFORMATION,
-			  sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			  sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			  sizeof(struct smb2_file_all_info), data);
 }
 
-- 
1.9.1

