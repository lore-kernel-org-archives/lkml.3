Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaJCXYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:24:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbaJCWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 145/238] Target/iser: Get isert_conn reference once got to connected_handler
Date: Fri,  3 Oct 2014 14:31:00 -0700
Message-Id: <20141003212918.322282597@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit c2f88b17a1d97ca4ecd96cc22333a7a4f1407d39 upstream.

In case the connection didn't reach connected state, disconnected
handler will never be invoked thus the second kref_put on
isert_conn will be missing.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -511,7 +511,6 @@ isert_connect_request(struct rdma_cm_id
 	init_completion(&isert_conn->conn_wait);
 	init_completion(&isert_conn->conn_wait_comp_err);
 	kref_init(&isert_conn->conn_kref);
-	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
@@ -663,7 +662,9 @@ isert_connect_release(struct isert_conn
 static void
 isert_connected_handler(struct rdma_cm_id *cma_id)
 {
-	return;
+	struct isert_conn *isert_conn = cma_id->context;
+
+	kref_get(&isert_conn->conn_kref);
 }
 
 static void


