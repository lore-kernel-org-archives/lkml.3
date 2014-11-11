Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaKKMJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:09:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57182 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaKKLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 021/170] iser-target: Disable TX completion interrupt coalescing
Date: Tue, 11 Nov 2014 11:06:20 +0000
Message-Id: <1415704129-12709-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 0d0f660d882c1c02748ced13966a2413aa5d6cc2 upstream.

This patch explicitly disables TX completion interrupt coalescing logic
in isert_put_response() and isert_put_datain() that was originally added
as an efficiency optimization in commit 95b60f07.

It has been reported that this change can trigger ABORT_TASK timeouts
under certain small block workloads, where disabling coalescing was
required for stability.  According to Sagi, this doesn't impact
overall performance, so go ahead and disable it for now.

Reported-by: Moussa Ba <moussaba@micron.com>
Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9959cd1faad9..676013a9dd94 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2183,7 +2183,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
-	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -2882,7 +2882,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 				     &isert_cmd->tx_desc.iscsi_header);
 		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 		isert_init_send_wr(isert_conn, isert_cmd,
-				   &isert_cmd->tx_desc.send_wr, true);
+				   &isert_cmd->tx_desc.send_wr, false);
 		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
 		wr->send_wr_num += 1;
 	}
-- 
2.1.0

