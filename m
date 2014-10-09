Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbaJIVeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:34:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbaJIVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 096/163] Target/iser: Don't put isert_conn inside disconnected handler
Date: Thu,  9 Oct 2014 14:02:01 -0700
Message-Id: <1412888588-26755-97-git-send-email-kamal@canonical.com>
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

commit 0fc4ea701fcf5bc51ace4e288af5be741465f776 upstream.

disconnected_handler is invoked on several CM events (such
as DISCONNECTED, DEVICE_REMOVAL, TIMEWAIT_EXIT...). Since
multiple  events can occur while before isert_free_conn is
invoked, we might put all isert_conn references and free
the connection too early.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a4210f9..44b883f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -695,7 +695,6 @@ isert_disconnect_work(struct work_struct *work)
 
 wake_up:
 	complete(&isert_conn->conn_wait);
-	isert_put_conn(isert_conn);
 }
 
 static void
@@ -2777,6 +2776,7 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	wait_for_completion(&isert_conn->conn_wait_comp_err);
 
 	wait_for_completion(&isert_conn->conn_wait);
+	isert_put_conn(isert_conn);
 }
 
 static void isert_free_conn(struct iscsi_conn *conn)
-- 
1.9.1

