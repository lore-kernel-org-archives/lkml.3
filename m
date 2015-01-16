Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbbAPOkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:40:21 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59925 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbAPOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:40:17 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] infiniband: Use unsigned for bit index
Date: Fri, 16 Jan 2015 15:39:56 +0100
Message-Id: <1421419196-4659-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the expressions idx/32 and idx%32, both idx and 32 have signed
type, and unfortunately the C standard prescribes rounding to 0, so
unless gcc can prove that idx is non-negative, these cannot be
implemented as simple shift respectively mask operations. Help gcc by
changing the type of idx to unsigned - this cuts another few
instructions from the generated code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index eff11e6c6183..61c3047f5170 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1479,10 +1479,10 @@ mbx_err:
 	return status;
 }
 
-static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
+static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, unsigned int idx)
 {
-	int i = idx / 32;
-	unsigned int mask = (1 << (idx % 32));
+	unsigned int i = idx / 32;
+	u32 mask = (1U << (idx % 32));
 
 	srq->idx_bit_fields[i] ^= mask;
 }
-- 
2.1.3

