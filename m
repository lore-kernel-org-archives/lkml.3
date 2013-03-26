Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3CZSAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:00:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3CZRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:06 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jOoP0IpjmfYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JVG3GFNzwGMA:10 a=vmLDa1wCAAAA:8 a=bwR9eBR2AAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=N80PJI9gs7BUv204s0gA:9 a=gv_BBZfBKR8A:10 a=1Rxr-DKSoAkA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173603.722733784@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Jamie Parsons <Jamie.Parsons@metaswitch.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 24/86] sctp: refactor sctp_outq_teardown to insure proper re-initalization
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0024-sctp-refactor-sctp_outq_teardown-to-insure-proper-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86 ]

Jamie Parsons reported a problem recently, in which the re-initalization of an
association (The duplicate init case), resulted in a loss of receive window
space.  He tracked down the root cause to sctp_outq_teardown, which discarded
all the data on an outq during a re-initalization of the corresponding
association, but never reset the outq->outstanding_data field to zero.  I wrote,
and he tested this fix, which does a proper full re-initalization of the outq,
fixing this problem, and hopefully future proofing us from simmilar issues down
the road.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Jamie Parsons <Jamie.Parsons@metaswitch.com>
Tested-by: Jamie Parsons <Jamie.Parsons@metaswitch.com>
CC: Jamie Parsons <Jamie.Parsons@metaswitch.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sctp/outqueue.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e7aa177c..e0902c9 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -223,7 +223,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 
 /* Free the outqueue structure and any related pending chunks.
  */
-void sctp_outq_teardown(struct sctp_outq *q)
+static void __sctp_outq_teardown(struct sctp_outq *q)
 {
 	struct sctp_transport *transport;
 	struct list_head *lchunk, *temp;
@@ -276,8 +276,6 @@ void sctp_outq_teardown(struct sctp_outq *q)
 		sctp_chunk_free(chunk);
 	}
 
-	q->error = 0;
-
 	/* Throw away any leftover control chunks. */
 	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
 		list_del_init(&chunk->list);
@@ -285,11 +283,17 @@ void sctp_outq_teardown(struct sctp_outq *q)
 	}
 }
 
+void sctp_outq_teardown(struct sctp_outq *q)
+{
+	__sctp_outq_teardown(q);
+	sctp_outq_init(q->asoc, q);
+}
+
 /* Free the outqueue structure and any related pending chunks.  */
 void sctp_outq_free(struct sctp_outq *q)
 {
 	/* Throw away leftover chunks. */
-	sctp_outq_teardown(q);
+	__sctp_outq_teardown(q);
 
 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
-- 
1.7.10.4


