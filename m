Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab3HBKKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030260Ab3HBKKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 51/99] svcrdma: underflow issue in decode_write_list()
Date: Fri,  2 Aug 2013 18:08:04 +0800
Message-Id: <20130802100233.160005466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b2781e1021525649c0b33fffd005ef219da33926 upstream.

My static checker marks everything from ntohl() as untrusted and it
complains we could have an underflow problem doing:

	return (u32 *)&ary->wc_array[nchunks];

Also on 32 bit systems the upper bound check could overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/svc_rdma_marshal.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -98,6 +98,7 @@ void svc_rdma_rcl_chunk_counts(struct rp
  */
 static u32 *decode_write_list(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 
 	struct rpcrdma_write_array *ary =
@@ -113,9 +114,12 @@ static u32 *decode_write_list(u32 *va, u
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
@@ -129,6 +133,7 @@ static u32 *decode_write_list(u32 *va, u
 
 static u32 *decode_reply_array(u32 *va, u32 *vaend)
 {
+	unsigned long start, end;
 	int nchunks;
 	struct rpcrdma_write_array *ary =
 		(struct rpcrdma_write_array *)va;
@@ -143,9 +148,12 @@ static u32 *decode_reply_array(u32 *va,
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


