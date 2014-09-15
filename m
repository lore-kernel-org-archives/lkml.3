Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaIOTrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:47:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaIOTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.10 63/71] CIFS: Fix wrong filename length for SMB2
Date: Mon, 15 Sep 2014 12:27:01 -0700
Message-Id: <20140915192640.797922444@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 1bbe4997b13de903c421c1cc78440e544b5f9064 upstream.

The existing code uses the old MAX_NAME constant. This causes
XFS test generic/013 to fail. Fix it by replacing MAX_NAME with
PATH_MAX that SMB1 uses. Also remove an unused MAX_NAME constant
definition.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h  |    5 -----
 fs/cifs/smb2file.c  |    2 +-
 fs/cifs/smb2inode.c |    2 +-
 fs/cifs/smb2ops.c   |    2 +-
 fs/cifs/smb2pdu.c   |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -74,11 +74,6 @@
 #define SERVER_NAME_LENGTH 40
 #define SERVER_NAME_LEN_WITH_NULL     (SERVER_NAME_LENGTH + 1)
 
-/* used to define string lengths for reversing unicode strings */
-/*         (256+1)*2 = 514                                     */
-/*           (max path length + 1 for null) * 2 for unicode    */
-#define MAX_NAME 514
-
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
 
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -73,7 +73,7 @@ smb2_open_file(const unsigned int xid, s
 		goto out;
 	}
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL) {
 		rc = -ENOMEM;
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -123,7 +123,7 @@ smb2_query_path_info(const unsigned int
 
 	*adjust_tz = false;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -243,7 +243,7 @@ smb2_query_file_info(const unsigned int
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1204,7 +1204,7 @@ SMB2_query_info(const unsigned int xid,
 {
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  FILE_ALL_INFORMATION,
-			  sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			  sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			  sizeof(struct smb2_file_all_info), data);
 }
 


