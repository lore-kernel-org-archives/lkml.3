Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaKFWob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaKFWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/162] iser-target: Disable TX completion interrupt coalescing
Date: Thu,  6 Nov 2014 14:35:30 -0800
Message-Id: <1415313426-9622-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 44b883f..9b2a108 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1909,7 +1909,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
-	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -2432,7 +2432,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 			     &isert_cmd->tx_desc.iscsi_header);
 	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 	isert_init_send_wr(isert_conn, isert_cmd,
-			   &isert_cmd->tx_desc.send_wr, true);
+			   &isert_cmd->tx_desc.send_wr, false);
 
 	atomic_add(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
-- 
1.9.1

