Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbbAPOkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:40:16 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39392 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbAPOkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:40:14 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] infiniband: Help gcc generate better code for ocrdma_srq_toggle_bit
Date: Fri, 16 Jan 2015 15:39:55 +0100
Message-Id: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc emits a surprising amount of code in order to flip a bit. One
would think that a single instruction is enough.

$ scripts/bloat-o-meter /tmp/ocrdma_verbs.o drivers/infiniband/hw/ocrdma/ocrdma_verbs.o
add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-142 (-142)
function                                     old     new   delta
ocrdma_post_srq_recv                         498     460     -38
ocrdma_poll_cq                              2010    1962     -48
ocrdma_discard_cqes                          495     439     -56

All three calls of ocrdma_srq_toggle_bit happen within spinlocks, so
saving a few useless instructions might be worthwhile.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fb8d8c4dfbb9..eff11e6c6183 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1484,10 +1484,7 @@ static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
 	int i = idx / 32;
 	unsigned int mask = (1 << (idx % 32));
 
-	if (srq->idx_bit_fields[i] & mask)
-		srq->idx_bit_fields[i] &= ~mask;
-	else
-		srq->idx_bit_fields[i] |= mask;
+	srq->idx_bit_fields[i] ^= mask;
 }
 
 static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
-- 
2.1.3

