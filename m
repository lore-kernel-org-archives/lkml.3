Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3BQXFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:05:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338Ab3BQWz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:27 -0500
Message-Id: <20130217225007.791299943@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Neil Horman <nhorman@tuxdriver.com>,
        Jamie Parsons <Jamie.Parsons@metaswitch.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/66] sctp: refactor sctp_outq_teardown to insure proper  re-initalization
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/outqueue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index cfeb1d4..96eb168 100644
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


