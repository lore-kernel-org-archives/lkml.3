Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3ERDC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:02:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3ERDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:32 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vynWSW92JrsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Jm3g4v_EwJgA:10 a=JDjsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=Hf6muOzgCGQA:10 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.918743974@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bryan Schumaker <bjschuma@netapp.com>, <stable@kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 069/136 ] nfsd: Decode and send 64bit time values
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0069-nfsd-Decode-and-send-64bit-time-values.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

[ Upstream commit bf8d909705e9d9bac31d9b8eac6734d2b51332a7 ]

The seconds field of an nfstime4 structure is 64bit, but we are assuming
that the first 32bits are zero-filled.  So if the client tries to set
atime to a value before the epoch (touch -t 196001010101), then the
server will save the wrong value on disk.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/nfs4xdr.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 551b061..348937b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -343,10 +343,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
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
@@ -369,10 +366,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
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
@@ -2397,8 +2391,7 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_ACCESS) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.atime.tv_sec);
+		WRITE64((s64)stat.atime.tv_sec);
 		WRITE32(stat.atime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
@@ -2411,15 +2404,13 @@ out_acl:
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
-- 
1.7.10.4


