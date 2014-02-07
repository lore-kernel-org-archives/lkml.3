Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaBGLYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40892 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaBGLXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 19/88] NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
Date: Fri,  7 Feb 2014 11:22:16 +0000
Message-Id: <1391772205-22239-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c7848f69ec4a8c03732cde5c949bd2aa711a9f4b upstream.

decode_op_hdr() cannot distinguish between an XDR decoding error and
the perfectly valid errorcode NFS4ERR_IO. This is normally not a
problem, but for the particular case of OPEN, we need to be able
to increment the NFSv4 open sequence id when the server returns
a valid response.

Reported-by: J Bruce Fields <bfields@fieldses.org>
Link: http://lkml.kernel.org/r/20131204210356.GA19452@fieldses.org
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4xdr.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index cfce99b..9e2d9a4 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3011,7 +3011,8 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+static bool __decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected,
+		int *nfs_retval)
 {
 	__be32 *p;
 	uint32_t opnum;
@@ -3021,19 +3022,32 @@ static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
 	if (unlikely(!p))
 		goto out_overflow;
 	opnum = be32_to_cpup(p++);
-	if (opnum != expected) {
-		dprintk("nfs: Server returned operation"
-			" %d but we issued a request for %d\n",
-				opnum, expected);
-		return -EIO;
-	}
+	if (unlikely(opnum != expected))
+		goto out_bad_operation;
 	nfserr = be32_to_cpup(p);
-	if (nfserr != NFS_OK)
-		return nfs4_stat_to_errno(nfserr);
-	return 0;
+	if (nfserr == NFS_OK)
+		*nfs_retval = 0;
+	else
+		*nfs_retval = nfs4_stat_to_errno(nfserr);
+	return true;
+out_bad_operation:
+	dprintk("nfs: Server returned operation"
+		" %d but we issued a request for %d\n",
+			opnum, expected);
+	*nfs_retval = -EREMOTEIO;
+	return false;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
-	return -EIO;
+	*nfs_retval = -EIO;
+	return false;
+}
+
+static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+{
+	int retval;
+
+	__decode_op_hdr(xdr, expected, &retval);
+	return retval;
 }
 
 /* Dummy routine */
@@ -4848,11 +4862,12 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
 	uint32_t savewords, bmlen, i;
 	int status;
 
-	status = decode_op_hdr(xdr, OP_OPEN);
-	if (status != -EIO)
-		nfs_increment_open_seqid(status, res->seqid);
-	if (!status)
-		status = decode_stateid(xdr, &res->stateid);
+	if (!__decode_op_hdr(xdr, OP_OPEN, &status))
+		return status;
+	nfs_increment_open_seqid(status, res->seqid);
+	if (status)
+		return status;
+	status = decode_stateid(xdr, &res->stateid);
 	if (unlikely(status))
 		return status;
 
-- 
1.8.3.2

