Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbaIOWTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbaIOWTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Milton Miller <miltonm@us.ibm.com>,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Whitcroft <apw@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/187] bnx2x: Fix kernel crash and data miscompare after EEH recovery
Date: Mon, 15 Sep 2014 15:07:35 -0700
Message-Id: <1410818997-9432-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>

commit 9aaae044abe95de182d09004cc3fa181bf22e6e0 upstream.

A rmb() is required to ensure that the CQE is not read before it
is written by the adapter DMA.  PCI ordering rules will make sure
the other fields are written before the marker at the end of struct
eth_fast_path_rx_cqe but without rmb() a weakly ordered processor can
process stale data.

Without the barrier we have observed various crashes including
bnx2x_tpa_start being called on queues not stopped (resulting in message
start of bin not in stop) and NULL pointer exceptions from bnx2x_rx_int.

Signed-off-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 6089bc4..a9324f4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -868,6 +868,18 @@ int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 		bd_prod = RX_BD(bd_prod);
 		bd_cons = RX_BD(bd_cons);
 
+		/* A rmb() is required to ensure that the CQE is not read
+		 * before it is written by the adapter DMA.  PCI ordering
+		 * rules will make sure the other fields are written before
+		 * the marker at the end of struct eth_fast_path_rx_cqe
+		 * but without rmb() a weakly ordered processor can process
+		 * stale data.  Without the barrier TPA state-machine might
+		 * enter inconsistent state and kernel stack might be
+		 * provided with incorrect packet description - these lead
+		 * to various kernel crashed.
+		 */
+		rmb();
+
 		cqe_fp_flags = cqe_fp->type_error_flags;
 		cqe_fp_type = cqe_fp_flags & ETH_FAST_PATH_RX_CQE_TYPE;
 
-- 
1.9.1

