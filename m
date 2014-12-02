Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaLBT0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573AbaLBTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 095/121] ib_isert: Add max_send_sge=2 minimum for control PDU responses
Date: Tue,  2 Dec 2014 11:19:34 -0800
Message-Id: <1417548000-1794-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9b2a108..708ca27 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -112,9 +112,12 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
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
1.9.1

