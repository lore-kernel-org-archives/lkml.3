Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaBEU6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:58:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:54697 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaBEUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 075/213] nfsd4: fix oops on unusual readlike compound
Date: Wed, 5 Feb 2014 15:00:30 -0500
Message-ID: <1391630568-49251-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d5f50b0c290431c65377c4afa1c764e2c3fe5305 upstream.

If the argument and reply together exceed the maximum payload size, then
a reply with a read-like operation can overlow the rq_pages array.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/nfs4xdr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 28d586a5e77e..3800e7680037 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2607,11 +2607,16 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	len = maxcount;
 	v = 0;
 	while (len > 0) {
-		pn = resp->rqstp->rq_resused++;
+		pn = resp->rqstp->rq_resused;
+		if (!resp->rqstp->rq_respages[pn]) { /* ran out of pages */
+			maxcount -= len;
+			break;
+		}
 		resp->rqstp->rq_vec[v].iov_base =
 			page_address(resp->rqstp->rq_respages[pn]);
 		resp->rqstp->rq_vec[v].iov_len =
 			len < PAGE_SIZE ? len : PAGE_SIZE;
+		resp->rqstp->rq_resused++;
 		v++;
 		len -= PAGE_SIZE;
 	}
@@ -2659,6 +2664,8 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	page = page_address(resp->rqstp->rq_respages[resp->rqstp->rq_resused++]);
 
@@ -2708,6 +2715,8 @@ nfsd4_encode_readdir(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	RESERVE_SPACE(8);  /* verifier */
 	savep = p;
-- 
1.8.5.2

