Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaFWNJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:09:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbaFWNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 82/93] Target/iscsi,iser: Avoid accepting transport connections during stop stage
Date: Mon, 23 Jun 2014 14:03:01 +0100
Message-Id: <1403528592-2163-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a upstream.

When the target is in stop stage, iSER transport initiates RDMA disconnects.
The iSER initiator may wish to establish a new connection over the
still existing network portal. In this case iSER transport should not
accept and resume new RDMA connections. In order to learn that, iscsi_np
is added with enabled flag so the iSER transport can check when deciding
weather to accept and resume a new connection request.

The iscsi_np is enabled after successful transport setup, and disabled
before iscsi_np login threads are cleaned up.

(Fix up context changes for v3.10.y - nab)

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.11: Used nab's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c   | 8 ++++++++
 drivers/target/iscsi/iscsi_target_core.h  | 1 +
 drivers/target/iscsi/iscsi_target_login.c | 1 +
 drivers/target/iscsi/iscsi_target_tpg.c   | 1 +
 4 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 91e91afba75c..8bb57deb86cc 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -382,6 +382,14 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	struct ib_device *ib_dev = cma_id->device;
 	int ret = 0;
 
+	spin_lock_bh(&np->np_thread_lock);
+	if (!np->enabled) {
+		spin_unlock_bh(&np->np_thread_lock);
+		pr_debug("iscsi_np is not enabled, reject connect request\n");
+		return rdma_reject(cma_id, NULL, 0);
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
 	pr_debug("Entering isert_connect_request cma_id: %p, context: %p\n",
 		 cma_id, cma_id->context);
 
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 4f77a78edef9..3c227516b410 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -762,6 +762,7 @@ struct iscsi_np {
 	int			np_ip_proto;
 	int			np_sock_type;
 	enum np_thread_state_table np_thread_state;
+	bool                    enabled;
 	enum iscsi_timer_flags_table np_login_timer_flags;
 	u32			np_exports;
 	enum np_flags_table	np_flags;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 6627bc7655f4..4cfc3ea5c49a 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -983,6 +983,7 @@ int iscsi_target_setup_login_socket(
 	}
 
 	np->np_transport = t;
+	np->enabled = true;
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index f31b4c5cdf3f..7ac798db3f78 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -182,6 +182,7 @@ static void iscsit_clear_tpg_np_login_thread(
 		return;
 	}
 
+	tpg_np->tpg_np->enabled = false;
 	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg);
 }
 
-- 
1.9.1

