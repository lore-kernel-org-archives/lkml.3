Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaBJUUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:20:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34554 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBJTlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 009/124] NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
Date: Mon, 10 Feb 2014 11:39:09 -0800
Message-Id: <1392061264-28124-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4xdr.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 26b1439..691a97b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3017,7 +3017,8 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+static bool __decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected,
+		int *nfs_retval)
 {
 	__be32 *p;
 	uint32_t opnum;
@@ -3027,19 +3028,32 @@ static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
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
@@ -4860,11 +4874,12 @@ static int decode_open(struct xdr_stream *xdr, struct nfs_openres *res)
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

