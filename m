Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaFWIk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55580 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/111] Target/iscsi,iser: Avoid accepting transport connections during stop stage
Date: Mon, 23 Jun 2014 10:31:38 +0200
Message-Id: <39a125dfd39308cbae38f8555d3fa2de017511a0.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 14f4b54fe38f3a8f8392a50b951c8aa43b63687a upstream.

When the target is in stop stage, iSER transport initiates RDMA disconnects.
The iSER initiator may wish to establish a new connection over the
still existing network portal. In this case iSER transport should not
accept and resume new RDMA connections. In order to learn that, iscsi_np
is added with enabled flag so the iSER transport can check when deciding
weather to accept and resume a new connection request.

The iscsi_np is enabled after successful transport setup, and disabled
before iscsi_np login threads are cleaned up.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c   | 8 ++++++++
 drivers/target/iscsi/iscsi_target_core.h  | 1 +
 drivers/target/iscsi/iscsi_target_login.c | 1 +
 drivers/target/iscsi/iscsi_target_tpg.c   | 1 +
 4 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8f23786c74e9..8645d19f7710 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -493,6 +493,14 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
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
index 9a5721b8ff96..e2e1e63237d9 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -777,6 +777,7 @@ struct iscsi_np {
 	int			np_ip_proto;
 	int			np_sock_type;
 	enum np_thread_state_table np_thread_state;
+	bool                    enabled;
 	enum iscsi_timer_flags_table np_login_timer_flags;
 	u32			np_exports;
 	enum np_flags_table	np_flags;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index f442a9c93403..f140a0eac985 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -983,6 +983,7 @@ int iscsi_target_setup_login_socket(
 	}
 
 	np->np_transport = t;
+	np->enabled = true;
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3cf77c0b76b4..adc9393f79e5 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -184,6 +184,7 @@ static void iscsit_clear_tpg_np_login_thread(
 		return;
 	}
 
+	tpg_np->tpg_np->enabled = false;
 	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
 }
 
-- 
2.0.0

