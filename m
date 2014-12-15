Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaLOPRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:17:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLOO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 017/168] ib_isert: Add max_send_sge=2 minimum for control PDU responses
Date: Mon, 15 Dec 2014 14:24:31 +0000
Message-Id: <1418653622-21105-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit f57915cfa5b2b14c1cffa2e83c034f55e3f0e70d upstream.

This patch adds a max_send_sge=2 minimum in isert_conn_setup_qp()
to ensure outgoing control PDU responses with tx_desc->num_sge=2
are able to function correctly.

This addresses a bug with RDMA hardware using dev_attr.max_sge=3,
that in the original code with the ConnectX-2 work-around would
result in isert_conn->max_sge=1 being negotiated.

Originally reported by Chris with ocrdma driver.

Reported-by: Chris Moore <Chris.Moore@emulex.com>
Tested-by: Chris Moore <Chris.Moore@emulex.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 676013a9dd94..33556f980b45 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -115,9 +115,12 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id,
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS;
 	/*
 	 * FIXME: Use devattr.max_sge - 2 for max_send_sge as
-	 * work-around for RDMA_READ..
+	 * work-around for RDMA_READs with ConnectX-2.
+	 *
+	 * Also, still make sure to have at least two SGEs for
+	 * outgoing control PDU responses.
 	 */
-	attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
+	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
 	isert_conn->max_sge = attr.cap.max_send_sge;
 
 	attr.cap.max_recv_sge = 1;
-- 
2.1.3

