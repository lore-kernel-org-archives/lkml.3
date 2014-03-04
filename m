Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbaCDUdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:33:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaCDUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [PATCH 3.10 16/97] CIFS: Fix too big maxBuf size for SMB3 mounts
Date: Tue,  4 Mar 2014 12:03:29 -0800
Message-Id: <20140304200346.625142781@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2glob.h |    3 +++
 fs/cifs/smb2ops.c  |   14 ++++----------
 fs/cifs/smb2pdu.c  |    3 +++
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -55,4 +55,7 @@
 #define SMB2_NTLMV2_SESSKEY_SIZE (16)
 #define SMB2_HMACSHA256_SIZE (32)
 
+/* Maximum buffer size value we can send with 1 credit */
+#define SMB2_MAX_BUFFER_SIZE 65536
+
 #endif	/* _SMB2_GLOB_H */
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -181,11 +181,8 @@ smb2_negotiate_wsize(struct cifs_tcon *t
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
@@ -199,11 +196,8 @@ smb2_negotiate_rsize(struct cifs_tcon *t
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
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -408,6 +408,9 @@ SMB2_negotiate(const unsigned int xid, s
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
+	/* set it to the maximum buffer size value we can send with 1 credit */
+	server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
+			       SMB2_MAX_BUFFER_SIZE);
 	server->max_read = le32_to_cpu(rsp->MaxReadSize);
 	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
 	/* BB Do we need to validate the SecurityMode? */


