Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaKKLKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaKKLKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 099/170] nfsd4: fix response size estimation for OP_SEQUENCE
Date: Tue, 11 Nov 2014 11:07:38 +0000
Message-Id: <1415704129-12709-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d1d84c9626bb3a519863b3ffc40d347166f9fb83 upstream.

We added this new estimator function but forgot to hook it up.  The
effect is that NFSv4.1 (and greater) won't do zero-copy reads.

The estimate was also wrong by 8 bytes.

Fixes: ccae70a9ee41 "nfsd4: estimate sequence response size"
Reported-by: Chuck Lever <chucklever@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8f029db5d271..2cbe5d09166a 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1555,7 +1555,8 @@ static inline u32 nfsd4_rename_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op
 static inline u32 nfsd4_sequence_rsize(struct svc_rqst *rqstp,
 				       struct nfsd4_op *op)
 {
-	return NFS4_MAX_SESSIONID_LEN + 20;
+	return (op_encode_hdr_size
+		+ XDR_QUADLEN(NFS4_MAX_SESSIONID_LEN) + 5) * sizeof(__be32);
 }
 
 static inline u32 nfsd4_setattr_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)
@@ -1859,6 +1860,7 @@ static struct nfsd4_operation nfsd4_ops[] = {
 		.op_func = (nfsd4op_func)nfsd4_sequence,
 		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_AS_FIRST_OP,
 		.op_name = "OP_SEQUENCE",
+		.op_rsize_bop = (nfsd4op_rsize)nfsd4_sequence_rsize,
 	},
 	[OP_DESTROY_CLIENTID] = {
 		.op_func = (nfsd4op_func)nfsd4_destroy_clientid,
-- 
2.1.0

