Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3FDWo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:27 -0400
Received: from 1wt.eu ([62.212.114.60]:35885 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3FDWoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:23 -0400
Message-Id: <20130604172136.231606591@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 143/184] nfsd4: fix oops on unusual readlike compound
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d5f50b0c290431c65377c4afa1c764e2c3fe5305 upstream.

If the argument and reply together exceed the maximum payload size, then
a reply with a read-like operation can overlow the rq_pages array.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfsd/nfs4xdr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6d27757..ab87b05 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2610,11 +2610,16 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
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
@@ -2662,6 +2667,8 @@ nfsd4_encode_readlink(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	page = page_address(resp->rqstp->rq_respages[resp->rqstp->rq_resused++]);
 
@@ -2711,6 +2718,8 @@ nfsd4_encode_readdir(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	RESERVE_SPACE(8);  /* verifier */
 	savep = p;
-- 
1.7.12.2.21.g234cd45.dirty



