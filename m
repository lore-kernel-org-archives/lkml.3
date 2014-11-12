Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaKLB1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:27:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaKLB1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:27:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Moussa Ba <moussaba@micron.com>,
        Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.17 141/319] iser-target: Disable TX completion interrupt coalescing
Date: Wed, 12 Nov 2014 10:14:39 +0900
Message-Id: <20141112011015.843673230@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2185,7 +2185,7 @@ isert_put_response(struct iscsi_conn *co
 		isert_cmd->tx_desc.num_sge = 2;
 	}
 
-	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
+	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
 
 	pr_debug("Posting SCSI Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
 
@@ -2884,7 +2884,7 @@ isert_put_datain(struct iscsi_conn *conn
 				     &isert_cmd->tx_desc.iscsi_header);
 		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
 		isert_init_send_wr(isert_conn, isert_cmd,
-				   &isert_cmd->tx_desc.send_wr, true);
+				   &isert_cmd->tx_desc.send_wr, false);
 		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
 		wr->send_wr_num += 1;
 	}


