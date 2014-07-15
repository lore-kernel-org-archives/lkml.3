Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbaGOV4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:56:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbaGOViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/198] CIFS: Fix memory leaks in SMB2_open
Date: Tue, 15 Jul 2014 14:28:40 -0700
Message-Id: <1405459868-15089-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 663a962151593c69374776e8651238d0da072459 upstream.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 787e171..63339c5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1089,6 +1089,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int rc = 0;
 	unsigned int num_iovecs = 2;
 	__u32 file_attributes = 0;
+	char *dhc_buf = NULL, *lc_buf = NULL;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1155,6 +1156,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			kfree(copy_path);
 			return rc;
 		}
+		lc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
@@ -1169,9 +1171,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
-			kfree(iov[num_iovecs-1].iov_base);
+			kfree(lc_buf);
 			return rc;
 		}
+		dhc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
@@ -1203,6 +1206,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		*oplock = rsp->OplockLevel;
 creat_exit:
 	kfree(copy_path);
+	kfree(lc_buf);
+	kfree(dhc_buf);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
-- 
1.9.1

