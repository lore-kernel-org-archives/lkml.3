Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaBKTHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaBKTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        J Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 29/79] NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
Date: Tue, 11 Feb 2014 11:05:33 -0800
Message-Id: <20140211184721.764892454@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4xdr.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3002,7 +3002,8 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected)
+static bool __decode_op_hdr(struct xdr_stream *xdr, enum nfs_opnum4 expected,
+		int *nfs_retval)
 {
 	__be32 *p;
 	uint32_t opnum;
@@ -3012,19 +3013,32 @@ static int decode_op_hdr(struct xdr_stre
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
@@ -4842,11 +4856,12 @@ static int decode_open(struct xdr_stream
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
 


