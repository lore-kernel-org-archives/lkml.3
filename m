Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405Ab3GQWzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab3GQWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 145/145] svcrdma: underflow issue in decode_write_list()
Date: Wed, 17 Jul 2013 15:47:57 -0700
Message-Id: <1374101277-7915-146-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b2781e1021525649c0b33fffd005ef219da33926 upstream.

My static checker marks everything from ntohl() as untrusted and it
complains we could have an underflow problem doing:

	return (u32 *)&ary->wc_array[nchunks];

Also on 32 bit systems the upper bound check could overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/xprtrdma/svc_rdma_marshal.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_marshal.c b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
index 8d2eddd..65b1462 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -98,6 +98,7 @@ void svc_rdma_rcl_chunk_counts(struct rpcrdma_read_chunk *ch,
  */
 static u32 *decode_write_list(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 
 	struct rpcrdma_write_array *ary =
@@ -113,9 +114,12 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) > end) {
 		dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
@@ -129,6 +133,7 @@ static u32 *decode_write_list(u32 *va, u32 *vaend)
 
 static u32 *decode_reply_array(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 	struct rpcrdma_write_array *ary =
 		(struct rpcrdma_write_array *)va;
@@ -143,9 +148,12 @@ static u32 *decode_reply_array(u32 *va, u32 *vaend)
 		return NULL;
 	}
 	nchunks = ntohl(ary->wc_nchunks);
-	if (((unsigned long)&ary->wc_array[0] +
-	     (sizeof(struct rpcrdma_write_chunk) * nchunks)) >
-	    (unsigned long)vaend) {
+
+	start = (unsigned long)&ary->wc_array[0];
+	end = (unsigned long)vaend;
+	if (nchunks < 0 ||
+	    nchunks > (SIZE_MAX - start) / sizeof(struct rpcrdma_write_chunk) ||
+	    (start + (sizeof(struct rpcrdma_write_chunk) * nchunks)) > end) {
 		dprintk("svcrdma: ary=%p, wc_nchunks=%d, vaend=%p\n",
 			ary, nchunks, vaend);
 		return NULL;
-- 
1.8.1.2

