Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbaCEPWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:22:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbaCEOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <piastry@etersoft.ru>, Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/131] CIFS: Fix too big maxBuf size for SMB3 mounts
Date: Wed,  5 Mar 2014 14:22:38 +0000
Message-Id: <1394029455-23128-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/smb2glob.h |  3 +++
 fs/cifs/smb2ops.c  | 14 ++++----------
 fs/cifs/smb2pdu.c  |  4 +++-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index c383508..bc0bb9c 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -57,4 +57,7 @@
 #define SMB2_CMACAES_SIZE (16)
 #define SMB3_SIGNKEY_SIZE (16)
 
+/* Maximum buffer size value we can send with 1 credit */
+#define SMB2_MAX_BUFFER_SIZE 65536
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f259e6c..ef476d3 100644
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
index abc9c28..a826043 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -413,7 +413,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	/* SMB2 only has an extended negflavor */
 	server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
-	server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
+	/* set it to the maximum buffer size value we can send with 1 credit */
+	server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
+			       SMB2_MAX_BUFFER_SIZE);
 	server->max_read = le32_to_cpu(rsp->MaxReadSize);
 	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
 	/* BB Do we need to validate the SecurityMode? */
-- 
1.9.0

