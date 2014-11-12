Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbaKLBew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525AbaKLBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chucklever@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.17 256/319] nfsd4: fix response size estimation for OP_SEQUENCE
Date: Wed, 12 Nov 2014 10:16:34 +0900
Message-Id: <20141112011035.133428687@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d1d84c9626bb3a519863b3ffc40d347166f9fb83 upstream.

We added this new estimator function but forgot to hook it up.  The
effect is that NFSv4.1 (and greater) won't do zero-copy reads.

The estimate was also wrong by 8 bytes.

Fixes: ccae70a9ee41 "nfsd4: estimate sequence response size"
Reported-by: Chuck Lever <chucklever@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1546,7 +1546,8 @@ static inline u32 nfsd4_rename_rsize(str
 static inline u32 nfsd4_sequence_rsize(struct svc_rqst *rqstp,
 				       struct nfsd4_op *op)
 {
-	return NFS4_MAX_SESSIONID_LEN + 20;
+	return (op_encode_hdr_size
+		+ XDR_QUADLEN(NFS4_MAX_SESSIONID_LEN) + 5) * sizeof(__be32);
 }
 
 static inline u32 nfsd4_setattr_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)
@@ -1850,6 +1851,7 @@ static struct nfsd4_operation nfsd4_ops[
 		.op_func = (nfsd4op_func)nfsd4_sequence,
 		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_AS_FIRST_OP,
 		.op_name = "OP_SEQUENCE",
+		.op_rsize_bop = (nfsd4op_rsize)nfsd4_sequence_rsize,
 	},
 	[OP_DESTROY_CLIENTID] = {
 		.op_func = (nfsd4op_func)nfsd4_destroy_clientid,


