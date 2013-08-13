Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3HMGkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:40:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab3HMGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 08/12] cifs: silence compiler warnings showing up with gcc-4.7.0
Date: Mon, 12 Aug 2013 23:35:43 -0700
Message-Id: <20130813063520.918853027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063520.285638946@linuxfoundation.org>
References: <20130813063520.285638946@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit b2a3ad9ca502169fc4c11296fa20f56059c7c031 upstream.

gcc-4.7.0 has started throwing these warnings when building cifs.ko.

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function ‘CIFSSMBSetCIFSACL’:
fs/cifs/cifssmb.c:3905:9: warning: array subscript is above array bounds [-Warray-bounds]
fs/cifs/cifssmb.c: In function ‘CIFSSMBSetFileInfo’:
fs/cifs/cifssmb.c:5711:8: warning: array subscript is above array bounds [-Warray-bounds]
fs/cifs/cifssmb.c: In function ‘CIFSSMBUnixSetFileInfo’:
fs/cifs/cifssmb.c:6001:25: warning: array subscript is above array bounds [-Warray-bounds]

This patch cleans up the code a bit by using the offsetof macro instead
of the funky "&pSMB->hdr.Protocol" construct.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifssmb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3473,13 +3473,12 @@ CIFSSMBSetCIFSACL(const int xid, struct
 	int rc = 0;
 	int bytes_returned = 0;
 	SET_SEC_DESC_REQ *pSMB = NULL;
-	NTRANSACT_RSP *pSMBr = NULL;
+	void *pSMBr;
 
 setCifsAclRetry:
-	rc = smb_init(SMB_COM_NT_TRANSACT, 19, tcon, (void **) &pSMB,
-			(void **) &pSMBr);
+	rc = smb_init(SMB_COM_NT_TRANSACT, 19, tcon, (void **) &pSMB, &pSMBr);
 	if (rc)
-			return (rc);
+		return rc;
 
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
@@ -3507,9 +3506,8 @@ setCifsAclRetry:
 	pSMB->AclFlags = cpu_to_le32(CIFS_ACL_DACL);
 
 	if (pntsd && acllen) {
-		memcpy((char *) &pSMBr->hdr.Protocol + data_offset,
-			(char *) pntsd,
-			acllen);
+		memcpy((char *)pSMBr + offsetof(struct smb_hdr, Protocol) +
+				data_offset, pntsd, acllen);
 		inc_rfc1001_len(pSMB, byte_count + data_count);
 	} else
 		inc_rfc1001_len(pSMB, byte_count);
@@ -5291,7 +5289,8 @@ CIFSSMBSetFileInfo(const int xid, struct
 	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
 	offset = param_offset + params;
 
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+	data_offset = (char *)pSMB +
+			offsetof(struct smb_hdr, Protocol) + offset;
 
 	count = sizeof(FILE_BASIC_INFO);
 	pSMB->MaxParameterCount = cpu_to_le16(2);
@@ -5560,7 +5559,7 @@ CIFSSMBUnixSetFileInfo(const int xid, st
 		       u16 fid, u32 pid_of_opener)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
-	FILE_UNIX_BASIC_INFO *data_offset;
+	char *data_offset;
 	int rc = 0;
 	u16 params, param_offset, offset, byte_count, count;
 
@@ -5582,8 +5581,9 @@ CIFSSMBUnixSetFileInfo(const int xid, st
 	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
 	offset = param_offset + params;
 
-	data_offset = (FILE_UNIX_BASIC_INFO *)
-				((char *)(&pSMB->hdr.Protocol) + offset);
+	data_offset = (char *)pSMB +
+			offsetof(struct smb_hdr, Protocol) + offset;
+
 	count = sizeof(FILE_UNIX_BASIC_INFO);
 
 	pSMB->MaxParameterCount = cpu_to_le16(2);
@@ -5605,7 +5605,7 @@ CIFSSMBUnixSetFileInfo(const int xid, st
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 
-	cifs_fill_unix_set_info(data_offset, args);
+	cifs_fill_unix_set_info((FILE_UNIX_BASIC_INFO *)data_offset, args);
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc)


