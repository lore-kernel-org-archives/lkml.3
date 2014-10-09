Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaJIVdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:33:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbaJIVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/163] Target/iser: Get isert_conn reference once got to connected_handler
Date: Thu,  9 Oct 2014 14:02:00 -0700
Message-Id: <1412888588-26755-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit c2f88b17a1d97ca4ecd96cc22333a7a4f1407d39 upstream.

In case the connection didn't reach connected state, disconnected
handler will never be invoked thus the second kref_put on
isert_conn will be missing.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 5199f4e..a4210f9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -501,7 +501,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	init_completion(&isert_conn->conn_wait);
 	init_completion(&isert_conn->conn_wait_comp_err);
 	kref_init(&isert_conn->conn_kref);
-	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 
@@ -642,7 +641,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 static void
 isert_connected_handler(struct rdma_cm_id *cma_id)
 {
-	return;
+	struct isert_conn *isert_conn = cma_id->context;
+
+	kref_get(&isert_conn->conn_kref);
 }
 
 static void
-- 
1.9.1

