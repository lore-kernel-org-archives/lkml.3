Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaLOTos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:44:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaLOT30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:29:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 44/96] SUNRPC: Fix locking around callback channel reply receive
Date: Mon, 15 Dec 2014 11:26:04 -0800
Message-Id: <1418671616-25482-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 093a1468b6edb0e568be7311b8d2228d205702db upstream.

Both xprt_lookup_rqst() and xprt_complete_rqst() require that you
take the transport lock in order to avoid races with xprt_transmit().

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Reviewed-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/svcsock.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index d06cb87..d4d2a2d 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -989,17 +989,12 @@ static int receive_cb_reply(struct svc_sock *svsk, struct svc_rqst *rqstp)
 	xid = *p++;
 	calldir = *p;
 
-	if (bc_xprt)
-		req = xprt_lookup_rqst(bc_xprt, xid);
-
-	if (!req) {
-		printk(KERN_NOTICE
-			"%s: Got unrecognized reply: "
-			"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
-			__func__, ntohl(calldir),
-			bc_xprt, xid);
+	if (!bc_xprt)
 		return -EAGAIN;
-	}
+	spin_lock_bh(&bc_xprt->transport_lock);
+	req = xprt_lookup_rqst(bc_xprt, xid);
+	if (!req)
+		goto unlock_notfound;
 
 	memcpy(&req->rq_private_buf, &req->rq_rcv_buf, sizeof(struct xdr_buf));
 	/*
@@ -1010,11 +1005,21 @@ static int receive_cb_reply(struct svc_sock *svsk, struct svc_rqst *rqstp)
 	dst = &req->rq_private_buf.head[0];
 	src = &rqstp->rq_arg.head[0];
 	if (dst->iov_len < src->iov_len)
-		return -EAGAIN; /* whatever; just giving up. */
+		goto unlock_eagain; /* whatever; just giving up. */
 	memcpy(dst->iov_base, src->iov_base, src->iov_len);
 	xprt_complete_rqst(req->rq_task, rqstp->rq_arg.len);
 	rqstp->rq_arg.len = 0;
+	spin_unlock_bh(&bc_xprt->transport_lock);
 	return 0;
+unlock_notfound:
+	printk(KERN_NOTICE
+		"%s: Got unrecognized reply: "
+		"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
+		__func__, ntohl(calldir),
+		bc_xprt, ntohl(xid));
+unlock_eagain:
+	spin_unlock_bh(&bc_xprt->transport_lock);
+	return -EAGAIN;
 }
 
 static int copy_pages_to_kvecs(struct kvec *vec, struct page **pages, int len)
-- 
1.9.1

