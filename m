Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966539AbaLLGzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:55:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51760 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758677AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        "Jeff Layton" <jlayton@primarydata.com>,
        "Trond Myklebust" <trond.myklebust@primarydata.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.710625318@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 141/164] SUNRPC: Fix locking around callback channel
 reply receive
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 093a1468b6edb0e568be7311b8d2228d205702db upstream.

Both xprt_lookup_rqst() and xprt_complete_rqst() require that you
take the transport lock in order to avoid races with xprt_transmit().

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Reviewed-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svcsock.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1054,17 +1054,12 @@ static int receive_cb_reply(struct svc_s
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
-			bc_xprt, ntohl(xid));
+	if (!bc_xprt)
 		return -EAGAIN;
-	}
+	spin_lock_bh(&bc_xprt->transport_lock);
+	req = xprt_lookup_rqst(bc_xprt, xid);
+	if (!req)
+		goto unlock_notfound;
 
 	memcpy(&req->rq_private_buf, &req->rq_rcv_buf, sizeof(struct xdr_buf));
 	/*
@@ -1075,11 +1070,21 @@ static int receive_cb_reply(struct svc_s
 	dst = &req->rq_private_buf.head[0];
 	src = &rqstp->rq_arg.head[0];
 	if (dst->iov_len < src->iov_len)
-		return -EAGAIN; /* whatever; just giving up. */
+		goto unlock_eagain; /* whatever; just giving up. */
 	memcpy(dst->iov_base, src->iov_base, src->iov_len);
 	xprt_complete_rqst(req->rq_task, svsk->sk_reclen);
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

