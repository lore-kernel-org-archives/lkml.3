Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3APQF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3APQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 131/222] nfsd4: fix oops on unusual readlike compound
Date: Wed, 16 Jan 2013 13:55:31 -0200
Message-Id: <1358351822-7675-132-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d5f50b0c290431c65377c4afa1c764e2c3fe5305 upstream.

If the argument and reply together exceed the maximum payload size, then
a reply with a read-like operation can overlow the rq_pages array.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfs4xdr.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6322df3..1e83186 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2946,11 +2946,16 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
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
@@ -2996,6 +3001,8 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	page = page_address(resp->rqstp->rq_respages[resp->rqstp->rq_resused++]);
 
@@ -3045,6 +3052,8 @@ nfsd4_encode_readdir(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	RESERVE_SPACE(NFS4_VERIFIER_SIZE);
 	savep = p;
-- 
1.7.9.5

