Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445Ab3BSTAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:00:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3BSSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Jamie Parsons <Jamie.Parsons@metaswitch.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 60/81] sctp: refactor sctp_outq_teardown to insure proper re-initalization
Date: Tue, 19 Feb 2013 15:49:23 -0300
Message-Id: <1361299784-8830-61-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sctp/outqueue.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a0fa19f..0716290 100644
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
1.7.9.5

