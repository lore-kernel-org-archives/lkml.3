Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaF3Mrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:47:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbaF3Man (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 162/181] CIFS: Fix memory leaks in SMB2_open
Date: Mon, 30 Jun 2014 13:53:03 +0200
Message-Id: <6d1aea575807f1ab9e63ecc4f1a5c5224ba4901a.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 663a962151593c69374776e8651238d0da072459 upstream.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5818d2ca66f1..829ad35f98d4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1085,6 +1085,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int rc = 0;
 	unsigned int num_iovecs = 2;
 	__u32 file_attributes = 0;
+	char *dhc_buf = NULL, *lc_buf = NULL;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1151,6 +1152,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			kfree(copy_path);
 			return rc;
 		}
+		lc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
@@ -1165,9 +1167,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
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
@@ -1199,6 +1202,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		*oplock = rsp->OplockLevel;
 creat_exit:
 	kfree(copy_path);
+	kfree(lc_buf);
+	kfree(dhc_buf);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
-- 
2.0.0

