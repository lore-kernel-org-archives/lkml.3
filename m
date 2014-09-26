Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaIZKFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:05:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbaIZJqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/142] CIFS: Fix wrong filename length for SMB2
Date: Fri, 26 Sep 2014 11:45:22 +0200
Message-Id: <47770ac167aec89d4743afee133ef9f6609ce768.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1bbe4997b13de903c421c1cc78440e544b5f9064 upstream.

The existing code uses the old MAX_NAME constant. This causes
XFS test generic/013 to fail. Fix it by replacing MAX_NAME with
PATH_MAX that SMB1 uses. Also remove an unused MAX_NAME constant
definition.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/cifsglob.h  | 5 -----
 fs/cifs/smb2file.c  | 2 +-
 fs/cifs/smb2inode.c | 2 +-
 fs/cifs/smb2ops.c   | 2 +-
 fs/cifs/smb2pdu.c   | 2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 465b65488b27..d13f77ea0034 100644
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
index 3f17b4550831..45992944e238 100644
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
index 84c012a6aba0..215f8d3e3e53 100644
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
index 4ac88f89a5e5..8956cf67299b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -251,7 +251,7 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7cf843b976fd..fb0c67372a90 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1489,7 +1489,7 @@ SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  FILE_ALL_INFORMATION,
-			  sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			  sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			  sizeof(struct smb2_file_all_info), data);
 }
 
-- 
2.1.0

