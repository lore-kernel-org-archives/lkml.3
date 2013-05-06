Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab3EFXUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:20:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab3EFXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 087/104] nfsd: Decode and send 64bit time values
Date: Mon,  6 May 2013 16:12:46 -0700
Message-Id: <20130506230052.583024075@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit bf8d909705e9d9bac31d9b8eac6734d2b51332a7 upstream.

The seconds field of an nfstime4 structure is 64bit, but we are assuming
that the first 32bits are zero-filled.  So if the client tries to set
atime to a value before the epoch (touch -t 196001010101), then the
server will save the wrong value on disk.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -344,10 +344,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_atime.tv_sec);
+			READ64(iattr->ia_atime.tv_sec);
 			READ32(iattr->ia_atime.tv_nsec);
 			if (iattr->ia_atime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -370,10 +367,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_mtime.tv_sec);
+			READ64(iattr->ia_mtime.tv_sec);
 			READ32(iattr->ia_mtime.tv_nsec);
 			if (iattr->ia_mtime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -2386,8 +2380,7 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_ACCESS) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.atime.tv_sec);
+		WRITE64((s64)stat.atime.tv_sec);
 		WRITE32(stat.atime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
@@ -2400,15 +2393,13 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_METADATA) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.ctime.tv_sec);
+		WRITE64((s64)stat.ctime.tv_sec);
 		WRITE32(stat.ctime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_MODIFY) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.mtime.tv_sec);
+		WRITE64((s64)stat.mtime.tv_sec);
 		WRITE32(stat.mtime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {


