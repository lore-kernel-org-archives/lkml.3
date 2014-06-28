Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbaF1R7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:59:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaF1RxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.15 113/139] CIFS: Fix memory leaks in SMB2_open
Date: Sat, 28 Jun 2014 10:47:54 -0700
Message-Id: <20140628174610.566262414@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 663a962151593c69374776e8651238d0da072459 upstream.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1089,6 +1089,7 @@ SMB2_open(const unsigned int xid, struct
 	int rc = 0;
 	unsigned int num_iovecs = 2;
 	__u32 file_attributes = 0;
+	char *dhc_buf = NULL, *lc_buf = NULL;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1155,6 +1156,7 @@ SMB2_open(const unsigned int xid, struct
 			kfree(copy_path);
 			return rc;
 		}
+		lc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
@@ -1169,9 +1171,10 @@ SMB2_open(const unsigned int xid, struct
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
@@ -1203,6 +1206,8 @@ SMB2_open(const unsigned int xid, struct
 		*oplock = rsp->OplockLevel;
 creat_exit:
 	kfree(copy_path);
+	kfree(lc_buf);
+	kfree(dhc_buf);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }


