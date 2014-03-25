Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaCYRVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaCYRVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <piastry@etersoft.ru>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 25/81] CIFS: Fix too big maxBuf size for SMB3 mounts
Date: Tue, 25 Mar 2014 10:15:38 -0700
Message-Id: <1395767794-5012-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 2365c4eaf077c48574ab6f143960048fc0f31518 upstream.

SMB3 servers can respond with MaxTransactSize of more than 4M
that can cause a memory allocation error returned from kmalloc
in a lock codepath. Also the client doesn't support multicredit
requests now and allows buffer sizes of 65536 bytes only. Set
MaxTransactSize to this maximum supported value.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb2glob.h |  3 +++
 fs/cifs/smb2ops.c  | 14 ++++----------
 fs/cifs/smb2pdu.c  |  4 +++-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 7c0e214..cc592ef 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -55,4 +55,7 @@
 #define SMB2_NTLMV2_SESSKEY_SIZE (16)
 #define SMB2_HMACSHA256_SIZE (32)
 
+/* Maximum buffer size value we can send with 1 credit */
+#define SMB2_MAX_BUFFER_SIZE 65536
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bceffe7..542efd2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -181,11 +181,8 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
-	/*
-	 * limit write size to 2 ** 16, because we don't support multicredit
-	 * requests now.
-	 */
-	wsize = min_t(unsigned int, wsize, 2 << 15);
+	/* set it to the maximum buffer size value we can send with 1 credit */
+	wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
 	return wsize;
 }
@@ -199,11 +196,8 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified rsize, or default */
 	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
-	/*
-	 * limit write size to 2 ** 16, because we don't support multicredit
-	 * requests now.
-	 */
-	rsize = min_t(unsigned int, rsize, 2 << 15);
+	/* set it to the maximum buffer size value we can send with 1 credit */
+	rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
 
 	return rsize;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 41d9d07..8a9b5df 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -407,7 +407,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	}
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
-	server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
+	/* set it to the maximum buffer size value we can send with 1 credit */
+	server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
+			       SMB2_MAX_BUFFER_SIZE);
 	server->max_read = le32_to_cpu(rsp->MaxReadSize);
 	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
 	/* BB Do we need to validate the SecurityMode? */
-- 
1.8.3.2

