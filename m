Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3IHDj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:39:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56410 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687Ab3IHDTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, davem@davemloft.net,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        "Neil Horman" <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        "West, Steve (NSN - US/Fort Worth)" <steve.west@nsn.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.251863536@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [010/121] sctp: fully initialize sctp_outq in sctp_outq_init
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit c5c7774d7eb4397891edca9ebdf750ba90977a69 ]

In commit 2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86
(refactor sctp_outq_teardown to insure proper re-initalization)
we modified sctp_outq_teardown to use sctp_outq_init to fully re-initalize the
outq structure.  Steve West recently asked me why I removed the q->error = 0
initalization from sctp_outq_teardown.  I did so because I was operating under
the impression that sctp_outq_init would properly initalize that value for us,
but it doesn't.  sctp_outq_init operates under the assumption that the outq
struct is all 0's (as it is when called from sctp_association_init), but using
it in __sctp_outq_teardown violates that assumption. We should do a memset in
sctp_outq_init to ensure that the entire structure is in a known state there
instead.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: "West, Steve (NSN - US/Fort Worth)" <steve.west@nsn.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: netdev@vger.kernel.org
CC: davem@davemloft.net
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/outqueue.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 96eb168..3dd7207 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -205,6 +205,8 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
+	memset(q, 0, sizeof(struct sctp_outq));
+
 	q->asoc = asoc;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
@@ -212,13 +214,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
 
-	q->fast_rtx = 0;
-	q->outstanding_bytes = 0;
 	q->empty = 1;
-	q->cork  = 0;
-
-	q->malloced = 0;
-	q->out_qlen = 0;
 }
 
 /* Free the outqueue structure and any related pending chunks.

