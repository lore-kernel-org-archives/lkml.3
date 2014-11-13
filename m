Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaKMTb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:31:27 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:58426 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaKMTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:24:59 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 01/16] crypto: caam - Remove unnecessary smp_read_barrier_depends()
Date: Thu, 13 Nov 2014 14:24:07 -0500
Message-Id: <1415906662-4576-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/crypto/caam/jr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index bae20d8..9b3ef1bc 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -181,8 +181,6 @@ static void caam_jr_dequeue(unsigned long devarg)
 		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
 			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
 
-			smp_read_barrier_depends();
-
 			if (jrp->outring[hw_idx].desc ==
 			    jrp->entinfo[sw_idx].desc_addr_dma)
 				break; /* found */
@@ -218,7 +216,6 @@ static void caam_jr_dequeue(unsigned long devarg)
 		if (sw_idx == tail) {
 			do {
 				tail = (tail + 1) & (JOBR_DEPTH - 1);
-				smp_read_barrier_depends();
 			} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
 				 jrp->entinfo[tail].desc_addr_dma == 0);
 
-- 
1.9.1

