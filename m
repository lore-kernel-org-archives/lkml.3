Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3IKFWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:22:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab3IKE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:28 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Yso__KIHSwUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SpT72YaHU-UA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=qRdIvxYzc-zviBVrG4QA:9 a=7DSvI1NPTFQA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042909.440304666@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [103/251] svcrdma: underflow issue in decode_write_list()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0103-svcrdma-underflow-issue-in-decode_write_list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b2781e1021525649c0b33fffd005ef219da33926 ]

My static checker marks everything from ntohl() as untrusted and it
complains we could have an underflow problem doing:

	return (u32 *)&ary->wc_array[nchunks];

Also on 32 bit systems the upper bound check could overflow.

Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sunrpc/xprtrdma/svc_rdma_marshal.c |   20 ++++++++++++++------
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
1.7.10.4


